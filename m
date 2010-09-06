Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab0IFBAm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 21:00:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35820 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab0IFBAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 21:00:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 3/4] writeback: nr_dirtied and nr_cleaned in /proc/vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
In-Reply-To: <20100905141715.GA9024@localhost>
References: <20100831074825.GA19358@localhost> <20100905141715.GA9024@localhost>
Message-Id: <20100906095414.C8BE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  6 Sep 2010 10:00:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Aug 31, 2010 at 03:48:25PM +0800, Wu Fengguang wrote:
> > > > The output format is quite different from /proc/vmstat.
> > > > Do we really need to "Node X", ":" and "times" decorations?
> > > 
> > > Node X is based on the meminfo file but I agree it's redundant information.
> > 
> > Thanks. In the same directory you can find a different style example
> > /sys/devices/system/node/node0/numastat :) If ever the file was named
> > vmstat! In the other hand, shall we put the numbers there? I'm confused..
> 
> With wider use of NUMA, I'm expecting more interests to put
> /proc/vmstat items into /sys/devices/system/node/node0/.

I prefer to create /sys/devices/system/node/node0/zones/zone-DMA32/vmstat
because the VM is managing pages as per-zones.
but /sys/devices/system/node/node0/vmstat is also useful.


> 
> What shall we do then? There are several possible options:
> - just put the /proc/vmstat items into nodeX/numastat
> - create nodeX/vmstat and make numastat a symlink to vmstat
> - create nodeX/vmstat and remove numastat in future
> 
> Any suggestions?


I like 3rd option :)
In addition, I doubt we really need to remove numastat. It's not
so harmful.



> 
> > > > And the "_PAGES" in NR_FILE_PAGES_DIRTIED looks redundant to
> > > > the "_page" in node_page_state(). It's a bit long to be a pleasant
> > > > name. NR_FILE_DIRTIED/NR_CLEANED looks nicer.
> > > 
> > > Yeah. Will fix.
> > 
> > Thanks. This is kind of nitpick, however here is another name by
> > Jan Kara: BDI_WRITTEN. BDI_WRITTEN may not be a lot better than
> > BDI_CLEANED, but here is a patch based on Jan's code. I'm cooking
> > more patches that make use of this per-bdi counter to estimate the
> > bdi's write bandwidth, and to further decide the optimal (large)
> > writeback chunk size as well as to do IO-less balance_dirty_pages().
> > 
> > Basically BDI_WRITTEN and NR_CLEANED are accounting for the same
> > thing in different dimensions. So it would be good if we can use
> > the same naming scheme to avoid confusing users: either to use
> > BDI_WRITTEN and NR_WRITTEN, or use BDI_CLEANED and NR_CLEANED.
> > What's your opinion?
> 
> I tend to prefer *_WRITTEN now.
> - *_WRITTEN reminds the users about IO, *_CLEANED is less so obvious.
> - *_CLEANED seems to be paired with NR_DIRTIED, this could be
>   misleading to the users. The fact is, dirty pages may either be
>   written to disk, or dropped (by truncate).

Umm...
If my understanding is correct, Michael really need *_CLEANED because
he want to compare NR_DIRTIED and *_CLEANED. That said, we need to
change counter implementation itself instead a name?



