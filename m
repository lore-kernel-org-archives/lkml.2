Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab2IHREP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:04:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab2IHREN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:04:13 -0400
Date: Sat, 8 Sep 2012 19:06:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] uprobes: single-step fixes
Message-ID: <20120908170601.GA19311@redhat.com>
References: <20120903152525.GA9028@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903152525.GA9028@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Oleg Nesterov wrote:
>
> Sebastian, I changed your patches a bit:
>
> 	1/7:
>
> 		- Change the subject and update the changelog. In particular,
> 		  s/utrace/uprobes/. I am wondering where this typo came from ;)

Hmm. I just noticed this patch is buggy. arch_uprobe_disable_step(&uprobe->arch)
is not safe after put_uprobe().

Srikar, I fixed this in my tree with the following change,

	--- kernel/events/uprobes.c~	2012-09-02 16:52:54.000000000 +0200
	+++ kernel/events/uprobes.c	2012-09-08 18:56:44.000000000 +0200
	@@ -1536,10 +1536,10 @@ static void handle_singlestep(struct upr
		else
			WARN_ON_ONCE(1);
	 
	+	arch_uprobe_disable_step(&uprobe->arch);
		put_uprobe(uprobe);
		utask->active_uprobe = NULL;
		utask->state = UTASK_RUNNING;
	-	arch_uprobe_disable_step(&uprobe->arch);
		xol_free_insn_slot(current);
	 
		spin_lock_irq(&current->sighand->siglock);

I hope your ack is still valid.

And this also allows us to rely on utask->state in disable_step(), see
the new 8/7 I'll send in a minute. I was going to fix this later, but
I just realized that "disable if trapped" is more buggy than I thought.

Assuming that you are agree with 6 and 8. I'd prefer the new one as a
separate change, but if you prefer to join them please let me know.

Oleg.

