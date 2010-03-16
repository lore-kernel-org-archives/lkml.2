Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937974Ab0CPRMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:12:18 -0400
Received: from waste.org ([173.11.57.241]:46452 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933193Ab0CPRMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:12:12 -0400
Subject: Re: [PATCH 1/1] NET: netpoll, fix potential NULL ptr dereference
From: Matt Mackall <mpm@selenic.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Daniel Borkmann <danborkmann@googlemail.com>
In-Reply-To: <1268753394-17765-1-git-send-email-jslaby@suse.cz>
References: <1268753394-17765-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 12:12:07 -0500
Message-ID: <1268759527.25503.2980.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 16:29 +0100, Jiri Slaby wrote:
> Stanse found that one error path in netpoll_setup dereferences npinfo
> even though it is NULL. Avoid that by adding new label and go to that
> instead.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Daniel Borkmann <danborkmann@googlemail.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  net/core/netpoll.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> index 7aa6972..d4ec38f 100644
> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -735,7 +735,7 @@ int netpoll_setup(struct netpoll *np)
>  		npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
>  		if (!npinfo) {
>  			err = -ENOMEM;
> -			goto release;
> +			goto put;
>  		}
>  
>  		npinfo->rx_flags = 0;
> @@ -845,7 +845,7 @@ int netpoll_setup(struct netpoll *np)
>  
>  		kfree(npinfo);
>  	}
> -
> +put:
>  	dev_put(ndev);
>  	return err;
>  }

I don't get it. The source of the branch tests for !ndev->npinfo and the
original destination of the branch also tests for !ndev->npinfo. I don't
see how it gets dereferenced.

This looks like it just patches over a false positive in your tool
(which isn't correlating the validity of npinfo with ndev->npinfo)
without actually improving the code. However, it seems that we can drop
the second check at release if we add your new exit point.

-- 
http://selenic.com : development and support for Mercurial and Linux


