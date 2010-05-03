Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab0ECWvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:51:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6913 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab0ECWvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:51:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent:x-system-of-record;
	b=T4vMo506rJ+aUpQu+yyguTBvc3B38ILZjT0jXgH2Qzik/9OdVo2xD/4AEHMZkfDxW
	WhR5Db+GQsgu/JcPZJKjQ==
Date: Mon, 3 May 2010 15:51:05 -0700
From: Michel Lespinasse <walken@google.com>
To: David Howells <dhowells@redhat.com>, Andrew Morton <akpm@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: x86 rwsem: up_read() does not check active count in fast path
Message-ID: <20100503225105.GA18897@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looking at the x86 rwsem code, I have been wondering about the up_read() path.
__rwsem_do_wake() comment mentions that one should check the active count on
the way there; however I could not find that check when coming from up_read().

If there are multiple read locks active on a given semaphore, and there is
a write lock queued, each read lock will go:
__up_read
-> notice sem value is <0
-> rwsem_wake
-> take spinlock
-> add 1 in __rwsem_do_wake
-> notice there were other active lockers
-> substract 1 again under 'undo'
-> release spinlock

This could be avoided by adding a check for the active count in __up_write(),
as in the following untested patch:

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 606ede1..915941f 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -200,11 +200,18 @@ static inline void __up_read(struct rw_semaphore *sem)
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
 		     "  jns        1f\n\t"
+#ifdef CONFIG_X86_64
+		     "  dec        %%edx\n\t" /* %edx = low 32 bits of %1 */
+#else
+		     "  dec        %1\n\t"
+		     "  and        %4,%1\n\t"
+#endif
+		     "  jnz        1f\n\t"
 		     "  call call_rwsem_wake\n"
 		     "1:\n"
 		     "# ending __up_read\n"
 		     : "+m" (sem->count), "=d" (tmp)
-		     : "a" (sem), "1" (tmp)
+		     : "a" (sem), "1" (tmp), "i" (RWSEM_ACTIVE_MASK)
 		     : "memory", "cc");
 }
 
Is there any reason not to do this ? I have to mention I don't have any
specific workload in mind that might benefit from this; I'm only sending this
because the code contradicts the __rwsem_do_wake() comment.

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
