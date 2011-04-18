Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1DRNeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:34:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36836 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1DRNeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:34:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pcr8NLqgEUV7oy69D5NSiUpei/x159BXm3xztUNOt7vOO377voaKdzPCzFxgEphl2M
         T5QNUhQmde8DwlZk5oVYoR6hb6k2ODYkqNqNWKIOJcHgZCQujGumcN3IcHP+AsTVaX4J
         uw9K67ab+GD4bd1XekdcQWOQI0eT+YOM9VxS4=
Date: Mon, 18 Apr 2011 21:34:05 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 3/7] lockdep: Annotate read/write states
Message-ID: <20110418133405.GA2080@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110417094505.865828233@chello.nl>
 <20110417095507.026186002@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110417095507.026186002@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 11:45:08AM +0200, Peter Zijlstra wrote:
> From: Gautham R Shenoy <ego@in.ibm.com>
> 
> Currently we do not save the recursive read dependencies in the dependency
> chain. As a result, a deadlock caused by the following chains are not spotted,
> since we never have the chain 1 in our dependency list:
> 
>  1: Rlock(A) --> lock(B)
>  2: lock(B)  --> Wlock(A), where A is a recursive read lock.
> 
> Before adding the Recursive Read locks to the dependency chains, we need to
> distinguish them from the normal read locks since the conflicting states for
> these two are quite different.
> 
> Currently the read/write status of a lock while it's acquired is denoted by a
> monotonically increasing variable where:
> 
>  0 - WRITE
>  1 - READ
>  2 - RECURSIVE READ
> 
> In this patch, we propose to modify this distinction from a monotonically
> increasing variable to a bit mask where:
> 
>  0x1 - WRITE
>  0x2 - READ
>  0x4 - RECURSIVE READ
> 
> This helps us to define the conflicting states for each lock with ease:
> Thereby, the conflicting states for a given states are defined as follows:
> 
>  Conflicting_states(WRITE):             RECURSIVE_READ | READ | WRITE
>  Conflicting_states(READ):                               READ | WRITE
>  Conflicting_states(RECURSIVE_READ):                            WRITE
> 
> Also, we use one more bit in the bitmask to distinguish the first recursive
> read in the current chain from the others, since it is sufficient to add only
> this dependency to the dependency list.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/lockdep.h |  107 ++++++++++++++++++++++++++++++++++++------------
>  kernel/lockdep.c        |   46 ++++++++++----------
>  2 files changed, 105 insertions(+), 48 deletions(-)
> 
> @@ -2273,7 +2273,7 @@ mark_held_locks(struct task_struct *curr
>  		hlock = curr->held_locks + i;
>  
>  		usage_bit = 2 + (mark << 2); /* ENABLED */
> -		if (hlock->read)
> +		if (hlock->rw_state)

		is_read(hlock->rw_state) ?

