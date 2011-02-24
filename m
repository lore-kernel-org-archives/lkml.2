Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab1BXXyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 18:54:14 -0500
Received: from adelie.canonical.com ([91.189.90.139]:58727 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab1BXXyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:54:12 -0500
Date: Thu, 24 Feb 2011 20:54:06 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.38-rc6
Message-ID: <20110224235405.GA1734@herton-IdeaPad-Y430>
References: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
 <20110222140349.GA20708@kryptos.osrc.amd.com>
 <AANLkTikESHHfjBqoLFOno6qQz-NXEAo-wBY5JEeAW61N@mail.gmail.com>
 <AANLkTinh4pF7iaUGMcv_9gPy+VBD5POsTHbF_2zPJ17r@mail.gmail.com>
 <AANLkTi=Ys4mb4pc28cH4NMdtMgb2KewJbkXEGJmEP4J0@mail.gmail.com>
 <AANLkTinxHVDwSCouTaZEvR3yTJnSPAas9z6JauGDdS7=@mail.gmail.com>
 <AANLkTinD2cC9dGg2eBtZQhWvhSsuH2BcWDj8byLhWWso@mail.gmail.com>
 <AANLkTin8+F003-jFoQ0pd9OjN1oT2iqyNjd58SDJZuMK@mail.gmail.com>
 <AANLkTinzse1ZfEvAuWfuZ_8VDypcnD5poU6GwOdYTgWh@mail.gmail.com>
 <20110224172114.GC2630@herton-IdeaPad-Y430>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224172114.GC2630@herton-IdeaPad-Y430>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 02:21:15PM -0300, Herton Ronaldo Krzesinski wrote:
> On Thu, Feb 24, 2011 at 08:37:11AM -0800, Linus Torvalds wrote:
> > On Thu, Feb 24, 2011 at 5:20 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> > >>
> > >> Every boot?
> > >
> > > Yes.
> > >
> > >> And just out of interest, what happens if you don't have the vesafb
> > >> driver at all?
> > >
> > > I used 'e' option from grub, removed the 'set gfxpayload = $linux_gfx_mode'
> > > and it works.
> > >
> > > dmesg: http://pastebin.com/JAZsk4vD
> > 
> > Hmm. So it definitely seems to be the hand-over.
> > 
> > Does this patch make any difference? When we unregister the old
> > framebuffer, we still leave it in the registered_fb[] array, which
> > looks wrong. But it would also be interesting to hear if setting
> > CONFIG_SLUB_DEBUG_ON or CONFIG_DEBUG_PAGEALLOC makes any difference
> > (they'd help detect accesses to free'd data structures).
> 
> Hi Linus,
> 
> I opened a bug about this issue in January, while I was still working
> with Mandriva and got a similar issue reported. Basically it's a race on
> vesafb removal with i915 with modesetting enabled. And indeed you have
> to use slub_debug to always reproduce it, sometimes the use after free
> of struct fb_info not always trigers it. I posted a testcase and a
> proposed patch at https://bugzilla.kernel.org/show_bug.cgi?id=26232

Sorry, I have a correction to this.

What I wrote here is confusing, the problem should happen on any
"firmware" framebuffer which gets replaced by any modesetting
framebuffer, like intelfb or nouveaufb, not only i915 as it can be
understood from what I stated. Just the test case I made and problem
reported was with i915, but same holds for nouveaufb as reported here.

The oops here first is because struct fb_info of vesafb is freed while
plymouthd has fb opened. In fb_open, we assign info to
file->private_data. So if the application opens it, and before it is
closed some framebuffer from drm (intelfb, nouveaufb...) replaces
vesafb, remove_conflicting_framebuffers removes the vesafb. Inside
remove_conflicting_framebuffers we call unregister_framebuffer, which in
the end will call fb_info->fbops->fb_destroy (vesafb_destroy) -> 
framebuffer_release(info) -> kfree(info)

Then if application closes its file descriptor after the drm framebuffer
loaded, it still has the reference of struct fb_info of vesafb in
file->private_data, then we get the oops as it tries to dereference the
info already freed.

But there is also races in this framebuffer removal also while it is
being unregistered, the accesses to registered_fb[] array, so I made the
testcase and attached to the bug report to show them.

> 
> I remember to have posted here on LKML the patch too, but didn't got
> answers to it.
> 
> Andy Whitcroft fixed it too with a similar patch,
> http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-natty.git;a=commit;h=c5a742b5f78e161d6a13853a7e3e6e1dfa429e69
> I CC'd Andy, the author of the patch, he will push his version, looks
> more complete as it takes care of mm_lock in do_mmap too.
> 
> My bug report has also another test case and fix for a inverse locking
> problem, it would be good to take a look too.
> 
> In any case, any of these problems are not recent regressions. The race
> on framebuffer removal at least exists since unregister_framebuffer
> started to be used to remove it while loading framebuffer from modesetting
> drivers.
> 
> > 
> >                           Linus
> 
> >  drivers/video/fbmem.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> > index e2bf953..e8f8925 100644
> > --- a/drivers/video/fbmem.c
> > +++ b/drivers/video/fbmem.c
> > @@ -1511,6 +1511,7 @@ void remove_conflicting_framebuffers(struct apertures_struct *a,
> >  			       "%s vs %s - removing generic driver\n",
> >  			       name, registered_fb[i]->fix.id);
> >  			unregister_framebuffer(registered_fb[i]);
> > +			registered_fb[i] = NULL;
> >  		}
> >  	}
> >  }
> 
> 
> -- 
> []'s
> Herton

-- 
[]'s
Herton
