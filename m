Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab2AETdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:33:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60101 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab2AETdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:33:39 -0500
Date: Thu, 5 Jan 2012 14:37:40 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bskeggs@redhat.com
Subject: Re: [PATCH] fixes to drm-next - TTM DMA code (v1)
Message-ID: <20120105193740.GC2799@homer.localdomain>
References: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com>
 <20111213160753.GC2339@homer.localdomain>
 <4EE77C02.1000103@vmware.com>
 <20111213164031.GA32052@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111213164031.GA32052@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 11:40:31AM -0500, Konrad Rzeszutek Wilk wrote:
> On Tue, Dec 13, 2011 at 05:23:30PM +0100, Thomas Hellstrom wrote:
> > On 12/13/2011 05:07 PM, Jerome Glisse wrote:
> > >On Mon, Dec 12, 2011 at 03:09:26PM -0500, Konrad Rzeszutek Wilk wrote:
> > >>Jerome pointed me to some accounting error in the DMA API debugging code and
> > >>while I can't figure it out yet, I did notice some extreme slowness - which
> > >>is due to the nouveau driver calling the unpopulate (now that unbind +
> > >>unpopulate are squashed) quite a lot (this is using Gnome Shell - I think GNOME2
> > >>did not have those issues but I can't recall).
> > >>
> > >>Anyhow these patches fix the 50% perf regression I saw and also some minor bugs
> > >>that I noticed.
> > >>
> > >Gonna review those today and test them.
> > >
> > >Cheers,
> > >Jerome
> > Hi!
> > 
> > I'm not whether any drivers are still using the AGP backend?
> 
> Uh, probably they do if the cards are AGP?
> The problem I encountered was with an PCIe Nvidia card:
> 
> 01:00.0 VGA compatible controller: nVidia Corporation G84 [GeForce 8600 GT] (rev a1
> 
> > Calling unpopulate / (previous clear) each time unbind is done
> > should be quite
> > inefficient with that one, as AGP sets up its own data structures
> > and copies page tables
> > on each populate. That should really be avoided unless there is a
> > good reason to have it.
> 
> nouveau_bo_rd32 and nv50_crtc_cursor_set showed up as the callers that
> were causing the unpopulate calls. It did happen _a lot_ when I moved the
> cursor madly.

Looked at that and i am pretty sure that those function can't trigger
unpopulate event (but i might have missed a path). I tested before and
after the ttm change and those function are as time consuming as before.

I think nouveau is doing something stupid in userspace when it comes to
cursor (might be the ddx or just gnome3 or X server haven't tracked that
down).

Anyway, bottom line is i believe we don't call unpopulate more than
before the ttm changes. It seems to be the same from code inspection,
previously each time we called clear we also freed the pages so clear
is equivalent to unpopulate. In theory we don't call unpopulate on
each unbind but given the current user we do (only path were unbind
is not followed by unpopulate is ttm_bo_move_ttm same as before the
patch so no change there).

So, Konrad patch to avoid calling set_pages_array_wb when the page is
cached is a proper fix, this is what happened before, and this is what
the ttm change broke. I believe there is no performance regression with
this ttm change on radeon or nouveau (tested only with gnome3+nexuiz
on nv50 and r600,r700,evergreen).

Cheers,
Jerome
