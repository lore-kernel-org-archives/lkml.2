Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1HWQun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:50:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab1HWQug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:50:36 -0400
Date: Tue, 23 Aug 2011 12:50:23 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Adam Cozzette <acozzette@cs.hmc.edu>
Cc: edwin_rong <edwin_rong@realsil.com.cn>, wwang <wei_wang@realsil.com.cn>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ums-realtek driver uses stack memory for DMA
Message-ID: <20110823165022.GK2270@zod.bos.redhat.com>
References: <20110801210905.GC2096@zod.bos.redhat.com>
 <20110802050411.GC3857@[192.168.0.12]>
 <20110802124117.GH2096@zod.bos.redhat.com>
 <20110812150556.GC3014@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110812150556.GC3014@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 11:05:56AM -0400, Josh Boyer wrote:
> On Tue, Aug 02, 2011 at 08:41:17AM -0400, Josh Boyer wrote:
> > On Mon, Aug 01, 2011 at 11:04:11PM -0600, Adam Cozzette wrote:
> > > On Mon, Aug 01, 2011 at 05:09:06PM -0400, Josh Boyer wrote:
> > > > Hello,
> > > > 
> > > > We have a report that the ums-realtek driver is generating a backtrace
> > > > due to using stack variables for DMA buffers.  The backtrace is below
> > > > and you can view the bug report here:
> > > > https://bugzilla.redhat.com/show_bug.cgi?id=720054
> > > > 
> > > > Looking through the code, it seems that every call to rts51x_read_mem,
> > > > rts51x_write_mem, and rts51x_read_status passes a stack variable to
> > > > rts51x_bulk_transport, which then calls usb_stor_bulk_transfer_buf with
> > > > this and generates the backtrace.  It is my understanding that the
> > > > driver should be passing variables that are not on the stack and have
> > > > been allocated with memory that will be suitable for the DMA api (e.g.
> > > > kmalloc).
> > > > 
> > > > Was this missed during the initial review and is anyone working on
> > > > adapting the driver to be compliant?
> > > 
> > > Could you try out this patch if it looks ok to you? I have not tested it because
> > > unfortunately I don't have the hardware. Right now it generates some compile
> > > warnings like this one:
> > > 
> > > drivers/usb/storage/realtek_cr.c:419:40: warning: ‘buf[0]’ may be used uninitialized in this function [-Wuninitialized]
> > > 
> > > It think they are harmless but I didn't see an obvious way to get rid of them,
> > > so if you have any suggestions I would be glad to hear them.
> > > 
> > > This patch changed rts51x_read_mem, rts51x_write_mem, and rts51x_read_status to
> > > allocate temporary buffers with kmalloc. This way stack addresses are not used
> > > for DMA when these functions call rts51x_bulk_transport.
> > > 
> > > Signed-off-by: Adam Cozzette <acozzette@cs.hmc.edu>
> > 
> > This looks pretty good.  I backported it to 3.0 and will do a scratch
> > build for the bug reporter to test with.
> 
> We've included this patch for a while now.  I think it should get queued
> up in mainline.

Adam, can you resend this patch to Greg with a proper subject line so we
can get it included in mainline?

https://lkml.org/lkml/2011/8/23/246

thanks,
josh
