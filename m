Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab2KNCfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:35:50 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13779 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab2KNCfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:35:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Nov 2012 18:35:46 -0800
Message-ID: <50A30381.3000609@nvidia.com>
Date: Tue, 13 Nov 2012 21:35:45 -0500
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] mfd: add TI TPS80031 mfd core driver
References: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com> <1352646721-8350-2-git-send-email-ldewangan@nvidia.com> <20121113074623.GL18224@opensource.wolfsonmicro.com> <50A287F2.4070008@nvidia.com> <20121114012217.GE4415@opensource.wolfsonmicro.com>
In-Reply-To: <20121114012217.GE4415@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 08:22 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Nov 13, 2012 at 11:18:34PM +0530, Laxman Dewangan wrote:
>> On Tuesday 13 November 2012 01:16 PM, Mark Brown wrote:
>>> I'm not sure your wake_base setting is sane here - this is expected to
>>> be a register.  If it is a register why is it not a #define?
>> There is no wake register. Here I kept for the incerease the wake
>> conut so that irq_set_irq_wake() can be called.
> So you want to write to random registers in the chip instead...  that
> doesn't seem like a terribly clever idea.

Yes, this is not a good idea, We will need support for wakeup without 
wakeup registers.
Probably we need to add one more parameter, wake enable to control 
without wake_base.


>
>> I think it is also not correct after change
>> regmap: irq: initialize all irqs to wake disabled
>> I need to set the irq_wake(0 without the register.
> I can't really parse any of the above, sorry.
>
>> There is 2 sets of registers which need to be configure, MASK and
>> LINE enable.
> So what does the second one do?


The MASK register used for updating status register when interrupt 
occurs and LINE register used to pass the status to actual interrupt line.
As per datasheet:

When INT_MSK_LINE [i] is set to 1, the associated interrupt number i is 
INT line masked, which means that no interrupt is generated on the INT line.
When INT_MSK_LINE [i] is set to 0, the associated interrupt number i is  
line enabled: An interrupt is generated on the INT line.
In any case, the INT_STS [i] status bit may or may not be updated, only 
linked to the INT_MSK_STS [i] configuration register bit.


When INT_MSK_STS [i] is set to 1, the associated interrupt number i is
status masked, which means that no interrupt is stored in the INT_STS 
[i]status bit. Note that no interrupt number i is generated on the INT 
line, even if the INT_MSK_LINE [i] register bit is set to 0.
When INT_MSK_STS [i] is set to 0, the associated interrupt number i is 
status enabled: An interrupt status is updated in the INT_STS [i] register.
The interrupt may or may not be generated on the INT line, depending on 
the INT_MSK_LINE [i] configuration register bit.
