Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2BWHuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 02:50:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58130 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab2BWHut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 02:50:49 -0500
Date: Thu, 23 Feb 2012 08:50:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES
 interrupts to an idle CPU -v1
Message-ID: <20120223075027.GB15306@elte.hu>
References: <1329957415-15239-1-git-send-email-venki@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329957415-15239-1-git-send-email-venki@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venkatesh Pallipadi <venki@google.com> wrote:

> * Do we need some accounting for these wakeups exported for powertop?

If then tracepoints.

> * We can also eliminate TS_POLLING flag in favor of this. But, that will have
>   a lot more touchpoints and better done as a standlone change.

Should most definitely be done for this series to be acceptble - 
as a preparatory patch in the series, with the feature at the 
end of the series.

> +DECLARE_PER_CPU(atomic_t *, idle_task_ti_flags);

That's ugly, we should access the idle task's ti flags directly.

To have efficient percpu access to the idle threads another 
clean-up is needed: we should turn idle_thread_array into a 
full-structure PER_CPU area.

For that we need a small variant of fork_idle(), which does not 
dup the init thread - pretty trivial.

fork_idle() should also make sure it does not schedule the child 
thread: thus we'd also be able to further simplify smpboot.c and 
get rid of all that extremely ugly 'struct create_idle' 
gymnastics in smpboot.c.

Thanks,

	Ingo
