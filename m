Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab2DHFRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:17:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51548 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab2DHFM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:27 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:29 -0700
Message-Id: <1333862139-31737-33-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/1e5fVwIOK5Fs2oaGQXW4rh2BPOMAuDMk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0010]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 
X-Spam-Combo: ***;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 33/43] userns: Convert binary formats to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/binfmt_elf.c       |   12 ++++++------
 fs/binfmt_elf_fdpic.c |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 48ffb3d..efc6731 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -228,10 +228,10 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	NEW_AUX_ENT(AT_BASE, interp_load_addr);
 	NEW_AUX_ENT(AT_FLAGS, 0);
 	NEW_AUX_ENT(AT_ENTRY, exec->e_entry);
-	NEW_AUX_ENT(AT_UID, cred->uid);
-	NEW_AUX_ENT(AT_EUID, cred->euid);
-	NEW_AUX_ENT(AT_GID, cred->gid);
-	NEW_AUX_ENT(AT_EGID, cred->egid);
+	NEW_AUX_ENT(AT_UID, from_kuid_munged(cred->user_ns, cred->uid));
+	NEW_AUX_ENT(AT_EUID, from_kuid_munged(cred->user_ns, cred->euid));
+	NEW_AUX_ENT(AT_GID, from_kgid_munged(cred->user_ns, cred->gid));
+	NEW_AUX_ENT(AT_EGID, from_kgid_munged(cred->user_ns, cred->egid));
  	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
 	NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
 	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
@@ -1367,8 +1367,8 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	psinfo->pr_flag = p->flags;
 	rcu_read_lock();
 	cred = __task_cred(p);
-	SET_UID(psinfo->pr_uid, cred->uid);
-	SET_GID(psinfo->pr_gid, cred->gid);
+	SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
+	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
 	rcu_read_unlock();
 	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
 	
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 9bd5612..82bf0ed 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -631,10 +631,10 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	NEW_AUX_ENT(AT_BASE,	interp_params->elfhdr_addr);
 	NEW_AUX_ENT(AT_FLAGS,	0);
 	NEW_AUX_ENT(AT_ENTRY,	exec_params->entry_addr);
-	NEW_AUX_ENT(AT_UID,	(elf_addr_t) cred->uid);
-	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) cred->euid);
-	NEW_AUX_ENT(AT_GID,	(elf_addr_t) cred->gid);
-	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) cred->egid);
+	NEW_AUX_ENT(AT_UID,	(elf_addr_t) from_kuid_munged(cred->user_ns, cred->uid));
+	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) from_kuid_munged(cred->user_ns, cred->euid));
+	NEW_AUX_ENT(AT_GID,	(elf_addr_t) from_kgid_munged(cred->user_ns, cred->gid));
+	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) from_kgid_munged(cred->user_ns, cred->egid));
 	NEW_AUX_ENT(AT_SECURE,	security_bprm_secureexec(bprm));
 	NEW_AUX_ENT(AT_EXECFN,	bprm->exec);
 
@@ -1431,8 +1431,8 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	psinfo->pr_flag = p->flags;
 	rcu_read_lock();
 	cred = __task_cred(p);
-	SET_UID(psinfo->pr_uid, cred->uid);
-	SET_GID(psinfo->pr_gid, cred->gid);
+	SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
+	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
 	rcu_read_unlock();
 	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
 
-- 
1.7.2.5

