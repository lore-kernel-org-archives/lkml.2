Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab1EQGiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 02:38:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:7236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab1EQGiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 02:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XNYska4ZChxkPfrIphC/889+v6uyK627fJ5l5yY3lZhunPNa4guLM2fcVJe659JjDv
         7TdtazlpaRxFrK+fHW8Q==
MIME-Version: 1.0
In-Reply-To: <20110512160349.GJ16531@cmpxchg.org>
References: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org>
	<1305212038-15445-3-git-send-email-hannes@cmpxchg.org>
	<4DCBFDB9.10209@redhat.com>
	<20110512160349.GJ16531@cmpxchg.org>
Date: Mon, 16 May 2011 23:38:07 -0700
Message-ID: <BANLkTi=+hVKx6bkowgiiatPGwSy0m3=2uQ@mail.gmail.com>
Subject: Re: [rfc patch 2/6] vmscan: make distinction between memcg reclaim
 and LRU list selection
From: Ying Han <yinghan@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 9:03 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Thu, May 12, 2011 at 11:33:13AM -0400, Rik van Riel wrote:
>> On 05/12/2011 10:53 AM, Johannes Weiner wrote:
>> >The reclaim code has a single predicate for whether it currently
>> >reclaims on behalf of a memory cgroup, as well as whether it is
>> >reclaiming from the global LRU list or a memory cgroup LRU list.
>> >
>> >Up to now, both cases always coincide, but subsequent patches will
>> >change things such that global reclaim will scan memory cgroup lists.
>> >
>> >This patch adds a new predicate that tells global reclaim from memory
>> >cgroup reclaim, and then changes all callsites that are actually about
>> >global reclaim heuristics rather than strict LRU list selection.
>> >
>> >Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>
>> >---
>> >  mm/vmscan.c |   96 ++++++++++++++++++++++++++++++++++------------------------
>> >  1 files changed, 56 insertions(+), 40 deletions(-)
>> >
>> >diff --git a/mm/vmscan.c b/mm/vmscan.c
>> >index f6b435c..ceeb2a5 100644
>> >--- a/mm/vmscan.c
>> >+++ b/mm/vmscan.c
>> >@@ -104,8 +104,12 @@ struct scan_control {
>> >      */
>> >     reclaim_mode_t reclaim_mode;
>> >
>> >-    /* Which cgroup do we reclaim from */
>> >-    struct mem_cgroup *mem_cgroup;
>> >+    /*
>> >+     * The memory cgroup we reclaim on behalf of, and the one we
>> >+     * are currently reclaiming from.
>> >+     */
>> >+    struct mem_cgroup *memcg;
>> >+    struct mem_cgroup *current_memcg;
>>
>> I can't say I'm fond of these names.  I had to read the
>> rest of the patch to figure out that the old mem_cgroup
>> got renamed to current_memcg.
>
> To clarify: sc->memcg will be the memcg that hit the hard limit and is
> the main target of this reclaim invocation.  current_memcg is the
> iterator over the hierarchy below the target.

I would assume the new variable memcg is a renaming of the
"mem_cgroup" which indicating which cgroup we reclaim on behalf of.
About the "current_memcg", i couldn't find where it is indicating to
be the current cgroup under the hierarchy below the "memcg".

Both mem_cgroup_shrink_node_zone() and try_to_free_mem_cgroup_pages()
are called within mem_cgroup_hierarchical_reclaim(), and the sc->memcg
is initialized w/ the victim passed down which is already the memcg
under hierarchy.

--Ying


> I realize this change in particular was placed a bit unfortunate in
> terms of understanding in the series, I just wanted to keep out the
> mem_cgroup to current_memcg renaming out of the next patch.  There is
> probably a better way, I'll fix it up and improve the comment.
>
>> Would it be better to call them my_memcg and reclaim_memcg?
>>
>> Maybe somebody else has better suggestions...
>
> Yes, suggestions welcome.  I'm not too fond of the naming, either.
>
>> Other than the naming, no objection.
>
> Thanks, Rik.
>
>        Hannes
>
