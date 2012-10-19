Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab2JSXP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 19:15:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41828 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090Ab2JSXP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 19:15:26 -0400
Date: Sat, 20 Oct 2012 00:15:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Message-ID: <20121019231518.GE13292@decadent.org.uk>
References: <20121019031302.789593147@linuxfoundation.org>
 <20121019031303.167008948@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019031303.167008948@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 02/37] lockd: use rpc clients cl_nodename for id encoding
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 08:16:25PM -0700, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Stanislav Kinsbursky <skinsbursky@parallels.com>
> 
> commit 303a7ce92064c285a04c870f2dc0192fdb2968cb upstream.
> 
> Taking hostname from uts namespace if not safe, because this cuold be
> performind during umount operation on child reaper death. And in this case
> current->nsproxy is NULL already.
 
In this case (3.0.y) you haven't included the following change
(commit cb7323fffa85 'lockd: create and use per-net NSM RPC clients on
MON/UNMON requests') that makes lockd actually use cl_nodename.  I
think this patch alone won't fix the bug, as nsm_args::nodename can
end up pointing to freed memory.

(I also wonder whether clients should really be per-net or per UTS
namespace, and whether those should be orthogonal namespaces at all.)

Ben.

[....]
> --- a/fs/lockd/mon.c
> +++ b/fs/lockd/mon.c
> @@ -40,6 +40,7 @@ struct nsm_args {
>  	u32			proc;
>  
>  	char			*mon_name;
> +	char			*nodename;
>  };
>  
>  struct nsm_res {
> @@ -93,6 +94,7 @@ static int nsm_mon_unmon(struct nsm_hand
>  		.vers		= 3,
>  		.proc		= NLMPROC_NSM_NOTIFY,
>  		.mon_name	= nsm->sm_mon_name,
> +		.nodename	= utsname()->nodename,
>  	};
>  	struct rpc_message msg = {
>  		.rpc_argp	= &args,
> @@ -429,7 +431,7 @@ static void encode_my_id(struct xdr_stre
>  {
>  	__be32 *p;
>  
> -	encode_nsm_string(xdr, utsname()->nodename);
> +	encode_nsm_string(xdr, argp->nodename);
>  	p = xdr_reserve_space(xdr, 4 + 4 + 4);
>  	*p++ = cpu_to_be32(argp->prog);
>  	*p++ = cpu_to_be32(argp->vers);

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
