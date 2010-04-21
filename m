Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0DUMZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:25:53 -0400
Received: from reserved-DSUX-GH1-UEA02 ([63.239.65.40]:48320 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab0DUMZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:25:50 -0400
Subject: Re: [RFC] Clean up MNT_NOSUID handling in exec
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
In-Reply-To: <g2jcb0375e11004201949g4ed17156j5d84dd5645c7ec27@mail.gmail.com>
References: <g2jcb0375e11004201949g4ed17156j5d84dd5645c7ec27@mail.gmail.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 21 Apr 2010 08:25:44 -0400
Message-Id: <1271852744.7088.32.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 22:49 -0400, Andrew Lutomirski wrote:
> On Tue, Apr 20, 2010 at 10:25 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> > Quoting Andrew Lutomirski (luto@mit.edu):
> >> On Tue, Apr 20, 2010 at 8:37 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> >> >
> >> > At least in the case of SELinux, context transitions upon execve are
> >> > already disabled in the nosuid case, and Eric's patch updated the
> >> > SELinux test accordingly.
> >>
> >> I don't see that code in current -linus, nor do I see where SELinux
> >> affects dumpability.  What's supposed to happen?  I'm writing a patch
> >> right now to clean this stuff up.
> >
> > check out security/selinux/hooks.c:selinux_bprm_set_creds()
> >
> >        if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
> >                new_tsec->sid = old_tsec->sid;
> >
> > I assume that's it?
> 
> *sigh*, that's it, of course.
> 
> But it seems odd that if you ask the system to change sid (i.e.
> exec_sid) and then you exec something that's nosuid, your request gets
> silently ignored.  Presumably either the request should be respected
> or some error should occur.
> 
> Also, the FILE__EXECUTE_NO_TRANS check looks bogus in the nosuid case
> -- you can't trust security labels if nosuid.

The current behavior, while possibly non-ideal, matches that of nosuid -
we suppress context transitions for files on that filesystem (without
preventing execution of files - for which there is a separate option,
noexec), while still accepting uids provided by the filesystem as
attributes for its files.  It was only intended to prevent privilege
escalation via executables on such a nosuid filesystem.  If you further
want to suppress all use of security contexts from the filesystem, then
you'd use the context= mount option that was later introduced.

In any event, you cannot simply change existing kernel behavior like
this, as it will break existing userspace+policy.  We can evolve the
logic conditional on some policy setting, but we have to preserve the
existing behavior for existing userland/policy.

> Here's a compile-tested patch (against current -git) that might make
> this all it bit more sane, and as a bonus it makes it easier to reuse
> the NOSUID mechanism down the road for some prctl flag.  Thoughts?
> SECINITSID_UNLABELED might want to be SECINITSID_FILE.

NAK for the changes to SELinux other than just changing the test to use
your new field (which btw looks just like a subset of Eric's patch aside
from naming it ->file_nosuid vs. just ->nosuid).

> diff --git a/fs/exec.c b/fs/exec.c
> index 49cdaa1..9b34234 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1151,11 +1151,14 @@ int prepare_binprm(struct linux_binprm *bprm)
>  	if (bprm->file->f_op == NULL)
>  		return -EACCES;
> 
> +	/* Check this exactly once to avoid races. */
> +	bprm->file_nosuid = !!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID);
> +
>  	/* clear any previous set[ug]id data from a previous binary */
>  	bprm->cred->euid = current_euid();
>  	bprm->cred->egid = current_egid();
> 
> -	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
> +	if (!bprm->file_nosuid) {
>  		/* Set-uid? */
>  		if (mode & S_ISUID) {
>  			bprm->per_clear |= PER_CLEAR_ON_SETID;
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index c809e28..ff6be04 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -36,6 +36,8 @@ struct linux_binprm{
>  	struct mm_struct *mm;
>  	unsigned long p; /* current top of mem */
>  	unsigned int
> +		file_nosuid:1,  /* true if file's security state should
> +				   be ignored. */
>  		cred_prepared:1,/* true if creds already prepared (multiple
>  				 * preps happen for interpreters) */
>  		cap_effective:1;/* true if has elevated effective capabilities,
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 6166973..4836913 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -390,7 +390,7 @@ static int get_file_caps(struct linux_binprm
> *bprm, bool *effective)
>  	if (!file_caps_enabled)
>  		return 0;
> 
> -	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
> +	if (bprm->file_nosuid)
>  		return 0;
> 
>  	dentry = dget(bprm->file->f_dentry);
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 5feecb4..762ac00 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2100,7 +2100,7 @@ static int selinux_bprm_set_creds(struct
> linux_binprm *bprm)
>  {
>  	const struct task_security_struct *old_tsec;
>  	struct task_security_struct *new_tsec;
> -	struct inode_security_struct *isec;
> +	u32 isid;
>  	struct common_audit_data ad;
>  	struct inode *inode = bprm->file->f_path.dentry->d_inode;
>  	int rc;
> @@ -2116,7 +2116,9 @@ static int selinux_bprm_set_creds(struct
> linux_binprm *bprm)
> 
>  	old_tsec = current_security();
>  	new_tsec = bprm->cred->security;
> -	isec = inode->i_security;
> +	isid = ((struct inode_security_struct*)inode->i_security)->sid;
> +	if (bprm->file_nosuid)
> +		isid = SECINITSID_UNLABELED;
> 
>  	/* Default to the current task SID. */
>  	new_tsec->sid = old_tsec->sid;
> @@ -2133,7 +2135,7 @@ static int selinux_bprm_set_creds(struct
> linux_binprm *bprm)
>  		new_tsec->exec_sid = 0;
>  	} else {
>  		/* Check for a default transition on this program. */
> -		rc = security_transition_sid(old_tsec->sid, isec->sid,
> +		rc = security_transition_sid(old_tsec->sid, isid,
>  					     SECCLASS_PROCESS, &new_tsec->sid);
>  		if (rc)
>  			return rc;
> @@ -2142,11 +2144,8 @@ static int selinux_bprm_set_creds(struct
> linux_binprm *bprm)
>  	COMMON_AUDIT_DATA_INIT(&ad, FS);
>  	ad.u.fs.path = bprm->file->f_path;
> 
> -	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
> -		new_tsec->sid = old_tsec->sid;
> -
>  	if (new_tsec->sid == old_tsec->sid) {
> -		rc = avc_has_perm(old_tsec->sid, isec->sid,
> +		rc = avc_has_perm(old_tsec->sid, isid,
>  				  SECCLASS_FILE, FILE__EXECUTE_NO_TRANS, &ad);
>  		if (rc)
>  			return rc;
> @@ -2157,7 +2156,7 @@ static int selinux_bprm_set_creds(struct
> linux_binprm *bprm)
>  		if (rc)
>  			return rc;
> 
> -		rc = avc_has_perm(new_tsec->sid, isec->sid,
> +		rc = avc_has_perm(new_tsec->sid, isid,
>  				  SECCLASS_FILE, FILE__ENTRYPOINT, &ad);
>  		if (rc)
>  			return rc;
-- 
Stephen Smalley
National Security Agency

