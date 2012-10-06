Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2JFJRX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 05:17:23 -0400
Received: from 1wt.eu ([62.212.114.60]:35992 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab2JFJRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 05:17:20 -0400
Date: Sat, 6 Oct 2012 11:17:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.5 regression on i915
Message-ID: <20121006091708.GC22618@1wt.eu>
References: <20121005234218.GC21163@1wt.eu> <CAPM=9txTo4agvvFnY8KbF82WoCxh0Pmb1HcoEP4ZUbauL5Ws8Q@mail.gmail.com> <20121005235845.GE21163@1wt.eu> <20121006072704.GA22465@1wt.eu> <CAPM=9twQb7BUe6cAD-5THBBP-eYAU56__V5UXNn2qfqdFkVwmA@mail.gmail.com> <20121006075956.GF21163@1wt.eu> <051c15$4i14fm@AZSMGA002.ch.intel.com> <20121006084258.GB22618@1wt.eu> <275ffc$6skdfn@fmsmga002.fm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <275ffc$6skdfn@fmsmga002.fm.intel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 10:04:00AM +0100, Chris Wilson wrote:
> On Sat, 6 Oct 2012 10:42:58 +0200, Willy Tarreau <w@1wt.eu> wrote:
> > On Sat, Oct 06, 2012 at 09:24:35AM +0100, Chris Wilson wrote:
> > > More likely X is segfaulting for another reason altogether. Can you
> > > please attach the stacktrace (with symbols!) and see if another
> > > bisection is required?
> > 
> > Yes, here it is.
> > 
> > (EE) intel(0): Failed to initialize kernel memory manager
> > 
> > Backtrace:
> > 0: X(xf86SigHandler+0x7e) [0x80d8b5e]
> > 1: [0xffffe400]
> > 2: /usr/lib/xorg/modules/drivers//intel_drv.so(i830_allocator_init+0x332) [0xb73756e2]
> 
> Drat, that is:
> 
> commit 7bb6fb8dd958ae773ac205282e3c0b56c22e01ed
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Tue Apr 24 08:22:52 2012 +0200
> 
>     drm/i915: disallow gem ums init ioctl for kms
>     
>     This ioctl used in a kms driver is only useful to create massive
>     havoc.
> 
> Can't see just why -intel crashes, but I presume it is during the
> i830_free_memory along that path.
> 
> Anyway, looks like that patch needs to be reverted.

Good catch, but now it dies later after screen goes black :

Backtrace:
0: X(xf86SigHandler+0x7e) [0x80d8b5e]
1: [0xffffe400]
2: /usr/lib/xorg/modules/drivers//intel_drv.so(I830Sync+0x4e) [0xb732eefe]
3: /usr/lib/xorg/modules/drivers//intel_drv.so [0xb733d916]
4: X(AbortDDX+0x8d) [0x80a146d]
5: X(AbortServer+0x28) [0x81b3ae8]
6: X(FatalError+0x66) [0x81b4066]
7: /usr/lib/xorg/modules/drivers//intel_drv.so [0xb733e626]
8: /usr/lib/xorg/modules/drivers//intel_drv.so [0xb733f962]
9: X(AddScreen+0x1fc) [0x806d42c]
10: X(InitOutput+0x21e) [0x80a1b7e]
11: X(main+0x296) [0x806dbb6]
12: /lib/libc.so.6(__libc_start_main+0xe0) [0xb7552390]
13: X(FontFileCompleteXLFD+0x20d) [0x806d121]

FatalError re-entered, aborting
Caught signal 11.  Server aborting

I suspect the error handling in this version of intel_drv is incomplete,
resulting in segfaults instead of plain error reporting.

Willy

