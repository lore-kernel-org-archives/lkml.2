Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab0DQCiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 22:38:06 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:58219 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758574Ab0DQCiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 22:38:04 -0400
Date: Sat, 17 Apr 2010 12:37:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] vmscan: simplify shrink_inactive_list()
Message-ID: <20100417023752.GG2493@dastard>
References: <20100415085420.GT2493@dastard>
 <20100415185310.D1A1.A69D9226@jp.fujitsu.com>
 <20100415192140.D1A4.A69D9226@jp.fujitsu.com>
 <20100415131532.GD10966@csn.ul.ie>
 <87tyrc92un.fsf@basil.nowhere.org>
 <20100415154442.GG10966@csn.ul.ie>
 <20100415165416.GV18855@one.firstfloor.org>
 <20100415234013.GX2493@dastard>
 <20100416145706.GK19264@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416145706.GK19264@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 03:57:07PM +0100, Mel Gorman wrote:
> On Fri, Apr 16, 2010 at 09:40:13AM +1000, Dave Chinner wrote:
> > On Thu, Apr 15, 2010 at 06:54:16PM +0200, Andi Kleen wrote:
> > > > It's a buying-time venture, I'll agree but as both approaches are only
> > > > about reducing stack stack they wouldn't be long-term solutions by your
> > > > criteria. What do you suggest?
> > > 
> > > (from easy to more complicated):
> > > 
> > > - Disable direct reclaim with 4K stacks
> > 
> > Just to re-iterate: we're blowing the stack with direct reclaim on
> > x86_64  w/ 8k stacks. 
> 
> Yep, that is not being disputed. By the way, what did you use to
> generate your report? Was it CONFIG_DEBUG_STACK_USAGE or something else?
> I used a modified bloat-o-meter to gather my data but it'd be nice to
> be sure I'm seeing the same things as you (minus XFS unless I
> specifically set it up).

I'm using the tracing subsystem to get them. Doesn't everyone use
that now? ;)

$ grep STACK .config
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_STACKTRACE=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_STACK_TRACER=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set

Then:

# echo 1 > /proc/sys/kernel/stack_tracer_enabled

<run workloads>

Monitor the worst recorded stack usage as it changes via:

# cat /sys/kernel/debug/tracing/stack_trace
        Depth    Size   Location    (44 entries)
        -----    ----   --------
  0)     5584     288   get_page_from_freelist+0x5c0/0x830
  1)     5296     272   __alloc_pages_nodemask+0x102/0x730
  2)     5024      48   kmem_getpages+0x62/0x160
  3)     4976      96   cache_grow+0x308/0x330
  4)     4880      96   cache_alloc_refill+0x27f/0x2c0
  5)     4784      96   __kmalloc+0x241/0x250
  6)     4688     112   vring_add_buf+0x233/0x420
......


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
