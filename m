Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0DODZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 23:25:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38325 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0DODZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 23:25:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100414012700.GA10450@sli10-desk.sh.intel.com>
References: <20100413175414.D110.A69D9226@jp.fujitsu.com> <20100414012700.GA10450@sli10-desk.sh.intel.com>
Message-Id: <20100414104434.D135.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 12:25:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

sorry for the delay.

> > After solving streaming io issue, I'll put it to mainline.
> if the streaming io issue is popular, how about below patch against my last one?
> we take priority == DEF_PRIORITY an exception.

Your patch seems works. but it is obviously ugly and bandaid patch.
So, I like single your previous patch rather than combinate this one.
Even though both dropping makes sense rather than both merge.

Please consider attack root cause.



> Index: linux/mm/vmscan.c
> ===================================================================
> --- linux.orig/mm/vmscan.c	2010-04-14 09:03:28.000000000 +0800
> +++ linux/mm/vmscan.c	2010-04-14 09:19:56.000000000 +0800
> @@ -1629,6 +1629,22 @@ static void get_scan_count(struct zone *
>  	fraction[0] = ap;
>  	fraction[1] = fp;
>  	denominator = ap + fp + 1;
> +
> +	/*
> +	 * memory pressure isn't high, we allow percentage underflow. This
> +	 * avoids swap in stream io case.
> +	 */
> +	if (priority == DEF_PRIORITY) {
> +		if (fraction[0] * 99 < fraction[1]) {
> +			fraction[0] = 0;
> +			fraction[1] = 1;
> +			denominator = 1;
> +		} else if (fraction[1] * 99 < fraction[0]) {
> +			fraction[0] = 1;
> +			fraction[1] = 0;
> +			denominator = 1;
> +		}
> +	}
>  out:
>  	for_each_evictable_lru(l) {
>  		int file = is_file_lru(l);
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



