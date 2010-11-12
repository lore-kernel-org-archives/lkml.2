Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab0KLNiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:38:52 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:44601 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932094Ab0KLNis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:38:48 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: NBzIJUUVM1nH1TcVCsiQOkIp_.ro.j1yiRf2llkRigFC9yU
 PtpI_Jr5khx0ylX.4h99BIC45MIpRJhwdD0vzgc9OZbrvYNHbi3ORLz_PE2s
 zUNFK6IEkCV1.hSt_B6syrg4BTlZXuNxT5fIkLKoGWkwWZFVNxIqt8646M3A
 ll4zQmQ4ScdFJmx7vvRsem4jHi7m_GgouSzV7b1wWJIT6r08M0HnJHAG2tfC
 a9BwSugGd44sFczuc9SXLEkye.jo3L3TFgR_BGVG_uZGGw7DQXycVuw06ZA3
 c9752Luqgolhw.IZJkIX4mShFEEefI.sdkIOGrn7y
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4CDD4349.6090601@schaufler-ca.com>
Date: Fri, 12 Nov 2010 05:38:17 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: label for task objects
References: <4CDC1D5A.6010604@gmail.com>
In-Reply-To: <4CDC1D5A.6010604@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 8:44 AM, Jarkko Sakkinen wrote:

> Applied against
> http://gitorious.org/simplified-mandatory-access-control-kernel
> This patch adds a new security attribute to Smack called
> SMACK64EXEC. It defines label that is used while task is
> running.
> Exception: in smack_task_wait() child task is checked
> for write access to parent task using label inherited
> from the task that forked it.
The smk_task value needs to get reset if the SMACK64EXEC attribute
gets written. I have a fix that I am testing and will pass along
presently.

> Signed-off-by: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
> ---
>  include/linux/xattr.h         |    2 +
>  security/smack/smack.h        |   30 +++++++
>  security/smack/smack_access.c |    4 +-
>  security/smack/smack_lsm.c    |  168 
> ++++++++++++++++++++++++++++++-----------
>  security/smack/smackfs.c      |    4 +-
>  5 files changed, 159 insertions(+), 49 deletions(-)
> diff --git a/include/linux/xattr.h b/include/linux/xattr.h
> index f1e5bde..351c790 100644
> --- a/include/linux/xattr.h
> +++ b/include/linux/xattr.h
> @@ -40,9 +40,11 @@
>  #define XATTR_SMACK_SUFFIX "SMACK64"
>  #define XATTR_SMACK_IPIN "SMACK64IPIN"
>  #define XATTR_SMACK_IPOUT "SMACK64IPOUT"
> +#define XATTR_SMACK_EXEC "SMACK64EXEC"
>  #define XATTR_NAME_SMACK XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
>  #define XATTR_NAME_SMACKIPIN    XATTR_SECURITY_PREFIX XATTR_SMACK_IPIN
>  #define XATTR_NAME_SMACKIPOUT    XATTR_SECURITY_PREFIX XATTR_SMACK_IPOUT
> +#define XATTR_NAME_SMACKEXEC    XATTR_SECURITY_PREFIX XATTR_SMACK_EXEC
>   #define XATTR_CAPS_SUFFIX "capability"
>  #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 43ae747..a2e2cdf 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -51,10 +51,16 @@ struct socket_smack {
>   */
>  struct inode_smack {
>      char        *smk_inode;    /* label of the fso */
> +    char        *smk_task;    /* label of the task */
>      struct mutex    smk_lock;    /* initialization lock */
>      int        smk_flags;    /* smack inode flags */
>  };
>  +struct task_smack {
> +    char        *smk_task;    /* label used for access control */
> +    char        *smk_forked;    /* label when forked */
> +};
> +
>  #define    SMK_INODE_INSTANT    0x01    /* inode is instantiated */
>   /*
> @@ -243,6 +249,30 @@ static inline char *smk_of_inode(const struct inode 
> *isp)
>  }
>   /*
> + * Present a pointer to the smack label in an task blob.
> + */
> +static inline char *smk_of_task(const struct task_smack *tsp)
> +{
> +    return tsp->smk_task;
> +}
> +
> +/*
> + * Present a pointer to the forked smack label in an task blob.
> + */
> +static inline char *smk_of_forked(const struct task_smack *tsp)
> +{
> +    return tsp->smk_forked;
> +}
> +
> +/*
> + * Present a pointer to the smack label in the curren task blob.
> + */
> +static inline char *smk_of_current(void)
> +{
> +    return smk_of_task(current_security());
> +}
> +
> +/*
>   * logging functions
>   */
>  #define SMACK_AUDIT_DENIED 0x1
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index f4fac64..42becbc 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -185,7 +185,7 @@ out_audit:
>  int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
>  {
>      int rc;
> -    char *sp = current_security();
> +    char *sp = smk_of_current();
>       rc = smk_access(sp, obj_label, mode, NULL);
>      if (rc == 0)
> @@ -196,7 +196,7 @@ int smk_curacc(char *obj_label, u32 mode, struct 
> smk_audit_info *a)
>       * only one that gets privilege and current does not
>       * have that label.
>       */
> -    if (smack_onlycap != NULL && smack_onlycap != current->cred->security)
> +    if (smack_onlycap != NULL && smack_onlycap != sp)
>          goto out_audit;
>       if (capable(CAP_MAC_OVERRIDE))
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index a1bdbfa..14be2b2 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -43,7 +43,7 @@
>   * Returns a pointer to the master list entry for the Smack label
>   * or NULL if there was no label to fetch.
>   */
> -static char *smk_fetch(struct inode *ip, struct dentry *dp)
> +static char *smk_fetch(const char *name, struct inode *ip, struct 
> dentry *dp)
>  {
>      int rc;
>      char in[SMK_LABELLEN];
> @@ -51,7 +51,7 @@ static char *smk_fetch(struct inode *ip, struct dentry 
> *dp)
>      if (ip->i_op->getxattr == NULL)
>          return NULL;
>  -    rc = ip->i_op->getxattr(dp, XATTR_NAME_SMACK, in, SMK_LABELLEN);
> +    rc = ip->i_op->getxattr(dp, name, in, SMK_LABELLEN);
>      if (rc < 0)
>          return NULL;
>  @@ -103,8 +103,8 @@ static int smack_ptrace_access_check(struct 
> task_struct *ctp, unsigned int mode)
>      if (rc != 0)
>          return rc;
>  -    sp = current_security();
> -    tsp = task_security(ctp);
> +    sp = smk_of_current();
> +    tsp = smk_of_task(task_security(ctp));
>      smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
>      smk_ad_setfield_u_tsk(&ad, ctp);
>  @@ -138,8 +138,8 @@ static int smack_ptrace_traceme(struct task_struct 
> *ptp)
>      smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
>      smk_ad_setfield_u_tsk(&ad, ptp);
>  -    sp = current_security();
> -    tsp = task_security(ptp);
> +    sp = smk_of_current();
> +    tsp = smk_of_task(task_security(ptp));
>      /* we won't log here, because rc can be overriden */
>      rc = smk_access(tsp, sp, MAY_READWRITE, NULL);
>      if (rc != 0 && has_capability(ptp, CAP_MAC_OVERRIDE))
> @@ -160,7 +160,7 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
>  static int smack_syslog(int type, bool from_file)
>  {
>      int rc;
> -    char *sp = current_security();
> +    char *sp = smk_of_current();
>       rc = cap_syslog(type, from_file);
>      if (rc != 0)
> @@ -395,6 +395,40 @@ static int smack_sb_umount(struct vfsmount *mnt, 
> int flags)
>  }
>   /*
> + * BPRM hooks
> + */
> +
> +static int smack_bprm_set_creds(struct linux_binprm *bprm)
> +{
> +    struct task_smack *tsp = bprm->cred->security;
> +    struct inode_smack *isp;
> +    struct dentry *dp;
> +    int rc;
> +
> +    rc = cap_bprm_set_creds(bprm);
> +    if (rc != 0)
> +        return rc;
> +
> +    if (bprm->cred_prepared)
> +        return 0;
> +
> +    if (bprm->file == NULL || bprm->file->f_dentry == NULL)
> +        return 0;
> +
> +    dp = bprm->file->f_dentry;
> +
> +    if (dp->d_inode == NULL)
> +        return 0;
> +
> +    isp = dp->d_inode->i_security;
> +
> +    if (isp->smk_task != NULL)
> +        tsp->smk_task = isp->smk_task;
> +
> +    return 0;
> +}
> +
> +/*
>   * Inode hooks
>   */
>  @@ -406,7 +440,7 @@ static int smack_sb_umount(struct vfsmount *mnt, 
> int flags)
>   */
>  static int smack_inode_alloc_security(struct inode *inode)
>  {
> -    inode->i_security = new_inode_smack(current_security());
> +    inode->i_security = new_inode_smack(smk_of_current());
>      if (inode->i_security == NULL)
>          return -ENOMEM;
>      return 0;
> @@ -668,7 +702,8 @@ static int smack_inode_setxattr(struct dentry 
> *dentry, const char *name,
>       if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
>          strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
> -        strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
> +        strcmp(name, XATTR_NAME_SMACKIPOUT) == 0 ||
> +        strcmp(name, XATTR_NAME_SMACKEXEC) == 0) {
>          if (!capable(CAP_MAC_ADMIN))
>              rc = -EPERM;
>          /*
> @@ -761,7 +796,8 @@ static int smack_inode_removexattr(struct dentry 
> *dentry, const char *name)
>       if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
>          strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
> -        strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
> +        strcmp(name, XATTR_NAME_SMACKIPOUT) == 0 ||
> +        strcmp(name, XATTR_NAME_SMACKEXEC) == 0) {
>          if (!capable(CAP_MAC_ADMIN))
>              rc = -EPERM;
>      } else
> @@ -899,7 +935,7 @@ static int smack_file_permission(struct file *file, 
> int mask)
>   */
>  static int smack_file_alloc_security(struct file *file)
>  {
> -    file->f_security = current_security();
> +    file->f_security = smk_of_current();
>      return 0;
>  }
>  @@ -1009,7 +1045,7 @@ static int smack_file_fcntl(struct file *file, 
> unsigned int cmd,
>   */
>  static int smack_file_set_fowner(struct file *file)
>  {
> -    file->f_security = current_security();
> +    file->f_security = smk_of_current();
>      return 0;
>  }
>  @@ -1029,7 +1065,7 @@ static int smack_file_send_sigiotask(struct 
> task_struct *tsk,
>  {
>      struct file *file;
>      int rc;
> -    char *tsp = tsk->cred->security;
> +    char *tsp = smk_of_task(tsk->cred->security);
>      struct smk_audit_info ad;
>       /*
> @@ -1086,7 +1122,9 @@ static int smack_file_receive(struct file *file)
>   */
>  static int smack_cred_alloc_blank(struct cred *cred, gfp_t gfp)
>  {
> -    cred->security = NULL;
> +    cred->security = kzalloc(sizeof(struct task_smack), gfp);
> +    if (cred->security == NULL)
> +        return -ENOMEM;
>      return 0;
>  }
>  @@ -1101,7 +1139,7 @@ static int smack_cred_alloc_blank(struct cred 
> *cred, gfp_t gfp)
>   */
>  static void smack_cred_free(struct cred *cred)
>  {
> -    cred->security = NULL;
> +    kfree(cred->security);
>  }
>   /**
> @@ -1115,7 +1153,16 @@ static void smack_cred_free(struct cred *cred)
>  static int smack_cred_prepare(struct cred *new, const struct cred *old,
>                    gfp_t gfp)
>  {
> -    new->security = old->security;
> +    struct task_smack *old_tsp = old->security;
> +    struct task_smack *new_tsp;
> +
> +    new_tsp = kzalloc(sizeof(struct task_smack), gfp);
> +    if (new_tsp == NULL)
> +        return -ENOMEM;
> +
> +    new_tsp->smk_task = old_tsp->smk_task;
> +    new_tsp->smk_forked = old_tsp->smk_task;
> +    new->security = new_tsp;
>      return 0;
>  }
>  @@ -1128,7 +1175,11 @@ static int smack_cred_prepare(struct cred *new, 
> const struct cred *old,
>   */
>  static void smack_cred_transfer(struct cred *new, const struct cred *old)
>  {
> -    new->security = old->security;
> +    struct task_smack *old_tsp = old->security;
> +    struct task_smack *new_tsp = new->security;
> +
> +    new_tsp->smk_task = old_tsp->smk_task;
> +    new_tsp->smk_forked = old_tsp->smk_task;
>  }
>   /**
> @@ -1140,12 +1191,13 @@ static void smack_cred_transfer(struct cred 
> *new, const struct cred *old)
>   */
>  static int smack_kernel_act_as(struct cred *new, u32 secid)
>  {
> +    struct task_smack *new_tsp = new->security;
>      char *smack = smack_from_secid(secid);
>       if (smack == NULL)
>          return -EINVAL;
>  -    new->security = smack;
> +    new_tsp->smk_task = smack;
>      return 0;
>  }
>  @@ -1161,8 +1213,10 @@ static int smack_kernel_create_files_as(struct 
> cred *new,
>                      struct inode *inode)
>  {
>      struct inode_smack *isp = inode->i_security;
> +    struct task_smack *tsp = new->security;
>  -    new->security = isp->smk_inode;
> +    tsp->smk_forked = isp->smk_inode;
> +    tsp->smk_task = isp->smk_inode;
>      return 0;
>  }
>  @@ -1179,7 +1233,7 @@ static int smk_curacc_on_task(struct task_struct 
> *p, int access)
>       smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
>      smk_ad_setfield_u_tsk(&ad, p);
> -    return smk_curacc(task_security(p), access, &ad);
> +    return smk_curacc(smk_of_task(task_security(p)), access, &ad);
>  }
>   /**
> @@ -1225,7 +1279,7 @@ static int smack_task_getsid(struct task_struct *p)
>   */
>  static void smack_task_getsecid(struct task_struct *p, u32 *secid)
>  {
> -    *secid = smack_to_secid(task_security(p));
> +    *secid = smack_to_secid(smk_of_task(task_security(p)));
>  }
>   /**
> @@ -1337,14 +1391,15 @@ static int smack_task_kill(struct task_struct 
> *p, struct siginfo *info,
>       * can write the receiver.
>       */
>      if (secid == 0)
> -        return smk_curacc(task_security(p), MAY_WRITE, &ad);
> +        return smk_curacc(smk_of_task(task_security(p)), MAY_WRITE,
> +                  &ad);
>      /*
>       * If the secid isn't 0 we're dealing with some USB IO
>       * specific behavior. This is not clean. For one thing
>       * we can't take privilege into account.
>       */
> -    return smk_access(smack_from_secid(secid), task_security(p),
> -              MAY_WRITE, &ad);
> +    return smk_access(smack_from_secid(secid),
> +              smk_of_task(task_security(p)), MAY_WRITE, &ad);
>  }
>   /**
> @@ -1356,12 +1411,12 @@ static int smack_task_kill(struct task_struct 
> *p, struct siginfo *info,
>  static int smack_task_wait(struct task_struct *p)
>  {
>      struct smk_audit_info ad;
> -    char *sp = current_security();
> -    char *tsp = task_security(p);
> +    char *sp = smk_of_current();
> +    char *tsp = smk_of_forked(task_security(p));
>      int rc;
>       /* we don't log here, we can be overriden */
> -    rc = smk_access(sp, tsp, MAY_WRITE, NULL);
> +    rc = smk_access(tsp, sp, MAY_WRITE, NULL);
>      if (rc == 0)
>          goto out_log;
>  @@ -1382,7 +1437,7 @@ static int smack_task_wait(struct task_struct *p)
>   out_log:
>      smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
>      smk_ad_setfield_u_tsk(&ad, p);
> -    smack_log(sp, tsp, MAY_WRITE, rc, &ad);
> +    smack_log(tsp, sp, MAY_WRITE, rc, &ad);
>      return rc;
>  }
>  @@ -1396,7 +1451,7 @@ static int smack_task_wait(struct task_struct *p)
>  static void smack_task_to_inode(struct task_struct *p, struct inode 
> *inode)
>  {
>      struct inode_smack *isp = inode->i_security;
> -    isp->smk_inode = task_security(p);
> +    isp->smk_inode = smk_of_task(task_security(p));
>  }
>   /*
> @@ -1415,7 +1470,7 @@ static void smack_task_to_inode(struct task_struct 
> *p, struct inode *inode)
>   */
>  static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t 
> gfp_flags)
>  {
> -    char *csp = current_security();
> +    char *csp = smk_of_current();
>      struct socket_smack *ssp;
>       ssp = kzalloc(sizeof(struct socket_smack), gfp_flags);
> @@ -1756,7 +1811,7 @@ static int smack_flags_to_may(int flags)
>   */
>  static int smack_msg_msg_alloc_security(struct msg_msg *msg)
>  {
> -    msg->security = current_security();
> +    msg->security = smk_of_current();
>      return 0;
>  }
>  @@ -1792,7 +1847,7 @@ static int smack_shm_alloc_security(struct 
> shmid_kernel *shp)
>  {
>      struct kern_ipc_perm *isp = &shp->shm_perm;
>  -    isp->security = current_security();
> +    isp->security = smk_of_current();
>      return 0;
>  }
>  @@ -1915,7 +1970,7 @@ static int smack_sem_alloc_security(struct 
> sem_array *sma)
>  {
>      struct kern_ipc_perm *isp = &sma->sem_perm;
>  -    isp->security = current_security();
> +    isp->security = smk_of_current();
>      return 0;
>  }
>  @@ -2033,7 +2088,7 @@ static int smack_msg_queue_alloc_security(struct 
> msg_queue *msq)
>  {
>      struct kern_ipc_perm *kisp = &msq->q_perm;
>  -    kisp->security = current_security();
> +    kisp->security = smk_of_current();
>      return 0;
>  }
>  @@ -2205,7 +2260,7 @@ static void smack_d_instantiate(struct dentry 
> *opt_dentry, struct inode *inode)
>      struct super_block *sbp;
>      struct superblock_smack *sbsp;
>      struct inode_smack *isp;
> -    char *csp = current_security();
> +    char *csp = smk_of_current();
>      char *fetched;
>      char *final;
>      struct dentry *dp;
> @@ -2325,9 +2380,13 @@ static void smack_d_instantiate(struct dentry 
> *opt_dentry, struct inode *inode)
>           * Get the dentry for xattr.
>           */
>          dp = dget(opt_dentry);
> -        fetched = smk_fetch(inode, dp);
> -        if (fetched != NULL)
> +        fetched = smk_fetch(XATTR_NAME_SMACK, inode, dp);
> +        if (fetched != NULL) {
>              final = fetched;
> +            isp->smk_task = smk_fetch(XATTR_NAME_SMACKEXEC, inode,
> +                          dp);
> +        }
> +
>          dput(dp);
>          break;
>      }
> @@ -2362,7 +2421,7 @@ static int smack_getprocattr(struct task_struct 
> *p, char *name, char **value)
>      if (strcmp(name, "current") != 0)
>          return -EINVAL;
>  -    cp = kstrdup(task_security(p), GFP_KERNEL);
> +    cp = kstrdup(smk_of_task(task_security(p)), GFP_KERNEL);
>      if (cp == NULL)
>          return -ENOMEM;
>  @@ -2386,6 +2445,7 @@ static int smack_getprocattr(struct task_struct 
> *p, char *name, char **value)
>  static int smack_setprocattr(struct task_struct *p, char *name,
>                   void *value, size_t size)
>  {
> +    struct task_smack *tsp;
>      struct cred *new;
>      char *newsmack;
>  @@ -2418,7 +2478,13 @@ static int smack_setprocattr(struct task_struct 
> *p, char *name,
>      new = prepare_creds();
>      if (new == NULL)
>          return -ENOMEM;
> -    new->security = newsmack;
> +    tsp = kzalloc(sizeof(struct task_smack), GFP_KERNEL);
> +    if (tsp == NULL) {
> +        kfree(new);
> +        return -ENOMEM;
> +    }
> +    tsp->smk_task = newsmack;
> +    new->security = tsp;
>      commit_creds(new);
>      return size;
>  }
> @@ -2719,7 +2785,7 @@ static void smack_sock_graft(struct sock *sk, 
> struct socket *parent)
>          return;
>       ssp = sk->sk_security;
> -    ssp->smk_in = ssp->smk_out = current_security();
> +    ssp->smk_in = ssp->smk_out = smk_of_current();
>      /* cssp->smk_packet is already set in smack_inet_csk_clone() */
>  }
>  @@ -2840,7 +2906,7 @@ static void smack_inet_csk_clone(struct sock *sk,
>  static int smack_key_alloc(struct key *key, const struct cred *cred,
>                 unsigned long flags)
>  {
> -    key->security = cred->security;
> +    key->security = smk_of_task(cred->security);
>      return 0;
>  }
>  @@ -2869,6 +2935,7 @@ static int smack_key_permission(key_ref_t key_ref,
>  {
>      struct key *keyp;
>      struct smk_audit_info ad;
> +    char *tsp = smk_of_task(cred->security);
>       keyp = key_ref_to_ptr(key_ref);
>      if (keyp == NULL)
> @@ -2882,14 +2949,14 @@ static int smack_key_permission(key_ref_t key_ref,
>      /*
>       * This should not occur
>       */
> -    if (cred->security == NULL)
> +    if (tsp == NULL)
>          return -EACCES;
>  #ifdef CONFIG_AUDIT
>      smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_KEY);
>      ad.a.u.key_struct.key = keyp->serial;
>      ad.a.u.key_struct.key_desc = keyp->description;
>  #endif
> -    return smk_access(cred->security, keyp->security,
> +    return smk_access(tsp, keyp->security,
>                   MAY_READWRITE, &ad);
>  }
>  #endif /* CONFIG_KEYS */
> @@ -3091,6 +3158,8 @@ struct security_operations smack_ops = {
>      .sb_mount =             smack_sb_mount,
>      .sb_umount =             smack_sb_umount,
>  +    .bprm_set_creds =        smack_bprm_set_creds,
> +
>      .inode_alloc_security =     smack_inode_alloc_security,
>      .inode_free_security =         smack_inode_free_security,
>      .inode_init_security =         smack_inode_init_security,
> @@ -3227,9 +3296,16 @@ static __init void init_smack_know_list(void)
>  static __init int smack_init(void)
>  {
>      struct cred *cred;
> +    struct task_smack *tsp;
> +
> +    tsp = kzalloc(sizeof(struct task_smack), GFP_KERNEL);
> +    if (tsp == NULL)
> +        return -ENOMEM;
>  -    if (!security_module_enable(&smack_ops))
> +    if (!security_module_enable(&smack_ops)) {
> +        kfree(tsp);
>          return 0;
> +    }
>       printk(KERN_INFO "Smack:  Initializing.\n");
>  @@ -3237,7 +3313,9 @@ static __init int smack_init(void)
>       * Set the security state for the initial task.
>       */
>      cred = (struct cred *) current->cred;
> -    cred->security = &smack_known_floor.smk_known;
> +    tsp->smk_forked = smack_known_floor.smk_known;
> +    tsp->smk_task = smack_known_floor.smk_known;
> +    cred->security = tsp;
>       /* initialize the smack_know_list */
>      init_smack_know_list();
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index dc1fd62..01a0be9 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -121,7 +121,7 @@ static void smk_netlabel_audit_set(struct 
> netlbl_audit *nap)
>  {
>      nap->loginuid = audit_get_loginuid(current);
>      nap->sessionid = audit_get_sessionid(current);
> -    nap->secid = smack_to_secid(current_security());
> +    nap->secid = smack_to_secid(smk_of_current());
>  }
>   /*
> @@ -1160,7 +1160,7 @@ static ssize_t smk_write_onlycap(struct file 
> *file, const char __user *buf,
>                   size_t count, loff_t *ppos)
>  {
>      char in[SMK_LABELLEN];
> -    char *sp = current->cred->security;
> +    char *sp = smk_of_task(current->cred->security);
>       if (!capable(CAP_MAC_ADMIN))
>          return -EPERM;

