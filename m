Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888Ab0FJWsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 18:48:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53173 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab0FJWsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 18:48:39 -0400
X-Authority-Analysis: v=1.1 cv=rR912iD8TqKBQWPhXASLR67rt2rT9ApkpBWj5XB9Duc= c=1 sm=0 a=l0vWjkAIsFQA:10 a=yQWWgrYGNuUA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=BulHB4dBAAAA:8 a=VnNF1IyMAAAA:8 a=XnEp0smhP56TeH7YzVMA:9 a=RK_Ee4clrYU8xpQspoAA:7 a=W0vlE3hO9951npFOs2A6tzdC5EkA:4 a=CjuIK1q_8ugA:10 a=B8IJiNHybsEA:10 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Thu, 10 Jun 2010 17:48:45 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, labeled-nfs@linux-nfs.org
Subject: Re: [PATCH 02/10] Security: Add Hook to test if the particular
 xattr is part of a MAC model.
Message-ID: <20100610224845.GA27104@hallyn.com>
References: <1276014176-20315-1-git-send-email-dpquigl@tycho.nsa.gov>
 <1276014176-20315-3-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276014176-20315-3-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David P. Quigley (dpquigl@tycho.nsa.gov):
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

Can you document the return value here?  The name does suggestion true/false
rather than success/fail, but it would be nice to have it spelled out without
having to look at one of the implementations to be sure.

Otherwise

Acked-by: Serge E. Hallyn <serue@us.ibm.com>


> + *
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
> -- 
> 1.6.2.5
> 
> 
> --
> This message was distributed to subscribers of the selinux mailing list.
> If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
> the words "unsubscribe selinux" without quotes as the message.
