Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1ASFpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 00:45:52 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46632 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1ASFpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 00:45:51 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LKLM <linux-kernel@vger.kernel.org>, xemul@openvz.org,
        David Miller <davem@davemloft.net>,
        "Sakkinen Jarkko.2 \(EXT-Tieto\/Tampere\)" 
	<ext-jarkko.2.sakkinen@nokia.com>,
        Janne Karhunen <Janne.Karhunen@nokia.com>,
        "Reshetova Elena \(Nokia-D\/Helsinki\)" <elena.reshetova@nokia.com>
References: <4D3466BD.10500@schaufler-ca.com>
Date: Tue, 18 Jan 2011 21:45:38 -0800
In-Reply-To: <4D3466BD.10500@schaufler-ca.com> (Casey Schaufler's message of
	"Mon, 17 Jan 2011 07:56:45 -0800")
Message-ID: <m1k4i1igzh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18sJc08yT2+3gUsuVHdLf0+Wv3K1kxf8Lk=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Casey Schaufler <casey@schaufler-ca.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] scm: provide full privilege set via SCM_PRIVILEGE
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> Subject: [PATCH] scm: provide full privilege set via SCM_PRIVILEGE
>
> The SCM mechanism currently provides interfaces for delivering
> the uid/gid and the "security context" (LSM information) of the
> peer on a UDS socket. All of the security credential information
> is available, but there is no interface available to obtain it.
> Further, the existing interfaces require that the user chose
> between the uid/gid and the context as the existing interfaces
> are exclusive.
>
> This patch introduces an additional interface that provides
> a complete set of security information from the peer credential.
> No additional work is required to provide the information
> internally, it is all being passed, just not exposed.

In ascii text?
A bitmap in hex?

Maybe it is just me, but this seems harder to deal with than
if the data had been transferred in binary.

Eric

>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> ---
>
>  include/asm-generic/socket.h |    1 +
>  include/linux/net.h          |    1 +
>  include/linux/socket.h       |    1 +
>  include/net/scm.h            |   80 +++++++++++++++++++++++++++++++++++++++++-
>  net/core/sock.c              |   11 ++++++
>  5 files changed, 93 insertions(+), 1 deletions(-)
> diff --git a/include/asm-generic/socket.h b/include/asm-generic/socket.h
> index 9a6115e..7aa8e84 100644
> --- a/include/asm-generic/socket.h
> +++ b/include/asm-generic/socket.h
> @@ -64,4 +64,5 @@
>  #define SO_DOMAIN		39
>  
>  #define SO_RXQ_OVFL             40
> +#define SO_PASSPRIV		41
>  #endif /* __ASM_GENERIC_SOCKET_H */
> diff --git a/include/linux/net.h b/include/linux/net.h
> index 16faa13..159a929 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -71,6 +71,7 @@ struct net;
>  #define SOCK_NOSPACE		2
>  #define SOCK_PASSCRED		3
>  #define SOCK_PASSSEC		4
> +#define SOCK_PASSPRIV		5
>  
>  #ifndef ARCH_HAS_SOCKET_TYPES
>  /**
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 86b652f..e9cfd68 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -147,6 +147,7 @@ static inline struct cmsghdr * cmsg_nxthdr (struct msghdr *__msg, struct cmsghdr
>  #define	SCM_RIGHTS	0x01		/* rw: access rights (array of int) */
>  #define SCM_CREDENTIALS 0x02		/* rw: struct ucred		*/
>  #define SCM_SECURITY	0x03		/* rw: security label		*/
> +#define SCM_PRIVILEGES  0x04		/* rw: privilege set		*/
>  
>  struct ucred {
>  	__u32	pid;
> diff --git a/include/net/scm.h b/include/net/scm.h
> index 3165650..4b8db21 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -101,6 +101,83 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
>  { }
>  #endif /* CONFIG_SECURITY_NETWORK */
>  
> +static __inline__ void scm_passpriv(struct socket *sock, struct msghdr *msg,
> +				struct scm_cookie *scm)
> +{
> +	const struct cred *credp = scm->cred;
> +	const struct group_info *gip;
> +	char *result;
> +	char *cp;
> +	int i;
> +#ifdef CONFIG_SECURITY_NETWORK
> +	char *secdata;
> +	u32 seclen;
> +	int err;
> +#endif /* CONFIG_SECURITY_NETWORK */
> +
> +	if (!test_bit(SOCK_PASSPRIV, &sock->flags))
> +		return;
> +
> +	gip = credp->group_info;
> +
> +	/*
> +	 * uid + euid + gid + egid + group-list + capabilities
> +	 *     + "uid=" + "euid=" + "gid=" + "egid=" + "grps="
> +	 *     + "cap-e=" + "cap-p=" + "cap-i="
> +	 * 10  + 10   + 10  + 10   + (ngrps * 10) + ecap + pcap + icap
> +	 *     + 4 + 5 + 4 + 5 + 5 + 6 + 6 + 6
> +	 */
> +	i = ((4 + gip->ngroups) * 11) + (3 * (_KERNEL_CAPABILITY_U32S * 8 + 1))
> +		+ 41;
> +
> +#ifdef CONFIG_SECURITY_NETWORK
> +	err = security_secid_to_secctx(scm->secid, &secdata, &seclen);
> +	if (!err)
> +		/*
> +		 * " context="
> +		 */
> +		i += seclen + 10;
> +#endif /* CONFIG_SECURITY_NETWORK */
> +
> +	result = kzalloc(i, GFP_KERNEL);
> +	if (result == NULL)
> +		return;
> +
> +	cp = result + sprintf(result, "euid=%d uid=%d egid=%d gid=%d",
> +				credp->euid, credp->uid,
> +				credp->egid, credp->gid);
> +
> +	if (gip != NULL && gip->ngroups > 0) {
> +		cp += sprintf(cp, " grps=%d", GROUP_AT(gip, 0));
> +		for (i = 1 ; i < gip->ngroups; i++)
> +			cp += sprintf(cp, ",%d", GROUP_AT(gip, i));
> +	}
> +
> +	cp += sprintf(cp, " cap-e=");
> +	CAP_FOR_EACH_U32(i)
> +		cp += sprintf(cp, "%08x", credp->cap_effective.cap[i]);
> +	cp += sprintf(cp, " cap-p=");
> +	CAP_FOR_EACH_U32(i)
> +		cp += sprintf(cp, "%08x", credp->cap_permitted.cap[i]);
> +	cp += sprintf(cp, " cap-i=");
> +	CAP_FOR_EACH_U32(i)
> +		cp += sprintf(cp, "%08x", credp->cap_inheritable.cap[i]);
> +
> +#ifdef CONFIG_SECURITY_NETWORK
> +	cp += sprintf(cp, " context=");
> +	strncpy(cp, secdata, seclen);
> +	cp += seclen;
> +	*cp = '\0';
> +
> +	security_release_secctx(secdata, seclen);
> +#endif /* CONFIG_SECURITY_NETWORK */
> +
> +	put_cmsg(msg, SOL_SOCKET, SCM_PRIVILEGES, strlen(result)+1, result);
> +
> +	kfree(result);
> +}
> +
> +
>  static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
>  				struct scm_cookie *scm, int flags)
>  {
> @@ -114,6 +191,8 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
>  	if (test_bit(SOCK_PASSCRED, &sock->flags))
>  		put_cmsg(msg, SOL_SOCKET, SCM_CREDENTIALS, sizeof(scm->creds), &scm->creds);
>  
> +	scm_passpriv(sock, msg, scm);
> +
>  	scm_destroy_cred(scm);
>  
>  	scm_passec(sock, msg, scm);
> @@ -124,6 +203,5 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
>  	scm_detach_fds(msg, scm);
>  }
>  
> -
>  #endif /* __LINUX_NET_SCM_H */
>  
> diff --git a/net/core/sock.c b/net/core/sock.c
> index fb60801..f134126 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -725,6 +725,13 @@ set_rcvbuf:
>  		else
>  			clear_bit(SOCK_PASSSEC, &sock->flags);
>  		break;
> +
> +	case SO_PASSPRIV:
> +		if (valbool)
> +			set_bit(SOCK_PASSPRIV, &sock->flags);
> +		else
> +			clear_bit(SOCK_PASSPRIV, &sock->flags);
> +		break;
>  	case SO_MARK:
>  		if (!capable(CAP_NET_ADMIN))
>  			ret = -EPERM;
> @@ -950,6 +957,10 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
>  		v.val = test_bit(SOCK_PASSSEC, &sock->flags) ? 1 : 0;
>  		break;
>  
> +	case SO_PASSPRIV:
> +		v.val = test_bit(SOCK_PASSPRIV, &sock->flags) ? 1 : 0;
> +		break;
> +
>  	case SO_PEERSEC:
>  		return security_socket_getpeersec_stream(sock, optval, optlen, len);
>  
