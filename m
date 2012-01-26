Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2AZJF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:05:28 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4130 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab2AZJFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:05:15 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4F21173A.9060405@broadcom.com>
Date: Thu, 26 Jan 2012 10:04:58 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111229
 Thunderbird/9.0
MIME-Version: 1.0
To: "Josh Boyer" <jwboyer@gmail.com>
cc: "Francis Moreau" <francis.moro@gmail.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg KH" <greg@kroah.com>
Subject: Re: kernel 3.2.1: BUG: scheduling while atomic:
 swapper/0/0/0x10000100
References: <CAC9WiBgpBCWZVjAQkJWSpXhC_dK1KKPfAHZvxVgaLV8BUsc41Q@mail.gmail.com>
 <4F1FBAA9.4040405@broadcom.com>
 <CAC9WiBjpsLuJhzw+vZsPC2bA73mad444Gq32DRL_gCri2MqaMw@mail.gmail.com>
 <4F1FD2AA.9020708@broadcom.com>
 <CA+5PVA73WHfnurWiyY4w9f4_mw=vUdpaNmAavHZtt+xYfo8Kcw@mail.gmail.com>
 <CAC9WiBgzg-dD5Sba9Cd_uvsfMxqQib+vsXXDyMSMSR_Y7P_CCw@mail.gmail.com>
 <CA+5PVA4Cq5BRfKEa1uckVbtCGKhKmuw1tujQ19T3wk3c5CcsAQ@mail.gmail.com>
In-Reply-To: <CA+5PVA4Cq5BRfKEa1uckVbtCGKhKmuw1tujQ19T3wk3c5CcsAQ@mail.gmail.com>
X-Enigmail-Version: 1.3.4
OpenPGP: id=B5E1A116
X-WSS-ID: 633FC6FE3DS19394463-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 05:49 PM, Josh Boyer wrote:
> On Wed, Jan 25, 2012 at 11:37 AM, Francis Moreau <francis.moro@gmail.com> wrote:
>> Hello,
>>
>> On Wed, Jan 25, 2012 at 1:11 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>>
>>> We've had a few similar issues reported in Fedora yesterday after we
>>> rebased to 3.2.1.
>>
>> From which kernel did you rebase to 3.2.1 ?
> 
> Fedora 16 went from 3.1.9 to 3.2.1 earlier this week.  We hadn't been getting
> reports like this until 3.2.1 showed up.  I asked one of the reporters to try
> 3.2.0 and they say it recreates there still, so it seems the issue showed up
> with the 3.2 release.  One user managed to capture the trace below using a
> kernel with a variety of debug options turned on.  It isn't the same backtrace
> but it might be related.
> 
> backtrace:
> :BUG: sleeping function called from invalid context at
> drivers/base/power/runtime.c:785
> :in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/0
> :1 lock held by swapper/0/0:
> : #0:  (&chip->rts51x_suspend_timer){+.-...}, at: [<ffffffff8108d711>]
> run_timer_softirq+0x111/0x600
> :Pid: 0, comm: swapper/0 Tainted: G        W    3.2.0-2.fc17.x86_64.debug #1
> :Call Trace:
> : <IRQ>  [<ffffffff8105ee7a>] __might_sleep+0x13a/0x1f0
> : [<ffffffffa00180b0>] ? rts51x_modi_suspend_timer+0x50/0x50 [ums_realtek]
> : [<ffffffff813fdee3>] __pm_runtime_idle+0xa3/0xb0
> : [<ffffffffa00180b0>] ? rts51x_modi_suspend_timer+0x50/0x50 [ums_realtek]
> : [<ffffffff8146ed30>] usb_autopm_put_interface+0x30/0x40

This trace seems to indicate what is wrong. At least for this one user.
The usb_autopm_put_interface() call seems result in a sleep and the
rts51x_suspend_timer_fn is holding a lock. Below the code indicated in
the trace.

runtime.c:
768 /**
769  * __pm_runtime_idle - Entry point for runtime idle operations.
770  * @dev: Device to send idle notification for.
771  * @rpmflags: Flag bits.
772  *
773  * If the RPM_GET_PUT flag is set, decrement the device's usage
count and
774  * return immediately if it is larger than zero.  Then carry out an idle
775  * notification, either synchronous or asynchronous.
776  *
777  * This routine may be called in atomic context if the RPM_ASYNC
flag is set,
778  * or if pm_runtime_irq_safe() has been called.
779  */
780 int __pm_runtime_idle(struct device *dev, int rpmflags)
781 {
782         unsigned long flags;
783         int retval;
784
785         might_sleep_if(!(rpmflags & RPM_ASYNC) && !dev->power.irq_safe);

This issue can either be caused in ums_realtek module or the usb autopm
code. Have not looked into that.

Gr. AvS

