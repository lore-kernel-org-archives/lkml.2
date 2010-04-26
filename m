Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab0DZJcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 05:32:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51519 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0DZJcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 05:32:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Apr 2010 18:28:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX][mm][PATCH] fix migration race in rmap_walk
Message-Id: <20100426182838.2cab9844.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100426084901.15c09a29.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100423120148.9ffa5881.kamezawa.hiroyu@jp.fujitsu.com>
	<20100423095922.GJ30306@csn.ul.ie>
	<20100423155801.GA14351@csn.ul.ie>
	<20100424110200.b491ec5f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100424104324.GD14351@csn.ul.ie>
	<20100426084901.15c09a29.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010 08:49:01 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Sat, 24 Apr 2010 11:43:24 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:

> > It looks nice but it still broke after 28 hours of running. The
> > seq-counter is still insufficient to catch all changes that are made to
> > the list. I'm beginning to wonder if a) this really can be fully safely
> > locked with the anon_vma changes and b) if it has to be a spinlock to
> > catch the majority of cases but still a lazy cleanup if there happens to
> > be a race. It's unsatisfactory and I'm expecting I'll either have some
> > insight to the new anon_vma changes that allow it to be locked or Rik
> > knows how to restore the original behaviour which as Andrea pointed out
> > was safe.
> > 
> Ouch. 

Ok, reproduced. Here is status in my test + printk().

 * A race doesn't seem to happen if swap=off. 
    I need to swapon to cause the bug.
 * Before unmap, mapcount=1, SwapCache for anonymous memory.
   old page's flag was SWAPCACHE, Active, Uptodate, Referenced, Locked.
 * After remap, mapcount=0, return code=0.
   new page's flag after remap was SwapCache, Active, Dirty, Uptodate, Referenced.

(Hmm, dirty bit can be added by try_to_unamp().)

-Kame



