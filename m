Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2LJMo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 07:44:56 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58961 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2LJMox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 07:44:53 -0500
Date: Mon, 10 Dec 2012 04:43:54 -0800
From: Chris Moeller <kode54@gmail.com>
To: Chris Moeller <kode54@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 0/1] Input: xpad - Implement wireless controller LED
 setting and fix connect time LED setting
Message-ID: <20121210044354.5d562079@umaro.lan>
In-Reply-To: <20121210025825.197ddc25@umaro.lan>
References: <20121130135406.38c9bdc9@umaro.lan>
	<1994333.0mnJMZMWGT@dtor-d630.eng.vmware.com>
	<20121130201329.3f8aefa0@umaro.lan>
	<20121203074318.GC28682@core.coreip.homeip.net>
	<20121210025825.197ddc25@umaro.lan>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012 02:58:25 -0800
Chris Moeller <kode54@gmail.com> wrote:

> On Sun, 2 Dec 2012 23:43:18 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > On Fri, Nov 30, 2012 at 08:13:29PM -0800, Chris Moeller wrote:
> > > On Fri, 30 Nov 2012 14:30:23 -0800
> > > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > 
> > > > Hi Chris,
> > > > 
> > > > On Friday, November 30, 2012 01:54:06 PM Chris Moeller wrote:
> > > > > I've submitted versions of this with prior patch sets, and
> > > > > this part was never accepted, possibly because it depended on
> > > > > other patches to work, or possibly because it wasn't so
> > > > > cleanly organized. This time, I've split the LED setting
> > > > > command off into its own static function, then call that on
> > > > > controller connect and optionally on LED setting commands.
> > > > > The static function does not include any locking, because
> > > > > locking inside the function which receives the incoming
> > > > > packets deadlocks the driver, and does not appear to be
> > > > > necessary anyway.
> > > > > 
> > > > > It also removes all traces of the original bulk out function
> > > > > which was designed for the purpose of setting the LED status
> > > > > on connect, as I found that it actually does not work at all.
> > > > > It appears to try to send the data, but nothing actually
> > > > > happens to the controller LEDs.
> > > > 
> > > > Attached is a reply I sent to on 7/4/11 to which you
> > > > unfortunately never responded. The issue is that of force
> > > > feedback (rumble) and LED share the same URB then access to
> > > > that URB should be arbitrated. The attached message contains a
> > > > patch that attempts to implement that arbitration, could you
> > > > please try it out and see what changes are needed to make it
> > > > work?
> > > > 
> > > > Thanks.
> > > > 
> > > 
> > > So sorry I missed your reply. That's what I get for filtering the
> > > mailing list messages past my inbox, then never following up on my
> > > filter/folder set for replies to my own messages. I recall you
> > > mentioned that potential race condition when I first submitted,
> > > but I forgot to do anything about it. I'm glad at least one of us
> > > has our stuff together. It seems to work just fine, but there may
> > > be a force feedback issue with the following test program, where
> > > it leaves the effect playing indefinitely after the program
> > > terminates, and then the controller itself ceases to respond until
> > > the module is removed and reloaded.
> > 
> > Just to confirm, you see this problem only with the patch being
> > discussed and do not see it without it, right?
> > 
> 
> Yeah, the problem only happens with this patch. Here's a silly mess
> which fixes it. If you can think of a better way to handle pending
> commands outside of the IRQ, be my guest. The problem seems to be that
> it doesn't like sending further commands from inside the output irq
> callback, so further commands are not sent, and the spinlock is left
> locked or something. So it seems that it needs to be such that the
> callback merely signals when the packet has completed sending, and the
> actual queue must be handled outside of the irq, and somehow kindly
> wait for the irq to complete for each command. Unless, you know,
> there's some other way to queue up multiple commands without waiting
> on each one to complete. I know bulk out doesn't work for the LED
> setting command, at least. Anyway, here goes.

Disregard this patch, it locks up frequently. I'm working on something
else instead.
