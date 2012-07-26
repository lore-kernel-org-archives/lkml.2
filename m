Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab2GZBiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 21:38:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15208 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2GZBiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 21:38:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6783"; a="212239912"
X-IronPort-AV: E=Sophos;i="4.77,656,1336374000"; 
   d="scan'208";a="121870262"
Message-ID: <50109F78.4040409@quicinc.com>
Date: Wed, 25 Jul 2012 18:38:00 -0700
From: Stephen Boyd <sboyd@quicinc.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] vsprintf: Fix %ps on non symbols when using kallsyms
References: <1335217525-30709-1-git-send-email-sboyd@codeaurora.org> <20120423145545.e7c41906.akpm@linux-foundation.org>
In-Reply-To: <20120423145545.e7c41906.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 4/23/2012 2:55 PM, Andrew Morton wrote:
> On Mon, 23 Apr 2012 14:45:24 -0700
> Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> Using %ps in a printk format will sometimes fail silently and
>> print the empty string if the address passed in does not match a
>> symbol that kallsyms knows about.

A coworker pointed out that the second patch in this series now prints
the symbol closest to the address passed in if kallsyms sees the address
is between two symbols. So if I have a pointer to some member of a
structure %ps prints the symbol for the containing structure, which is
not really helpful.

For example

struct test {
  int i;
  int j;
} my_test;

printk("%ps\n", &my_test.j)


would print out "my_test" instead of "0xc4523400".

This is especially bad for the spinlock debugging case where there could
be two locks embedded in some static structure. I think it would be a
good idea to apply this patch so we get a good middle ground by printing
the name and the offset. Or we can revert the patch and I'll add more
info by printing lockdep information about the lock.

-----8<------

From: Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH] spinlock_debug: Print offset in addition to symbol name

If there are two spinlocks embedded in a structure that kallsyms
knows about and one of the spinlocks locks up we will print the
name of the containing structure instead of the address of the
lock. This is quite bad, so let's use %pS instead of %ps so we
get an offset in addition to the symbol so we can determine which
particular lock is having problems.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 lib/spinlock_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index e91fbc2..eb10578 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -58,7 +58,7 @@ static void spin_dump(raw_spinlock_t *lock, const char *msg)
 	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
 		msg, raw_smp_processor_id(),
 		current->comm, task_pid_nr(current));
-	printk(KERN_EMERG " lock: %ps, .magic: %08x, .owner: %s/%d, "
+	printk(KERN_EMERG " lock: %pS, .magic: %08x, .owner: %s/%d, "
 			".owner_cpu: %d\n",
 		lock, lock->magic,
 		owner ? owner->comm : "<none>",

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

