Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab1ECIzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 04:55:48 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:28006
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509Ab1ECIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 04:55:46 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2cK1432N98dKzz1202hzz8275chz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKM3GU-01-4Q0-02
X-M-MSG: 
Date: Tue, 3 May 2011 10:55:40 +0200
From: Robert Richter <robert.richter@amd.com>
To: Nicolas Kaiser <nikai@nikai.net>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] s390: oprofile: fix error checks in
 oprofile_hwsampler_init()
Message-ID: <20110503085540.GX31407@erda.amd.com>
References: <20110502154805.71664123@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110502154805.71664123@absol.kitzblitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.05.11 09:48:05, Nicolas Kaiser wrote:
> Checking 'oprofile_min_interval < 0' and
> 'oprofile_max_interval < 0' doesn't work because
> 'oprofile_min_interval' and 'oprofile_max_interval' are unsigned.

max/min_interval are through all the code always unsigned. I don't
know how min/max_sampl_rate in struct hws_qsi_info_block is spec'ed,
but there it is unsigned too.

So the best would be to return qsi.min/max_sampl_rate in
hwsampler_query_min/max_interval() directly with no error codes as
unsigned longs and to change the code in oprofile_hwsampler_init() to
check for null. Both functions hwsampler_query_min/max_interval()
could be moved to hwsampler.h as static inline functions. This makes
the code also easier.

This patch does not handle the null value case and the data truncation
by casting from unsigned to singed is not fixed.

-Robert

> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
> Untested.
> 
>  arch/s390/oprofile/init.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
> index c63d7e5..09c3088 100644
> --- a/arch/s390/oprofile/init.c
> +++ b/arch/s390/oprofile/init.c
> @@ -138,22 +138,26 @@ static int oprofile_create_hwsampling_files(struct super_block *sb,
>  
>  static int oprofile_hwsampler_init(struct oprofile_operations *ops)
>  {
> +	long retval;
> +
>  	if (hwsampler_setup())
>  		return -ENODEV;
>  
>  	/*
>  	 * create hwsampler files only if hwsampler_setup() succeeds.
>  	 */
> -	oprofile_min_interval = hwsampler_query_min_interval();
> -	if (oprofile_min_interval < 0) {
> +	retval = hwsampler_query_min_interval();
> +	if (retval < 0) {
>  		oprofile_min_interval = 0;
>  		return -ENODEV;
>  	}
> -	oprofile_max_interval = hwsampler_query_max_interval();
> -	if (oprofile_max_interval < 0) {
> +	oprofile_min_interval = retval;
> +	retval = hwsampler_query_max_interval();
> +	if (retval < 0) {
>  		oprofile_max_interval = 0;
>  		return -ENODEV;
>  	}
> +	oprofile_max_interval = retval;
>  
>  	if (oprofile_timer_init(ops))
>  		return -ENODEV;
> -- 
> 1.7.3.4
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

