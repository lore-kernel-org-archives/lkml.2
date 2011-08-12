Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab1HLGu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 02:50:26 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:50374 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205Ab1HLGuX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 02:50:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110810163142.GA10156@google.com>
References: <1312899309-24067-1-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-2-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-3-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-4-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-5-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-6-git-send-email-keshava_mgowda@ti.com>
	<20110810163142.GA10156@google.com>
Date: Fri, 12 Aug 2011 12:20:21 +0530
Message-ID: <CAP05o4L+qn4K=jLx5Jo8WsG7LnU=VniQSR+fLc=RM5mW4kP1OQ@mail.gmail.com>
Subject: Re: [PATCH 5/5 v4] mfd: omap: usb: Runtime PM support
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Todd Poynor <toddpoynor@google.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        khilman@ti.com, b-cousson@ti.com, paul@pwsan.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 10:01 PM, Todd Poynor <toddpoynor@google.com> wrote:
> On Tue, Aug 09, 2011 at 07:45:09PM +0530, Keshava Munegowda wrote:
>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>
>> The usbhs core driver does not enable/disable the intefrace and
>
>
> typo: interface
>
>> fucntional clocks; These clocks are handled by hwmod and runtime pm,
>
>
> typo: functional
>
>> hence insted of the clock enable/disable, the runtime pm APIS are
>> used. however,the port clocks are handled by the usbhs core.
>>
>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>
> ...
>> @@ -913,12 +598,15 @@ static int usbhs_enable(struct device *dev)
>>                               (pdata->ehci_data->reset_gpio_port[1], 1);
>>       }
>>
>> -end_count:
>> -     omap->count++;
>> +     pm_runtime_put_sync(dev);
>>       spin_unlock_irqrestore(&omap->lock, flags);
>
> Is pm_runtime_irq_safe() needed (else I think runtime PM callbacks may
> re-enable IRQs... or there's the new *_suspend runtime PM calls that
> may avoid this)?

 pm_runtime_irq_safe()  is not required; usbhs does not have a parent
and it is the parent driver of
ehci and ohci drivers.


>
> ...
>> @@ -266,10 +261,12 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
>>       struct usb_hcd *hcd     = dev_get_drvdata(dev);
>>
>>       usb_remove_hcd(hcd);
>> -     omap_usbhs_disable(dev);
>>       disable_put_regulator(dev->platform_data);
>> -     iounmap(hcd->regs);
>>       usb_put_hcd(hcd);
>> +     iounmap(hcd->regs);

yes , I will do this.

>
>
> usb_put_hcd may release the hcd, needs to be after the deref for
> iounmap.
>
>> +     pm_runtime_put_sync(dev);
>> +     pm_runtime_disable(dev);
>
>
> Todd
>
