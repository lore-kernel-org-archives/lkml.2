Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab0IBFuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 01:50:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46883 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0IBFuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 01:50:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 2 Sep 2010 14:45:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Subject: Re: [PATCH] Make is_mem_section_removable more conformable with
 offlining code
Message-Id: <20100902144500.a0d05b08.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100901124138.GD6663@tiehlicka.suse.cz>
References: <20100820141400.GD4636@tiehlicka.suse.cz>
	<20100822004232.GA11007@localhost>
	<20100823092246.GA25772@tiehlicka.suse.cz>
	<20100831141942.GA30353@localhost>
	<20100901121951.GC6663@tiehlicka.suse.cz>
	<20100901124138.GD6663@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010 14:41:38 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Wed 01-09-10 14:19:51, Michal Hocko wrote:
> > On Tue 31-08-10 22:19:42, Wu Fengguang wrote:
> > > On Mon, Aug 23, 2010 at 05:22:46PM +0800, Michal Hocko wrote:
> > > > On Sun 22-08-10 08:42:32, Wu Fengguang wrote:
> > > > > Hi Michal,
> > > > 
> > > > Hi,
> > > > 
> > > > > 
> > > > > It helps to explain in changelog/code
> > > > > 
> > > > > - in what situation a ZONE_MOVABLE will contain !MIGRATE_MOVABLE
> > > > >   pages? 
> > > > 
> > > > page can be MIGRATE_RESERVE IIUC.
> > > 
> > > Yup, it may also be set to MIGRATE_ISOLATE by soft_offline_page().
> > 
> > Doesn't it make sense to check for !MIGRATE_UNMOVABLE then?
> 
> Something like the following patch.
> 
> 
> From de85f1aa42115678d3340f0448cd798577036496 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Fri, 20 Aug 2010 15:39:16 +0200
> Subject: [PATCH] Make is_mem_section_removable more conformable with offlining code
> 
> Currently is_mem_section_removable checks whether each pageblock from
> the given pfn range is of MIGRATE_MOVABLE type or if it is free. If both
> are false then the range is considered non removable.
> 
> On the other hand, offlining code (more specifically
> set_migratetype_isolate) doesn't care whether a page is free and instead
> it just checks the migrate type of the page and whether the page's zone
> is movable.
> 
> This can lead into a situation when we can mark a node as not removable
> just because a pageblock is MIGRATE_RESERVE and it is not free.
> 
> Let's make a common helper is_page_removable which unifies both tests
> at one place. Also let's check for MIGRATE_UNMOVABLE rather than all
> possible MIGRATEable types.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Hmm..Why MIGRATE_RECLAIMABLE is included ?

If MIGRATE_RCLAIMABLE is included, set_migrate_type() should check the
range of pages. Because it makes the pageblock as MIGRAGE_MOVABLE after
failure of memory hotplug.

Original code checks.

 - the range is MIGRAGE_MOVABLE or
 - the range includes only free pages and LRU pages.

Then, moving them back to MIGRAGE_MOVABLE after failure was correct.
Doesn't this makes changes MIGRATE_RECALIMABLE to be MIGRATE_MOVABLE and
leads us to more fragmentated situation ?

Thanks,
-Kame


