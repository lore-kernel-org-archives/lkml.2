Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab2DDNWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 09:22:30 -0400
Received: from msa106.auone-net.jp ([61.117.18.166]:36265 "EHLO
	msa106.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2DDNW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 09:22:29 -0400
Date: Wed, 4 Apr 2012 22:22:27 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Commit 8ef874bfc7296fa206eea2ad1e8a426f576bf6f6 has broken ss
 command
References: <20120404090312.1B68C6AC03E@msa102.auone-net.jp>
 <1333530463.18626.545.camel@edumazet-glaptop>
 <20120404100015.D41B162C03E@msa106.auone-net.jp>
 <1333534877.18626.566.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333534877.18626.566.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <20120404132228.3C5B262C03B@msa106.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-04 12:21:17 +0200, Eric Dumazet wrote:
> Please try this patch :
> 
> diff --git a/misc/ss.c b/misc/ss.c
> index 5414f75..8c00760 100644
> --- a/misc/ss.c
> +++ b/misc/ss.c
> @@ -1534,8 +1534,10 @@ static int tcp_show_netlink(struct filter *f, FILE *dump_fp, int socktype)
>  		.msg_iovlen = f->f ? 3 : 1,
>  	};
>  
> -	if (sendmsg(fd, &msg, 0) < 0)
> +	if (sendmsg(fd, &msg, 0) < 0) {
> +		close(fd);
>  		return -1;
> +	}
>  
>  	iov[0] = (struct iovec){
>  		.iov_base = buf,
> @@ -1589,6 +1591,10 @@ static int tcp_show_netlink(struct filter *f, FILE *dump_fp, int socktype)
>  					fprintf(stderr, "ERROR truncated\n");
>  				} else {
>  					errno = -err->error;
> +					if (errno == EOPNOTSUPP) {
> +						close(fd);
> +						return -1;
> +					}
>  					perror("TCPDIAG answers");
>  				}
>  				close(fd);

This patch solved the problem. Thank you!
