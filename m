Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3AHR4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:56:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49883 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab3AHR4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:56:03 -0500
MIME-Version: 1.0
Message-ID: <9b035d90-b6de-43cf-a188-7b3d32ed09f2@default>
Date: Tue, 8 Jan 2013 09:54:49 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCHv2 8/9] zswap: add to mm/
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1357590280-31535-9-git-send-email-sjenning@linux.vnet.ibm.com>
 <50EC541B.5000905@linux.vnet.ibm.com>
In-Reply-To: <50EC541B.5000905@linux.vnet.ibm.com>
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
> Sent: Tuesday, January 08, 2013 10:15 AM
> To: Seth Jennings
> Cc: Greg Kroah-Hartman; Andrew Morton; Nitin Gupta; Minchan Kim; Konrad Rzeszutek Wilk; Dan
> Magenheimer; Robert Jennings; Jenifer Hopper; Mel Gorman; Johannes Weiner; Rik van Riel; Larry
> Woodman; linux-mm@kvack.org; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org
> Subject: Re: [PATCHv2 8/9] zswap: add to mm/
> 
> On 01/07/2013 12:24 PM, Seth Jennings wrote:
> > +struct zswap_tree {
> > +	struct rb_root rbroot;
> > +	struct list_head lru;
> > +	spinlock_t lock;
> > +	struct zs_pool *pool;
> > +};
> 
> BTW, I spent some time trying to get this lock contended.  You thought
> the anon_vma locks would dominate and this spinlock would not end up
> very contended.
> 
> I figured that if I hit zswap from a bunch of CPUs that _didn't_ use
> anonymous memory (and thus the anon_vma locks) that some more contention
> would pop up.  I did that with a bunch of CPUs writing to tmpfs, and
> this lock was still well down below anon_vma.  The anon_vma contention
> was obviously coming from _other_ anonymous memory around.
> 
> IOW, I feel a bit better about this lock.  I only tested on 16 cores on
> a system with relatively light NUMA characteristics, and it might be the
> bottleneck if all the anonymous memory on the system is mlock()'d and
> you're pounding on tmpfs, but that's pretty contrived.

IIUC, Seth's current "flush" code only gets called when in the context
of a frontswap_store and is very limited in what it does, whereas the
goal will be for flushing to run both as an independent thread and do
more complex things (e.g. so that wholepages can be reclaimed rather
than random zpages).

So it will be interesting to re-test contention when zswap is complete.

Dan
