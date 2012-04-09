Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab2DIIq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:46:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31823 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab2DIIq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:46:58 -0400
X-AuditID: cbfee61a-b7c49ae0000061d4-0c-4f82a200ddbc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>
Cc: "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1333944982-15859-1-git-send-email-olof@lixom.net>
In-reply-to: <1333944982-15859-1-git-send-email-olof@lixom.net>
Subject: RE: [PATCH] video: exynos: fix build warning and bad pointer deref in
 dp driver
Date: Mon, 09 Apr 2012 17:46:56 +0900
Message-id: <002301cd162d$51bd6b00$f5384100$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0WB47Ng3u4GY5tShC3ai7B1T/BfwAJVrqg
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Olof Johansson [mailto:olof@lixom.net]
> Sent: Monday, April 09, 2012 1:16 PM
> 
> I'm not 100% sure if the fix for 'adjust_request' is correct, since
> it's uncertain what the original intent was. But it's so clearly an
> uninitialized pointer dereference that my resolution seems to make sense.
> 
> drivers/video/exynos/exynos_dp_core.c: In function 'exynos_dp_set_link_train':
> drivers/video/exynos/exynos_dp_core.c:521:21: warning: 'adjust_request' may be used uninitialized in
> this function [-Wuninitialized]
> drivers/video/exynos/exynos_dp_core.c:481:6: note: 'adjust_request' was declared here
> drivers/video/exynos/exynos_dp_core.c:529:18: warning: 'reg' may be used uninitialized in this function
> [-Wuninitialized]
> drivers/video/exynos/exynos_dp_core.c:395:6: note: 'reg' was declared here
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  drivers/video/exynos/exynos_dp_core.c |   23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
> index 2a4481c..8973e18 100644
> --- a/drivers/video/exynos/exynos_dp_core.c
> +++ b/drivers/video/exynos/exynos_dp_core.c
> @@ -392,24 +392,19 @@ static unsigned int exynos_dp_get_lane_link_training(
>  				struct exynos_dp_device *dp,
>  				int lane)
>  {
> -	u32 reg;
> -
>  	switch (lane) {
>  	case 0:
> -		reg = exynos_dp_get_lane0_link_training(dp);
> -		break;
> +		return exynos_dp_get_lane0_link_training(dp);
>  	case 1:
> -		reg = exynos_dp_get_lane1_link_training(dp);
> -		break;
> +		return exynos_dp_get_lane1_link_training(dp);
>  	case 2:
> -		reg = exynos_dp_get_lane2_link_training(dp);
> -		break;
> +		return exynos_dp_get_lane2_link_training(dp);
>  	case 3:
> -		reg = exynos_dp_get_lane3_link_training(dp);
> -		break;
> +		return exynos_dp_get_lane3_link_training(dp);
>  	}

I don't like multi return.

> 
> -	return reg;
> +	WARN_ON(1);
> +	return 0;
>  }
> 
>  static void exynos_dp_reduce_link_rate(struct exynos_dp_device *dp)
> @@ -489,13 +484,13 @@ static int exynos_dp_process_clock_recovery(struct exynos_dp_device *dp)
>  				6, link_status);
>  	lane_count = dp->link_train.lane_count;
> 
> +	adjust_request = link_status + (DPCD_ADDR_ADJUST_REQUEST_LANE0_1
> +					- DPCD_ADDR_LANE0_1_STATUS);
> +

It makes the problem. adjust_request will be different.

OK, I understand what you want to do.
I will send the version 2 patch which is simpler.

Thank you for sending the patch.

>  	if (exynos_dp_clock_recovery_ok(link_status, lane_count) == 0) {
>  		/* set training pattern 2 for EQ */
>  		exynos_dp_set_training_pattern(dp, TRAINING_PTN2);
> 
> -		adjust_request = link_status + (DPCD_ADDR_ADJUST_REQUEST_LANE0_1
> -						- DPCD_ADDR_LANE0_1_STATUS);
> -
>  		exynos_dp_get_adjust_train(dp, adjust_request);
> 
>  		buf[0] = DPCD_SCRAMBLING_DISABLED |
> --
> 1.7.9.2.359.gebfc2

