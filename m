Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0G1Oqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:46:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab0G1Oqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:46:39 -0400
Date: Wed, 28 Jul 2010 16:46:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
Message-ID: <20100728144627.GB6391@jolsa.Belkin>
References: <18537.1280318862@redhat.com>
 <AANLkTikB9Msot4m_oaw+V+dvEg+SzyXHb0cqhKQqUtC2@mail.gmail.com>
 <20100727155023.GF1967@jolsa.brq.redhat.com>
 <AANLkTineVrcffFWGxQ+EzYno6xvcNS9=M7hn_KddASnQ@mail.gmail.com>
 <24865.1280249187@redhat.com>
 <19398.1280323047@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19398.1280323047@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 02:17:27PM +0100, David Howells wrote:
> 
> The attached patch should suffice to fix get_task_cred(), and should render
> Jiri's patch unnecessary.
> 
> David
> ---
> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] CRED: Move get_task_cred() out of line and make it use atomic_inc_not_zero()
> 
> It's possible for get_task_cred() as it currently stands to 'corrupt' a set of
> credentials by incrementing their usage count after their replacement by the
> task being accessed.
> 
> What happens is that get_task_cred() engages the RCU read lock, accesses the cred
> 
> 
> 	TASK_1			TASK_2			RCU_CLEANER
> 	-->get_task_cred(TASK_2)
> 	rcu_read_lock()
> 	__cred = __task_cred(TASK_2)
> 				-->commit_creds()
> 				old_cred = TASK_2->real_cred
> 				TASK_2->real_cred = ...
> 				put_cred(old_cred)
> 				  call_rcu(old_cred)
> 		[__cred->usage == 0]
> 	get_cred(__cred)
> 		[__cred->usage == 1]
> 	rcu_read_unlock()
> 							-->put_cred_rcu()
> 							[__cred->usage == 1]
> 							panic()
> 
> However, since a tasks credentials are generally not changed very often, we can
> reasonably make use of a loop involving reading the creds pointer and using
> atomic_inc_not_zero() to attempt to increment it if it hasn't already hit zero.
> 
> If successful, we can safely return the credentials in the knowledge that, even
> if the task we're accessing has released them, they haven't gone to the RCU
> cleanup code.

looks ok, I changed the task_state to use this and I'm running the
bug reproducer... so far so good ;)

wbr,
jirka
