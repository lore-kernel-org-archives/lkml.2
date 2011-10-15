Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1JOWck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 18:32:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6680 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab1JOWcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 18:32:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=jYqLk37RMXEPjhMrSakuvQRTGC5uqB+7wxVkOwmOGKGVKSTROFwGaJcu/WtTm199G
	Jqn/rh6HDDS//J+T0ECLQ==
Date: Sat, 15 Oct 2011 15:32:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Borislav Petkov <bp@alien8.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Tejun Heo <tj@kernel.org>, Tejun Heo <htejun@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
In-Reply-To: <20111015222324.GA16432@liondog.tnic>
Message-ID: <alpine.DEB.2.00.1110151529570.25063@chino.kir.corp.google.com>
References: <20111015201239.GA3475@swordfish> <alpine.DEB.2.00.1110151436420.15894@chino.kir.corp.google.com> <20111015222324.GA16432@liondog.tnic>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Oct 2011, Borislav Petkov wrote:

> > I think this is a problem with lockdep itself, could you try reverting 
> > f59de8992aa6 ("lockdep: Clear whole lockdep_map on initialization") if 
> > this reliably happens everytime you reboot (lockdep will only emit this 
> > once and then will suppress future warnings until the next boot)?
> > 
> > I think the new memset() is inadvertently clearing the name for 
> > double_unlock_balance().
> 
> Great,
> 
> so I'm not the only one seeing the above:
> http://marc.info/?l=linux-kernel&m=131468805610527
> 
> Due to it being very hard to reproduce, we dismissed it then as a
> possible hw corruption.
> 
> But yeah, it looks like I have triggered it on -rc9 too, just the
> other day. Oh, and I see -rc6 and -rc8 warnings in the logs too. Ok,
> correction, not that hard to trigger.
> 

Could you try to revert f59de8992aa6 ("lockdep: Clear whole lockdep_map on 
initialization") with this patch and see if it helps?  Thanks.
---
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2874,7 +2874,10 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		      struct lock_class_key *key, int subclass)
 {
-	memset(lock, 0, sizeof(*lock));
+	int i;
+
+	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
+		lock->class_cache[i] = NULL;
 
 #ifdef CONFIG_LOCK_STAT
 	lock->cpu = raw_smp_processor_id();
