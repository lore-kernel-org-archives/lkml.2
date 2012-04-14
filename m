Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab2DNG0E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 02:26:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56866 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2DNG0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 02:26:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6679"; a="179387190"
X-IronPort-AV: E=Sophos;i="4.75,420,1330934400"; 
   d="scan'208";a="302870271"
Date: Sat, 14 Apr 2012 11:56:46 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Madhan Jaganathan <madhanj@qca.qualcomm.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Paul Stewart <pstew@google.com>,
        Gary Morain <gmorain@google.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 31/78] ath9k: fix max noise floor threshold
Message-ID: <20120414062643.GA9827@vmraj-lnx.users.atheros.com>
References: <20120411231023.489450259@linuxfoundation.org>
 <1334381772.7150.412.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1334381772.7150.412.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 06:36:12AM +0100, Ben Hutchings wrote:
> On Wed, 2012-04-11 at 16:10 -0700, Greg KH wrote:
> > 3.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > 
> > commit 2ee0a07028d2cde6e131b73f029dae2b93c50f3a upstream.
> > 
> > Currently the maximum noise floor limit is set as too high (-60dB). The
> > assumption of having a higher threshold limit is that it would help
> > de-sensitize the receiver (reduce phy errors) from continuous
> > interference. But when we have a bursty interference where there are
> > collisions and then free air time and if the receiver is desensitized too
> > much, it will miss the normal packets too. Lets make use of chips
> > specific min, nom and max limits always. This patch helps to improve the
> > connection stability in congested networks.
> [...]
> 
> It looks like this is also applicable to 3.0 and 3.2, but the debug
> logging statement changed between 3.2 and 3.3 and stopped this from
> applying directly.  Attaching an (untested) backport.
> 
Thanks a lot Ben. looks fine.

-Rajkumar
> 
> -- 
> Ben Hutchings
> It is easier to change the specification to fit the program than vice versa.

> From 6d19cb7b3325e6c460db0f07f178793f4500783a Mon Sep 17 00:00:00 2001
> From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Date: Thu, 15 Mar 2012 06:08:04 +0530
> Subject: [PATCH] ath9k: fix max noise floor threshold
> 
> commit 2ee0a07028d2cde6e131b73f029dae2b93c50f3a upstream.
> 
> Currently the maximum noise floor limit is set as too high (-60dB). The
> assumption of having a higher threshold limit is that it would help
> de-sensitize the receiver (reduce phy errors) from continuous
> interference. But when we have a bursty interference where there are
> collisions and then free air time and if the receiver is desensitized too
> much, it will miss the normal packets too. Lets make use of chips
> specific min, nom and max limits always. This patch helps to improve the
> connection stability in congested networks.
> 
> Cc: Paul Stewart <pstew@google.com>
> Tested-by: Gary Morain <gmorain@google.com>
> Signed-off-by: Madhan Jaganathan <madhanj@qca.qualcomm.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> [bwh: Backported to 3.0/3.2: adjust context]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/net/wireless/ath/ath9k/calib.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
> index 8ddef3e..d771de5 100644
> --- a/drivers/net/wireless/ath/ath9k/calib.c
> +++ b/drivers/net/wireless/ath/ath9k/calib.c
> @@ -20,7 +20,6 @@
>  
>  /* Common calibration code */
>  
> -#define ATH9K_NF_TOO_HIGH	-60
>  
>  static int16_t ath9k_hw_get_nf_hist_mid(int16_t *nfCalBuffer)
>  {
> @@ -348,10 +347,10 @@ static void ath9k_hw_nf_sanitize(struct ath_hw *ah, s16 *nf)
>  			"NF calibrated [%s] [chain %d] is %d\n",
>  			(i >= 3 ? "ext" : "ctl"), i % 3, nf[i]);
>  
> -		if (nf[i] > ATH9K_NF_TOO_HIGH) {
> +		if (nf[i] > limit->max) {
>  			ath_dbg(common, ATH_DBG_CALIBRATE,
>  				"NF[%d] (%d) > MAX (%d), correcting to MAX\n",
> -				i, nf[i], ATH9K_NF_TOO_HIGH);
> +				i, nf[i], limit->max);
>  			nf[i] = limit->max;
>  		} else if (nf[i] < limit->min) {
>  			ath_dbg(common, ATH_DBG_CALIBRATE,
> -- 
> 1.7.9.5
> 



