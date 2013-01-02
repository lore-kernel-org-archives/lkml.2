Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3ABTFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 14:05:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40812 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3ABTFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 14:05:37 -0500
MIME-Version: 1.0
Message-ID: <9955b9e0-731b-4cbf-9db0-683fcd32f944@default>
Date: Wed, 2 Jan 2013 11:04:24 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCH 7/8] zswap: add to mm/
References: <<1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com>>
 <<1355262966-15281-8-git-send-email-sjenning@linux.vnet.ibm.com>>
 <0e91c1e5-7a62-4b89-9473-09fff384a334@default>
 <50E32255.60901@linux.vnet.ibm.com> <50E4588E.6080001@linux.vnet.ibm.com>
 <28a63847-7659-44c4-9c33-87f5d50b2ea0@default>
 <50E479AD.9030502@linux.vnet.ibm.com>
In-Reply-To: <50E479AD.9030502@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dave Hansen [mailto:dave@linux.vnet.ibm.com]
> Subject: Re: [PATCH 7/8] zswap: add to mm/

Hi Dave --

I suspect we are in violent agreement but just to make sure...

Although zswap is the current example, I guess I am discussing
a bigger issue, which IMHO is much more important:  How should
compression be utilized in the kernel (if at all)?  Zswap is
simply one implementation of in-kernel compression (handling
anonymous pages only) and zcache is another (handling both
anonymous pages and pagecache pages).   Each has some
limited policy, and policy defaults built-in, but neither IMHO
is adequately aware of (let alone integrated with) MM policy to
be useful to a broad set of end users and to be enabled by default
by generic distros.
 
> On 01/02/2013 09:26 AM, Dan Magenheimer wrote:
> > However if one compares the total percentage
> > of RAM used for zpages by zswap vs the total percentage of RAM
> > used by slab, I suspect that the zswap number will dominate,
> > perhaps because zswap is storing primarily data and slab is
> > storing primarily metadata?
> 
> That's *obviously* 100% dependent on how you configure zswap.  But, that
> said, most of _my_ systems tend to sit with about 5% of memory in
> reclaimable slab 

The 5% "sitting" number for slab is somewhat interesting, but
IMHO irrelevant here. The really interesting value is what percent
is used by slab when the system is under high memory pressure; I'd
imagine that number would be much smaller.  True?

> which is certainly on par with how I'd expect to see
> zswap used.

You are suggesting that the default zswap_max_pool_percent
should be set to 5?  (Current default is 20.)  Zswap has little
or no value on a system that would otherwise never swap.
Why would you set the zswap limit so low?  IMHO, even 20
may be too low.

> > I don't claim to be any kind of expert here, but I'd imagine
> > that MM doesn't try to manage the total amount of slab space
> > because slab is "a cost of doing business".  However, for
> > in-kernel compression to be widely useful, IMHO it will be
> > critical for MM to somehow load balance between total pageframes
> > used for compressed pages vs total pageframes used for
> > normal pages, just as today it needs to balance between
> > active and inactive pages.
> 
> The issue isn't about balancing.  It's about reclaim where the VM only
> cares about whole pages.  If our subsystem (zwhatever or slab) is only
> designed to reclaim _parts_ of pages, can we be successful in returning
> whole pages to the VM?

IMHO, it's about *both* balancing _and_ reclaim.  One remaining
major point of debate between zcache and zswap is that zcache
accepts lower density to ensure that whole pages can be easily
returned to the VM (and thus allow balancing) while zswap targets
best density (by using zsmalloc) and doesn't address returning
whole pages to the VM.

> The slab shrinkers only work on parts of pages (singular slab objects).
>  Yet, it does appear that they function well enough when we try to
> reclaim from them.  I've never seen a slab's sizes spiral out of control
> due to fragmentation.

Perhaps this is because the reclaimable slab objects are mostly
metadata which is highly connected to reclaimable data objects?
E.g. reclaiming most reclaimable data pages also coincidentally
reclaims most slab objects?

(Also, it is not the slab size that would be the issue here but
its density... i.e. if, after shrinking, 1000 pageframes contain
only 2000 various 4-byt objects, that would be "out of control".
Is there any easy visibility into slab density?)

In any case, I would posit that both the nature of zpages and their
average size relative to a whole page is quite unusual compared to slab.
So while there may be some useful comparisons between zswap
and slab, the differences may warrant dramatically different policy.
