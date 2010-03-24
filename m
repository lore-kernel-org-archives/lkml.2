Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0CXUyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:54:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab0CXUys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:54:48 -0400
Subject: Re: [RFC,PATCH 2/2] cputimers/proc:
 do_task_stat()->thread_group_times() is racy and O(n) under ->siglock
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100324204554.GA31780@redhat.com>
References: <20100324204554.GA31780@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 21:54:42 +0100
Message-ID: <1269464082.12097.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 21:45 +0100, Oleg Nesterov wrote:
> Nowadays ->siglock is overloaded, it would be really nice to change
> do_task_stat() to walk through the list of threads lockless. And note
> that we are doing while_each_thread() twice!
> 
> while_each_thread() is rcu-safe, but thread_group_times() also needs
> ->siglock to serialize the modifications of signal_struct->prev_Xtime
> members.
> 
> 

Right, so from what I remember the issue is that, yes top et al rely on
that monotonicity, but more importantly I think
clock_gettime(CLOCK_PROCESS_CPUTIME_ID) should indeed use ->siglock to
ensure it serializes against do_exit() so that either we iterate the
thread or get the accumulated runtime from signal_struct but not both
(or neither).



