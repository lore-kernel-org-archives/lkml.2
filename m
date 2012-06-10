Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2FJGiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 02:38:50 -0400
Received: from ozlabs.org ([203.10.76.45]:40921 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab2FJGie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 02:38:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] kthread: Implement park/unpark facility
In-Reply-To: <alpine.LFD.2.02.1206051538280.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1206042203590.3086@ionos> <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au> <alpine.LFD.2.02.1206051135260.3086@ionos> <alpine.LFD.2.02.1206051538280.3086@ionos>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sun, 10 Jun 2012 15:10:42 +0930
Message-ID: <878vfviv1h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012 15:41:48 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> Subject: kthread: Implement park/unpark facility
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 18 Apr 2012 16:37:40 +0200
> 
> To avoid the full teardown/setup of per cpu kthreads in the case of
> cpu hot(un)plug, provide a facility which allows to put the kthread
> into a park position and unpark it when the cpu comes online again.

Like the idea, but the API is awkward.  Now you've made returning from a
thread do different things depending on whether it was parked or not.

How about just have the thread call "kthread_parkme()" which only
returns if/when the thread is unparked?

So the thread does:

        while (!kthread_should_stop()) {
                if (kthread_should_park()) {
                        ... cleanup ...
                        kthread_parkme();
                        ... restore ...
                }
                ... work ...
        }

Threads which never exit have "for (;;)" instead of while
(!kthread_should_stop()).

Cheers,
Rusty.
