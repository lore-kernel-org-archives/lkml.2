Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1HWIO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:14:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:50269 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1HWIOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:14:54 -0400
Date: Tue, 23 Aug 2011 10:14:50 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Felipe Balbi <balbi@ti.com>,
        torvalds@linux-foundation.org, mporter@ti.com,
        Kevin Hilman <khilman@ti.com>, "Govindraj.R" <govindraj.raja@ti.com>
Subject: Re: [PATCH] tty: omap-serial: fix boot hang by converting to use a
 threaded IRQ handler (was Re: [PATCH] irq: always set IRQF_ONESHOT if no
 primary handler is specified)
Message-ID: <20110823081450.GA20979@linutronix.de>
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de>
 <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com>
 <4E4D4A5F.202@linutronix.de>
 <20110818213418.GA20509@legolas.emea.dhcp.ti.com>
 <alpine.DEB.2.00.1108221742130.10315@utopia.booyaka.com>
 <alpine.DEB.2.00.1108222306300.28226@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108222306300.28226@utopia.booyaka.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley | 2011-08-22 23:10:21 [-0600]:

>IRQ handler type mismatch for IRQ 74

>It turns out that the omap-serial code used one threaded IRQ
>handler[1][2] and one non-threaded IRQ handler[3] that shared the same
>IRQ.  During the 3.1-rc series, a patch was merged[4] that caused
>IRQF_ONESHOT to be set on the threaded handler, but the non-threaded
>handler did not have IRQF_ONESHOT set.  Since interrupt handlers

Is the type of IRQ74 edge or line/eoi?
Since you registered the serial handler as threaded and the primary
handler did _not_ disable the irq source (due to the absence of the
IRQF_ONESHOT flag or a custom primary handler which does this by
changing a bit in the hardware) it is more or less luck that you did not
hang forever on the first serial interrupt. Well, it does not happen
with edge typed interrupt lines.

>that share the same IRQ must also share the presence or absence of
>IRQF_ONESHOT[5], this new commit caused a mismatch that prevented the
>non-threaded IRQ from registering.

In theory it should be okay if the handler without ONESHOT is either
primary only or primary + threaded and the primary disables the irq
source.

Sebastian
