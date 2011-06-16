Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab1FPQkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:40:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43161 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab1FPQkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:40:07 -0400
Date: Thu, 16 Jun 2011 10:40:04 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] dw_spi: rework message processing
Message-ID: <20110616164004.GF3795@ponder.secretlab.ca>
References: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com>
 <1308158588-17249-4-git-send-email-dirk.brandewie@gmail.com>
 <20110616131425.GD31534@ponder.secretlab.ca>
 <4DFA2965.1000708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFA2965.1000708@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 09:03:49AM -0700, Dirk Brandewie wrote:
> On 06/16/2011 06:14 AM, Grant Likely wrote:
> >On Wed, Jun 15, 2011 at 10:23:06AM -0700, dirk.brandewie@gmail.com wrote:
> >>From: Dirk Brandewie<dirk.brandewie@gmail.com>
> >>
> >>NOTE: patch created git format-patch --break-rewrites=/50%
> >>
> >>This patch reworks the message pump worker thread function to run
> >>until all messages queued to the driver have been handled. The
> >>function to handle individual spi_transfers is now a synchronus
> >>function the tasklet to handle spi_transfers has been removed. Work
> >>for the worker thread is only queued in host controller transfer
> >>function.
> >>
> >>Psuedo code for new thread function:
> >>   message = get_message()
> >>   while (message){
> >>     for_each_transfer_in_msg(message){
> >>       transfer_setup(transfer)
> >>       do_transfer()
> >>     }
> >>     complete_message()
> >>     message = get_message()
> >>   }
> >>
> >>Changes that fell out of the message thread changes:
> >>Non-DMA transfers that are larger than the size of the controller FIFO
> >>are handled as interrupt driven transfers.
> >>
> >>Common FIFO handling functions shared PIO and interrupt transfers.
> >>
> >>Simplified queue stop/start funcitons.
> >>
> >>Cleanup fixes:
> >>Changed exported all exported function names to have dw_spi_ prefix
> >>
> >>Removed support for registering chip select control function. Setting
> >>the slave chip select is handled by setting the SER (Slave enable
> >>register)
> >
> >What about for implementations that use a GPIO for the SPI chip
> >select?  It is very common for board designs to use GPIOs for
> >multiplexing the SPI bus.
> 
> OK I can put that back. I took it out for the following reason.
> 
> The Slave Enable Register (SER) must be set for the IP block to
> start the transfer.  The bit in SER directly control a separate chip
> select pin while there is an active transfer.  This gives four chip
> selects in the direct mapping case and up to fifteen if the slave
> chip selects are muxed together.
> 
> >
> >>
> >>Removed code that looked at the cs_change hint in the
> >>spi_transfer. Software has no contorl over whether the slave chip
> >>select is de-asserted at the end of the transfer.  Once the TX FIFO
> >>goes empty the slave chip select is dropped.
> >
> >This sounds wrong.  cs_change is *not* merely a hint.  It must be respected.
> >If the driver has no direct control over the CS line, then it is
> >incumbent on the driver to guaranteed that the cs deassert condition
> >does not occur.  This will probably mean chaining up all the transfers
> >in a message so that the TX FIFO remains full.  If cs_change is
> >requested, then the FIFO must be allowed to empty before kicking of
> >the next group of transfers.
> >
> 
> I agree it is wrong that the driver can not directly control the chip select :-)
> 
> I could probably manage to get the PIO and interrupt case to honor
> this but would add a fair bit of complexity, I have no idea how to
> make the DMA case work I am open to suggestions :-).  The current
> driver has this issue I just made it explicit maybe we should add a
> warning message in the driver to let client driver writers aware of
> the Silicon behaviour.

Use scatter/gather DMA or a bounce buffer to chain up contiguous
transfers into a single DMA operation.  "Best effort" is not okay in
this situation, the behaviour is required even if it does add
complexity.

g.
