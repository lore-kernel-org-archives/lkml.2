Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab2LLGQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:16:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27917 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab2LLGN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:13:58 -0500
X-IronPort-AV: E=Sophos;i="4.84,264,1355068800"; 
   d="scan'208";a="6380971"
From: Hu Tao <hutao@cn.fujitsu.com>
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Subject: [PATCH v12 1/8] save/load cpu runstate
Date: Wed, 12 Dec 2012 14:13:44 +0800
Message-Id: <82c48bf2db6be635c24bc96b02e74d1aa1a2f9d5.1355290850.git.hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1.240.ge8a1f5a
In-Reply-To: <cover.1355290850.git.hutao@cn.fujitsu.com>
References: <cover.1355290850.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:13:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:13:05,
	Serialize complete at 2012/12/12 14:13:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 migration.c |  6 +-----
 monitor.c   |  5 ++---
 savevm.c    |  1 +
 sysemu.h    |  2 ++
 vl.c        | 34 ++++++++++++++++++++++++++++++++++
 5 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/migration.c b/migration.c
index 73ce170..31fa300 100644
--- a/migration.c
+++ b/migration.c
@@ -102,11 +102,7 @@ static void process_incoming_migration_co(void *opaque)
     /* Make sure all file formats flush their mutable metadata */
     bdrv_invalidate_cache_all();
 
-    if (autostart) {
-        vm_start();
-    } else {
-        runstate_set(RUN_STATE_PAUSED);
-    }
+    load_run_state();
 }
 
 static void enter_migration_coroutine(void *opaque)
diff --git a/monitor.c b/monitor.c
index c0e32d6..1226501 100644
--- a/monitor.c
+++ b/monitor.c
@@ -2067,13 +2067,12 @@ void qmp_closefd(const char *fdname, Error **errp)
 
 static void do_loadvm(Monitor *mon, const QDict *qdict)
 {
-    int saved_vm_running  = runstate_is_running();
     const char *name = qdict_get_str(qdict, "name");
 
     vm_stop(RUN_STATE_RESTORE_VM);
 
-    if (load_vmstate(name) == 0 && saved_vm_running) {
-        vm_start();
+    if (load_vmstate(name) == 0) {
+        load_run_state();
     }
 }
 
diff --git a/savevm.c b/savevm.c
index 5d04d59..98963a4 100644
--- a/savevm.c
+++ b/savevm.c
@@ -2149,6 +2149,7 @@ void do_savevm(Monitor *mon, const QDict *qdict)
     }
 
     saved_vm_running = runstate_is_running();
+    save_run_state();
     vm_stop(RUN_STATE_SAVE_VM);
 
     memset(sn, 0, sizeof(*sn));
diff --git a/sysemu.h b/sysemu.h
index f5ac664..618f55e 100644
--- a/sysemu.h
+++ b/sysemu.h
@@ -19,6 +19,8 @@ extern uint8_t qemu_uuid[];
 int qemu_uuid_parse(const char *str, uint8_t *uuid);
 #define UUID_FMT "%02hhx%02hhx%02hhx%02hhx-%02hhx%02hhx-%02hhx%02hhx-%02hhx%02hhx-%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx"
 
+void save_run_state(void);
+void load_run_state(void);
 bool runstate_check(RunState state);
 void runstate_set(RunState new_state);
 int runstate_is_running(void);
diff --git a/vl.c b/vl.c
index c8e9c78..6f274cc 100644
--- a/vl.c
+++ b/vl.c
@@ -331,6 +331,7 @@ static int default_driver_check(QemuOpts *opts, void *opaque)
 /* QEMU state */
 
 static RunState current_run_state = RUN_STATE_PRELAUNCH;
+static RunState saved_run_state = RUN_STATE_PRELAUNCH;
 
 typedef struct {
     RunState from;
@@ -354,6 +355,7 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_PAUSED, RUN_STATE_FINISH_MIGRATE },
 
     { RUN_STATE_POSTMIGRATE, RUN_STATE_RUNNING },
+    { RUN_STATE_POSTMIGRATE, RUN_STATE_PAUSED },
     { RUN_STATE_POSTMIGRATE, RUN_STATE_FINISH_MIGRATE },
 
     { RUN_STATE_PRELAUNCH, RUN_STATE_RUNNING },
@@ -364,6 +366,7 @@ static const RunStateTransition runstate_transitions_def[] = {
     { RUN_STATE_FINISH_MIGRATE, RUN_STATE_POSTMIGRATE },
 
     { RUN_STATE_RESTORE_VM, RUN_STATE_RUNNING },
+    { RUN_STATE_RESTORE_VM, RUN_STATE_PAUSED },
 
     { RUN_STATE_RUNNING, RUN_STATE_DEBUG },
     { RUN_STATE_RUNNING, RUN_STATE_INTERNAL_ERROR },
@@ -393,11 +396,39 @@ static const RunStateTransition runstate_transitions_def[] = {
 
 static bool runstate_valid_transitions[RUN_STATE_MAX][RUN_STATE_MAX];
 
+void save_run_state(void)
+{
+    saved_run_state = current_run_state;
+}
+
+void load_run_state(void)
+{
+    if (saved_run_state == RUN_STATE_RUNNING) {
+        vm_start();
+    } else if (!runstate_check(saved_run_state)) {
+        runstate_set(saved_run_state);
+    } else {
+        ; /* leave unchanged */
+    }
+}
+
 bool runstate_check(RunState state)
 {
     return current_run_state == state;
 }
 
+static void runstate_save(QEMUFile *f, void *opaque)
+{
+    qemu_put_byte(f, saved_run_state);
+}
+
+static int runstate_load(QEMUFile *f, void *opaque, int version_id)
+{
+    saved_run_state = qemu_get_byte(f);
+
+    return 0;
+}
+
 static void runstate_init(void)
 {
     const RunStateTransition *p;
@@ -407,6 +438,9 @@ static void runstate_init(void)
     for (p = &runstate_transitions_def[0]; p->from != RUN_STATE_MAX; p++) {
         runstate_valid_transitions[p->from][p->to] = true;
     }
+
+    register_savevm(NULL, "runstate", 0, 1,
+                    runstate_save, runstate_load, NULL);
 }
 
 /* This function will abort() on invalid state transitions */
-- 
1.8.0.1.240.ge8a1f5a

