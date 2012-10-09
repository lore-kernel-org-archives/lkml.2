Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2JIV1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:27:32 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53529 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab2JIV12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:27:28 -0400
Date: Tue, 9 Oct 2012 14:27:24 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 5/5] aio: Refactor aio_read_evt, use cmxchg(), fix bug
Message-ID: <20121009212724.GD29494@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-5-git-send-email-koverstreet@google.com>
 <20121009183753.GP26187@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009183753.GP26187@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 11:37:53AM -0700, Zach Brown wrote:
> On Mon, Oct 08, 2012 at 11:39:20PM -0700, Kent Overstreet wrote:
> > Bunch of cleanup
> 
> Ugh.  That's way too much noisy change for one patch with no
> description.  Break it up into functional pieces and actually describe
> them.

Heh, I actually didn't mean to send these patches out to lkml just yet
(though now I'm glad I did). There definitely is too much in this patch,
it kinda snowballed.

> > events off the ringbuffer without racing with io_getevents().
> 
> Are you sure this is safe in the presence of wrapping indices?  It's
> been a very long time since I've looked at this, but I could never
> convince myself that it was safe.
> 
> What I'm worried about is cmpxchg()s caller sampling, say, and index of
> 0, having another task GO NUTS and wrap that index all the way around
> back to 0, and then having that initial cmpchg() caller see the wrapped
> 0 index and think that's nothing's changed in the interim.
> 
> Is this a problem?

Ohhhh, yeah it is - ABA. That's easily solved though, we do the head %
nr when we're using the head pointer, and let the stored value use the
full 32 bits.

If libaio is the only thing in userspace looking at the ringbuffer, and
if I'm looking at the latest libaio code this shouldn't break
anything...

> (I wish I could find the comment I wrote in a very old patch to tear out
> the mapped ring entirely.. It was a great list of its design mistakes.)

Sticking the head and tail pointers on the same cacheline is one of my
main complaints. If you could find that comment I'd be interested in
reading it, though.
