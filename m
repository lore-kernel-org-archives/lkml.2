Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab0KZLDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:03:10 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44816 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab0KZLDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:03:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: Free memory never fully used, swapping
Cc: kosaki.motohiro@jp.fujitsu.com, Simon Kirby <sim@hostway.ca>,
        Shaohua Li <shaohua.li@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <20101125161238.GD26037@csn.ul.ie>
References: <20101125090328.GB14180@hostway.ca> <20101125161238.GD26037@csn.ul.ie>
Message-Id: <20101126195118.B6E7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 26 Nov 2010 20:03:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two points.

> @@ -2310,10 +2324,12 @@ loop_again:
>  				 * spectulatively avoid congestion waits
>  				 */
>  				zone_clear_flag(zone, ZONE_CONGESTED);
> +				if (i <= pgdat->high_zoneidx)
> +					any_zone_ok = 1;
>  			}
>  
>  		}
> -		if (all_zones_ok)
> +		if (all_zones_ok || (order && any_zone_ok))
>  			break;		/* kswapd: all done */
>  		/*
>  		 * OK, kswapd is getting into trouble.  Take a nap, then take
> @@ -2336,7 +2352,7 @@ loop_again:
>  			break;
>  	}
>  out:
> -	if (!all_zones_ok) {
> +	if (!(all_zones_ok || (order && any_zone_ok))) {

This doesn't work ;)
kswapd have to clear ZONE_CONGESTED flag before enter sleeping.
otherwise nobody can clear it.

Say, we have to fill below condition.
 - All zone are successing zone_watermark_ok(order-0)
 - At least one zone are successing zone_watermark_ok(high-order)



> @@ -2417,6 +2439,7 @@ static int kswapd(void *p)
>  		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
>  		new_order = pgdat->kswapd_max_order;
>  		pgdat->kswapd_max_order = 0;
> +		pgdat->high_zoneidx = MAX_ORDER;

I don't think MAX_ORDER is correct ;)

        high_zoneidx = pgdat->high_zoneidx;
        pgdat->high_zoneidx = pgdat->nr_zones - 1;

?


And, we have another kswapd_max_order reading place. (after kswapd_try_to_sleep)
We need it too.




