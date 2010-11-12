Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab0KLVgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:36:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab0KLVgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:36:45 -0500
Date: Fri, 12 Nov 2010 16:36:34 -0500
From: Jeff Layton <jlayton@redhat.com>
To: sandeen@redhat.com
Cc: Rik van Riel <riel@redhat.com>, Zan Lynx <zlynx@acm.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        jmoyer@redhat.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] clear PageError bit in msync & fsync
Message-ID: <20101112163634.7bf09326@tlielax.poochiereds.net>
In-Reply-To: <4CDDA8E7.2090003@redhat.com>
References: <20101109114422.3918e7f6@annuminas.surriel.com>
	<20101109142109.224267d0@corrin.poochiereds.net>
	<4CD9A209.6070807@redhat.com>
	<4CD9BB5B.2090206@acm.org>
	<4CD9BBF9.8020600@redhat.com>
	<4CDDA8E7.2090003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010 14:51:51 -0600
Eric Sandeen <esandeen@redhat.com> wrote:

> On 11/09/2010 03:24 PM, Rik van Riel wrote:
> > On 11/09/2010 04:21 PM, Zan Lynx wrote:
> >> On 11/9/10 12:33 PM, Rik van Riel wrote:
> >>> On 11/09/2010 02:21 PM, Jeff Layton wrote:
> >>>
> >>>> This does leave the page in sort of a funky state. The uptodate bit
> >>>> will still probably be set, but the dirty bit won't be. The page will
> >>>> be effectively "disconnected" from the backing store until someone
> >>>> writes to it.
> >>>>
> >>>> I suppose though that this is the best that can reasonably be done in
> >>>> this situation however...
> >>>
> >>> I spent a few days looking for alternatives, and indeed I found
> >>> nothing better...
> >>
> >> Just an off the top of my head crazy idea...
> >>
> >> Could you leave the error bit set on the page and treat it as a dirty
> >> bit during a future msync, clearing the error bit at that point.
> >>
> >> The general idea would be to leave the error set unless an explicit
> >> write was requested.
> > 
> > The problem with that is that the page will be unreclaimable,
> > and the VM could get filled with PageError pages and be unable
> > to make further progress (if the IO path does not come back).
> 
> As a further crazy idea ;)  what if it only persisted for "X" write
> attempts?  Maybe (sigh) a tunable?
> 
> That way several fsyncs get the chance to see it, but eventually
> enough writebacks will go off to give up and clear it.  Hacky,
> but an idea ...

That is an interesting idea. Not losing your dirty data in the face of
a transient error would certainly be a nice-to-have. One has to
consider that applications using mmap might have a hard time reissuing
the writes. Keeping the dirty bit set might be less problematic in that
situation.

Blue-skying for a min...

1) you could instead or in addition allow some method for discarding
the dirty pages that are backed by this device manually. Some magical
file under /sys maybe? That way you have some way to get rid of the data
when you know that the device isn't coming back. Doing that manually
might be safer than relying on a certain number of retries (though it
does require someone to know what they're doing in order to clear the
problem).

2) Could you prevent new pages that are backed by this device from
being dirtied or mmapped until the problem is cleared? Not exactly sure
how to implement that, but it might keep someone from making things
worse when this sort of problem occurs.

-- 
Jeff Layton <jlayton@redhat.com>
