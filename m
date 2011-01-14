Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab1ANMZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 07:25:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44597 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1ANMY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 07:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JmKruqn3bu1hHjAzAEPs2EOXoAGLTMCumhKf2zQrP0yoDuZ/CemS1kVaOX1B7tZ4P9
         ARkwDuK1J/i6EesTCf7Wbm5BKKZc041twkQOwfZcSlsu7bWxZo8NkSHXvwuTgMb3MDe2
         msPEtCC5VyemKqQnizPKiNiwumKOD6hoO7twk=
MIME-Version: 1.0
In-Reply-To: <20110114121342.GQ23189@cmpxchg.org>
References: <20110114190412.73362cd7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110114191042.dd145d22.kamezawa.hiroyu@jp.fujitsu.com>
	<20110114121342.GQ23189@cmpxchg.org>
Date: Fri, 14 Jan 2011 21:24:57 +0900
Message-ID: <AANLkTim8VLaXYH2HWYULBUP7vBb-FEJh4U=Zi-u2bMwX@mail.gmail.com>
Subject: Re: [PATCH 3/4] [BUGFIX] fix memcgroup LRU stat with THP
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Greg Thelen <gthelen@google.com>, aarcange@redhat.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/14 Johannes Weiner <hannes@cmpxchg.org>:
> On Fri, Jan 14, 2011 at 07:10:42PM +0900, KAMEZAWA Hiroyuki wrote:
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> memroy cgroup's LRU stat should take care of size of pages because
>> Transparent Hugepage inserts hugepage into LRU and zone counter
>> is updeted based on the size of page.
>>
>> If this value is the number wrong, memory reclaim will not work well.
>>
>> Note: only head page of THP's huge page is linked into LRU.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>  mm/memcontrol.c |   10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> Index: mmotm-0107/mm/memcontrol.c
>> ===================================================================
>> --- mmotm-0107.orig/mm/memcontrol.c
>> +++ mmotm-0107/mm/memcontrol.c
>> @@ -815,7 +815,10 @@ void mem_cgroup_del_lru_list(struct page
>>        * removed from global LRU.
>>        */
>>       mz = page_cgroup_zoneinfo(pc);
>> -     MEM_CGROUP_ZSTAT(mz, lru) -= 1;
>> +     if (!PageTransHuge(page))
>> +             MEM_CGROUP_ZSTAT(mz, lru) -= 1;
>> +     else
>> +             MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
>
> compound_order() returns 0 for !PG_head pages, that should do the
> right thing without checking PageTransHuge(), right?

You're right. Then, I can remove this 'if'. Thank you.
Hmm, I'll check other places, again.

Regards,
-Kame
