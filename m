Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2CMCu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 22:50:26 -0400
Received: from ozlabs.org ([203.10.76.45]:57813 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab2CMCuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 22:50:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] module: use rcu to protect module list read
In-Reply-To: <1331393157.2453.15.camel@edumazet-laptop>
References: <1331389203-3309-1-git-send-email-xiyou.wangcong@gmail.com> <1331393157.2453.15.camel@edumazet-laptop>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 13 Mar 2012 11:07:58 +1030
Message-ID: <87k42pz66x.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2012 07:25:57 -0800, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le samedi 10 mars 2012 à 22:20 +0800, Cong Wang a écrit :
> > Now the read of module list is protected by preempt disable + *_rcu
> > list operations, this is odd, as RCU read lock should be able to
> > protect it directly. This patch makes the read of module list
> > protected by RCU read lock and the write still protected by
> > module_mutex.
> > 
> 
> Problem is that your patch does more than that.
> 
> In set_all_modules_text_rw() and set_all_modules_text_ro() you removed
> the mutex in favor of rcu_read_lock()
> 
> Also, module code uses synchronize_sched(), not synchronize_rcu()

Yes, but only for paranoia.  Really, it's vs. stop_machine().

> Take a look at Documentation/RCU/whatisRCU.txt and see that
> preempt_disable() / preempt_enable() are documented as a right protect
> code, in line 333.
> 
> You added races in /proc/modules as well.

I'm surprised that patch didn't warn... CONFIG_DEBUG_ATOMIC_SLEEP=y
might help here....

Cheers,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
