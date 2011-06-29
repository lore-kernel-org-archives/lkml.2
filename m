Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1F2PWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:22:36 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:54624 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518Ab1F2PWd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:22:33 -0400
MIME-Version: 1.0
In-Reply-To: <87d3ix5c6y.fsf@ti.com>
References: <1306934847-6098-1-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-2-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-3-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-4-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-5-git-send-email-keshava_mgowda@ti.com>
	<87d3ix5c6y.fsf@ti.com>
Date: Wed, 29 Jun 2011 20:52:30 +0530
Message-ID: <BANLkTim43pAKe1o-aFmgh79bNqSyZmW_Fg@mail.gmail.com>
Subject: Re: [PATCH 4/4] mfd: global Suspend and resume support of ehci and ohci
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        b-cousson@ti.com, paul@pwsan.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 5:36 AM, Kevin Hilman <khilman@ti.com> wrote:
> Keshava Munegowda <keshava_mgowda@ti.com> writes:
>
>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>
>> The global suspend and resume functions for usbhs core driver
>> are implemented.These routine are called when the global suspend
>> and resume occurs. Before calling these functions, the
>> bus suspend and resume of ehci and ohci drivers are called
>> from runtime pm.
>>
>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>
> First, from what I can see, this is only a partial implementation of
> runtime PM.  What I mean is that the runtime PM methods are used only
> during the suspend path.  The rest of the time the USB host IP block is
> left enabled, even when nothing is connected.
>
> I tested this on my 3530/Overo board, and verified that indeed the
> usbhost powerdomain hits retention on suspend, but while idle, when
> nothing is connected, I would expect the driver could be clever enough
> to use runtime PM (probably using autosuspend timeouts) to disable the
> hardware as well.
>
>> ---
>>  drivers/mfd/omap-usb-host.c |  103 +++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 103 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
>> index 43de12a..32d19e2 100644
>> --- a/drivers/mfd/omap-usb-host.c
>> +++ b/drivers/mfd/omap-usb-host.c
>> @@ -146,6 +146,10 @@
>>  #define is_ehci_hsic_mode(x) (x == OMAP_EHCI_PORT_MODE_HSIC)
>>
>>
>> +/* USBHS state bits */
>> +#define OMAP_USBHS_INIT              0
>> +#define OMAP_USBHS_SUSPEND   4
>
> These additional state bits don't seem to be necessary.
>
> For suspend, just check 'pm_runtime_is_suspended()'
>
> The init flag is only used in the suspend/resume hooks, but the need for
> it is a side effect of not correctly using the runtime PM callbacks.
>
> Remember that the runtime PM get/put hooks have usage counting.  Only
> when the usage count transitions to/from zero is the actual
> hardware-level enable/disable (via omap_hwmod) being done.
>
> The current code is making the assumption that every call to get/put is
> going to result in an enable/disable of the hardware.
>
> Instead, all of the code that needs to be run only upon actual
> enable/disable of the hardware should be done in the driver's
> runtime_suspend/runtime_resume callbacks.  These are only called when
> the hardware actually changes state.
>
> Not knowing that much about the EHCI block, upon first glance, it looks
> like mmuch of what is done in usbhs_enable() should actually be done in
> the ->runtime_resume() callback, and similarily, much of what is done in
> usbhs_disable() should be done in the ->runtime_suspend() callback.

Kevin,
   do you mean driver->runtime_resume and driver->runtime_resume call backs.
are these call backs from pm_runtime_get_sync and pm_runtime_put_sync?
