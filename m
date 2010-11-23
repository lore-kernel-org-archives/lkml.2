Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab0KWB2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 20:28:37 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44224 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab0KWB2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 20:28:36 -0500
Date: Mon, 22 Nov 2010 17:28:36 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md: Call blk_queue_flush() to establish flush/fua
	support
Message-ID: <20101123012836.GV14383@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20101122232208.GU14383@tux1.beaverton.ibm.com> <20101123105000.331b40f8@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123105000.331b40f8@notabene.brown>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 10:50:00AM +1100, Neil Brown wrote:
> On Mon, 22 Nov 2010 15:22:08 -0800
> "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> 
> > Before 2.6.37, the md layer had a mechanism for catching I/Os with the barrier
> > flag set, and translating the barrier into barriers for all the underlying
> > devices.  With 2.6.37, I/O barriers have become plain old flushes, and the md
> > code was updated to reflect this.  However, one piece was left out -- the md
> > layer does not tell the block layer that it supports flushes or FUA access at
> > all, which results in md silently dropping flush requests.
> > 
> > Since the support already seems there, just add this one piece of bookkeeping
> > to restore the ability to flush writes through md.
> 
> I would rather just unconditionally call
>    blk_queue_flush(mddev->queue, REQ_FLUSH | REQ_FUA);
> 
> I don't think there is much to be gained by trying to track exactly what the
> underlying devices support, and as the devices can change, that is racy
> anyway.
> 
> Thoughts?

I don't think there's anything that would get confused by an md that advertises
flush/fua support when any of the underlying devices don't support it, but that
was the only reason why I didn't just code it up your way to start with. :)

None of the in-kernel code checks queue->flush_flags except the block layer
itself, and the block layer silently strips off REQ_FLUSH/REQ_FUA if the device
doesn't support it.  I'm not sure I like /that/ behavior, but at the moment I
have no objection.  dm hardcodes the flags on as well.

--D
