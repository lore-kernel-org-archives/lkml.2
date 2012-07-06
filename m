Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab2GFK2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:28:53 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51540 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab2GFK2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:28:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120705101015.1e3a3afc@endymion.delvare>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
 <1340805255-8041-8-git-send-email-djkurtz@chromium.org> <20120704221600.416d4475@endymion.delvare>
 <CAGS+omAwkwd17MVe3uWoPNCL3y0BvKDvbFGWwjhJ5CpTqncsXA@mail.gmail.com> <20120705101015.1e3a3afc@endymion.delvare>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 6 Jul 2012 18:28:28 +0800
X-Google-Sender-Auth: xIaop_sUzZdDM36yy_mruLsndRQ
Message-ID: <CAGS+omAgVLumYvOssHfdjELXixMdfRSxSj003xPzQ5v4h_D-mA@mail.gmail.com>
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

On Thu, Jul 5, 2012 at 4:10 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Daniel,
>
> On Thu, 5 Jul 2012 12:31:11 +0800, Daniel Kurtz wrote:
>> On Thu, Jul 5, 2012 at 4:16 AM, Jean Delvare <khali@linux-fr.org> wrote:
>> > You should be able to reproduce this bug by loading i2c-i801 with
>> > option disable_features=0x0002, assuming your SMBus IRQ is shared.
>> >
>> > This leads me to several thoughts (feel free to correct me if I'm
>> > wrong, I am getting very tired):
>> >
>> > 1* This must be the reason why a bit was added to the PCI status
>> >    register starting with the ICH5, telling you if an interrupt has been
>> >    delivered to you. Checking for it as you originally did was a good idea
>> >    after all.
>>
>> Reducing scope to get accepted patches in sooner sounds like a good plan to me.
>
> Agreed.
>
>> > 2* Is there any reason why you decided to clear the status bits in
>> >    i801_isr(), rather than after wait_event()? I am no expert in
>> >    interrupt handling, I admit, but letting the "caller" clear the status
>> >    bits would ensure we don't clear status bits when nobody is actually
>> >    waiting to catch them.
>>
>> BYTE_DONE is cleared to kick off the next byte, and it doesn't
>> generate a wait_event, thus it is cleared right in the irq.
>
> No problem with BYTE_DONE.
>
>> The logic for clearing the STATUS_FLAGS was simply that they all
>> indicate the end of a transaction, so there won't be any further
>> interrupts.  Thus, it is safe to clear it in the irq, since the irq
>> will be followed by exactly one wait_event, which can read and process
>> saved status.
>
> It is safe if and only if someone is actually listening to the event.
> This was not the case for me yesterday. Even if we don't mix interrupts
> and polling, i801_isr() might still get called when we aren't
> listening. Not only because the IRQ may be shared, but also for events
> we don't yet handle, such as an SMBus Alert. Not sure about slave
> mode.

The real reason for clearing the flag in the hard irq is that
otherwise, we end up with an infinite irq loop.  The interrupt is
apparently level triggered, and must be cleared before exiting the
ISR.

Unfortunately, I only had time today to discover this, but not time to fix it.
Next week I will be away, so I won't have a chance to provide more
patches for the next 10 days.

I think the 6 patches you have already make a complete set, however,
and shouldn't be waiting for the interrupt patch(es) which can follow
at some future date.

-Daniel

>
>> > 3* Applying this patch (7/8) without the one adding interrupt support
>> >    to i801_block_transaction_byte_by_byte (8/8) is not OK: mixing
>> >    interrupts and polling isn't safe. So unless we implement 1* or 2*,
>> >    both patches would have to be merged before being pushed upstream.
>> >
>> > 4* Even then, we have to keep in mind that i801_isr() may be called
>> >    before the transaction is finished (if IRQ is shared.) My testing
>> >    has shown that error flags may be raised before the BUSY flag is
>> >    cleared, so we should use in i801_isr() the same strict conditions
>> >    we are now using in the polling code. In other words, if we get an
>> >    interrupt but the BUSY flag is still set, then it's not our
>> >    interrupt and we should ignore it. This applies even if 2* or 3*
>> >    above are implemented, but no longer if 1* is implemented.
>> >
>> > 5* Your claim that no locking is needed might have to be revisited when
>> >    interrupts are shared.
>> >
>> > Implementing 1* has the drawback of limiting interrupt support to ICH5
>> > and later chips, but I suspect it is the easiest and safest way, so I
>> > have no objection if you want to do that.
>>
>> Let's do this first, and then refactor later to add support for
>> pre-ICH5 parts, if needed.
>
> OK, fine with me. The only downside is that it excludes my
> heavily-shared IRQ test machine, so testing that the shared IRQ case is
> properly covered will be a little harder.
>
>> It sounds like supporting the pre-ICH5 parts w/ shared IRQ is not very
>> pretty, since we are no longer guaranteed that we get a single
>> transaction terminating interrupt.
>
> Indeed. In that case, using interrupts will be much like using polling,
> except that status check happens whenever we receive an interrupt,
> rather than at fixed time interval.
>
>> Do you still maintain a public git repository?
>
> I never did.
>
>> Have you updated it with the accepted version of the previous cleanup patches?
>> I see this one, but it doesn't look updated:
>>   http://git.kernel.org/?p=linux/kernel/git/jdelvare/staging.git;a=summary
>
> This tree is only for sending patches to Linus. It doesn't reflect the
> current status of my working tree.
>
> I am maintaining quilt series for that, which you can find at:
> http://khali.linux-fr.org/devel/linux-3/
>
>> I'd like to fix up the interrupt patches per your feedback, but I'm
>> not quite sure what the current status is of all the cleanup patches.
>>
>> In other words, if you push up the complete set of cleanup patches, I
>> can then rebase the new consolidated irq patch onto it, and send them
>> here for review.
>
> I updated the i2c series this morning, so it's up-to-date.
>
> --
> Jean Delvare
