Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab2GEEbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 00:31:35 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57661 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2GEEbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 00:31:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120704221600.416d4475@endymion.delvare>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
 <1340805255-8041-8-git-send-email-djkurtz@chromium.org> <20120704221600.416d4475@endymion.delvare>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 5 Jul 2012 12:31:11 +0800
X-Google-Sender-Auth: dBc2mwyt_vD3_KTKyLwg90BeHtg
Message-ID: <CAGS+omAwkwd17MVe3uWoPNCL3y0BvKDvbFGWwjhJ5CpTqncsXA@mail.gmail.com>
Subject: Re: [PATCH 7/8 v3] i2c: i801: enable irq for i801 smbus transactions
To: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Thu, Jul 5, 2012 at 4:16 AM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi again Daniel,
>
> On Wed, 27 Jun 2012 21:54:14 +0800, Daniel Kurtz wrote:
>> Add a new 'feature' to i2c-i801 to enable using i801 interrupts.
>> When the feature is enabled, then an isr is installed for the device's
>> pci irq.
>>
>> An I2C/SMBus transaction is always terminated by one of the following
>> interrupt sources: FAILED, BUS_ERR, DEV_ERR, or on success: INTR.
>>
>> When the isr fires for one of these cases, it sets the ->status variable
>> and wakes up the waitq.  The waitq then saves off the status code, and
>> clears ->status (in preparation for some future transaction).
>> The SMBus controller generates an INTR irq at the end of each
>> transaction where INTREN was set in the HST_CNT register.
>>
>> No locking is needed around accesses to priv->status since all writes to
>> it are serialized: it is only ever set once in the isr at the end of a
>> transaction, and cleared while no irqs can occur.  In addition, the I2C
>> adapter lock guarantees that entire I2C transactions for a single
>> adapter are always serialized.
>>
>> For this patch, the INTREN bit is set only for SMBus block, byte and word
>> transactions, but not for I2C reads or writes.  The use of the DS
>> (BYTE_DONE) interrupt with byte-by-byte I2C transactions is implemented in
>> a subsequent patch.
>
> Hmm, I have hit a bug with this patch. I was testing it on my ICH3-M
> laptop, and while SMBus byte and word reads worked fine, SMBus block
> reads did fail once in a while.
>
> The ICH3-M lacks the block buffer, so SMBus block reads use the
> i801_block_transaction_byte_by_byte function, which at this point does
> not use interrupts. However, the IRQ is heavily shared on this laptop:
> additionally to SMBus, it is used for USB, sound, network and even the
> graphics chip. So function i801_isr() is called all the time.
>
> If i801_isr() is being called while
> i801_block_transaction_byte_by_byte() is running, there is a chance
> that the status register will have some flags set, in particular INTR.
> If so, the code in i801_isr() will clear the flags and wake up the
> wait queue while nobody was actually waiting for. And
> i801_block_transaction_byte_by_byte() will wait for an event which was
> already processed, leading to a timeout.
>
> You should be able to reproduce this bug by loading i2c-i801 with
> option disable_features=0x0002, assuming your SMBus IRQ is shared.
>
> This leads me to several thoughts (feel free to correct me if I'm
> wrong, I am getting very tired):
>
> 1* This must be the reason why a bit was added to the PCI status
>    register starting with the ICH5, telling you if an interrupt has been
>    delivered to you. Checking for it as you originally did was a good idea
>    after all.

Reducing scope to get accepted patches in sooner sounds like a good plan to me.

> 2* Is there any reason why you decided to clear the status bits in
>    i801_isr(), rather than after wait_event()? I am no expert in
>    interrupt handling, I admit, but letting the "caller" clear the status
>    bits would ensure we don't clear status bits when nobody is actually
>    waiting to catch them.

BYTE_DONE is cleared to kick off the next byte, and it doesn't
generate a wait_event, thus it is cleared right in the irq.

The logic for clearing the STATUS_FLAGS was simply that they all
indicate the end of a transaction, so there won't be any further
interrupts.  Thus, it is safe to clear it in the irq, since the irq
will be followed by exactly one wait_event, which can read and process
saved status.

> 3* Applying this patch (7/8) without the one adding interrupt support
>    to i801_block_transaction_byte_by_byte (8/8) is not OK: mixing
>    interrupts and polling isn't safe. So unless we implement 1* or 2*,
>    both patches would have to be merged before being pushed upstream.
>
> 4* Even then, we have to keep in mind that i801_isr() may be called
>    before the transaction is finished (if IRQ is shared.) My testing
>    has shown that error flags may be raised before the BUSY flag is
>    cleared, so we should use in i801_isr() the same strict conditions
>    we are now using in the polling code. In other words, if we get an
>    interrupt but the BUSY flag is still set, then it's not our
>    interrupt and we should ignore it. This applies even if 2* or 3*
>    above are implemented, but no longer if 1* is implemented.
>
> 5* Your claim that no locking is needed might have to be revisited when
>    interrupts are shared.
>
> Implementing 1* has the drawback of limiting interrupt support to ICH5
> and later chips, but I suspect it is the easiest and safest way, so I
> have no objection if you want to do that.

Let's do this first, and then refactor later to add support for
pre-ICH5 parts, if needed.
It sounds like supporting the pre-ICH5 parts w/ shared IRQ is not very
pretty, since we are no longer guaranteed that we get a single
transaction terminating interrupt.

>
> --
> Jean Delvare

Do you still maintain a public git repository?
Have you updated it with the accepted version of the previous cleanup patches?
I see this one, but it doesn't look updated:
  http://git.kernel.org/?p=linux/kernel/git/jdelvare/staging.git;a=summary

I'd like to fix up the interrupt patches per your feedback, but I'm
not quite sure what the current status is of all the cleanup patches.

In other words, if you push up the complete set of cleanup patches, I
can then rebase the new consolidated irq patch onto it, and send them
here for review.

Thanks!
-Dan
