Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1AZReF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:34:05 -0500
Received: from smtp-out.google.com ([74.125.121.67]:57035 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1AZReE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:34:04 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:in-reply-to:message-id:
	user-agent:mime-version:content-type;
	b=Qcw5LWQaZ35dDa2Xms5c1sZckwmrNpERE/u3PEODnMHqUbn50xvmq081mAJG8o2Qg
	WoL8cvS9YKr7EzS/uiXZA==
From: Greg Thelen <gthelen@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: handle overflow in mem_cgroup_out_of_memory()
References: <1296030555-3594-1-git-send-email-gthelen@google.com>
	<20110126170713.GA2401@cmpxchg.org>
Date: Wed, 26 Jan 2011 09:33:09 -0800
In-Reply-To: <20110126170713.GA2401@cmpxchg.org> (Johannes Weiner's message of
	"Wed, 26 Jan 2011 18:07:13 +0100")
Message-ID: <xr93y667lgdm.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> writes:

> On Wed, Jan 26, 2011 at 12:29:15AM -0800, Greg Thelen wrote:
>> mem_cgroup_get_limit() returns a byte limit as a unsigned 64 bit value,
>> which is converted to a page count by mem_cgroup_out_of_memory().  Prior
>> to this patch the conversion could overflow on 32 bit platforms
>> yielding a limit of zero.
>
> Balbir: It can truncate, because the conversion shrinks the required
> bits of this 64-bit number by only PAGE_SHIFT (12).  Trying to store
> the resulting up to 52 significant bits in a 32-bit integer will cut
> up to 20 significant bits off.
>
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>> ---
>>  mm/oom_kill.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 7dcca55..3fcac51 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -538,7 +538,7 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
>>  	struct task_struct *p;
>>  
>>  	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
>> -	limit = mem_cgroup_get_limit(mem) >> PAGE_SHIFT;
>> +	limit = min(mem_cgroup_get_limit(mem) >> PAGE_SHIFT, (u64)ULONG_MAX);
>
> I would much prefer using min_t(u64, ...).  To make it really, really
> explicit that this is 64-bit arithmetic.  But that is just me, no
> correctness issue.
>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

I agree that min_t() is clearer.  Does the following look better?

Author: Greg Thelen <gthelen@google.com>
Date:   Wed Jan 26 00:05:59 2011 -0800

    oom: handle truncation in mem_cgroup_out_of_memory()
    
    mem_cgroup_get_limit() returns a byte limit as an unsigned 64 bit value.
    mem_cgroup_out_of_memory() converts this byte limit to an unsigned long
    page count.  Prior to this patch, the 32 bit version of
    mem_cgroup_out_of_memory() would silently truncate the most significant
    20 bits from byte limit when constructing the limit as a page count.
    For byte limits with the lowest 44 bits set to zero, this truncation
    would compute a page limit of zero.
    
    This patch checks for such large byte limits that cannot be converted to
    page counts without loosing information.  In such situations, where a 32
    bit page counter is too small to represent the corresponding byte count,
    select a maximal page count.
    
    Signed-off-by: Greg Thelen <gthelen@google.com>

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 7dcca55..0164060 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -538,7 +538,7 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
 	struct task_struct *p;
 
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
-	limit = mem_cgroup_get_limit(mem) >> PAGE_SHIFT;
+	limit = min_t(u64, mem_cgroup_get_limit(mem) >> PAGE_SHIFT, ULONG_MAX);
 	read_lock(&tasklist_lock);
 retry:
 	p = select_bad_process(&points, limit, mem, NULL);
