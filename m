Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab1INSBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 14:01:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59813 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221Ab1INSBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 14:01:46 -0400
thread-index: AcxzCFgkdVDi8Nh6Rbibqcj/VR6tSg==
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4657
Subject: Re: [PATCH] irq: call also chip->irq_mask from irq_disable
From: Tero Kristo <t-kristo@ti.com>
Reply-To: <t-kristo@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "LKML" <linux-kernel@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>
In-Reply-To: <alpine.LFD.2.02.1109141757150.2723@ionos>
References: <1315990675-22814-1-git-send-email-t-kristo@ti.com> <alpine.LFD.2.02.1109141757150.2723@ionos>
Content-Type: text/plain; charset="UTF-8"
Organization: Texas Instruments
Date: Wed, 14 Sep 2011 21:01:33 +0300
Message-ID: <1316023293.2355.33.camel@sokoban>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 18:04 +0200, Thomas Gleixner wrote:
> On Wed, 14 Sep 2011, Tero Kristo wrote:
> 
> > Current implementation of the irq_disable only calls chip->irq_disable.
> > This fails to disable interrupt on some chip implementations, as there
> > are two alternative chip specific functions for this task,
> > chip->irq_disable and chip->irq_mask. Added alternative path for
> > chip->irq_disable also.
> 
> This does not fail to do so. It's done on purpose. We don't want to
> access the interrupt chip when we can avoid it.
> 
> So we just mark the interrupt disabled and keep the line enabled.
> When another interrupt happens, then the handling code checks the
> disabled state of the line, masks the interrupt on the hardware level
> and sets the pending bit. This is documented behaviour and not going
> to change.
> 
> http://docs.blackfin.uclinux.org/kernel/generated/genericirq/ch04s03.html#Delayed_interrupt_disable
> 

Hmm okay, that makes sense.

> What are you trying to solve ?

I was seeing a hang with a chain handler implementation that was caused
by this delayed disable implementation, I am using a generic chip with
irq_mask / irq_unmask. Adding this patch to the kernel fixed the hang in
this case. There might be something wrong in my implementation of the
chain handler itself, I'll take a look at it again and try to figure out
another way to avoid it. I have another idea I can pursue, and based on
some initial testing it actually seems to be working.

-Tero



Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: 0115040-6. Kotipaikka: Helsinki
 

