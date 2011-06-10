Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab1FJMYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:24:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39832 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab1FJMYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p17Ie7rUksrNfjcbqFf+IqVBGAgR63ykykY6N9WaDOGqTeON4sCEZitQO8j9bx9xkO
         2fY40gDCOB9oLMiXwZU/fAYSOWJU7gplDPNdozoBoZ9z2+Qa0XgCMZmUGFjPzBFd712t
         SUEhqUV9Q08EwXuLKHWEcTbBH4n2jC6+YjfKU=
MIME-Version: 1.0
In-Reply-To: <20110610110412.GE4110@tiehlicka.suse.cz>
References: <20110609093045.1f969d30.kamezawa.hiroyu@jp.fujitsu.com>
	<20110610081218.GC4832@tiehlicka.suse.cz>
	<20110610173958.d9ab901c.kamezawa.hiroyu@jp.fujitsu.com>
	<20110610090802.GB4110@tiehlicka.suse.cz>
	<20110610185952.a07b968f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110610110412.GE4110@tiehlicka.suse.cz>
Date: Fri, 10 Jun 2011 21:24:51 +0900
Message-ID: <BANLkTingsPiS81KEkOb6+eKdz=2UMUHmQg@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH v3] memcg: fix behavior of per cpu charge cache draining.
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/10 Michal Hocko <mhocko@suse.cz>:
> On Fri 10-06-11 18:59:52, KAMEZAWA Hiroyuki wrote:
>> On Fri, 10 Jun 2011 11:08:02 +0200
>> Michal Hocko <mhocko@suse.cz> wrote:
>>
>> > On Fri 10-06-11 17:39:58, KAMEZAWA Hiroyuki wrote:
>> > > On Fri, 10 Jun 2011 10:12:19 +0200
>> > > Michal Hocko <mhocko@suse.cz> wrote:
>> > >
>> > > > On Thu 09-06-11 09:30:45, KAMEZAWA Hiroyuki wrote:
>> > [...]
>> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> > > > > index bd9052a..3baddcb 100644
>> > > > > --- a/mm/memcontrol.c
>> > > > > +++ b/mm/memcontrol.c
>> > > > [...]
>> > > > >  static struct mem_cgroup_per_zone *
>> > > > >  mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
>> > > > > @@ -1670,8 +1670,6 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
>> > > > >               victim = mem_cgroup_select_victim(root_mem);
>> > > > >               if (victim == root_mem) {
>> > > > >                       loop++;
>> > > > > -                     if (loop >= 1)
>> > > > > -                             drain_all_stock_async();
>> > > > >                       if (loop >= 2) {
>> > > > >                               /*
>> > > > >                                * If we have not been able to reclaim
>> > > > > @@ -1723,6 +1721,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
>> > > > >                               return total;
>> > > > >               } else if (mem_cgroup_margin(root_mem))
>> > > > >                       return total;
>> > > > > +             drain_all_stock_async(root_mem);
>> > > > >       }
>> > > > >       return total;
>> > > > >  }
>> > > >
>> > > > I still think that we pointlessly reclaim even though we could have a
>> > > > lot of pages pre-charged in the cache (the more CPUs we have the more
>> > > > significant this might be).
>> > >
>> > > The more CPUs, the more scan cost for each per-cpu memory, which makes
>> > > cache-miss.
>> > >
>> > > I know placement of drain_all_stock_async() is not big problem on my host,
>> > > which has 2socket/8core cpus. But, assuming 1000+ cpu host,
>> >
>> > Hmm, it really depends what you want to optimize for. Reclaim path is
>> > already slow path and cache misses, while not good, are not the most
>> > significant issue, I guess.
>> > What I would see as a much bigger problem is that there might be a lot
>> > of memory pre-charged at those per-cpu caches. Falling into a reclaim
>> > costs us much more IMO and we can evict something that could be useful
>> > for no good reason.
>> >
>>
>> It's waste of time to talk this kind of things without the numbers.
>>
>> ok, I don't change the caller's logic. Discuss this when someone gets
>> number of LARGE smp box.
>
> Sounds reasonable.
>
> [..,]
>> please test/ack if ok.
>
> see comment bellow.
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
>
> [...]
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index bd9052a..75713cb 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -359,7 +359,7 @@ enum charge_type {
>>  static void mem_cgroup_get(struct mem_cgroup *mem);
>>  static void mem_cgroup_put(struct mem_cgroup *mem);
>>  static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
>> -static void drain_all_stock_async(void);
>> +static void drain_all_stock_async(struct mem_cgroup *mem);
>>
>>  static struct mem_cgroup_per_zone *
>>  mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
>> @@ -1670,8 +1670,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
>>               victim = mem_cgroup_select_victim(root_mem);
>>               if (victim == root_mem) {
>>                       loop++;
>> -                     if (loop >= 1)
>> -                             drain_all_stock_async();
>> +                     drain_all_stock_async(root_mem);
>>                       if (loop >= 2) {
>>                               /*
>>                                * If we have not been able to reclaim
>
> This still doesn't prevent from direct reclaim even though we have freed
> enough pages from pcp caches. Should I post it as a separate patch?
>

yes. please in different thread. Maybe moving this out of loop will
make sense. (And I have a cleanup patch for this loop. I'll do that
when I post it later, anyway)

Thanks,
-Kame
