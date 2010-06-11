Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082Ab0FKChG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 22:37:06 -0400
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:44502 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754825Ab0FKChE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 22:37:04 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: KGf.G_IVM1n6Cg98efz93PWOJ5OoS68CHypbM.uMfb8LsYlATbUYofDdtbwjoQil1TT9ZHNT1jGrVjAZPG.m4zNxcZf2SiKRLZirpOLyhDa0xvmD5v1fsj6LaXLdzcQjhhGbI6LF7nMBdzQ0R7tvLQf9cGFs5NTLMdWISf.ru_sukCgEnKc.ULha6FI5eBqc9_LGehDyYr9CBEMDDIV8mYkHZq2nY6ZF.LWvCmmCP2JQ1xAtQOna8lHoLw2j4keKNkpYFzoy85GdH.vnadEEdAHqcL_ixzRUbRXIgimV_OT3mdvKORqfftheFIcd6MvXyn9JP.v7KNVlbUe9O8wM
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4C11A14D.2070804@schaufler-ca.com>
Date: Thu, 10 Jun 2010 19:37:01 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: hch@infradead.org, viro@zeniv.linux.org.uk, sds@tycho.nsa.gov,
       matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, labeled-nfs@linux-nfs.org
Subject: Re: [PATCH 02/10] Security: Add Hook to test if the particular xattr
 is part of a MAC model.
References: <1276014176-20315-1-git-send-email-dpquigl@tycho.nsa.gov> <1276014176-20315-3-git-send-email-dpquigl@tycho.nsa.gov>
In-Reply-To: <1276014176-20315-3-git-send-email-dpquigl@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Quigley wrote:
> There are areas in the Labeled NFS code where where we need to test if the
> attribute being requested exhibits the semantics of a MAC model. This allows us
> to make sure that we get the desired semantics from the attribute instead of
> something else such as capabilities or a time based LSM.
>
> Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
> Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
> ---
>  include/linux/security.h   |   11 +++++++++++
>  security/capability.c      |    6 ++++++
>  security/security.c        |    6 ++++++
>  security/selinux/hooks.c   |    6 ++++++
>  security/smack/smack_lsm.c |   11 +++++++++++
>  5 files changed, 40 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 4d01784..9597620 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1373,6 +1373,10 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	@pages contains the number of pages.
>   *	Return 0 if permission is granted.
>   *
> + * @ismaclabel:
> + * 	Check if the extended attribute specified by @name represents a MAC label.
> + * 	@name full extended attribute name to check against LSM as a MAC label.
> + *
>   

What about the case where a file might have multiple MAC labels?
Not that I plan to do that, but given how often I get asked if a
file can have multiple MAC attributes you might want to explicitly
define how that might work. Especially in an environment where LSMs
don't stack.

Trusted Irix supports both sensitivity and integrity, and although
Trix uses a single (large) label to include both it was a coin toss
decision between that and two separate labels.


>   * @secid_to_secctx:
>   *	Convert secid to security context.
>   *	@secid contains the security ID.
> @@ -1664,6 +1668,7 @@ struct security_operations {
>  
>  	int (*getprocattr) (struct task_struct *p, char *name, char **value);
>  	int (*setprocattr) (struct task_struct *p, char *name, void *value, size_t size);
> +	int (*ismaclabel) (const char * name);
>  	int (*secid_to_secctx) (u32 secid, char **secdata, u32 *seclen);
>  	int (*secctx_to_secid) (const char *secdata, u32 seclen, u32 *secid);
>  	void (*release_secctx) (char *secdata, u32 seclen);
> @@ -1919,6 +1924,7 @@ int security_getprocattr(struct task_struct *p, char *name, char **value);
>  int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size);
>  int security_netlink_send(struct sock *sk, struct sk_buff *skb);
>  int security_netlink_recv(struct sk_buff *skb, int cap);
> +int security_ismaclabel(const char *name);
>  int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
>  int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
>  void security_release_secctx(char *secdata, u32 seclen);
> @@ -2676,6 +2682,11 @@ static inline int security_netlink_recv(struct sk_buff *skb, int cap)
>  	return cap_netlink_recv(skb, cap);
>  }
>  
> +static inline int security_ismaclabel(const char *name)
> +{
> +	return 0;
> +}
> +
>  static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
>  {
>  	return -EOPNOTSUPP;
> diff --git a/security/capability.c b/security/capability.c
> index 9ce1c2f..0d8f7e9 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -829,6 +829,11 @@ static int cap_setprocattr(struct task_struct *p, char *name, void *value,
>  	return -EINVAL;
>  }
>  
> +static int cap_ismaclabel(const char *name)
> +{
> +	return 0;
> +}
> +
>  static int cap_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
>  {
>  	return -EOPNOTSUPP;
> @@ -1064,6 +1069,7 @@ void security_fixup_ops(struct security_operations *ops)
>  	set_to_cap_if_null(ops, d_instantiate);
>  	set_to_cap_if_null(ops, getprocattr);
>  	set_to_cap_if_null(ops, setprocattr);
> +	set_to_cap_if_null(ops, ismaclabel);
>  	set_to_cap_if_null(ops, secid_to_secctx);
>  	set_to_cap_if_null(ops, secctx_to_secid);
>  	set_to_cap_if_null(ops, release_secctx);
> diff --git a/security/security.c b/security/security.c
> index c1b6847..1f0765c 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1013,6 +1013,12 @@ int security_netlink_recv(struct sk_buff *skb, int cap)
>  }
>  EXPORT_SYMBOL(security_netlink_recv);
>  
> +int security_ismaclabel(const char *name)
> +{
> +	return security_ops->ismaclabel(name);
> +}
> +EXPORT_SYMBOL(security_ismaclabel);
> +
>  int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
>  {
>  	return security_ops->secid_to_secctx(secid, secdata, seclen);
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 435c51f..8239f5c 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5372,6 +5372,11 @@ abort_change:
>  	return error;
>  }
>  
> +static int selinux_ismaclabel(const char *name)
> +{
> +	return (strcmp(name,XATTR_NAME_SELINUX) == 0);
> +}
> +
>  static int selinux_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
>  {
>  	return security_sid_to_context(secid, secdata, seclen);
> @@ -5610,6 +5615,7 @@ static struct security_operations selinux_ops = {
>  	.getprocattr =			selinux_getprocattr,
>  	.setprocattr =			selinux_setprocattr,
>  
> +	.ismaclabel =			selinux_ismaclabel,
>  	.secid_to_secctx =		selinux_secid_to_secctx,
>  	.secctx_to_secid =		selinux_secctx_to_secid,
>  	.release_secctx =		selinux_release_secctx,
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index fdfeaa2..449e223 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -3012,6 +3012,16 @@ static void smack_audit_rule_free(void *vrule)
>  #endif /* CONFIG_AUDIT */
>  
>  /**
> + * smack_ismaclabel - check if xattr @name references a smack MAC label
> + * @name: Full xattr name to check.
> + */
> +static int smack_ismaclabel(const char *name)
> +{
> +	return (strcmp(name, XATTR_NAME_SMACK) == 0);
> +}
> +
> +
> +/**
>   * smack_secid_to_secctx - return the smack label for a secid
>   * @secid: incoming integer
>   * @secdata: destination
> @@ -3199,6 +3209,7 @@ struct security_operations smack_ops = {
>  	.audit_rule_free =		smack_audit_rule_free,
>  #endif /* CONFIG_AUDIT */
>  
> +	.ismaclabel =			smack_ismaclabel,
>  	.secid_to_secctx = 		smack_secid_to_secctx,
>  	.secctx_to_secid = 		smack_secctx_to_secid,
>  	.release_secctx = 		smack_release_secctx,
>   

