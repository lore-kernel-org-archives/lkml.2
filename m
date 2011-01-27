Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1A0Aal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:30:41 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34802 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab1A0Aaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:30:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 Jan 2011 09:24:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: handle overflow in mem_cgroup_out_of_memory()
Message-Id: <20110127092434.df18c7a6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110126142909.0b710a0c.akpm@linux-foundation.org>
References: <1296030555-3594-1-git-send-email-gthelen@google.com>
	<20110126170713.GA2401@cmpxchg.org>
	<xr93y667lgdm.fsf@gthelen.mtv.corp.google.com>
	<20110126183023.GB2401@cmpxchg.org>
	<xr9362tbl83f.fsf@gthelen.mtv.corp.google.com>
	<20110126142909.0b710a0c.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 14:29:09 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 26 Jan 2011 12:32:04 -0800
> Greg Thelen <gthelen@google.com> wrote:
> 
> > > That being said, does this have any practical impact at all?  I mean,
> > > this code runs when the cgroup limit is breached.  But if the number
> > > of allowed pages (not bytes!) can not fit into 32 bits, it means you
> > > have a group of processes using more than 16T.  On a 32-bit machine.
> > 
> > The value of this patch is up for debate.  I do not have an example
> > situation where this truncation causes the wrong thing to happen.  I
> > suppose it might be possible for a racing update to
> > memory.limit_in_bytes which grows the limit from a reasonable (example:
> > 100M) limit to a large limit (example 1<<45) could benefit from this
> > patch.  I admit that this case seems pathological and may not be likely
> > or even worth bothering over.  If neither the memcg nor the oom
> > maintainers want the patch, then feel free to drop it.  I just noticed
> > the issue and thought it might be worth addressing.
> 
> Ah.  I was scratching my head over that.
> 
> In zillions of places the kernel assumes that a 32-bit kernel has less
> than 2^32 pages of memory, so the code as it stands is, umm, idiomatic.
> 

I think we can assume that. 

> But afaict the only way the patch makes a real-world difference is if
> res_counter_read_u64() is busted?
> 
> And, as you point out, res_counter_read_u64() is indeed busted on
> 32-bit machines.  It has 25 callsites in mm/memcontrol.c - has anyone
> looked at the implications of this?  What happens in all those
> callsites if the counter is read during a count rollover?
> 

I'll review. Against the roll-over, I think we just need to take lock.
So, res_counter_read_u64() implementation was wrong. It should take lock.
Please give me time.


THanks,
-Kame




