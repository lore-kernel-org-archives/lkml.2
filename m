Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1FEToh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 15:44:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48972 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab1FETof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 15:44:35 -0400
Date: Sun, 5 Jun 2011 21:44:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110605194419.GA12965@elte.hu>
References: <20110605151323.GA30590@elte.hu>
 <20110605152641.GA31124@elte.hu>
 <20110605153218.GA31471@elte.hu>
 <4DEBA9CC.4090503@die-jansens.de>
 <4DEBB05C.8090506@die-jansens.de>
 <4DEBB3DA.8060001@die-jansens.de>
 <20110605172052.GA1036@elte.hu>
 <4DEBBFF9.2030101@die-jansens.de>
 <20110605185957.GA3452@elte.hu>
 <4DEBD95B.6030901@die-jansens.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEBD95B.6030901@die-jansens.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arne Jansen <lists@die-jansens.de> wrote:

> From the timing I see I'd guess it has something to do with the 
> scheduler kicking in during printk. I'm neither familiar with the 
> printk code nor with the scheduler.

Yeah, that's the well-known wake-up of klogd:

void console_unlock(void)
{
...
        up(&console_sem);

actually ... that's not the klogd wake-up at all (!). I so suck today 
at bug analysis :-)

It's the console lock()/unlock() sequence, and guess what does it:

 drivers/tty/tty_io.c:   console_lock();
 drivers/tty/vt/selection.c:     console_lock();

and the vt.c code in a dozen places.

So maybe it's some sort of tty related memory corruption that was 
made *visible* via the extra assert that the scheduler is doing? The 
pi_list is embedded in task struct.

This would explain why only printk() triggers it and other wakeup 
patterns not.

Now, i don't really like this theory either. Why is there no other 
type of corruption? And exactly why did only the task_struct::pi_lock 
field get corrupted while nearby fields not? Also, none of the fields 
near pi_lock are even remotely tty related.

Thanks,

	Ingo
