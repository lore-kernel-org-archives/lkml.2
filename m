Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0DUCuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 22:50:05 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:36080 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab0DUCt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 22:49:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=ZAi5rYCSxBcF1DVDmLpm/qFSj/gkqVkIqROzh1FIo4nQsB6AsemIvkcO/WvBL3zU0M
         5VdRHEF7XlCw3jpNPzkL790rGLlo5RdWGTKKYzdwgSFRsRmCo/jI1hDQzRY1JhE5E9u7
         NM2R8T9yhzdkcbWQh5XXE3B6A/x/IdezEyyaU=
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 20 Apr 2010 22:49:39 -0400
X-Google-Sender-Auth: bd95dd57bddc2c13
Message-ID: <g2jcb0375e11004201949g4ed17156j5d84dd5645c7ec27@mail.gmail.com>
Subject: [RFC] Clean up MNT_NOSUID handling in exec
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 10:25 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting Andrew Lutomirski (luto@mit.edu):
>> On Tue, Apr 20, 2010 at 8:37 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>> >
>> > At least in the case of SELinux, context transitions upon execve are
>> > already disabled in the nosuid case, and Eric's patch updated the
>> > SELinux test accordingly.
>>
>> I don't see that code in current -linus, nor do I see where SELinux
>> affects dumpability.  What's supposed to happen?  I'm writing a patch
>> right now to clean this stuff up.
>
> check out security/selinux/hooks.c:selinux_bprm_set_creds()
>
>        if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
>                new_tsec->sid = old_tsec->sid;
>
> I assume that's it?

*sigh*, that's it, of course.

But it seems odd that if you ask the system to change sid (i.e.
exec_sid) and then you exec something that's nosuid, your request gets
silently ignored.  Presumably either the request should be respected
or some error should occur.

Also, the FILE__EXECUTE_NO_TRANS check looks bogus in the nosuid case
-- you can't trust security labels if nosuid.

Here's a compile-tested patch (against current -git) that might make
this all it bit more sane, and as a bonus it makes it easier to reuse
the NOSUID mechanism down the road for some prctl flag.  Thoughts?
SECINITSID_UNLABELED might want to be SECINITSID_FILE.


diff --git a/fs/exec.c b/fs/exec.c
index 49cdaa1..9b34234 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1151,11 +1151,14 @@ int prepare_binprm(struct linux_binprm *bprm)
 	if (bprm->file->f_op == NULL)
 		return -EACCES;

+	/* Check this exactly once to avoid races. */
+	bprm->file_nosuid = !!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID);
+
 	/* clear any previous set[ug]id data from a previous binary */
 	bprm->cred->euid = current_euid();
 	bprm->cred->egid = current_egid();

-	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
+	if (!bprm->file_nosuid) {
 		/* Set-uid? */
 		if (mode & S_ISUID) {
 			bprm->per_clear |= PER_CLEAR_ON_SETID;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index c809e28..ff6be04 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -36,6 +36,8 @@ struct linux_binprm{
 	struct mm_struct *mm;
 	unsigned long p; /* current top of mem */
 	unsigned int
+		file_nosuid:1,  /* true if file's security state should
+				   be ignored. */
 		cred_prepared:1,/* true if creds already prepared (multiple
 				 * preps happen for interpreters) */
 		cap_effective:1;/* true if has elevated effective capabilities,
diff --git a/security/commoncap.c b/security/commoncap.c
index 6166973..4836913 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -390,7 +390,7 @@ static int get_file_caps(struct linux_binprm
*bprm, bool *effective)
 	if (!file_caps_enabled)
 		return 0;

-	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
+	if (bprm->file_nosuid)
 		return 0;

 	dentry = dget(bprm->file->f_dentry);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5feecb4..762ac00 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2100,7 +2100,7 @@ static int selinux_bprm_set_creds(struct
linux_binprm *bprm)
 {
 	const struct task_security_struct *old_tsec;
 	struct task_security_struct *new_tsec;
-	struct inode_security_struct *isec;
+	u32 isid;
 	struct common_audit_data ad;
 	struct inode *inode = bprm->file->f_path.dentry->d_inode;
 	int rc;
@@ -2116,7 +2116,9 @@ static int selinux_bprm_set_creds(struct
linux_binprm *bprm)

 	old_tsec = current_security();
 	new_tsec = bprm->cred->security;
-	isec = inode->i_security;
+	isid = ((struct inode_security_struct*)inode->i_security)->sid;
+	if (bprm->file_nosuid)
+		isid = SECINITSID_UNLABELED;

 	/* Default to the current task SID. */
 	new_tsec->sid = old_tsec->sid;
@@ -2133,7 +2135,7 @@ static int selinux_bprm_set_creds(struct
linux_binprm *bprm)
 		new_tsec->exec_sid = 0;
 	} else {
 		/* Check for a default transition on this program. */
-		rc = security_transition_sid(old_tsec->sid, isec->sid,
+		rc = security_transition_sid(old_tsec->sid, isid,
 					     SECCLASS_PROCESS, &new_tsec->sid);
 		if (rc)
 			return rc;
@@ -2142,11 +2144,8 @@ static int selinux_bprm_set_creds(struct
linux_binprm *bprm)
 	COMMON_AUDIT_DATA_INIT(&ad, FS);
 	ad.u.fs.path = bprm->file->f_path;

-	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
-		new_tsec->sid = old_tsec->sid;
-
 	if (new_tsec->sid == old_tsec->sid) {
-		rc = avc_has_perm(old_tsec->sid, isec->sid,
+		rc = avc_has_perm(old_tsec->sid, isid,
 				  SECCLASS_FILE, FILE__EXECUTE_NO_TRANS, &ad);
 		if (rc)
 			return rc;
@@ -2157,7 +2156,7 @@ static int selinux_bprm_set_creds(struct
linux_binprm *bprm)
 		if (rc)
 			return rc;

-		rc = avc_has_perm(new_tsec->sid, isec->sid,
+		rc = avc_has_perm(new_tsec->sid, isid,
 				  SECCLASS_FILE, FILE__ENTRYPOINT, &ad);
 		if (rc)
 			return rc;
