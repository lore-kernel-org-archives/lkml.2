Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab2JSTx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:53:27 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:7250 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab2JSTxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:53:25 -0400
Message-ID: <1350676398.1169.6.camel@MikesLinux.fc.hp.com>
Subject: Re: [PATCH] mm: memmap_init_zone() performance improvement
From: Mike Yoknis <mike.yoknis@hp.com>
Reply-To: mike.yoknis@hp.com
To: Mel Gorman <mgorman@suse.de>
Cc: mingo@redhat.com, akpm@linux-foundation.org, linux-arch@vger.kernel.org,
        mmarek@suse.cz, tglx@linutronix.de, hpa@zytor.com, arnd@arndb.de,
        sam@ravnborg.org, minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        mhocko@suse.cz, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 19 Oct 2012 13:53:18 -0600
In-Reply-To: <1349794597.29752.10.camel@MikesLinux.fc.hp.com>
References: <1349276174-8398-1-git-send-email-mike.yoknis@hp.com>
	 <20121008151656.GM29125@suse.de>
	 <1349794597.29752.10.camel@MikesLinux.fc.hp.com>
Organization: Hewlett-Packard
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 08:56 -0600, Mike Yoknis wrote:
> On Mon, 2012-10-08 at 16:16 +0100, Mel Gorman wrote:
> > On Wed, Oct 03, 2012 at 08:56:14AM -0600, Mike Yoknis wrote:
> > > memmap_init_zone() loops through every Page Frame Number (pfn),
> > > including pfn values that are within the gaps between existing
> > > memory sections.  The unneeded looping will become a boot
> > > performance issue when machines configure larger memory ranges
> > > that will contain larger and more numerous gaps.
> > > 
> > > The code will skip across invalid sections to reduce the
> > > number of loops executed.
> > > 
> > > Signed-off-by: Mike Yoknis <mike.yoknis@hp.com>
> > 
> > I do not see the need for
> > the additional complexity unless you can show it makes a big difference
> > to boot times.
> > 
> 
> Mel,
> 
> Let me pass along the numbers I have.  We have what we call an
> "architectural simulator".  It is a computer program that pretends that
> it is a computer system.  We use it to test the firmware before real
> hardware is available.  We have booted Linux on our simulator.  As you
> would expect it takes longer to boot on the simulator than it does on
> real hardware.
> 
> With my patch - boot time 41 minutes
> Without patch - boot time 94 minutes
> 
> These numbers do not scale linearly to real hardware.  But indicate to
> me a place where Linux can be improved.
> 
> Mike Yoknis
> 
Mel,
I finally got access to prototype hardware.  
It is a relatively small machine with only 64GB of RAM.
 
I put in a time measurement by reading the TSC register.
I booted both with and without my patch -
 
Without patch -
[    0.000000]   Normal zone: 13400064 pages, LIFO batch:31
[    0.000000] memmap_init_zone() enter 1404184834218
[    0.000000] memmap_init_zone() exit  1411174884438  diff = 6990050220
 
With patch -
[    0.000000]   Normal zone: 13400064 pages, LIFO batch:31
[    0.000000] memmap_init_zone() enter 1555530050778
[    0.000000] memmap_init_zone() exit  1559379204643  diff = 3849153865
 
This shows that without the patch the routine spends 45% 
of its time spinning unnecessarily.
 
Mike Yoknis


