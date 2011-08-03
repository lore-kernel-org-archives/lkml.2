Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab1HCXO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:14:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27893 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab1HCXOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:14:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=MR/Ez6GMNLhGEYbtxsknmvPmKSIcmZSt6KpiROU46f4BZTMw1zidTmghq2nLAFisr
	rpL1z0L3CRUvq4k086xlQ==
MIME-Version: 1.0
In-Reply-To: <20110729050437.GB9069@legolas.emea.dhcp.ti.com>
References: <1311206974.2945.198.camel@work-vm>
	<20110729050437.GB9069@legolas.emea.dhcp.ti.com>
Date: Wed, 3 Aug 2011 16:14:50 -0700
Message-ID: <CAMbhsRQvc9dHJ5Er4x177NNE4Yg+4fbM2kmYhVUTPN8ug_WqhQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] musb: Avoid musb_gadget_pullup "Unhandled fault"
 oops on omap4
From: Colin Cross <ccross@google.com>
To: balbi@ti.com
Cc: John Stultz <john.stultz@linaro.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 10:04 PM, Felipe Balbi <balbi@ti.com> wrote:
> hi,
>
> On Wed, Jul 20, 2011 at 05:09:34PM -0700, John Stultz wrote:
>> I've recently run across an "Unhandled fault: imprecise external abort"
>> oops that is caused when a driver called usb_gadget_connect() when there
>> was no cable plugged into the musb gadget port.
>>
>> You can see the oops message here:
>> https://launchpadlibrarian.net/75635123/minicom.txt
>>
>> Doing some digging, it seemed the problem was triggered when reading
>> from the musb registers in musb_pullup() when the device controller is
>> powered down.
>>
>> Looking at other examples of where the registers were accessed, I
>> noticed they were always enclosed by pm_runtime_get/put calls. So I
>> added such calls to the musb_gadget_pullup() function and it seemed to
>> resolve the problem.
>>
>> Now, full disclosure: this was triggered with the out-of-tree Android
>> adb gadget driver. However, I suspect the same behavior could be
>> triggered using the composite gadget driver as well, so I think this is
>> a generic issue. However, if I'm wrong, let me know and I'll try to make
>> sure the fix is done in the right place.
>>
>> If this is the right fix, it probably should be queued for 3.1 and
>> 3.0-stable.
>>
>> Comments and feedback would be greatly appreciated!
>>
>>
>> Reported-by: Zach Pfeffer <zach.pfeffer@linaro.org>
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>
> Applied, thanks.
>
> improved commit log slightly:
>
> commit 7e1bb0fdcc9b51ebec0a1e5e06ff075aab55c941
> Author: John Stultz <john.stultz@linaro.org>
> Date:   Wed Jul 20 17:09:34 2011 -0700
>
>    usb: musb: fix oops on musb_gadget_pullup
>
>    an 'unhandled fault' is causes when a gadget driver calls
>    usb_gadget_connect() while the USB cable isn't plugged into
>    the OTG port.
>
>    the fault is caused by an access to MUSB's memory space
>    while its clock is turned off due to pm_runtime kicking
>    in.
>
>    in order to fix the fault, we enclose musb_gadget_pullup()
>    with pm_runtime_get_sync() ... pm_runtime_put() calls to
>    be sure we will always reach that path with clock turned on.
>
>    [ balbi@ti.com : simplified commit log; removed few things
>        which didn't belong there ]
>
>    Cc: stable@kernel.org
>    Reported-by: Zach Pfeffer <zach.pfeffer@linaro.org>
>    Signed-off-by: John Stultz <john.stultz@linaro.org>
>    Signed-off-by: Felipe Balbi <balbi@ti.com>
>
> --
> balbi
>

musb_pullup can get called from usb_function_deactivate in atomic
context (usb_function_deactivate -> usb_gadget_disconnect ->
musb_pullup), and pm_runtime_get_sync is not safe in atomic context
unless pm_runtime_irq_safe has been called in musb-core.c (which I'm
not sure it is safe to do).

Since this already gets called in atomic context, you might as well
put the irq-safe pm_runtime calls inside the if statement, and avoid
unnecessary wakeups.
