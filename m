Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab1IAJQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:16:01 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:35820 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab1IAJP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:15:59 -0400
X-Greylist: delayed 1085 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Sep 2011 05:15:59 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E5F4F3B.7000607@cam.ac.uk>
Date: Thu, 01 Sep 2011 10:24:11 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110801 Thunderbird/5.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Stephen Warren <swarren@nvidia.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Russell King <linux@arm.linux.org.uk>, Andrew Chew <achew@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/3] staging:iio:magnetometer:ak8975 Don't use irq_to_gpio()
References: <1314819657-828-1-git-send-email-swarren@nvidia.com> <4E5F4B4E.5060801@cam.ac.uk>
In-Reply-To: <4E5F4B4E.5060801@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/11 10:07, Jonathan Cameron wrote:
> On 08/31/11 20:40, Stephen Warren wrote:
>> Tegra doesn't have irq_to_gpio() any more, and ak8975 is included in
>> tegra_defconfig. This causes a build failure. Solve this with a heavy-handed
>> method for now.
>>
>> I suspect the long-term solution is to pass both the IRQ and GPIO IDs
>> to the driver; the GPIO ID coming from either platform data, or perhaps
>> enhancing struct i2c_client to add a gpio field alongside irq.
> Definitely on the platform data front. We need some means of doing this now
> hence my patch putting most trivial form of that in.

Actually taking the time to look at the code...

Can someone explain to me (I have a feeling I may just have forgotten this)
why we aren't using an interrupt here?  It looks like a bus transaction triggered
read.  So why not do a enable_irq followed by triggering the read and use a
waitqueue to wait for an interrupt handler to signal it is done?

Having found the datahsheeting lying around on the net I can't see why this
won't work and be somewhat cleaner than current polling approach.

Jonathan
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
>> ---
>> Russell, now that irq_to_gpio() is going away, can you comment on how
>> you'd like to fix drivers that do this kind of thing? Thanks.
>>
>>  drivers/staging/iio/magnetometer/ak8975.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
>> index a17fa9f..bd40e32 100644
>> --- a/drivers/staging/iio/magnetometer/ak8975.c
>> +++ b/drivers/staging/iio/magnetometer/ak8975.c
>> @@ -477,7 +477,7 @@ static int ak8975_probe(struct i2c_client *client,
>>  	int err;
>>  
>>  	/* Grab and set up the supplied GPIO. */
>> -	eoc_gpio = irq_to_gpio(client->irq);
>> +	eoc_gpio = -1; /* FIXME: irq_to_gpio(client->irq) */
>>  
>>  	/* We may not have a GPIO based IRQ to scan, that is fine, we will
>>  	   poll if so */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

