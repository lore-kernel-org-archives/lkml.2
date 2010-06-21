Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0FUH44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 03:56:56 -0400
Received: from nox2.protox.org ([95.130.11.66]:47917 "EHLO protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab0FUH4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 03:56:55 -0400
Date: Mon, 21 Jun 2010 09:57:41 +0200
From: Jerome Glisse <glisse@freedesktop.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel <dri-devel@lists.freedesktop.org>,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] DRM / radeon / PM: Do not evict VRAM during freeze phase
 of hibernation
Message-ID: <20100621075741.GB2350@barney.localdomain>
References: <201006182221.57333.rjw@sisk.pl>
 <1276904995.6513.7.camel@t60prh>
 <201006191453.58379.rjw@sisk.pl>
 <201006200143.06059.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006200143.06059.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 01:43:05AM +0200, Rafael J. Wysocki wrote:
> On Saturday, June 19, 2010, Rafael J. Wysocki wrote:
> > On Saturday, June 19, 2010, Dave Airlie wrote:
> > > On Sat, 2010-06-19 at 01:23 +0200, Rafael J. Wysocki wrote:
> > > > On Friday, June 18, 2010, Dave Airlie wrote:
> > > > > On Fri, 2010-06-18 at 22:21 +0200, Rafael J. Wysocki wrote:
> > > > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > > 
> > > > > > I have recently noticed a 55 sec. delay during the "device freeze"
> > > > > > phase of hibernation on my test-bed HP nx6325.  Due to the 100%
> > > > > > reproducibility of it I was able to narrow it down to
> > > > > > radeon_suspend_kms() and then it turned out that the delay occured
> > > > > > somewhere in radeon_bo_evict_vram().  However, it doesn't seem really
> > > > > > necessary or even very useful to me to evict VRAM at this particular
> > > > > > point, because we're going to create an image and bring the device
> > > > > > back to the fully functional state in a little while.  Thus, I think
> > > > > > the VRAM evicition can be skipped for state.event == PM_EVENT_FREEZE,
> > > > > > which makes the delay go away.
> > > > > 
> > > > > I'm not 100% sure of the hibernate sequencing and its early in the
> > > > > morning, but we want to evict VRAM before image building so we can have
> > > > > the contents of VRAM in the image so we can restore them on resume. Does
> > > > > this just avoid evicting them a second time after we created the image?
> > > > 
> > > > No, it's the first time, before creating the image, but I didn't seen any
> > > > difference on resume with and without the patch, so I thought it was a good
> > > > idea. :-)
> > > 
> > > On the machine you have its most likely not going to show up unless you
> > > are running a 3D app or something across suspend, since currently X
> > > re-exposes most apps on VT switch, so they just redraw.
> > 
> > Yes.  Moreover, hibernation is always done after a VT switch.  That's why
> > I said I thought the eviction wasn't necessary in the changelog.
> > 
> > BTW, I have three different test boxes with radeon hardware and the
> > $subject patch is not a problem on any of them.
> > 
> > > Was it always this slow?
> > 
> > Nope.  It definitely is a regression, although I'm not sure what's the last
> > good kernel.
> > 
> > > you can see how many objects are in vram using
> > > debugfs (/sys/kernel/debug/dri/0/radeon_vram_mm), it sounds like the TTM
> > > eviction process is blocking on something,
> 
> I did some more debug work (the _total_ lack of comments inside of the
> relevant radeon and ttm code makes this a next-to-impossible task, though)
> and found that all of the delays (up to 5 seconds) happen inside of
> ttm_bo_move_accel_cleanup() called from radeon_move_blit(), where the "new"
> memory type is TTL_PL_TT and the "old" one is TTL_PL_VRAM.  The preceding
> radeon_copy() always returns 0.
> 
> Please let me know if you need more information.
> 
> Thanks,
> Rafael

Can you confirm that this is trigger by first radeon_bo_evict_vram in
radeon_suspend_kms() ? Also can you check if irq is enabled (put some
debug in the irq handler of your gpu). My guess is that irq are stop
(likely stop before radeon suspend callback) and that we endup waiting
that the fence timeout expire in radeon_fence_wait().

Cheers,
Jerome
