Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab1FAXwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 19:52:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40796 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1FAXwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 19:52:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F0BI2pgwtQ5HonDo11l9omvsdyjiucBvgIABKcDQEtrN+2q5WHPNk52iAXihhrTAf6
         SgxGnGP+bDc2CmjCdEETp2ov2eD2flux8fmUTui4HxfULSVif1YIKGKNwY840kARVWzj
         I/uHFTh2glc7KRkukfLl1XdfiYxZBfwjEeQUg=
MIME-Version: 1.0
In-Reply-To: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
Date: Thu, 2 Jun 2011 08:52:47 +0900
Message-ID: <BANLkTikgqSsg5+49295h7kdZ=sQpZLs4kw@mail.gmail.com>
Subject: Re: [patch 0/8] mm: memcg naturalization -rc2
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/1 Johannes Weiner <hannes@cmpxchg.org>:
> Hi,
>
> this is the second version of the memcg naturalization series.  The
> notable changes since the first submission are:
>
>    o the hierarchy walk is now intermittent and will abort and
>      remember the last scanned child after sc->nr_to_reclaim pages
>      have been reclaimed during the walk in one zone (Rik)
>
>    o the global lru lists are never scanned when memcg is enabled
>      after #2 'memcg-aware global reclaim', which makes this patch
>      self-sufficient and complete without requiring the per-memcg lru
>      lists to be exclusive (Michal)
>
>    o renamed sc->memcg and sc->current_memcg to sc->target_mem_cgroup
>      and sc->mem_cgroup and fixed their documentation, I hope this is
>      better understandable now (Rik)
>
>    o the reclaim statistic counters have been renamed.  there is no
>      more distinction between 'pgfree' and 'pgsteal', it is now
>      'pgreclaim' in both cases; 'kswapd' has been replaced by
>      'background'
>
>    o fixed a nasty crash in the hierarchical soft limit check that
>      happened during global reclaim in memcgs that are hierarchical
>      but have no hierarchical parents themselves
>
>    o properly implemented the memcg-aware unevictable page rescue
>      scanner, there were several blatant bugs in there
>
>    o documentation on new public interfaces
>
> Thanks for your input on the first version.
>
> I ran microbenchmarks (sparse file catting, essentially) to stress
> reclaim and LRU operations.  There is no measurable overhead for
> !CONFIG_MEMCG, memcg disabled during boot, memcg enabled but no
> configured groups, and hard limit reclaim.
>
> I also ran single-threaded kernbenchs in four unlimited memcgs in
> parallel, contained in a hard-limited hierarchical parent that put
> constant pressure on the workload.  There is no measurable difference
> in runtime, the pgpgin/pgpgout counters, and fairness among memcgs in
> this test compared to an unpatched kernel.  Needs more evaluation,
> especially with a higher number of memcgs.
>
> The soft limit changes are also proven to work in so far that it is
> possible to prioritize between children in a hierarchy under pressure
> and that runtime differences corresponded directly to the soft limit
> settings in the previously described kernbench setup with staggered
> soft limits on the groups, but this needs quantification.
>
> Based on v2.6.39.
>

Hmm, I welcome and will review this patches but.....some points I want to say.

1. No more conflict with Ying's work ?
    Could you explain what she has and what you don't in this v2 ?
    If Ying's one has something good to be merged to your set, please
include it.

2. it's required to see performance score in commit log.

3. I think dirty_ratio as 1st big patch to be merged. (But...hmm..Greg ?
    My patches for asynchronous reclaim is not very important. I can rework it.

4. This work can be splitted into some small works.
     a) fix for current code and clean ups
     a') statistics
     b) soft limit rework
     c) change global reclaim

  I like (a)->(b)->(c) order. and while (b) you can merge your work
with Ying's one.
  And for a') , I'd like to add a new file memory.reclaim_stat as I've
already shown.
  and allow resetting.

  Hmm, how about splitting patch 2/8 into small patches and see what happens in
  3.2 or 3.3 ? While that, we can make softlimit works better.
  (and once we do 2/8, our direction will be fixed to the direction to
remove global LRU.)

5. please write documentation to explain what new LRU do.

BTW, after this work, lists of ROOT cgroup comes again. I may need to check
codes which see memcg is ROOT or not. Because we removed many atomic
ops in memcg, I wonder ROOT cgroup can be accounted again..

Thanks,
-Kame
