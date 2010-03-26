Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab0CZICR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 04:02:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab0CZICO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 04:02:14 -0400
Date: Fri, 26 Mar 2010 08:59:24 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] cputimers/proc:
	do_task_stat()->thread_group_times() is racy and O(n) under
	->siglock
Message-ID: <20100326075923.GB2596@dhcp-lab-161.englab.brq.redhat.com>
References: <20100324204554.GA31780@redhat.com> <1269464082.12097.3.camel@laptop> <20100325121250.GA3664@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325121250.GA3664@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 01:12:50PM +0100, Oleg Nesterov wrote:
> > but more importantly I think
> > clock_gettime(CLOCK_PROCESS_CPUTIME_ID) should indeed use ->siglock to
> > ensure it serializes against do_exit() so that either we iterate the
> > thread or get the accumulated runtime from signal_struct but not both
> > (or neither).
> 
> Oh. I forgot everything I knew about posix-cpu-timers... But, it seems,
> posix_cpu_clock_get() calls thread_group_cputime() under tasklist and
> thus can't race with exit.

We assure thread_group_cputime() is called with one of: tasklist_lock
or ->siglock to avoid races with __exit_signal. Except oom killer and
elf core-dump code where is no lock, where we assume exit is not called
or we don't care of inaccurate results.

Stanislaw
