Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab2BROoD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 09:44:03 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62431 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab2BROn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 09:43:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.28.167 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120218133904.GA1678@cmpxchg.org>
References: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
	<20120217182818.f3e7fe28.kamezawa.hiroyu@jp.fujitsu.com>
	<20120218133904.GA1678@cmpxchg.org>
Date: Sat, 18 Feb 2012 22:43:58 +0800
Message-ID: <CAJd=RBD=U1Uy_MnO9wL_Ag6M7tYUOfs=aSXV+sJabHWRNSSudQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] memcg: remove PCG_FILE_MAPPED
From: Hillf Danton <dhillf@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 9:39 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Fri, Feb 17, 2012 at 06:28:18PM +0900, KAMEZAWA Hiroyuki wrote:
>> @@ -2559,7 +2555,7 @@ static int mem_cgroup_move_account(struct page *page,
>>
>>       move_lock_mem_cgroup(from, &flags);
>>
>> -     if (PageCgroupFileMapped(pc)) {
>> +     if (page_mapped(page)) {
>
> As opposed to update_page_stat(), this runs against all types of
> pages, so I think it should be
>
>        if (!PageAnon(page) && page_mapped(page))
>
> instead.
>
Perhaps the following helper or similar needed,
along with page_mapped()

static inline bool page_is_file_mapping(struct page *page)
{
	struct address_space *mapping = page_mapping(page);

	return mapping && mapping != &swapper_space &&
		((unsigned long)mapping & PAGE_MAPPING_FLAGS) == 0;
}

>>               /* Update mapped_file data for mem_cgroup */
>>               preempt_disable();
>>               __this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
