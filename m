Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab1JJPxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:53:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50016 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1JJPxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:53:41 -0400
Date: Mon, 10 Oct 2011 11:53:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-x86_64@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH] cpu idle ticks show twice in xen pvm guest
Message-ID: <20111010155319.GA29140@phenom.oracle.com>
References: <ce19ea02-45e6-465a-a4c8-b5d74bf8c2ad@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce19ea02-45e6-465a-a4c8-b5d74bf8c2ad@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E931502.0110:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 10:11:58PM -0700, Zhenzhong Duan wrote:
> Run below test on xen pvm.
> # x=$(cat /proc/stat | grep cpu0 | awk '{print $5}') && sleep 60  \
> && y=$(cat /proc/stat | grep cpu0 | awk '{print $5}') \
> && echo -e  "X:$x\nY:$y\nIDLE:" $(echo "scale=3; ($y-$x)/6000*100" | bc)
> 
> @ X:58562301
> @ Y:58574282
> @ IDLE: 199.600
> 
> Normal idle percent should be around 100%.
> xen_timer_interrupt called account_idle_ticks to account hypervisor stolen idle ticks 
> but these ticks will be accounted again when idle ticks restarted.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Signed-off-by: Joe Jin <joe.jin@oracle.com>

Please in the future also CC the maintainers (you can get that using
the scripts/get_maintainer.pl).

Jeremy, any thoughts?
> 
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 163b467..5dcbc91 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -151,7 +151,6 @@ static void do_stolen_accounting(void)
>  
>  	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);
>  	__this_cpu_write(xen_residual_blocked, blocked);
> -	account_idle_ticks(ticks);
>  }
>  
>  /* Get the TSC speed from Xen */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
