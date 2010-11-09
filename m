Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab0KIDwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:52:45 -0500
Received: from smtp-out.google.com ([74.125.121.35]:54626 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0KIDwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:52:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wCQ7osoKbLOs+9qYwq3Oo6oK+3SyP5tdwc8knWz6SG1ldQBAccGXkN691Xp6sJeHt1
         5t6wbl35akf5gzNdlSeA==
MIME-Version: 1.0
In-Reply-To: <20101109124426.312f9979.nishimura@mxp.nes.nec.co.jp>
References: <1289265320-7025-1-git-send-email-gthelen@google.com> <20101109124426.312f9979.nishimura@mxp.nes.nec.co.jp>
From: Greg Thelen <gthelen@google.com>
Date: Mon, 8 Nov 2010 19:52:20 -0800
Message-ID: <AANLkTi=7sKC_911w7NPtsX_uQ20EapC3QjMrU9Y5iA8N@mail.gmail.com>
Subject: Re: [PATCH] memcg: avoid overflow in memcg_hierarchical_free_pages()
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 7:44 PM, Daisuke Nishimura
<nishimura@mxp.nes.nec.co.jp> wrote:
> On Mon,  8 Nov 2010 17:15:20 -0800
> Greg Thelen <gthelen@google.com> wrote:
>
>> Use page counts rather than byte counts to avoid overflowing
>> unsigned long local variables.
>>
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>> ---
>>  mm/memcontrol.c |   10 +++++-----
>>  1 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 6c7115d..b287afd 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1345,17 +1345,17 @@ memcg_hierarchical_free_pages(struct mem_cgroup *mem)
>>  {
>>       unsigned long free, min_free;
>>
> hmm, the default value of RES_LIMIT is LLONG_MAX, so I think we must declare
> "free" as unsinged long long to avoid overflow.

Agreed.  I am testing a fix for that issue now.  I do not want
complicate this patch with the RES_LIMIT issue you mention.  The fix
will be in a separate patch.

> Thanks,
> Daisuke Nishimura.
>
>> -     min_free = global_page_state(NR_FREE_PAGES) << PAGE_SHIFT;
>> +     min_free = global_page_state(NR_FREE_PAGES);
>>
>>       while (mem) {
>> -             free = res_counter_read_u64(&mem->res, RES_LIMIT) -
>> -                     res_counter_read_u64(&mem->res, RES_USAGE);
>> +             free = (res_counter_read_u64(&mem->res, RES_LIMIT) -
>> +                     res_counter_read_u64(&mem->res, RES_USAGE)) >>
>> +                     PAGE_SHIFT;
>>               min_free = min(min_free, free);
>>               mem = parent_mem_cgroup(mem);
>>       }
>>
>> -     /* Translate free memory in pages */
>> -     return min_free >> PAGE_SHIFT;
>> +     return min_free;
>>  }
>>
>>  /*
>> --
>> 1.7.3.1
>>
>
