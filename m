Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1IAHEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 03:04:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15994 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab1IAHE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 03:04:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=YSBZpBgaqweoYipGERDlPd6nK8LFMGphVq0xi7M/y27l4s7IvSUq8j9CCRQ0IP8J7
	kc9UDLJWYknrzo5HFX7sQ==
MIME-Version: 1.0
In-Reply-To: <20110901064034.GC22561@redhat.com>
References: <20110722171540.74eb9aa7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110808124333.GA31739@redhat.com>
	<20110809083345.46cbc8de.kamezawa.hiroyu@jp.fujitsu.com>
	<20110829155113.GA21661@redhat.com>
	<20110830101233.ae416284.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830070424.GA13061@redhat.com>
	<20110830162050.f6c13c0c.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830084245.GC13061@redhat.com>
	<CALWz4iyXbrgcrZEOsgvvW9mu6fr7Qwbn2d1FR_BVw6R_pMZPsQ@mail.gmail.com>
	<20110901064034.GC22561@redhat.com>
Date: Thu, 1 Sep 2011 00:04:24 -0700
Message-ID: <CALWz4iyKXx+q5uKVOFqDs3Xx7ZGOertJ-ZWkwO=Z0Ynr4qsm2A@mail.gmail.com>
Subject: Re: [patch] Revert "memcg: add memory.vmscan_stat"
From: Ying Han <yinghan@google.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 11:40 PM, Johannes Weiner <jweiner@redhat.com> wrote:
> On Wed, Aug 31, 2011 at 11:05:51PM -0700, Ying Han wrote:
>> On Tue, Aug 30, 2011 at 1:42 AM, Johannes Weiner <jweiner@redhat.com> wrote:
>> > You want to look at A and see whether its limit was responsible for
>> > reclaim scans in any children.  IMO, that is asking the question
>> > backwards.  Instead, there is a cgroup under reclaim and one wants to
>> > find out the cause for that.  Not the other way round.
>> >
>> > In my original proposal I suggested differentiating reclaim caused by
>> > internal pressure (due to own limit) and reclaim caused by
>> > external/hierarchical pressure (due to limits from parents).
>> >
>> > If you want to find out why C is under reclaim, look at its reclaim
>> > statistics.  If the _limit numbers are high, C's limit is the problem.
>> > If the _hierarchical numbers are high, the problem is B, A, or
>> > physical memory, so you check B for _limit and _hierarchical as well,
>> > then move on to A.
>> >
>> > Implementing this would be as easy as passing not only the memcg to
>> > scan (victim) to the reclaim code, but also the memcg /causing/ the
>> > reclaim (root_mem):
>> >
>> >        root_mem == victim -> account to victim as _limit
>> >        root_mem != victim -> account to victim as _hierarchical
>> >
>> > This would make things much simpler and more natural, both the code
>> > and the way of tracking down a problem, IMO.
>>
>> This is pretty much the stats I am currently using for debugging the
>> reclaim patches. For example:
>>
>> scanned_pages_by_system 0
>> scanned_pages_by_system_under_hierarchy 50989
>>
>> scanned_pages_by_limit 0
>> scanned_pages_by_limit_under_hierarchy 0
>>
>> "_system" is count under global reclaim, and "_limit" is count under
>> per-memcg reclaim.
>> "_under_hiearchy" is set if memcg is not the one triggering pressure.
>
> I don't get this distinction between _system and _limit.  How is it
> orthogonal to _limit vs. _hierarchy, i.e. internal vs. external?

Something like :

+enum mem_cgroup_scan_context {
+       SCAN_BY_SYSTEM,
+       SCAN_BY_SYSTEM_UNDER_HIERARCHY,
+       SCAN_BY_LIMIT,
+       SCAN_BY_LIMIT_UNDER_HIERARCHY,
+       NR_SCAN_CONTEXT,
+};

if (global_reclaim(sc))
   context = scan_by_system
else
   context = scan_by_limit

if (target != mem)
   context++;

>
> If the system scans memcgs then no limit is at fault.  It's just
> external pressure.
>
> For example, what is the distinction between scanned_pages_by_system
> and scanned_pages_by_system_under_hierarchy?

you are right about this, there is no much difference on these since
it is counting global reclaim and everyone
is under_hierarchy except root_cgroup. For root cgroup, it is counted
in "_system". (internal)

The reason for scanned_pages_by_system would be, per your definition,
neither due to
> the limit (_by_system -> global reclaim) nor not due to the limit
> (!_under_hierarchy -> memcg is the one triggering pressure)

This value "scanned_pages_by_system" only making senses for root
cgroup, which now could be counted as "# of pages scanned in root lru
under global reclaim".

--Ying
