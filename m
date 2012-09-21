Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab2IUAls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:41:48 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56773 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab2IUAlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:41:45 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-security-module@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Date: Thu, 20 Sep 2012 17:28:49 -0700
Message-Id: <1348187330-6616-13-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+UOZXbM4BeY/fVr9MgjL+FKZ4DWfALvTQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3188]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 
X-Spam-Combo: ****;<linux-security-module@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 13/14] userns: On ia64 deal with current_uid and current_gid being kuid and kgid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

These ia64 uses of current_uid and current_gid slipped through the
cracks when I was converting everything to kuids and kgids convert
them now.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/ia64/kernel/mca_drv.c |    3 ++-
 arch/ia64/kernel/perfmon.c |   32 ++++++++++++++++----------------
 arch/ia64/kernel/signal.c  |    4 ++--
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
index 1c2e894..9392e02 100644
--- a/arch/ia64/kernel/mca_drv.c
+++ b/arch/ia64/kernel/mca_drv.c
@@ -158,7 +158,8 @@ mca_handler_bh(unsigned long paddr, void *iip, unsigned long ipsr)
 	ia64_mlogbuf_dump();
 	printk(KERN_ERR "OS_MCA: process [cpu %d, pid: %d, uid: %d, "
 		"iip: %p, psr: 0x%lx,paddr: 0x%lx](%s) encounters MCA.\n",
-	       raw_smp_processor_id(), current->pid, current_uid(),
+	       raw_smp_processor_id(), current->pid,
+		from_kuid(&init_user_ns, current_uid()),
 		iip, ipsr, paddr, current->comm);
 
 	spin_lock(&mca_bh_lock);
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 3fa4bc5..5a5c222 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2380,8 +2380,8 @@ static int
 pfm_bad_permissions(struct task_struct *task)
 {
 	const struct cred *tcred;
-	uid_t uid = current_uid();
-	gid_t gid = current_gid();
+	kuid_t uid = current_uid();
+	kgid_t gid = current_gid();
 	int ret;
 
 	rcu_read_lock();
@@ -2389,20 +2389,20 @@ pfm_bad_permissions(struct task_struct *task)
 
 	/* inspired by ptrace_attach() */
 	DPRINT(("cur: uid=%d gid=%d task: euid=%d suid=%d uid=%d egid=%d sgid=%d\n",
-		uid,
-		gid,
-		tcred->euid,
-		tcred->suid,
-		tcred->uid,
-		tcred->egid,
-		tcred->sgid));
-
-	ret = ((uid != tcred->euid)
-	       || (uid != tcred->suid)
-	       || (uid != tcred->uid)
-	       || (gid != tcred->egid)
-	       || (gid != tcred->sgid)
-	       || (gid != tcred->gid)) && !capable(CAP_SYS_PTRACE);
+		from_kuid(&init_user_ns, uid),
+		from_kgid(&init_user_ns, gid),
+		from_kuid(&init_user_ns, tcred->euid),
+		from_kuid(&init_user_ns, tcred->suid),
+		from_kuid(&init_user_ns, tcred->uid),
+		from_kgid(&init_user_ns, tcred->egid),
+		from_kgid(&init_user_ns, tcred->sgid)));
+
+	ret = ((!uid_eq(uid, tcred->euid))
+	       || (!uid_eq(uid, tcred->suid))
+	       || (!uid_eq(uid, tcred->uid))
+	       || (!gid_eq(gid, tcred->egid))
+	       || (!gid_eq(gid, tcred->sgid))
+	       || (!gid_eq(gid, tcred->gid))) && !capable(CAP_SYS_PTRACE);
 
 	rcu_read_unlock();
 	return ret;
diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index a199be1..37dd795 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -220,7 +220,7 @@ ia64_rt_sigreturn (struct sigscratch *scr)
 	si.si_errno = 0;
 	si.si_code = SI_KERNEL;
 	si.si_pid = task_pid_vnr(current);
-	si.si_uid = current_uid();
+	si.si_uid = from_kuid_munged(current_user_ns(), current_uid());
 	si.si_addr = sc;
 	force_sig_info(SIGSEGV, &si, current);
 	return retval;
@@ -317,7 +317,7 @@ force_sigsegv_info (int sig, void __user *addr)
 	si.si_errno = 0;
 	si.si_code = SI_KERNEL;
 	si.si_pid = task_pid_vnr(current);
-	si.si_uid = current_uid();
+	si.si_uid = from_kuid_munged(current_user_ns(), current_uid());
 	si.si_addr = addr;
 	force_sig_info(SIGSEGV, &si, current);
 	return 0;
-- 
1.7.5.4

