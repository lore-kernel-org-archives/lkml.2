Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032Ab2DLHAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 03:00:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33653 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab2DLHAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 03:00:23 -0400
Date: Thu, 12 Apr 2012 09:01:15 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: clear fencing tracking state when
 retiring request
Message-ID: <20120412070115.GB3705@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>
References: <1334186877-6299-1-git-send-email-daniel.vetter@ffwll.ch>
 <1334187495_375289@CP5-2952>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334187495_375289@CP5-2952>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 12:38:09AM +0100, Chris Wilson wrote:
> On Thu, 12 Apr 2012 01:27:57 +0200, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > This fixes a regression introduce in
> s/introduce/introduced/
>  
> > commit 7dd4906586274f3945f2aeaaa5a33b451c3b4bba
> > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > Date:   Wed Mar 21 10:48:18 2012 +0000
> > 
> >     drm/i915: Mark untiled BLT commands as fenced on gen2/3
> > 
> > which fixed fencing tracking for untiled blt commands.
> > 
> > A side effect of that patch was that now also untiled objects have a
> > non-zero obj->last_fenced_seqno to track when a fence can be set up
> > after a pipelined tiling change. Unfortunately this was only cleared
> > by the fence setup and teardown code, resulting in tons of untiled but
> > inactive objects with non-zero last_fenced_seqno.
> > 
> > Now after resume we completely reset the seqno tracking, both on the
> > driver side (by setting dev_priv->next_seqno = 1) and on the hw side
> > (by allocating a new hws page, which contains the seqnos). Hilarity
> > and indefinite waits ensued from the stale seqnos in
> > obj->last_fenced_seqno from before the suspend.
> > 
> > The fix is to properly clear the fencing tracking state like we
> > already do for the normal gpu rendering while moving objects off the
> > active list.
> > 
> > Reported-and-tested-by: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: Jiri Slaby <jslaby@suse.cz>
> > Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> I spent sometime discussing whether or not we could hit a similar bug
> with a well placed change of tiling after resume, and the outcome is
> that as the fences are reset during freeze then all tiled objects that
> had been used for rendering would have been flushed (and their
> last_fenced_seqno set to 0).
> 
> So this is a new regression caused by the aforementioned patch and this
> is the cleanest fix,
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Picked up for -fixes, thanks for the review.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
