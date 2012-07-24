Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab2GXPwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 11:52:10 -0400
Received: from longford.logfs.org ([213.229.74.203]:41717 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab2GXPwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 11:52:09 -0400
Date: Tue, 24 Jul 2012 10:38:22 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120724143822.GA24954@logfs.org>
References: <20120424205946.GH20610@logfs.org>
 <201207231533.16350.tvrtko.ursulin@onelan.co.uk>
 <20120723200230.GC17767@logfs.org>
 <201207240901.16151.tvrtko.ursulin@onelan.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201207240901.16151.tvrtko.ursulin@onelan.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 July 2012 09:01:16 +0100, Tvrtko Ursulin wrote:
> On Monday 23 Jul 2012 21:02:30 Jörn Engel wrote:
> > On Mon, 23 July 2012 15:33:16 +0100, Tvrtko Ursulin wrote:
> > > On Thursday 12 Jul 2012 18:46:34 Jörn Engel wrote:
> 
> At the very least block console does not work from interrupt context while 
> netconsole does, right? Also netconsole does things to try and work around low 
> memory situations. Things like that I think would be useful additions to 
> documentation.

Blockconsole does work from interrupt context.  It has buffers for 1MB
worth of data.  Until those fill up, it only does a memcpy and
schedules a workqueue for writeback.  If you panic, it will do the
writeback immediately.  While I wouldn't believe this to always work,
I have yet to see a confirmed failure case.

Blockconsole itself has no allocations in the write path, so it should
be unaffected by low memory situation.  The underlying driver and
block layer code may well be.

> > > I second the notion that logging to partitions would be useful.
> > 
> > Below is a compile-tested patch to do that.  Feel free to give it a
> > spin and fix any bugs.
> 
> I can't promise to do that in the very near future, but in principle idea 
> could be interesting to me, at least to evaluate how reliable mechanism is 
> with different storage interfaces and controllers.

Fair enough.  In the meantime I will leave this code out.  Adding a
new interface that noone has tested would be pretty bad style.

> > > Also, and I haven't checked what the swap format is, if it could somehow
> > > be integrated together that could be useful.
> > 
> > That appears to be slightly less likely than crossbreeding a rabbit
> > with a chicken.  Is there something obvious I have missed?
> 
> I was thinking how swap space is always there and is potentially much faster 
> to write to than a random USB stick - which could translate to more reliable. 
> Then it's a question of which storage subsystem (libata vs. usb-storage) would 
> work better in different oops/panic situations. Again I tend to have less hope 
> in USB based solutions - maybe it's my bias from working in that area many 
> years ago. So the idea of swap space was that _if_ swap format could be 
> extended to allocate a number of blocks to use other than swap, then that area 
> could be used by blockconsole. Seemed like a convenient and potentially more 
> reliable solution to me, but as I said the latter may depend.

In my systems swap is often absent.  Plus, taking a few blocks a swap
aside is in the end just partitioning in a new dress.  So the argumen
appears to boil down to using partitions again.  The equivalent of
swap files might be interesting, but can also be somewhat scary.  So I
would leave it to others to actually write the code - if they care.

Libata is fine, blockconsole can work on any block device.

Jörn

--
Anything that can go wrong, will.
-- Finagle's Law
