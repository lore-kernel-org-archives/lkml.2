Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1BDPtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 10:49:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab1BDPtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 10:49:07 -0500
Date: Fri, 4 Feb 2011 16:48:00 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: =?utf-8?Q?Jind=C5=99ich_Makovi=C4=8Dka?= <makovick@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: khugepaged: gets stuck when writing to USB flash, 2.6.38-rc2
Message-ID: <20110204154800.GB30909@random.random>
References: <AANLkTi=uOpN0PwWdGh6iri-vJwuMS+WMPxmaZjv0-TrV@mail.gmail.com>
 <20110201154947.GX16981@random.random>
 <20110203132407.GF11958@csn.ul.ie>
 <20110203190612.GL5843@random.random>
 <AANLkTimRE-=vB=oTFmc64fqJKHUTUT=3X_Gzx78PZ7Xu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimRE-=vB=oTFmc64fqJKHUTUT=3X_Gzx78PZ7Xu@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 10:16:17PM +0100, Jindřich Makovička wrote:
> On Thu, Feb 3, 2011 at 20:06, Andrea Arcangeli <aarcange@redhat.com> wrote:
> > On Thu, Feb 03, 2011 at 01:24:08PM +0000, Mel Gorman wrote:
> >> This is very likely. Compaction calls into migration which will wait on
> >> dirty pages after a time. With a large number of dirty pages backed by a
> >> slow drive such as a USB stick, it could be getting stalled there for a
> >> long period of time.
> >>
> >> Whether migration sleeps or not can be controlled by the sync parameter
> >> passed into try_to_compact_memory which could be always forced to false
> >> if GFP_NO_KSWAPD?
> >
> > I would expect that to hide any regression we could have because of
> > more dirty cache in the system, yes.
> >
> > However Jindřich reported not being able to reproduce anything anymore
> > in -rc3, so I'm unsure if we should make that change anymore. I asked
> > to try again cause it should too easy that got fixed magically
> 
> I tried again and reproduced with -rc3 too, sorry for misinformation.
> 
> I also tried echo never >  /sys/kernel/mm/transparent_hugepage/defrag
> , and it seems preventing the system freeze, but still the copying
> itself sometimes comes to almost complete stop (GkrellM shows short
> spikes of tens of kB/s on the USB /dev/sdX). In this case, khugepaged
> is also in DN. I still didn't observe this problem when disabling THP
> completely by echo never > enabled .

Ok then you may need this too:

 echo never > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag

Compaction is likely too heavy so we need to look into that.
