Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab1J0Rmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 13:42:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7122 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab1J0Rml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 13:42:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 27 Oct 2011 10:42:40 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "pavel@ucw.cz" <pavel@ucw.cz>, "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Thu, 27 Oct 2011 23:12:37 +0530
Subject: RE: [PATCH] PM: fix calculation mistake in roll-over cases
Thread-Topic: [PATCH] PM: fix calculation mistake in roll-over cases
Thread-Index: AcyTFv7I10HHq9xGS6u0cVWRZkVU/QBtrX4w
Message-ID: <D958900912E20642BCBC71664EFECE3E6D123A0AFF@BGMAIL02.nvidia.com>
References: <1319538052-2480-1-git-send-email-vbyravarasu@nvidia.com>
 <201110251508.40854.rjw@sisk.pl>
In-Reply-To: <201110251508.40854.rjw@sisk.pl>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
Sent: Tuesday, October 25, 2011 6:39 PM
To: Venu Byravarasu
Cc: pavel@ucw.cz; len.brown@intel.com; gregkh@suse.de; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Alan Stern
Subject: Re: [PATCH] PM: fix calculation mistake in roll-over cases

On Tuesday, October 25, 2011, vbyravarasu@nvidia.com wrote:
> From: venu byravarasu <vbyravarasu@nvidia.com>
> 
> In case of jiffies roll over, delta is made zero.
> Hence fixing it, after taking roll over into consideration.
> 
> Signed-off-by: venu byravarasu <vbyravarasu@nvidia.com>
> ---
> When jiffies roll over, calculation of time spent in the
> current state (stored in variable 'delta') is incorrect.
> Hence fixing it, after taking roll over into consideration.
> 
>  drivers/base/power/runtime.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 1079e03..bd93fb0 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -30,12 +30,13 @@ static int rpm_suspend(struct device *dev, int rpmflags);
>  void update_pm_runtime_accounting(struct device *dev)
>  {
>  	unsigned long now = jiffies;
> -	int delta;
> +	unsigned long delta;
> +	unsigned long max_num = ~0;
>  
>  	delta = now - dev->power.accounting_timestamp;
>  
> -	if (delta < 0)
> -		delta = 0;
> +	if (now < dev->power.accounting_timestamp)
> +		delta = max_num - dev->power.accounting_timestamp + now;
>  
>  	dev->power.accounting_timestamp = now;

> I'm not sure how this is supposed to improve things.  Care to give more
> details?
Below two items were taken care with this change:
1. Value of now is jiffies which is unsigned long.
As it is being stored in delta of 'int' type, for all values of now > 0x80000000,
Delta will be made 0 with the original if condition.
By changing delta to unsigned long, this is taken care.

2. Even if delta is made unsigned, in cases of jiffies roll over, delta will be zero.
That is also being taken care with the code added as part of if condition.

Plz let me know if you still have any questions.
> Rafael
Thanks,
Venu
