Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab0ICBJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:09:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44619 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab0ICBJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:09:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
Date: Fri, 3 Sep 2010 03:07:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "M. Vefa Bicakci" <bicave@superonline.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
References: <201009022157.18561.rjw@sisk.pl> <201009022224.59313.rjw@sisk.pl> <20100903085756.B657.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100903085756.B657.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009030307.34057.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 03, 2010, KOSAKI Motohiro wrote:
> Hello,
> 
> > > > > Like in the patch below, perhaps?
> > > > 
> > > > Looks like fine. but I have one question. hibernate_preallocate_memory() call
> > > > preallocate_image_memory() two times. Why do you only care latter one?
> > > > former one seems similar risk.
> > > 
> > > The first one is mandatory, ie. if we can't allocate the requested number of
> > > pages at this point, we fail the entire hibernation.  In that case the
> > > performance hit doesn't matter.
> > 
> > IOW, your patch at http://lkml.org/lkml/2010/9/2/262 is still necessary to
> > protect against the infinite loop in that case.
> 
> As far as I understand, we need distinguish two allocation failure.
>   1) failure because no enough memory
> 	-> yes, hibernation should fail
>  2) failure because already allocated enough lower zone memory
> 	-> why should we fail?
> 
> If the system has a lot of memory, scenario (2) is happen frequently than (1).
> I think we need check alloc_highmem and alloc_normal variable and call
> preallocate_image_highmem() again instead preallocate_image_memory()
> if we've alread allocated enough lots normal memory.
> 
> nit?

Actually I thought about that, but we don't really see hibernation fail for
this reason.  In all of the tests I carried out the requested 50% of highmem
had been allocated before allocations from the normal zone started to be
made, even if highmem was 100% full at that point.  So this appears to be
a theoretical issue and covering it would require us to change the algorithm
entirely (eg. it doesn't make sense to call preallocate_highmem_fraction() down
the road if that happens).

Thanks,
Rafael
