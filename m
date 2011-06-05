Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab1FEOKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 10:10:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35051 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab1FEOKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 10:10:17 -0400
Date: Sun, 5 Jun 2011 16:10:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110605141003.GB29338@elte.hu>
References: <20110605081747.GA17920@elte.hu>
 <4DEB4FA7.3050400@die-jansens.de>
 <20110605095555.GA22058@elte.hu>
 <4DEB58D8.4000805@die-jansens.de>
 <20110605110132.GB23463@elte.hu>
 <20110605111933.GA24592@elte.hu>
 <20110605113627.GA25724@elte.hu>
 <4DEB6F3A.3000109@die-jansens.de>
 <20110605133958.GA27812@elte.hu>
 <4DEB8A93.30601@die-jansens.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEB8A93.30601@die-jansens.de>
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

> Here we go:
> 
> http://eischnee.de/lockup.txt
> 
> Now it's your turn :)

So the lockup is in:

 [<ffffffff813af2d9>] do_raw_spin_lock+0x129/0x170
 [<ffffffff8108a4bd>] ? try_to_wake_up+0x29d/0x350
 [<ffffffff8185ce71>] _raw_spin_lock+0x51/0x70
 [<ffffffff81092df6>] ? vprintk+0x76/0x4a0
 [<ffffffff81092df6>] vprintk+0x76/0x4a0
 [<ffffffff810c5f8d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8108a4bd>] ? try_to_wake_up+0x29d/0x350
 [<ffffffff81859e19>] printk+0x63/0x65
 [<ffffffff8108a4bd>] ? try_to_wake_up+0x29d/0x350
 [<ffffffff81091f98>] warn_slowpath_common+0x38/0xb0
 [<ffffffff81092025>] warn_slowpath_null+0x15/0x20
 [<ffffffff8108a4bd>] try_to_wake_up+0x29d/0x350
 [<ffffffff8108a5a0>] wake_up_process+0x10/0x20
 [<ffffffff8185c071>] __up+0x41/0x50
 [<ffffffff810b937c>] up+0x3c/0x50
 [<ffffffff81092a36>] console_unlock+0x1a6/0x200
 [<ffffffff81092f86>] vprintk+0x206/0x4a0
 [<ffffffff810c5f8d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff810ba6db>] ? local_clock+0x4b/0x60
 [<ffffffffa0012000>] ? 0xffffffffa0011fff
 [<ffffffff81859e19>] printk+0x63/0x65
 [<ffffffffa001201d>] test_init+0x1d/0x2b [test]
 [<ffffffff810001ce>] do_one_initcall+0x3e/0x170

Somehow we end up generating a WARN_ON() within a printk()'s 
try_to_wake_up() and predictably we lock up on that ...

Peter?

Arne, mind helping a bit with:

 [<ffffffff81091f98>] warn_slowpath_common+0x38/0xb0
 [<ffffffff81092025>] warn_slowpath_null+0x15/0x20
 [<ffffffff8108a4bd>] try_to_wake_up+0x29d/0x350

which WARN_ON() does that correspond to in try_to_wake_up()?

Thanks,

	Ingo
