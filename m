Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0HKQBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:01:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43489 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab0HKQBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G6t5l+ei5a8hDeIc4UXVZNyOC8mRk2s513RDgCFgM4bp0fp0WkKikEom8T+qb6DfhK
         Jl6XqI3n8wllxFtkNBfTfr3TFY47kKm8tgILJCubXLrSk98qclRu8kZK6RlM7lonyYXw
         5mv4HSdwaGXZwG3a1hH+QQdPKiTwa3tlYb074=
MIME-Version: 1.0
In-Reply-To: <20100811083753.19001.28878.stgit@warthog.procyon.org.uk>
References: <20100811083753.19001.28878.stgit@warthog.procyon.org.uk>
Date: Wed, 11 Aug 2010 11:01:19 -0500
Message-ID: <AANLkTinFOhtSe8nXu1pHbD+vbyFzgsgOqqz7SJ_70bT9@mail.gmail.com>
Subject: Re: [PATCH 1/3] NFS: Use kernel DNS resolver [ver #2]
From: Steve French <smfrench@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches 1 - 3 of this series now in cifs-2.6.git

On Wed, Aug 11, 2010 at 3:37 AM, David Howells <dhowells@redhat.com> wrote:
> From: Bryan Schumaker <bjschuma@netapp.com>
>
> Use the kernel DNS resolver to translate hostnames to IP addresses.  Create a
> new config option to choose between the legacy DNS resolver and the new
> resolver.
>
> Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
> Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  fs/nfs/Kconfig       |   16 ++++++++++++++++
>  fs/nfs/dns_resolve.c |   24 ++++++++++++++++++++++++
>  fs/nfs/dns_resolve.h |   12 ++++++++++++
>  3 files changed, 52 insertions(+), 0 deletions(-)
>
> diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
> index cc1bb33..c5bbdca 100644
> --- a/fs/nfs/Kconfig
> +++ b/fs/nfs/Kconfig
> @@ -100,3 +100,19 @@ config NFS_FSCACHE
>        help
>          Say Y here if you want NFS data to be cached locally on disc through
>          the general filesystem cache manager
> +
> +config NFS_USE_LEGACY_DNS
> +       bool "Use the legacy NFS DNS resolver"
> +       depends on NFS_V4
> +       help
> +         The kernel now provides a method for translating a host name into an
> +         IP address.  Select Y here if you would rather use your own DNS
> +         resolver script.
> +
> +         If unsure, say N
> +
> +config NFS_USE_KERNEL_DNS
> +       bool
> +       depends on NFS_V4 && !NFS_USE_LEGACY_DNS
> +       select DNS_RESOLVER
> +       default y
> diff --git a/fs/nfs/dns_resolve.c b/fs/nfs/dns_resolve.c
> index 76fd235..dba50a5 100644
> --- a/fs/nfs/dns_resolve.c
> +++ b/fs/nfs/dns_resolve.c
> @@ -6,6 +6,29 @@
>  * Resolves DNS hostnames into valid ip addresses
>  */
>
> +#ifdef CONFIG_NFS_USE_KERNEL_DNS
> +
> +#include <linux/sunrpc/clnt.h>
> +#include <linux/dns_resolver.h>
> +
> +ssize_t nfs_dns_resolve_name(char *name, size_t namelen,
> +               struct sockaddr *sa, size_t salen)
> +{
> +       ssize_t ret;
> +       char *ip_addr = NULL;
> +       int ip_len;
> +
> +       ip_len = dns_query(NULL, name, namelen, NULL, &ip_addr, NULL);
> +       if (ip_len > 0)
> +               ret = rpc_pton(ip_addr, ip_len, sa, salen);
> +       else
> +               ret = -ESRCH;
> +       kfree(ip_addr);
> +       return ret;
> +}
> +
> +#else
> +
>  #include <linux/hash.h>
>  #include <linux/string.h>
>  #include <linux/kmod.h>
> @@ -346,3 +369,4 @@ void nfs_dns_resolver_destroy(void)
>        nfs_cache_unregister(&nfs_dns_resolve);
>  }
>
> +#endif
> diff --git a/fs/nfs/dns_resolve.h b/fs/nfs/dns_resolve.h
> index a3f0938..199bb55 100644
> --- a/fs/nfs/dns_resolve.h
> +++ b/fs/nfs/dns_resolve.h
> @@ -6,8 +6,20 @@
>
>  #define NFS_DNS_HOSTNAME_MAXLEN        (128)
>
> +
> +#ifdef CONFIG_NFS_USE_KERNEL_DNS
> +static inline int nfs_dns_resolver_init(void)
> +{
> +       return 0;
> +}
> +
> +static inline void nfs_dns_resolver_destroy(void)
> +{}
> +#else
>  extern int nfs_dns_resolver_init(void);
>  extern void nfs_dns_resolver_destroy(void);
> +#endif
> +
>  extern ssize_t nfs_dns_resolve_name(char *name, size_t namelen,
>                struct sockaddr *sa, size_t salen);
>
>
>



-- 
Thanks,

Steve
