Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1BFP1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 10:27:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:8717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab1BFP1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 10:27:34 -0500
Message-Id: <849307$bf0dak@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,433,1291622400"; 
   d="scan'208";a="384841044"
Date: Sun, 06 Feb 2011 15:27:23 +0000
To: Jeff Chua <jeff.chua.linux@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com> <s5hfws1whq8.wl%tiwai@suse.de> <AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com> <AANLkTikE_Oa=HGhW3zpc_rdeBvOWckpZ6dfFWq=JnL9R@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTikE_Oa=HGhW3zpc_rdeBvOWckpZ6dfFWq=JnL9R@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Feb 2011 22:49:38 +0800, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Sun, Feb 6, 2011 at 10:01 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > On Sun, Feb 6, 2011 at 7:00 PM, Takashi Iwai <tiwai@suse.de> wrote:
> >> At Sun, 6 Feb 2011 09:50:51 +0800,
> >> Jeff Chua wrote:
> >>>
> >>> On Sun, Feb 6, 2011 at 2:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>> >> The suspend monster is back! The suspend-to-ram is fine, but upon
> >>> >> resume, screen is blank. Haven't bisected in case someone has also
> >>> >> done so.
> >
> >> Hrm, what is the symptom?  I couldn't find it because you cut off the
> >> thread, and it's not cited.
> >
> > Takashi-san,
> >
> > It's the commit below. I've checked it twice. Reverting it solves the
> > problem. Suspend to Ram ok. Upon resume, screen is blank. Keyboard
> > hangs. Had to do a hard reset.
> 
> > The commit you mentioned just adds an interface, and the the callbacks
> > aren't defined.  The real change is either in
> >  commit f3269058e7a80083dcdf89698bfcd1a6c6f8fd12
> >    drm/i915/crt: Force the initial probe after reset
> > or
> >  commit 5d1d0cc87fc0887921993ea0742932e0c8adeda0
> >    drm/i915: Reset crtc after resume
> 
> uh, Sorry, misread your original post. I've retest it, and it's the 2nd one.
> 
> commit 5d1d0cc87fc0887921993ea0742932e0c8adeda0
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Mon Jan 24 15:02:15 2011 +0000
> 
>     drm/i915: Reset crtc after resume
> 
>     Based on a patch by Takashi Iwai.
> 
> 
> I wasn't really doing a bisect last night. Just reverting those
> patches that seems to be the problem last night. Just arrived in Tokyo
> last night. Long flight, too tired to do the bisect. By luck, the
> commit I reverted worked, but you caught me!
> 
> This time. it down to the root cause!

One last step: move contents of intel_crtc_reset() back to
intel_crtc_init() one by one.

The active flag is my suspicion. I was thinking that we brought up the
outputs in a similar manner upon resume as upon initial boot. On
reflection, this is the not case.

However, the first action we take inside modesetting is to disable the
outputs about to be reconfigured. So setting active should be the right
course of action so that cleanup any residual state from resume.

So I am intrigued as to which line is the cause, and just where the
machine becomes unresponsive...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
