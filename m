Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab2KSPNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:13:19 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:50372 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab2KSPNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:13:14 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 07:12:31 -0800
Message-Id: <1353337961-12962-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/CpB3inX8hHMMucrSDu5O7asV0IJ/IVbk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1956]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 06/16] userns: Allow unprivileged use of setns.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Push the permission check from the core setns syscall into
  the setns install methods where the user namespace of the
  target namespace can be determined, and used in a ns_capable
  call.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 ipc/namespace.c          |    6 +++++-
 kernel/nsproxy.c         |    3 ---
 kernel/utsname.c         |    7 ++++++-
 net/core/net_namespace.c |    7 ++++++-
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/ipc/namespace.c b/ipc/namespace.c
index f362298c..6ed33c0 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -161,8 +161,12 @@ static void ipcns_put(void *ns)
 	return put_ipc_ns(ns);
 }
 
-static int ipcns_install(struct nsproxy *nsproxy, void *ns)
+static int ipcns_install(struct nsproxy *nsproxy, void *new)
 {
+	struct ipc_namespace *ns = new;
+	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
 	/* Ditch state from the old ipc namespace */
 	exit_sem(current);
 	put_ipc_ns(nsproxy->ipc_ns);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index a214e0e..4357a0a 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -242,9 +242,6 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
 	struct file *file;
 	int err;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	file = proc_ns_fget(fd);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
diff --git a/kernel/utsname.c b/kernel/utsname.c
index 679d97a..4a9362f 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -102,8 +102,13 @@ static void utsns_put(void *ns)
 	put_uts_ns(ns);
 }
 
-static int utsns_install(struct nsproxy *nsproxy, void *ns)
+static int utsns_install(struct nsproxy *nsproxy, void *new)
 {
+	struct uts_namespace *ns = new;
+
+	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
 	get_uts_ns(ns);
 	put_uts_ns(nsproxy->uts_ns);
 	nsproxy->uts_ns = ns;
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 6456439..ec2870b 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -630,8 +630,13 @@ static void netns_put(void *ns)
 
 static int netns_install(struct nsproxy *nsproxy, void *ns)
 {
+	struct net *net = ns;
+
+	if (!ns_capable(net->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
 	put_net(nsproxy->net_ns);
-	nsproxy->net_ns = get_net(ns);
+	nsproxy->net_ns = get_net(net);
 	return 0;
 }
 
-- 
1.7.5.4

