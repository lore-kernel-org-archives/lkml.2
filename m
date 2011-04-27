Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267Ab1D0XvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:51:03 -0400
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:24714 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753561Ab1D0XvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:51:01 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: pYoctjsVM1n1aA5feu3gumJmuUXHYMeLMtN2S18hG2I4pkS
 TuS.kFBrFz5jEnULCUzBol1MUu5HtGk4YZDFds7gh.IBSuAcfzkGoxn.AELg
 YPDUTQpsbHMJkMA9ncxw8q691XOammOXwsJJvU6lx_KZOQav6x.cCiZp7MXH
 NoyFY0TdqCEd.mwpUlLBulUBfzG9LYFb4PTXVF4Tz82GsR2phnEGoAypfj.n
 l2SW8WuYNZ1KoCGcPQmflb5dawQW8a0NhqdVBMcHrFJCwqmfiB3ZECF7EoYR
 XXX0W2A.JGhw78I_WbrOd6yyGTm2xRo_8kRsmHJLCinqhxqvCrjvNgrboZyw
 obIb4TgCnKvzfgXOEUPaHAQDT4WyU2W8Kkn_FZtoagQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DB8ABE2.5080704@schaufler-ca.com>
Date: Wed, 27 Apr 2011 16:50:58 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Roberto Sassu <roberto.sassu@polito.it>
CC: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        ecryptfs-devel@lists.launchpad.net, eparis@redhat.com,
        sds@tycho.nsa.gov, selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 6/7] security: new LSM hook security_file_getsecid()
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it> <1303907657-18366-7-git-send-email-roberto.sassu@polito.it>
In-Reply-To: <1303907657-18366-7-git-send-email-roberto.sassu@polito.it>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/2011 5:34 AM, Roberto Sassu wrote:
> The new LSM hook security_file_getsecid() and its implementation in the
> capability module, SELinux and SMACK allows to obtain the security
> identifier associated to a file descriptor.

Why do you want a secid? You have the security information from
the file structure readily available.

What use to you intend to put this to?

> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  include/linux/security.h   |   12 ++++++++++++
>  security/capability.c      |    6 ++++++
>  security/security.c        |    6 ++++++
>  security/selinux/hooks.c   |    7 +++++++
>  security/smack/smack_lsm.c |   11 +++++++++++
>  5 files changed, 42 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/security.h b/include/linux/security.h
> index ca02f17..6e73a1a 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -630,6 +630,11 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	to receive an open file descriptor via socket IPC.
>   *	@file contains the file structure being received.
>   *	Return 0 if permission is granted.
> + * @file_getsecid:
> + *	Get the secid associated with the file descriptor.
> + *	@file contains a pointer to the file descriptor.
> + *	@secid contains a pointer to the location where result will be saved.
> + *	In case of failure, @secid will be set to zero.
>   *
>   * Security hook for dentry
>   *
> @@ -1492,6 +1497,7 @@ struct security_operations {
>  	int (*file_send_sigiotask) (struct task_struct *tsk,
>  				    struct fown_struct *fown, int sig);
>  	int (*file_receive) (struct file *file);
> +	void (*file_getsecid)(const struct file *file, u32 *secid);
>  	int (*dentry_open) (struct file *file, const struct cred *cred);
>  
>  	int (*task_create) (unsigned long clone_flags);
> @@ -1751,6 +1757,7 @@ int security_file_set_fowner(struct file *file);
>  int security_file_send_sigiotask(struct task_struct *tsk,
>  				 struct fown_struct *fown, int sig);
>  int security_file_receive(struct file *file);
> +void security_file_getsecid(const struct file *file, u32 *secid);
>  int security_dentry_open(struct file *file, const struct cred *cred);
>  int security_task_create(unsigned long clone_flags);
>  int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
> @@ -2251,6 +2258,11 @@ static inline int security_file_receive(struct file *file)
>  	return 0;
>  }
>  
> +static inline void security_file_getsecid(const struct file *file, u32 *secid)
> +{
> +	*secid = 0;
> +}
> +
>  static inline int security_dentry_open(struct file *file,
>  				       const struct cred *cred)
>  {
> diff --git a/security/capability.c b/security/capability.c
> index 2984ea4..fcb569d 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -349,6 +349,11 @@ static int cap_file_receive(struct file *file)
>  	return 0;
>  }
>  
> +static void cap_file_getsecid(const struct file *file, u32 *secid)
> +{
> +	*secid = 0;
> +}
> +
>  static int cap_dentry_open(struct file *file, const struct cred *cred)
>  {
>  	return 0;
> @@ -953,6 +958,7 @@ void __init security_fixup_ops(struct security_operations *ops)
>  	set_to_cap_if_null(ops, file_set_fowner);
>  	set_to_cap_if_null(ops, file_send_sigiotask);
>  	set_to_cap_if_null(ops, file_receive);
> +	set_to_cap_if_null(ops, file_getsecid);
>  	set_to_cap_if_null(ops, dentry_open);
>  	set_to_cap_if_null(ops, task_create);
>  	set_to_cap_if_null(ops, cred_alloc_blank);
> diff --git a/security/security.c b/security/security.c
> index 1011423..9973dab 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -688,6 +688,12 @@ int security_file_receive(struct file *file)
>  	return security_ops->file_receive(file);
>  }
>  
> +void security_file_getsecid(const struct file *file, u32 *secid)
> +{
> +	security_ops->file_getsecid(file, secid);
> +}
> +EXPORT_SYMBOL(security_file_getsecid);
> +
>  int security_dentry_open(struct file *file, const struct cred *cred)
>  {
>  	int ret;
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 6772687..e1e787c 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3179,6 +3179,12 @@ static int selinux_file_receive(struct file *file)
>  	return file_has_perm(cred, file, file_to_av(file));
>  }
>  
> +static void selinux_file_getsecid(const struct file *file, u32 *secid)
> +{
> +	struct file_security_struct *fsec = file->f_security;
> +	*secid = fsec->sid;
> +}
> +
>  static int selinux_dentry_open(struct file *file, const struct cred *cred)
>  {
>  	struct file_security_struct *fsec;
> @@ -5498,6 +5504,7 @@ static struct security_operations selinux_ops = {
>  	.file_set_fowner =		selinux_file_set_fowner,
>  	.file_send_sigiotask =		selinux_file_send_sigiotask,
>  	.file_receive =			selinux_file_receive,
> +	.file_getsecid =		selinux_file_getsecid,
>  
>  	.dentry_open =			selinux_dentry_open,
>  
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 6612ba1..a583736 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1304,6 +1304,16 @@ static int smack_file_receive(struct file *file)
>  	return smk_curacc(file->f_security, may, &ad);
>  }
>  
> +/**
> + * smack_file_getsecid - Extract file descriptor's security id
> + * @file: file descriptor to extract the info from
> + * @secid: where result will be saved
> + */
> +static void smack_file_getsecid(const struct file *file, u32 *secid)
> +{
> +	*secid = smack_to_secid(file->f_security);
> +}
> +
>  /*
>   * Task hooks
>   */
> @@ -3434,6 +3444,7 @@ struct security_operations smack_ops = {
>  	.file_set_fowner = 		smack_file_set_fowner,
>  	.file_send_sigiotask = 		smack_file_send_sigiotask,
>  	.file_receive = 		smack_file_receive,
> +	.file_getsecid =		smack_file_getsecid,
>  
>  	.cred_alloc_blank =		smack_cred_alloc_blank,
>  	.cred_free =			smack_cred_free,

