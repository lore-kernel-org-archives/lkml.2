Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab2JWWWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:22:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34987 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab2JWWWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:22:37 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] genirq: provide means to retrigger parent
Organization: Deep Root Systems, LLC
References: <1350425269-11489-1-git-send-email-khilman@deeprootsystems.com>
	<20121016221502.GY28061@n2100.arm.linux.org.uk>
Date: Tue, 23 Oct 2012 15:23:04 -0700
In-Reply-To: <20121016221502.GY28061@n2100.arm.linux.org.uk> (Russell King's
	message of "Tue, 16 Oct 2012 23:15:02 +0100")
Message-ID: <871ugo7rqv.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Tue, Oct 16, 2012 at 03:07:49PM -0700, Kevin Hilman wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>> 
>> Attempts to retrigger nested threaded IRQs currently fail because they
>> have no primary handler.  In order to support retrigger of nested
>> IRQs, the parent IRQ needs to be retriggered.
>> 
>> To fix, when an IRQ needs to be resent, if the interrupt has a parent
>> IRQ and runs in the context of the parent IRQ, then resend the parent.
>> 
>> Also, handle_nested_irq() needs to clear the replay flag like the
>> other handlers, otherwise check_irq_resend() will set it and it will
>> never be cleared.  Without clearing, it results in the first resend
>> working fine, but check_irq_resend() returning early on subsequent
>> resends because the replay flag is still set.
>> 
>> Problem discovered on ARM/OMAP platforms where a nested IRQ that's
>> also a wakeup IRQ happens late in suspend and needed to be retriggered
>> during the resume process.
>> 
>> Reported-by: Kevin Hilman <khilman@ti.com>
>> Tested-by: Kevin Hilman <khilman@ti.com>
>> [khilman@ti.com: changelog edits, clear IRQS_REPLAY in handle_nested_irq()]
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>
> Umm, we also have the converse situation.  We have platforms where the
> resend has to be done from the child IRQ, and the parent must not be
> touched.  I hope that doesn't break those.

I'm assuming the child IRQs you're concerned with are not threaded,
right?  This patch only addresses nested, threaded IRQs, and these don't
have a primary handler to run at all, so cannot do any triggering.

Kevin

