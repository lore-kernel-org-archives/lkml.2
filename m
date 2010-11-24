Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0KXIrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:47:42 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47966 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab0KXIrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:47:41 -0500
Date: Wed, 24 Nov 2010 17:46:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [question] NR_IRQS in genirq
Message-ID: <20101124084653.GG2212@linux-sh.org>
References: <AANLkTimoBdFyQ6GfS2DKiF0wdRox0x7MfM0_keD9Z1D0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimoBdFyQ6GfS2DKiF0wdRox0x7MfM0_keD9Z1D0@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 03:28:37PM +0800, Haojian Zhuang wrote:
> Hi all,
> 
> I'm using the latest kernel 2.6.37-rc1. Now I met some issues on genirq.
> 
> 1. While SPARSE IRQ is enabled, nr_irqs may be larger than NR_IRQS.
> But the allocated_irqs bitmap (kernel/irq/irqdesc.c) is restricted in
> NR_IRQS. Is it an issue?
> 
> 2. irqs_resend bitmap of kernel/irq/resend.c is also restricted in
> NR_IRQS. Is it an issue, too?
> 
Perhaps something like:

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 9988d03..11bd76c 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -215,6 +215,11 @@ int __init early_irq_init(void)
 	initcnt = arch_probe_nr_irqs();
 	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d %d\n", NR_IRQS, nr_irqs, initcnt);
 
+	if (unlikely(nr_irqs > NR_IRQS)) {
+		WARN(1, "Probed more than NR_IRQS, chomping.\n");
+		nr_irqs = NR_IRQS;
+	}
+
 	for (i = 0; i < initcnt; i++) {
 		desc = alloc_desc(i, node);
 		set_bit(i, allocated_irqs);

?
