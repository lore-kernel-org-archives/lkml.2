Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1HPPbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:31:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:57285 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab1HPPbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:31:53 -0400
Date: Tue, 16 Aug 2011 17:31:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Threaded interrupt handling question in RT kernel
In-Reply-To: <CAGzjT4eGV-KLFNuE2F8ehYCEdi7DT8wo_tYbkUQHPxjuArHc2Q@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1108161729130.2807@ionos>
References: <CAGzjT4eGV-KLFNuE2F8ehYCEdi7DT8wo_tYbkUQHPxjuArHc2Q@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Aug 2011, Jaccon Bastiaansen wrote:

> Hello Thomas, Peter
> 
> We have a question about threaded interrupt handling:
> 
> By default, when using threaded interrupt handlers, the IRQ is
> disabled in hard IRQ context and enabled again after all threaded
> interrupt handlers connected to that IRQ have run. In this way, high
> priority interrupt handlers can be delayed until the lowest priority
> interrupt handler thread has run. Therefore it seems that it's not
> useful to have a separate thread for each interrupt handler (what's
> the use of being able to set interrupt handler thread priorities when
> you still have to wait for the one with the lowest priority).

That's correct, but RT just makes use of the general facility which is
designed to have a separate thread for each device.
 
> So we think that we should use the request_threaded_irq() function.

You can do that for a specific driver, but we cannot do that in RT for
every driver in the kernel.

> The task of the handler that is executed in hard IRQ context is to
> check whether the device that it controls is generating an interrupt
> and if it does, deactivate the IRQ output of the device and wakeup the
> interrupt handler thread by returning IRQ_WAKE_THREAD. By deactivating
> the IRQ output, another device connected to the same IRQ can activate
> the IRQ again before the interrupt handler thread of the first device
> has run. This guarantees that a high priority threaded interrupt
> handler of a device on a shared IRQ can run before a low priority
> threaded interrupt handler of a device on the same IRQ has run. So
> when using threaded interrupt handlers for devices on a shared IRQ,
> make sure that all drivers have used request_threaded_irq().
> Otherwise, high priority threaded interrupt handlers can be delayed by
> low priority threaded interrupt handlers.
> 
> Is all this correct or do we miss something?

That's how it's designed to work.

Thanks,

	tglx
