Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab1EMJK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:10:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53786 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab1EMJK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:10:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 13 May 2011 18:04:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Weiner <jweiner@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Greg Thelen <gthelen@google.com>
Subject: Re: [RFC][PATCH 0/7] memcg async reclaim
Message-Id: <20110513180409.7feea2f9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTinFesh5cpdk16dWygoWJeH8QU0hTw@mail.gmail.com>
References: <20110510190216.f4eefef7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110511182844.d128c995.akpm@linux-foundation.org>
	<20110512103503.717f4a96.kamezawa.hiroyu@jp.fujitsu.com>
	<20110511205110.354fa05e.akpm@linux-foundation.org>
	<20110512132237.813a7c7f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110512171725.d367980f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110513120318.63ff7d0e.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTinFesh5cpdk16dWygoWJeH8QU0hTw@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 22:10:30 -0700
Ying Han <yinghan@google.com> wrote:

> On Thu, May 12, 2011 at 8:03 PM, KAMEZAWA Hiroyuki <
> kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Thu, 12 May 2011 17:17:25 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > > On Thu, 12 May 2011 13:22:37 +0900
> > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > I'll check what codes in vmscan.c or /mm affects memcg and post a
> > > required fix in step by step. I think I found some..
> > >
> >
> > After some tests, I doubt that 'automatic' one is unnecessary until
> > memcg's dirty_ratio is supported. And as Andrew pointed out,
> > total cpu consumption is unchanged and I don't have workloads which
> > shows me meaningful speed up.
> >
> 
> The total cpu consumption is one way to measure the background reclaim,
> another thing I would like to measure is a histogram of page fault latency
> for a heavy page allocation application. I would expect with background
> reclaim, we will get less variation on the page fault latency than w/o it.
> 
> Sorry i haven't got chance to run some tests to back it up. I will try to
> get some data.
> 

My posted set needs some tweaks and fixes. I'll post re-tuned one in the
next week. (But I'll be busy until Wednesday.)

> 
> > But I guess...with dirty_ratio, amount of dirty pages in memcg is
> > limited and background reclaim can work enough without noise of
> > write_page() while applications are throttled by dirty_ratio.
> >
> 
> Definitely. I have run into the issue while debugging the soft_limit
> reclaim. The background reclaim became very inefficient if we have dirty
> pages greater than the soft_limit. Talking w/ Greg about it regarding his
> per-memcg dirty page limit effort, we should consider setting the dirty
> ratio which not allowing the dirty pages greater the reclaim watermarks
> (here is the soft_limit).
> 

I think I got some positive result...in some situation.

On 8cpu, 24GB RAM system, under 300MB memcg, run 2 programs
  Program 1)  while true; do cat ./test/1G > /dev/null;done
              This fills memcg with clean file cache.
  Program 2)  malloc(200MB) and page-fault, free it in 200 times.

And measure Program2's time.

Case 1) running only Program2

real    0m17.086s
user    0m0.057s
sys     0m17.257s


Case 2) running Program 1 and 2 without async reclaim.

[kamezawa@bluextal test]$ time ./catch_and_release  > /dev/null

real    0m26.182s
user    0m0.115s
sys     0m19.075s
[kamezawa@bluextal test]$ time ./catch_and_release  > /dev/null

real    0m23.155s
user    0m0.096s
sys     0m18.175s
[kamezawa@bluextal test]$ time ./catch_and_release  > /dev/null

real    0m24.667s
user    0m0.108s
sys     0m18.804s


Case 3) running Program 1 and 2 with async reclaim of 8MB to limit.


[kamezawa@bluextal test]$ time ./catch_and_release  > /dev/null

real    0m21.438s
user    0m0.083s
sys     0m17.864s
[kamezawa@bluextal test]$ time ./catch_and_release  > /dev/null

real    0m23.010s
user    0m0.079s
sys     0m17.819s
[kamezawa@bluextal test]$ time ./catch_and_release  > /dev/null

real    0m19.596s
user    0m0.108s
sys     0m18.053s


If my test is correct, there are some meaningful positive effect.
But I doubt there may be case with negative result case. 

I wonder to see posivie value, application shouldn't do 'write' ;)
Anyway, I'll make a try in the next week, again.

Thanks,
-Kame






