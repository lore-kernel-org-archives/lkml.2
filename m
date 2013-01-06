Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3AFSbg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 13:31:36 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:51965 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab3AFSbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 13:31:34 -0500
MIME-Version: 1.0
In-Reply-To: <50E92DC3.4050906@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
 <1357375071-11793-10-git-send-email-alex.shi@intel.com> <50E7EAB1.6020302@intel.com>
 <50E92DC3.4050906@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 6 Jan 2013 10:31:12 -0800
X-Google-Sender-Auth: S57qJS-P0Rg7VkDI09ekiu58RB0
Message-ID: <CA+55aFxbS-u1Zfwg2oKOmHq6FBF+dRRhrdssqc9PpC_gXoV3+g@mail.gmail.com>
Subject: Re: [PATCH v3 09/22] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
To: Alex Shi <alex.shi@intel.com>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, namhyung@kernel.org,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        preeti@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 5, 2013 at 11:54 PM, Alex Shi <alex.shi@intel.com> wrote:
>
> I just looked into the aim9 benchmark, in this case it forks 2000 tasks,
> after all tasks ready, aim9 give a signal than all tasks burst waking up
> and run until all finished.
> Since each of tasks are finished very quickly, a imbalanced empty cpu
> may goes to sleep till a regular balancing give it some new tasks. That
> causes the performance dropping. cause more idle entering.

Sounds like for AIM (and possibly for other really bursty loads), we
might want to do some load-balancing at wakeup time by *just* looking
at the number of running tasks, rather than at the load average. Hmm?

The load average is fundamentally always going to run behind a bit,
and while you want to use it for long-term balancing, a short-term you
might want to do just a "if we have a huge amount of runnable
processes, do a load balancing *now*". Where "huge amount" should
probably be relative to the long-term load balancing (ie comparing the
number of runnable processes on this CPU right *now* with the load
average over the last second or so would show a clear spike, and a
reason for quick action).

           Linus
