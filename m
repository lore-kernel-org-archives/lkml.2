Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab2HOKxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 06:53:47 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39323 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2HOKxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 06:53:45 -0400
Date: Wed, 15 Aug 2012 06:53:40 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: John Fastabend <john.r.fastabend@intel.com>
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [net PATCH v3 2/3] net: netprio: fd passed in SCM_RIGHTS
 datagram not set correctly
Message-ID: <20120815105340.GB23811@hmsreliant.think-freely.org>
References: <20120814223424.3551.21608.stgit@jf-dev1-dcblab>
 <20120814223430.3551.88909.stgit@jf-dev1-dcblab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814223430.3551.88909.stgit@jf-dev1-dcblab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 03:34:30PM -0700, John Fastabend wrote:
> A socket fd passed in a SCM_RIGHTS datagram was not getting
> updated with the new tasks cgrp prioidx. This leaves IO on
> the socket tagged with the old tasks priority.
> 
> To fix this add a check in the scm recvmsg path to update the
> sock cgrp prioidx with the new tasks value.
> 
> Thanks to Al Viro for catching this.
> 
> CC: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
> ---
> 
>  net/core/scm.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/net/core/scm.c b/net/core/scm.c
> index 8f6ccfd..040cebe 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -265,6 +265,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  	for (i=0, cmfptr=(__force int __user *)CMSG_DATA(cm); i<fdmax;
>  	     i++, cmfptr++)
>  	{
> +		struct socket *sock;
>  		int new_fd;
>  		err = security_file_receive(fp[i]);
>  		if (err)
> @@ -281,6 +282,9 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  		}
>  		/* Bump the usage count and install the file. */
>  		get_file(fp[i]);
> +		sock = sock_from_file(fp[i], &err);
> +		if (sock)
> +			sock_update_netprioidx(sock->sk, current);
>  		fd_install(new_fd, fp[i]);
>  	}
>  
> 
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>

