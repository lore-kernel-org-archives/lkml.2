Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0KCUbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 16:31:47 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45883 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab0KCUbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 16:31:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pSo4RgzbVxVIL3KqXMTLcvdv875PKPOyzm2Lenmm3rYDRJUEiXo5+yjsMl3buelc7p
         ncBnc9BamvnWDCw2o1ZDULbUQxmvUoj9a6XuMMn/PPcdF73yG3XoIYKj2smcsQcsg2qK
         Wvijk4uEJz60tuOvbaCjW1HwmPSSdKf5DC7jE=
Subject: Re: [PATCH] drivers/net/tile/: on-chip network drivers for the
 tile architecture
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <4CD1BA71.3000806@tilera.com>
References: <201011012107.oA1L7TGd031588@farm-0027.internal.tilera.com>
	 <20101103125959.3231daa1@s6510>  <4CD19DCF.1040709@tilera.com>
	 <1288806622.2511.187.camel@edumazet-laptop>  <4CD1BA71.3000806@tilera.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 21:31:40 +0100
Message-ID: <1288816300.2718.5.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 novembre 2010 à 15:39 -0400, Chris Metcalf a écrit :

> I read it and internalized it long ago, and re-read it when I got Stephen's
> original email.  I should have said that explicitly instead of a comment
> with a smiley -- email is a tricky communication medium sometimes.
> 
> Several uses of "*(volatile int *)ptr" in that file are intended as
> performance hints.  A more obvious way to state this, for our compiler, is
> to say "prefetch_L1(ptr)".  This generates essentially the same code, but
> avoids the red flag for "volatile" and also reads more clearly, so it's a
> good change.
> 
> The other use is part of a very precise dance that involves detailed
> knowledge of the Tile memory subsystem micro-architecture.  This doesn't
> really belong in the network device driver code, so I've moved it to
> <asm/cacheflush.h>, and cleaned it up, with detailed comments.  The use
> here is that our network hardware's DMA engine can be used in a mode where
> it reads directly from memory, in which case you must ensure that any
> cached values have been flushed.
> 

This kind of things really must be discussed before using it in a
network driver.

Because, an skb can be built by one CPU, queued on a qdisc queue, with
no particular "cached values have been flushed" ...

It then can be dequeued by another CPU, and given to the device.
What happens then ?

> /*
>  * Flush & invalidate a VA range that is homed remotely on a single core,
>  * waiting until the memory controller holds the flushed values.
>  */
> static inline void finv_buffer_remote(void *buffer, size_t size)
> {
> 	char *p;
> 	int i;
> 
> 	/*
> 	 * Flush and invalidate the buffer out of the local L1/L2
> 	 * and request the home cache to flush and invalidate as well.
> 	 */
> 	__finv_buffer(buffer, size);
> 
> 	/*
> 	 * Wait for the home cache to acknowledge that it has processed
> 	 * all the flush-and-invalidate requests.  This does not mean
> 	 * that the flushed data has reached the memory controller yet,
> 	 * but it does mean the home cache is processing the flushes.
> 	 */
> 	__insn_mf();
> 
> 	/*
> 	 * Issue a load to the last cache line, which can't complete
> 	 * until all the previously-issued flushes to the same memory
> 	 * controller have also completed.  If we weren't striping
> 	 * memory, that one load would be sufficient, but since we may
> 	 * be, we also need to back up to the last load issued to
> 	 * another memory controller, which would be the point where
> 	 * we crossed an 8KB boundary (the granularity of striping
> 	 * across memory controllers).  Keep backing up and doing this
> 	 * until we are before the beginning of the buffer, or have
> 	 * hit all the controllers.
> 	 */
> 	for (i = 0, p = (char *)buffer + size - 1;
> 	     i < (1 << CHIP_LOG_NUM_MSHIMS()) && p >= (char *)buffer;
> 	     ++i) {
> 		const unsigned long STRIPE_WIDTH = 8192;
> 
> 		/* Force a load instruction to issue. */
> 		*(volatile char *)p;
> 
> 		/* Jump to end of previous stripe. */
> 		p -= STRIPE_WIDTH;
> 		p = (char *)((unsigned long)p | (STRIPE_WIDTH - 1));
> 	}
> 
> 	/* Wait for the loads (and thus flushes) to have completed. */
> 	__insn_mf();
> }
> 


