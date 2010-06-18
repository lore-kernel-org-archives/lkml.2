Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0FRXxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 19:53:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0FRXxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 19:53:44 -0400
Subject: Re: [PATCH] DRM / radeon / PM: Do not evict VRAM during freeze
 phase of hibernation
From: Dave Airlie <airlied@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>,
       linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ondrej Zary <linux@rainbow-software.org>
In-Reply-To: <201006190123.00694.rjw@sisk.pl>
References: <201006182221.57333.rjw@sisk.pl>
	 <1276895296.6513.3.camel@t60prh>  <201006190123.00694.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Jun 2010 09:49:55 +1000
Message-ID: <1276904995.6513.7.camel@t60prh>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-19 at 01:23 +0200, Rafael J. Wysocki wrote:
> On Friday, June 18, 2010, Dave Airlie wrote:
> > On Fri, 2010-06-18 at 22:21 +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > I have recently noticed a 55 sec. delay during the "device freeze"
> > > phase of hibernation on my test-bed HP nx6325.  Due to the 100%
> > > reproducibility of it I was able to narrow it down to
> > > radeon_suspend_kms() and then it turned out that the delay occured
> > > somewhere in radeon_bo_evict_vram().  However, it doesn't seem really
> > > necessary or even very useful to me to evict VRAM at this particular
> > > point, because we're going to create an image and bring the device
> > > back to the fully functional state in a little while.  Thus, I think
> > > the VRAM evicition can be skipped for state.event == PM_EVENT_FREEZE,
> > > which makes the delay go away.
> > 
> > I'm not 100% sure of the hibernate sequencing and its early in the
> > morning, but we want to evict VRAM before image building so we can have
> > the contents of VRAM in the image so we can restore them on resume. Does
> > this just avoid evicting them a second time after we created the image?
> 
> No, it's the first time, before creating the image, but I didn't seen any
> difference on resume with and without the patch, so I thought it was a good
> idea. :-)

On the machine you have its most likely not going to show up unless you
are running a 3D app or something across suspend, since currently X
re-exposes most apps on VT switch, so they just redraw.

Was it always this slow? you can see how many objects are in vram using
debugfs (/sys/kernel/debug/dri/0/radeon_vram_mm), it sounds like the TTM
eviction process is blocking on something, we shouldn't be using any
UC/WC memory on that machine so I can't imagine the new pool allocator
stuff would get in the way. Maybe its the lack of GFP_USER, (Jerome
posted a patch).

Dave.


