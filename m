Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2DASuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 14:50:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37601 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2DASuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 14:50:08 -0400
Date: Sun, 1 Apr 2012 21:49:13 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Rafal Prylowski <prylowski@metasoft.pl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Message-ID: <20120401184913.GJ5812@mwesterb-mobl.ger.corp.intel.com>
References: <4F683B36.8090101@metasoft.pl>
 <20120321193836.GC3740@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48E3E@AUSP01VMBX24.collaborationhost.net>
 <20120323070446.GC5812@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48EEB@AUSP01VMBX24.collaborationhost.net>
 <20120324073207.GD5812@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F002069702575E@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F002069702575E@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 05:33:49PM -0500, H Hartley Sweeten wrote:

> I tried doing a bit more debugging with the handle_one_vic function. It
> appears that the timer tick is what's causing the spi dma interrupts grief.
> I'm just not sure how it's happening or how to fix it...
> 
> I modified handle_one_vic to output a message when multiple interrupts
> are detected in the stat. Then, if multiple interrupts were detected, to output
> a message with the new calculated stat and the actual stat. These "should"
> occur one right after the other when multiple interrupts are detected. But
> that's not what I'm getting. Here's a sample trace with comments:
> 
> handle_one_vic: stat:0x00060000 - handling irq:17 now
> 	stat shows interrupts 17 and 18
> handle_one_vic: stat:0x00040010 - handling irq:4 now
> 	stat shows interrupts 4 and 18, 17 was handled
> handle_one_vic: next stat:0x00040000 - actual stat:0x00040000
> 	next stat shows interrupt 18, 4 was handled, 18 is pending
> handle_one_vic: stat:0x00040000 - handling irq:18 now
> 	stat shows interrupt 18
> handle_one_vic: next stat:0x00000000 - actual stat:0x00000010
> 	next stat shows no interrupts, 18 was handled, 4 is pending
> handle_one_vic: next stat:0x00040000 - actual stat:0x00000000
> 	next stat shows interrupt 18, it was already handled, none are pending
> handle_one_vic: stat:0x00040000 - handling irq:18 now
> 	stat shows interrupt 18 (which was already handled)
> dma dma1chan1: spurious interrupt: status=00002180
> 	bang... spurious interrupt
> 
> It looks like the timer interrupt (4) is causing vic_handle_irq to start
> iterating over the VIC's while an iteration is already in progress.  One
> of the iterations is handling interrupt 18 correctly but, since the stat
> is only read once, the second iteration also tries to handle it.
>
> Any ideas?

Unfortunately no :-/ I've been investigating this also and so far haven't
found anything which could explain this behaviour. It is good that you found
that the timer interrupt might have something to do with this. I'm going to
add some more debugging code and see if that helps to identify the reason for
this.

It might also be that the ep93xx_dma driver is doing something wrong in its
interrupt handler which causes the DONE bit to stay asserted even though the
first thing it does is to write 0 to M2M_INTERRUPT register which is supposed
to clear the interrupt..
