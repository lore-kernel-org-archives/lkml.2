Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab0GOApa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:45:30 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57198 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038Ab0GOAoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:44:21 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 09/13] AppArmor: mediation of non file objects
Date: Wed, 14 Jul 2010 17:43:37 -0700
Message-Id: <1279154621-25868-10-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipc:
AppArmor ipc is currently limited to mediation done by file mediation
and basic ptrace tests.  Improved mediation is a wip.

rlimits:
AppArmor provides basic abilities to set and control rlimits at
a per profile level.  Only resources specified in a profile are controled
or set.  AppArmor rules set the hard limit to a value <= to the current
hard limit (ie. they can not currently raise hard limits), and if
necessary will lower the soft limit to the new hard limit value.

AppArmor does not track resource limits to reset them when a profile
is left so that children processes inherit the limits set by the
parent even if they are not confined by the same profile.

Capabilities:  AppArmor provides a per profile mask of capabilities,
that will further restrict.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/capability.c         |  141 ++++++++++++++++++++++++++++++++
 security/apparmor/include/capability.h |   45 ++++++++++
 security/apparmor/include/ipc.h        |   28 ++++++
 security/apparmor/include/resource.h   |   46 ++++++++++
 security/apparmor/ipc.c                |  114 ++++++++++++++++++++++++++
 security/apparmor/resource.c           |  132 ++++++++++++++++++++++++++++++
 6 files changed, 506 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/capability.c
 create mode 100644 security/apparmor/include/capability.h
 create mode 100644 security/apparmor/include/ipc.h
 create mode 100644 security/apparmor/include/resource.h
 create mode 100644 security/apparmor/ipc.c
 create mode 100644 security/apparmor/resource.c

diff --git a/security/apparmor/capability.c b/security/apparmor/capability.c
new file mode 100644
index 0000000..9c28d92
--- /dev/null
+++ b/security/apparmor/capability.c
@@ -0,0 +1,141 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor capability mediation functions
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#include <linux/capability.h>
+#include <linux/errno.h>
+#include <linux/gfp.h>
+
+#include "include/apparmor.h"
+#include "include/capability.h"
+#include "include/context.h"
+#include "include/policy.h"
+#include "include/audit.h"
+
+/*
+ * Table of capability names: we generate it from capabilities.h.
+ */
+#include "capability_names.h"
+
+struct audit_cache {
+	struct aa_profile *profile;
+	kernel_cap_t caps;
+};
+
+static DEFINE_PER_CPU(struct audit_cache, audit_cache);
+
+/**
+ * audit_cb - call back for capability components of audit struct
+ * @ab - audit buffer   (NOT NULL)
+ * @va - audit struct to audit data from  (NOT NULL)
+ */
+static void audit_cb(struct audit_buffer *ab, void *va)
+{
+	struct common_audit_data *sa = va;
+	audit_log_format(ab, " capname=");
+	audit_log_untrustedstring(ab, capability_names[sa->u.cap]);
+}
+
+/**
+ * audit_caps - audit a capability
+ * @profile: profile confining task
+ * @task: task capability test was performed against
+ * @cap: capability tested
+ * @error: error code returned by test
+ *
+ * Do auditing of capability and handle, audit/complain/kill modes switching
+ * and duplicate message elimination.
+ *
+ * returns: 0 or sa->error on succes,  error code on failure
+ */
+static int audit_caps(struct aa_profile *profile, struct task_struct *task,
+		      int cap, int error)
+{
+	struct audit_cache *ent;
+	int type = AUDIT_APPARMOR_AUTO;
+	struct common_audit_data sa;
+	COMMON_AUDIT_DATA_INIT(&sa, CAP);
+	sa.tsk = task;
+	sa.u.cap = cap;
+	sa.aad.op = OP_CAPABLE;
+	sa.aad.error = error;
+
+	if (likely(!error)) {
+		/* test if auditing is being forced */
+		if (likely((AUDIT_MODE(profile) != AUDIT_ALL) &&
+			   !cap_raised(profile->caps.audit, cap)))
+			return 0;
+		type = AUDIT_APPARMOR_AUDIT;
+	} else if (DO_KILL(profile) ||
+		   cap_raised(profile->caps.kill, cap)) {
+		type = AUDIT_APPARMOR_KILL;
+	} else if (cap_raised(profile->caps.quiet, cap) &&
+		   AUDIT_MODE(profile) != AUDIT_NOQUIET &&
+		   AUDIT_MODE(profile) != AUDIT_ALL) {
+		/* quiet auditing */
+		return error;
+	}
+
+	/* Do simple duplicate message elimination */
+	ent = &get_cpu_var(audit_cache);
+	if (profile == ent->profile && cap_raised(ent->caps, cap)) {
+		put_cpu_var(audit_cache);
+		if (COMPLAIN_MODE(profile))
+			return complain_error(error);
+		return error;
+	} else {
+		aa_put_profile(ent->profile);
+		ent->profile = aa_get_profile(profile);
+		cap_raise(ent->caps, cap);
+	}
+	put_cpu_var(audit_cache);
+
+	return aa_audit(type, profile, GFP_ATOMIC, &sa, audit_cb);
+}
+
+/**
+ * profile_capable - test if profile allows use of capability @cap
+ * @profile: profile being enforced    (NOT NULL, NOT unconfined)
+ * @cap: capability to test if allowed
+ *
+ * Returns: 0 if allowed else -EPERM
+ */
+static int profile_capable(struct aa_profile *profile, int cap)
+{
+	return cap_raised(profile->caps.allow, cap) ? 0 : -EPERM;
+}
+
+/**
+ * aa_capable - test permission to use capability
+ * @task: task doing capability test against
+ * @profile: profile confining @task
+ * @cap: capability to be tested
+ * @audit: whether an audit record should be generated
+ *
+ * Look up capability in profile capability set.
+ *
+ * Returns: 0 on success, or else an error code.
+ */
+int aa_capable(struct task_struct *task, struct aa_profile *profile, int cap,
+	       int audit)
+{
+	int error = profile_capable(profile, cap);
+
+	if (!audit) {
+		if (COMPLAIN_MODE(profile))
+			return complain_error(error);
+		return error;
+	}
+
+	return audit_caps(profile, task, cap, error);
+}
diff --git a/security/apparmor/include/capability.h b/security/apparmor/include/capability.h
new file mode 100644
index 0000000..c24d295
--- /dev/null
+++ b/security/apparmor/include/capability.h
@@ -0,0 +1,45 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor capability mediation definitions.
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __AA_CAPABILITY_H
+#define __AA_CAPABILITY_H
+
+#include <linux/sched.h>
+
+struct aa_profile;
+
+/* aa_caps - confinement data for capabilities
+ * @allowed: capabilities mask
+ * @audit: caps that are to be audited
+ * @quiet: caps that should not be audited
+ * @kill: caps that when requested will result in the task being killed
+ * @extended: caps that are subject finer grained mediation
+ */
+struct aa_caps {
+	kernel_cap_t allow;
+	kernel_cap_t audit;
+	kernel_cap_t quiet;
+	kernel_cap_t kill;
+	kernel_cap_t extended;
+};
+
+int aa_capable(struct task_struct *task, struct aa_profile *profile, int cap,
+	       int audit);
+
+static inline void aa_free_cap_rules(struct aa_caps *caps)
+{
+	/* NOP */
+}
+
+#endif /* __AA_CAPBILITY_H */
diff --git a/security/apparmor/include/ipc.h b/security/apparmor/include/ipc.h
new file mode 100644
index 0000000..aeda0fb
--- /dev/null
+++ b/security/apparmor/include/ipc.h
@@ -0,0 +1,28 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor ipc mediation function definitions.
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __AA_IPC_H
+#define __AA_IPC_H
+
+#include <linux/sched.h>
+
+struct aa_profile;
+
+int aa_may_ptrace(struct task_struct *tracer_task, struct aa_profile *tracer,
+		  struct aa_profile *tracee, unsigned int mode);
+
+int aa_ptrace(struct task_struct *tracer, struct task_struct *tracee,
+	      unsigned int mode);
+
+#endif /* __AA_IPC_H */
diff --git a/security/apparmor/include/resource.h b/security/apparmor/include/resource.h
new file mode 100644
index 0000000..1e009ce
--- /dev/null
+++ b/security/apparmor/include/resource.h
@@ -0,0 +1,46 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor resource limits function defintions.
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __AA_RESOURCE_H
+#define __AA_RESOURCE_H
+
+#include <linux/resource.h>
+#include <linux/sched.h>
+
+struct aa_profile;
+
+/* struct aa_rlimit - rlimits settings for the profile
+ * @mask: which hard limits to set
+ * @limits: rlimit values that override task limits
+ *
+ * AppArmor rlimits are used to set confined task rlimits.  Only the
+ * limits specified in @mask will be controlled by apparmor.
+ */
+struct aa_rlimit {
+	unsigned int mask;
+	struct rlimit limits[RLIM_NLIMITS];
+};
+
+int aa_map_resource(int resource);
+int aa_task_setrlimit(struct aa_profile *profile, unsigned int resource,
+		      struct rlimit *new_rlim);
+
+void __aa_transition_rlimits(struct aa_profile *old, struct aa_profile *new);
+
+static inline void aa_free_rlimit_rules(struct aa_rlimit *rlims)
+{
+	/* NOP */
+}
+
+#endif /* __AA_RESOURCE_H */
diff --git a/security/apparmor/ipc.c b/security/apparmor/ipc.c
new file mode 100644
index 0000000..d667f89
--- /dev/null
+++ b/security/apparmor/ipc.c
@@ -0,0 +1,114 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor ipc mediation
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#include <linux/gfp.h>
+#include <linux/ptrace.h>
+
+#include "include/audit.h"
+#include "include/capability.h"
+#include "include/context.h"
+#include "include/policy.h"
+
+/* call back to audit ptrace fields */
+static void audit_cb(struct audit_buffer *ab, void *va)
+{
+	struct common_audit_data *sa = va;
+	audit_log_format(ab, " target=");
+	audit_log_untrustedstring(ab, sa->aad.target);
+}
+
+/**
+ * aa_audit_ptrace - do auditing for ptrace
+ * @profile: profile being enforced  (NOT NULL)
+ * @target: profile being traced (NOT NULL)
+ * @error: error condition
+ *
+ * Returns: %0 or error code
+ */
+static int aa_audit_ptrace(struct aa_profile *profile,
+			   struct aa_profile *target, int error)
+{
+	struct common_audit_data sa;
+	COMMON_AUDIT_DATA_INIT_NONE(&sa);
+	sa.aad.op = OP_PTRACE;
+	sa.aad.target = target;
+	sa.aad.error = error;
+
+	return aa_audit(AUDIT_APPARMOR_AUTO, profile, GFP_ATOMIC, &sa,
+			audit_cb);
+}
+
+/**
+ * aa_may_ptrace - test if tracer task can trace the tracee
+ * @tracer_task: task who will do the tracing  (NOT NULL)
+ * @tracer: profile of the task doing the tracing  (NOT NULL)
+ * @tracee: task to be traced
+ * @mode: whether PTRACE_MODE_READ || PTRACE_MODE_ATTACH
+ *
+ * Returns: %0 else error code if permission denied or error
+ */
+int aa_may_ptrace(struct task_struct *tracer_task, struct aa_profile *tracer,
+		  struct aa_profile *tracee, unsigned int mode)
+{
+	/* TODO: currently only based on capability, not extended ptrace
+	 *       rules,
+	 *       Test mode for PTRACE_MODE_READ || PTRACE_MODE_ATTACH
+	 */
+
+	if (!tracer || tracer == tracee)
+		return 0;
+	/* log this capability request */
+	return aa_capable(tracer_task, tracer, CAP_SYS_PTRACE, 1);
+}
+
+/**
+ * aa_ptrace - do ptrace permission check and auditing
+ * @tracer: task doing the tracing
+ * @tracee: task being traced
+ * @mode: ptrace mode either PTRACE_MODE_READ || PTRACE_MODE_ATTACH
+ *
+ * Returns: %0 else error code if permission denied or error
+ */
+int aa_ptrace(struct task_struct *tracer, struct task_struct *tracee,
+	      unsigned int mode)
+{
+	/*
+	 * tracer can ptrace tracee when
+	 * - tracer is unconfined ||
+	 *   - tracer is in complain mode
+	 *   - tracer has rules allowing it to trace tracee currently this is:
+	 *       - confined by the same profile ||
+	 *       - tracer profile has CAP_SYS_PTRACE
+	 */
+
+	struct aa_profile *tracer_p;
+	/* cred released below */
+	const struct cred *cred = get_task_cred(tracer);
+	int error = 0;
+	tracer_p = aa_cred_profile(cred);
+
+	if (!unconfined(tracer_p)) {
+		/* lcred released below */
+		struct cred *lcred = get_task_cred(tracee);
+		struct aa_profile *tracee_p = aa_cred_profile(lcred);
+
+		error = aa_may_ptrace(tracer, tracer_p, tracee_p, mode);
+		error = aa_audit_ptrace(tracer_p, tracee_p, error);
+
+		put_cred(lcred);
+	}
+	put_cred(cred);
+
+	return error;
+}
diff --git a/security/apparmor/resource.c b/security/apparmor/resource.c
new file mode 100644
index 0000000..ca8773a
--- /dev/null
+++ b/security/apparmor/resource.c
@@ -0,0 +1,132 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor resource mediation and attachment
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#include <linux/audit.h>
+
+#include "include/audit.h"
+#include "include/resource.h"
+#include "include/policy.h"
+
+/*
+ * Table of rlimit names: we generate it from resource.h.
+ */
+#include "rlim_names.h"
+
+/* audit callback for resource specific fields */
+static void audit_cb(struct audit_buffer *ab, void *va)
+{
+	struct common_audit_data *sa = va;
+
+	audit_log_format(ab, " rlimit=%s value=%lu",
+			 rlim_names[sa->aad.rlim.rlim], sa->aad.rlim.max);
+}
+
+/**
+ * audit_resource - audit setting resource limit
+ * @profile: profile being enforced  (NOT NULL)
+ * @sa: audit data  (NOT NULL)
+ *
+ * Returns: 0 or sa->error else other error code on failure
+ */
+static int audit_resource(struct aa_profile *profile, unsigned int resource,
+			  unsigned long value, int error)
+{
+	struct common_audit_data sa;
+
+	COMMON_AUDIT_DATA_INIT_NONE(&sa);
+	sa.aad.op = OP_SETRLIMIT,
+	sa.aad.rlim.rlim = resource;
+	sa.aad.rlim.max = value;
+	sa.aad.error = error;
+	return aa_audit(AUDIT_APPARMOR_AUTO, profile, GFP_KERNEL, &sa,
+			audit_cb);
+}
+
+/**
+ * aa_map_resouce - map compiled policy resource to internal #
+ * @resource: flattened policy resource number
+ *
+ * Returns: resource # for the current architecture.
+ *
+ * rlimit resource can vary based on architecture map the compiled policy
+ * resource # to the internal representation for the architecture.
+ */
+int aa_map_resource(int resource)
+{
+	return rlim_map[resource];
+}
+
+/**
+ * aa_task_setrlimit - test permission to set an rlimit
+ * @profile - profile confining the task  (NOT NULL)
+ * @resource - the resource being set
+ * @new_rlim - the new resource limit  (NOT NULL)
+ *
+ * Control raising the processes hard limit.
+ *
+ * Returns: 0 or error code if setting resource failed
+ */
+int aa_task_setrlimit(struct aa_profile *profile, unsigned int resource,
+		      struct rlimit *new_rlim)
+{
+	int error = 0;
+
+	if (profile->rlimits.mask & (1 << resource) &&
+	    new_rlim->rlim_max > profile->rlimits.limits[resource].rlim_max)
+
+		error = audit_resource(profile, resource, new_rlim->rlim_max,
+			-EACCES);
+
+	return error;
+}
+
+/**
+ * __aa_transition_rlimits - apply new profile rlimits
+ * @old: old profile on task  (MAYBE NULL)
+ * @new: new profile with rlimits to apply  (NOT NULL)
+ */
+void __aa_transition_rlimits(struct aa_profile *old, struct aa_profile *new)
+{
+	unsigned int mask = 0;
+	struct rlimit *rlim, *initrlim;
+	int i;
+
+	/* for any rlimits the profile controlled reset the soft limit
+	 * to the less of the tasks hard limit and the init tasks soft limit
+	 */
+	if (old && old->rlimits.mask) {
+		for (i = 0, mask = 1; i < RLIM_NLIMITS; i++, mask <<= 1) {
+			if (old->rlimits.mask & mask) {
+				rlim = current->signal->rlim + i;
+				initrlim = init_task.signal->rlim + i;
+				rlim->rlim_cur = min(rlim->rlim_max,
+						     initrlim->rlim_cur);
+			}
+		}
+	}
+
+	/* set any new hard limits as dictated by the new profile */
+	if (!(new && new->rlimits.mask))
+		return;
+	for (i = 0, mask = 1; i < RLIM_NLIMITS; i++, mask <<= 1) {
+		if (!(new->rlimits.mask & mask))
+			continue;
+
+		rlim = current->signal->rlim + i;
+		rlim->rlim_max = min(rlim->rlim_max,
+				     new->rlimits.limits[i].rlim_max);
+		/* soft limit should not exceed hard limit */
+		rlim->rlim_cur = min(rlim->rlim_cur, rlim->rlim_max);
+	}
+}
-- 
1.7.0.4

