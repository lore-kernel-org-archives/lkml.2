Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1HPO2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:28:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56660 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab1HPO2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:28:06 -0400
MIME-Version: 1.0
Date: Tue, 16 Aug 2011 16:28:04 +0200
Message-ID: <CAGzjT4eGV-KLFNuE2F8ehYCEdi7DT8wo_tYbkUQHPxjuArHc2Q@mail.gmail.com>
Subject: Threaded interrupt handling question in RT kernel
From: Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas, Peter

We have a question about threaded interrupt handling:

By default, when using threaded interrupt handlers, the IRQ is
disabled in hard IRQ context and enabled again after all threaded
interrupt handlers connected to that IRQ have run. In this way, high
priority interrupt handlers can be delayed until the lowest priority
interrupt handler thread has run. Therefore it seems that it's not
useful to have a separate thread for each interrupt handler (what's
the use of being able to set interrupt handler thread priorities when
you still have to wait for the one with the lowest priority).

So we think that we should use the request_threaded_irq() function.
The task of the handler that is executed in hard IRQ context is to
check whether the device that it controls is generating an interrupt
and if it does, deactivate the IRQ output of the device and wakeup the
interrupt handler thread by returning IRQ_WAKE_THREAD. By deactivating
the IRQ output, another device connected to the same IRQ can activate
the IRQ again before the interrupt handler thread of the first device
has run. This guarantees that a high priority threaded interrupt
handler of a device on a shared IRQ can run before a low priority
threaded interrupt handler of a device on the same IRQ has run. So
when using threaded interrupt handlers for devices on a shared IRQ,
make sure that all drivers have used request_threaded_irq().
Otherwise, high priority threaded interrupt handlers can be delayed by
low priority threaded interrupt handlers.

Is all this correct or do we miss something?


Regards,
  Jaccon Bastiaansen
