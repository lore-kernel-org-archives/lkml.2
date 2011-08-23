Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab1HWQO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:14:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959Ab1HWQOW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:14:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110823095711.058d9cf4@lxorguk.ukuu.org.uk>
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de>
 <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com> <4E4D4A5F.202@linutronix.de>
 <20110818213418.GA20509@legolas.emea.dhcp.ti.com> <alpine.DEB.2.00.1108221742130.10315@utopia.booyaka.com>
 <alpine.DEB.2.00.1108222306300.28226@utopia.booyaka.com> <20110823095711.058d9cf4@lxorguk.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 23 Aug 2011 09:13:55 -0700
Message-ID: <CA+55aFyFzzd2GBbwFYrXMK353UE4tdrdZ5Lt8=qEwaaMJvStnA@mail.gmail.com>
Subject: Re: [PATCH] tty: omap-serial: fix boot hang by converting to use a
 threaded IRQ handler (was Re: [PATCH] irq: always set IRQF_ONESHOT if no
 primary handler is specified)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Walmsley <paul@pwsan.com>, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, mporter@ti.com,
        Kevin Hilman <khilman@ti.com>, "Govindraj.R" <govindraj.raja@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 1:57 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon, 22 Aug 2011 23:10:21 -0600 (MDT)
> Paul Walmsley <paul@pwsan.com> wrote:
>
>>
>> Convert the omap-serial hardirq handler to a threaded IRQ handler. Without
>> this patch, OMAP boards which use the on-board OMAP UARTs and the
>> omap-serial driver will not boot to userspace after commit
>> f3637a5f2e2eb391ff5757bc83fb5de8f9726464 ("irq: Always set IRQF_ONESHOT if
>> no primary handler is specified").  Enabling CONFIG_DEBUG_SHIRQ reveals
>> 'IRQ handler type mismatch' errors:
>
> There are multiple other drivers reporting all these problems - the
> faulty irq change should be reverted at this point not the drivers
> fiddled with.

Agreed. It's too late to try to fix random drivers.

The real issue seems to be that clue:

    "Enabling CONFIG_DEBUG_SHIRQ reveals 'IRQ handler type mismatch' errors"

iow, we have a shared irq, and forcing the IRQF_ONESHOT bit is
resulting in those shared interrupts now having different values of
IRQF_ONESHOT, so this test triggers:

                /*
                 * Can't share interrupts unless both agree to and are
                 * the same type (level, edge, polarity). So both flag
                 * fields must have IRQF_SHARED set and the bits which
                 * set the trigger type must match. Also all must
                 * agree on ONESHOT.
                 */
                if (!((old->flags & new->flags) & IRQF_SHARED) ||
                    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK) ||
                    ((old->flags ^ new->flags) & IRQF_ONESHOT)) {
                        old_name = old->name;
                        goto mismatch;
                }

and the irq isn't installed at all (setup_irq returns with EBUSY).

So the commit that caused this problem was simply bogus. The commit log says

                       "Since it is required for those users and
    there is no difference for others it makes sense to add this flag
    unconditionally."

but the "there is no difference for others" seems to be total crap,
exactly because it results in this IRQF mismatch.

So I think that commit should just be reverted. Thomas?

                           Linus
