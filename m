Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab2JSWKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:10:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41373 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933027Ab2JSWKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:10:40 -0400
Date: Fri, 19 Oct 2012 23:10:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk
Message-ID: <20121019221030.GC13292@decadent.org.uk>
References: <20121019024350.087156547@linuxfoundation.org>
 <20121019024351.583490752@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019024351.583490752@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 09/76] lockd: use rpc clients cl_nodename for id encoding
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 07:46:33PM -0700, Greg Kroah-Hartman wrote:
> 3.6-stable review patch.  If anyone has any objections, please let me know.
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
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  fs/lockd/mon.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/fs/lockd/mon.c
> +++ b/fs/lockd/mon.c
> @@ -42,6 +42,7 @@ struct nsm_args {
>  	u32			proc;
>  
>  	char			*mon_name;
> +	char			*nodename;
>  };
>  
>  struct nsm_res {
> @@ -141,6 +142,7 @@ static int nsm_mon_unmon(struct nsm_hand
>  		.vers		= 3,
>  		.proc		= NLMPROC_NSM_NOTIFY,
>  		.mon_name	= nsm->sm_mon_name,
> +		.nodename	= utsname()->nodename,

Can we be sure that this string pointer will remain valid at the point
where current->nsproxy has become NULL?  Or should nsm_args::nodename
actually be a copy of the string?

Ben.

>  	};
>  	struct rpc_message msg = {
>  		.rpc_argp	= &args,
> @@ -477,7 +479,7 @@ static void encode_my_id(struct xdr_stre
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
