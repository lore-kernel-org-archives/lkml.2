Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2AWSK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:10:28 -0500
Received: from mx2.netapp.com ([216.240.18.37]:32809 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab2AWSK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:10:26 -0500
X-IronPort-AV: E=Sophos;i="4.71,557,1320652800"; 
   d="scan'208";a="619171478"
Message-ID: <1327342224.2628.3.camel@lade.trondhjem.org>
Subject: Re: linux-next: build failure after merge of the final tree (nfs
 tree related)
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Date: Mon, 23 Jan 2012 13:10:24 -0500
In-Reply-To: <20120123135942.3e991094b91d9087d2ba81ae@canb.auug.org.au>
References: <20120123135942.3e991094b91d9087d2ba81ae@canb.auug.org.au>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
X-OriginalArrivalTime: 23 Jan 2012 18:10:26.0098 (UTC) FILETIME=[48104920:01CCD9FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 13:59 +1100, Stephen Rothwell wrote: 
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
> 
> net/sunrpc/svcsock.c: In function 'svc_setup_socket':
> net/sunrpc/svcsock.c:1412:40: error: 'struct sock_common' has no member named 'skc_net'
> 
> This build has CONFIG_NET_NS unset.
> 
> Caused by commit eff9c3383687 ("SUNRPC: pass network namespace to service
> registering routines").
> 
> I applied this (suboptimal) patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 23 Jan 2012 13:55:01 +1100
> Subject: [PATCH] SUNRPC: fixup for namespace changes
> 
> Fixes this build error when CONFIG_NET_NS is not set:
> 
> net/sunrpc/svcsock.c: In function 'svc_setup_socket':
> net/sunrpc/svcsock.c:1412:40: error: 'struct sock_common' has no member named 'skc_net'
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  net/sunrpc/svcsock.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index e8af0c9..4d02d1a 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -41,6 +41,7 @@
>  #include <net/ipv6.h>
>  #include <net/tcp.h>
>  #include <net/tcp_states.h>
> +#include <net/net_namespace.h>
>  #include <asm/uaccess.h>
>  #include <asm/ioctls.h>
>  
> @@ -1409,7 +1410,13 @@ static struct svc_sock *svc_setup_socket(struct svc_serv *serv,
>  
>  	/* Register socket with portmapper */
>  	if (*errp >= 0 && pmap_register)
> -		*errp = svc_register(serv, sock->sk->sk_net, inet->sk_family,
> +		*errp = svc_register(serv,
> +#ifdef CONFIG_NET_NS
> +				     sock->sk->sk_net,
> +#else
> +				     &init_net,
> +#endif
> +				     inet->sk_family,
>  				     inet->sk_protocol,
>  				     ntohs(inet_sk(inet)->inet_sport));
>  
> -- 
> 1.7.9.rc0.23.g7e521

Stanislav,

Shouldn't we just be using a 'sock_net(sock->sk)'?

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

