Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2ALJZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:25:34 -0500
Received: from seven.medozas.de ([188.40.89.202]:35921 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab2ALJZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:25:31 -0500
Date: Thu, 12 Jan 2012 10:25:23 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Josh Triplett <josh@joshtriplett.org>
cc: paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com, manfred@colorfullife.com,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: avoid checking for constant
In-Reply-To: <20120112071431.GA1896@leaf>
Message-ID: <alpine.LNX.2.01.1201121018430.31943@frira.zrqbmnf.qr>
References: <1326345104-6919-1-git-send-email-jengelh@medozas.de> <20120112071431.GA1896@leaf>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 2012-01-12 08:14, Josh Triplett wrote:

>On Thu, Jan 12, 2012 at 06:11:44AM +0100, Jan Engelhardt wrote:
>> When compiling kernel or module code with -O0, "offset" is no longer
>> considered a constant, and therefore always triggers the build error
>> that BUILD_BUG_ON is defined to yield.
>[...]
>> --- a/include/linux/rcupdate.h
>> +++ b/include/linux/rcupdate.h
>> @@ -805,8 +805,6 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
>>  {
>>  	typedef void (*rcu_callback)(struct rcu_head *);
>>  
>> -	BUILD_BUG_ON(!__builtin_constant_p(offset));
>> -
>>  	/* See the kfree_rcu() header comment. */
>>  	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
>
>The very next check after the one you removed will break if the
>compiler can't check the offset at compile time.

Thanks for catching that. How about the following approach? :

parent f9fab10bbd768b0e5254e53a4a8477a94bfc4b96 (v3.2-rc7-86-gf9fab10)
commit a4145604f1e40ce93a25a053f0f49341324b0077
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Jan 11 10:05:00 2012 +0100

rcu: avoid checking for constant

When compiling kernel or module code with -O0, "offset" is no longer
considered a constant, and therefore always triggers the build error
that BUILD_BUG_ON is defined to yield.

What is the rationale between the forced constant check,
introduced in 9ab1544eb4196ca8d05c433b2eb56f74496b1ee3?

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/rcupdate.h |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 2cf4226..5e7286d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -795,24 +795,6 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 #define RCU_INIT_POINTER(p, v) \
 		p = (typeof(*v) __force __rcu *)(v)
 
-static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
-{
-	return offset < 4096;
-}
-
-static __always_inline
-void __kfree_rcu(struct rcu_head *head, unsigned long offset)
-{
-	typedef void (*rcu_callback)(struct rcu_head *);
-
-	BUILD_BUG_ON(!__builtin_constant_p(offset));
-
-	/* See the kfree_rcu() header comment. */
-	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
-
-	call_rcu(head, (rcu_callback)offset);
-}
-
 /**
  * kfree_rcu() - kfree an object after a grace period.
  * @ptr:	pointer to kfree
@@ -836,6 +818,10 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
  * Note that the allowable offset might decrease in the future, for example,
  * to allow something like kmem_cache_free_rcu().
  */
+#define __kfree_rcu(head, offset) \
+	call_rcu(head, (void (*)(struct rcu_head *))(unsigned long)(offset) + \
+		 BUILD_BUG_ON_ZERO((offset) >= 4096))
+
 #define kfree_rcu(ptr, rcu_head)					\
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
 
-- 
# Created with git-export-patch
