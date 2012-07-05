Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab2GEVsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 17:48:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55005 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2GEVsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 17:48:13 -0400
MIME-Version: 1.0
In-Reply-To: <1341524367.4020.1324.camel@calx>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <1341511933-11169-2-git-send-email-tytso@mit.edu> <1341514078.4020.1213.camel@calx>
 <CA+55aFyMYVLCW0OYTVttkjjOwyu9VgDM9haNC=BeoRCEiWWNPQ@mail.gmail.com> <1341524367.4020.1324.camel@calx>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jul 2012 14:47:52 -0700
X-Google-Sender-Auth: U_zFVzNbgqmR0NpkriojELCr-bs
Message-ID: <CA+55aFxAe1pRN+jvdLveHQ+nNRNC6HDZ+S4Y9P202rxgNLN8pg@mail.gmail.com>
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
To: Matt Mackall <mpm@selenic.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 2:39 PM, Matt Mackall <mpm@selenic.com> wrote:
>
> From my read, this code path gets called on timer interrupts too.

That's hopefully never true for any normal cases (timers are *very*
special - they tend to go through their own architecture-specific
stuff). On modern PC's, for example, the timers happen through the
local apic timers directly.

In fact, with SMP, it's a really bad idea to use a normal irq for
timer interrupts, since you really really want per-CPU-core timers.

But yes, we should probably make sure that *if* the architecture uses
regular interrupts for timers we don't count them. The problematic
embedded platforms are often pretty crap hardware: even when they are
SMP, they might use an external timer irq (and then we broadcast the
thing). I think we have the IRQF_TIMER flag for that, so we could add
a check for that.

                 Linus
