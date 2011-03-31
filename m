Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1CaDo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 23:44:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905Ab1CaDoz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 23:44:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110331033432.GA434@redhat.com>
References: <20110329040939.GA32764@redhat.com> <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com> <20110331033432.GA434@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 20:44:06 -0700
Message-ID: <AANLkTimPi-Vbi3DNLEeShCpfOJEuUZo3--3CQ_BMgJiS@mail.gmail.com>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 8:34 PM, Dave Jones <davej@redhat.com> wrote:
>
> so 'perf kmem record sleep 5' shows hundreds of calls kmem_cache_free from
> the kworker processes. Called from shmem_i_callback, __d_free and file_free_rcu.
> My guess is that my fuzzing caused so many allocations that the rcu freeing is
> still ongoing an hour or so after the process has quit.  does that make any sense?

No, that shouldn't be the case. RCU freeing should go on for just a
few RCU periods, and be done. I think there is some "limit the work we
do for rcu each time" in order to not have bad latencies, but even so
that shouldn't take _that_ long. And as you say, you should see the
freeing in the slab stats.

So clearly there are shmem inodes being destroyed, but it shouldn't be
from an hour ago. I wonder if your system isn't as idle as you think
it is.

But I'm cc'ing Paul, maybe he'll disagree and say it's expected and
that the RCU batch size is really small. Or at least give some hint
about how to check the pending rcu state.

                       Linus
