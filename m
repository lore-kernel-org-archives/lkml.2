Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2LNWEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:04:04 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:37776 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab2LNWEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:04:02 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-security-module@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
References: <87txroxpgq.fsf@xmission.com>
Date: Fri, 14 Dec 2012 14:03:54 -0800
In-Reply-To: <87txroxpgq.fsf@xmission.com> (Eric W. Biederman's message of
	"Fri, 14 Dec 2012 14:01:57 -0800")
Message-ID: <87hanoxpdh.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+aRMyLmshQ70Fjo7ovbVJrUbIs9jPwqow=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0140]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 2/4] userns: Require CAP_SYS_ADMIN for most uses of setns.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andy Lutomirski <luto@amacapital.net> found a nasty little bug in
the permissions of setns.  With unprivileged user namespaces it
became possible to create new namespaces without privilege.

However the setns calls were relaxed to only require CAP_SYS_ADMIN in
the user nameapce of the targed namespace.

Which made the following nasty sequence possible.

pid = clone(CLONE_NEWUSER | CLONE_NEWNS);
if (pid == 0) { /* child */
	system("mount --bind /home/me/passwd /etc/passwd");
}
else if (pid != 0) { /* parent */
	char path[PATH_MAX];
	snprintf(path, sizeof(path), "/proc/%u/ns/mnt");
	fd = open(path, O_RDONLY);
	setns(fd, 0);
	system("su -");
}

Prevent this possibility by requiring CAP_SYS_ADMIN
in the current user namespace when joing all but the user namespace.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/namespace.c           |    3 ++-
 ipc/namespace.c          |    3 ++-
 kernel/pid_namespace.c   |    3 ++-
 kernel/utsname.c         |    3 ++-
 net/core/net_namespace.c |    3 ++-
 5 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c1bbe86..398a50f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2781,7 +2781,8 @@ static int mntns_install(struct nsproxy *nsproxy, void *ns)
 	struct path root;
 
 	if (!ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN) ||
-	    !nsown_capable(CAP_SYS_CHROOT))
+	    !nsown_capable(CAP_SYS_CHROOT) ||
+	    !nsown_capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	if (fs->users != 1)
diff --git a/ipc/namespace.c b/ipc/namespace.c
index cf3386a..7c1fa45 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -170,7 +170,8 @@ static void ipcns_put(void *ns)
 static int ipcns_install(struct nsproxy *nsproxy, void *new)
 {
 	struct ipc_namespace *ns = new;
-	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN))
+	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN) ||
+	    !nsown_capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* Ditch state from the old ipc namespace */
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 560da0d..fdbd0cd 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -325,7 +325,8 @@ static int pidns_install(struct nsproxy *nsproxy, void *ns)
 	struct pid_namespace *active = task_active_pid_ns(current);
 	struct pid_namespace *ancestor, *new = ns;
 
-	if (!ns_capable(new->user_ns, CAP_SYS_ADMIN))
+	if (!ns_capable(new->user_ns, CAP_SYS_ADMIN) ||
+	    !nsown_capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/*
diff --git a/kernel/utsname.c b/kernel/utsname.c
index f6336d5..08b197e 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -113,7 +113,8 @@ static int utsns_install(struct nsproxy *nsproxy, void *new)
 {
 	struct uts_namespace *ns = new;
 
-	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN))
+	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN) ||
+	    !nsown_capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	get_uts_ns(ns);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 2e9a313..8acce01 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -649,7 +649,8 @@ static int netns_install(struct nsproxy *nsproxy, void *ns)
 {
 	struct net *net = ns;
 
-	if (!ns_capable(net->user_ns, CAP_SYS_ADMIN))
+	if (!ns_capable(net->user_ns, CAP_SYS_ADMIN) ||
+	    !nsown_capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	put_net(nsproxy->net_ns);
-- 
1.7.5.4

