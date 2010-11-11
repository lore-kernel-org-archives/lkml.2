Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab0KKV6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:58:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:35243 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258Ab0KKV62 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:58:28 -0500
Subject: Re: [RFC][PATCH 17/22] sched: add signaling overrunning -deadline
 tasks.
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288334428.8661.158.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334428.8661.158.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 22:58:21 +0100
Message-ID: <1289512701.2084.197.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:40 +0200, Raistlin wrote:
> +static inline void __dl_signal(struct task_struct *tsk, int which)
> +{
> +       struct siginfo info;
> +       long long amount = which == SF_SIG_DMISS ? tsk->dl.stats.last_dmiss :
> +                          tsk->dl.stats.last_rorun;
> +
> +       info.si_signo = SIGXCPU;
> +       info.si_errno = which;
> +       info.si_code = SI_KERNEL;
> +       info.si_pid = 0;
> +       info.si_uid = 0;
> +       info.si_value.sival_int = (int)amount;
> +
> +       /* Correctly take the locks on task's sighand */
> +       __group_send_sig_info(SIGXCPU, &info, tsk);
> +       /* Log what happened to dmesg */
> +       printk(KERN_INFO "SCHED_DEADLINE: 0x%4x by %Ld [ns] in %d (%s)\n",
> +              which, amount, task_pid_nr(tsk), tsk->comm);
> +} 

This being a G-EDF like scheduler with a u<=1 schedulability test, we're
firmly in soft-rt territory which means the above will be very easy to
trigger.. Maybe not spam dmesg?
