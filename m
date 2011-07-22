Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab1GVP6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:58:40 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:41942 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1GVP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:58:38 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E299E32.10806@cam.ac.uk>
Date: Fri, 22 Jul 2011 16:58:42 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Andersson <eric.andersson@unixphere.com>
CC: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengguang.guo@bosch-sensortec.com,
        stefan.nilsson@unixphere.com, alan@lxorguk.ukuu.org.uk,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH v4 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
References: <1311203359-23779-1-git-send-email-eric.andersson@unixphere.com> <1311203359-23779-2-git-send-email-eric.andersson@unixphere.com> <4E293621.50306@cam.ac.uk> <20110722132410.GA958@scully.xfiles.lan>
In-Reply-To: <20110722132410.GA958@scully.xfiles.lan>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/11 14:24, Eric Andersson wrote:
>> Mostly looks fine.  Couple of nitpicks and one query about the interrupt
>> handling (more general than this driver).
>>
>> Can I confirm I've understood this correctly. When one receives any of the
>> interrupts, the driver just kicks out a reading?  Given there is a delay
>> before this read, imagine both high and low thresholds are set.  It's entirely
>> possible for both to occur before the thread gets there and the value that is
>> read to be somewhere in between... We'll get one interrupt and have no idea
>> what happened...
>>
>> Is there any way of working out what has occured and pushing that out?
> In our case we are enabling three conditional interrupts where each
> one of them have the chance of asserting the interrupt pin when
> their particular interrupt criterias are fulfilled. This means that
> one interrupt, for instance any motion, can assert the irq pin and
> then at the same time have a high- and/or low-g interrupt consecutively
> activated as well (but pin asserted by any motion already) where the
> pin will be kept asserted until all the criterias for each asserted
> interrupt are exited (i.e. not fullfilled anymore). So even if there
> is a delay from the pin assertion and the irq thread read-out it
> doesn't really matter if consecutive interrupts are activated in
> between. At least one of the criterias will be met and there will be a motion
> detection to read out. Of course, the interrupt types could be masked
> out from the status register (addr. 0x09 bits 0 & 1 for low-/high-g
> int), but I really don't see the purpose of this.
Perhaps tap type events?  High acceleration followed by not much. If unlucky
will register as stationary...  Lots of use cases out of input where you have
very little idea what is going on, but I guess what you have here might
work well for input.
> 
> A comment regarding latched vs. non-latched irqs - we are intentionally not
> using latched interrupts with the current setup since we currently don't
> see the need for it. A latched setup would typically be needed in a high
> inflow interrupt feature, such as new data interrupt, where the interrupt
> buffer can be flooded due to high event frequency.
> An alternative could be to activate the latched interrupt feature and
> explicitly clear the interrupts from the driver, but this would just fire
> off a new event directly until any of the interrupt criterias are fullfilled.
> If you have any preferences or requirements when it comes to this, please share
> your thoughts and we'll act upon this for the next version.
> 
>>> +	if (bma150->client->irq > 0) {
>>> +		ret = input_register_device(idev);
>>> +		if (ret < 0) {
>>> +			input_free_device(idev);
>>> +			return ret;
>>> +		}
>>> +		ret = request_threaded_irq(bma150->client->irq, NULL, bma150_irq_thread,
>>> +			IRQF_TRIGGER_RISING, BMA150_DRIVER, bma150);
>> Does this want to be oneshot? I don't think you have the latch enabled, so strobing
>> across a threshold could result in an interrupt storm.
> Sure, it could be worth having it sequential to the read-outs from the thread
> instead of buffering events while reading. I'll fix.
> 
> As for your nitpicks, I will fix them for the next version.
> 
> Thanks for reviewing!
> 

