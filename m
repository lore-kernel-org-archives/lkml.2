Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab1LFLAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:00:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53322 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089Ab1LFLAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:00:14 -0500
MIME-Version: 1.0
In-Reply-To: <20111206104654.GN14542@n2100.arm.linux.org.uk>
References: <20111202192618.GC3037@localhost.localdomain>
	<CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com>
	<1322867573.11728.22.camel@pasglop>
	<20111205161157.GA27550@localhost.localdomain>
	<alpine.LFD.2.02.1112051236350.2357@xanadu.home>
	<20111205180253.GB29812@localhost.localdomain>
	<alpine.LFD.2.02.1112051310150.2357@xanadu.home>
	<20111205192605.GD29812@localhost.localdomain>
	<alpine.LFD.2.02.1112051443190.2357@xanadu.home>
	<20111206093709.GB2274@linaro.org>
	<20111206104654.GN14542@n2100.arm.linux.org.uk>
Date: Tue, 6 Dec 2011 12:00:12 +0100
X-Google-Sender-Auth: NRkNOgXUSxJgiVfPyYJJ9LwuDhM
Message-ID: <CAMuHMdXvuwXps7j2jz18aB1VueLh5Vn0m94jLvBEO-CmsG1JxQ@mail.gmail.com>
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
        Pawel Moll <pawel.moll@arm.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 11:46, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> But.. let's make one thing clear: Alan Cox and Linus have been going on
> about how IRQ0 should not be used.  Let's be crystal clear: even x86
> uses IRQ0.  It happens to be the PIC timer, and that gets claimed early
> on during the x86 boot.  So please don't tell me that x86 avoids IRQ0.
> It doesn't.  It just happens that x86 never shows IRQ0 to anything but
> the i8253 PIC driver.

It's shown in /proc/interrupts due to a "bug" in show_interrupts().
The (gmail damaged) patch below fixes this bug.

>From 46f51a2d42548358868a34df00c2a4e47bbdf691 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <Geert.Uytterhoeven@eu.sony.com>
Date: Tue, 6 Dec 2011 11:55:05 +0100
Subject: [PATCH] /proc/interrupts: irq zero is invalid

As zero is an invalid irq number, show_interrupts() should not try to
print it. Just return after printing the header for i == 0.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 kernel/irq/proc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 4bd4faa..5b8bbf0 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -439,6 +439,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "CPU%-8d", j);
 		seq_putc(p, '\n');
+		return 0;
 	}

 	desc = irq_to_desc(i);
-- 
1.7.0.4

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
