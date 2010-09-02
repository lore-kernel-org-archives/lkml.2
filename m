Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab0IBT6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:58:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43638 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab0IBT6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:58:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
Date: Thu, 2 Sep 2010 21:57:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "M. Vefa Bicakci" <bicave@superonline.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org
References: <20100901093219.9744.A69D9226@jp.fujitsu.com> <201009020002.25113.rjw@sisk.pl> <20100902091010.D050.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100902091010.D050.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009022157.18561.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 02, 2010, KOSAKI Motohiro wrote:
> > On Wednesday, September 01, 2010, KOSAKI Motohiro wrote:
> > > > === 8< ===
> > > > PM: Marking nosave pages: ...0009f000 - ...000100000
> > > > PM: basic memory bitmaps created
> > > > PM: Syncing filesystems ... done
> > > > Freezing user space processes ... (elapsed 0.01 seconds) done.
> > > > Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> > > > PM: Preallocating image memory...
> > > > shrink_all_memory start
> > > > PM: shrink memory: pass=1, req:310171 reclaimed:15492 free:360936
> > > > PM: shrink memory: pass=2, req:294679 reclaimed:28864 free:373981
> > > > PM: shrink memory: pass=3, req:265815 reclaimed:60311 free:405374
> > > > PM: shrink memory: pass=4, req:205504 reclaimed:97870 free:443024
> > > > PM: shrink memory: pass=5, req:107634 reclaimed:146948 free:492141
> > > > shrink_all_memory: req:107634 reclaimed:146948 free:492141
> > > > PM: preallocate_image_highmem 556658 278329
> > > > PM: preallocate_image_memory 103139 103139
> > > > PM: preallocate_highmem_fraction 183908 556658 760831 -> 183908
> > > > === >8 ===
> > > 
> > > Rafael, this log mean hibernate_preallocate_memory() has a bug.
> > 
> > Well, it works as designed ...
> > 
> > > It allocate memory as following order.
> > >  1. preallocate_image_highmem()  (i.e. __GFP_HIGHMEM)
> > >  2. preallocate_image_memory()   (i.e. GFP_KERNEL)
> > >  3. preallocate_highmem_fraction (i.e. __GFP_HIGHMEM)
> > >  4. preallocate_image_memory()   (i.e. GFP_KERNEL)
> > > 
> > > But, please imazine following scenario (as Vefa's scenario).
> > >  - system has 3GB memory. 1GB is normal. 2GB is highmem.
> > >  - all normal memory is free
> > >  - 1.5GB memory of highmem are used for tmpfs. rest 500MB is free.
> > 
> > Indeed, that's a memory allocation pattern I didn't anticipate.
> > 
> > > At that time, hibernate_preallocate_memory() works as following.
> > > 
> > > 1. call preallocate_image_highmem(1GB)
> > > 2. call preallocate_image_memory(500M)		total 1.5GB allocated
> > > 3. call preallocate_highmem_fraction(660M)	total 2.2GB allocated
> > > 
> > > then, all of normal zone memory was exhaust. next preallocate_image_memory()
> > > makes OOM, and oom_killer_disabled makes infinite loop.
> > > (oom_killer_disabled careless is vmscan bug. I'll fix it soon)
> > 
> > So, it looks like the problem will go away if we check if there are any normal
> > pages to allocate from before calling the last preallocate_image_memory()?
> > 
> > Like in the patch below, perhaps?
> 
> Looks like fine. but I have one question. hibernate_preallocate_memory() call
> preallocate_image_memory() two times. Why do you only care latter one?
> former one seems similar risk.

The first one is mandatory, ie. if we can't allocate the requested number of
pages at this point, we fail the entire hibernation.  In that case the
performance hit doesn't matter.

Thanks,
Rafael
