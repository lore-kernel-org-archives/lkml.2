Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab0EOHht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 03:37:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52079 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab0EOHhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 03:37:47 -0400
Date: Sat, 15 May 2010 09:37:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20100515073732.GA17120@elte.hu>
References: <20100514155312.9684cb9d.sfr@canb.auug.org.au>
 <20100514150343.GQ15159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514150343.GQ15159@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> Sorry for the mess.  I think the following patch 
> cleans it up.  The last piece deals with the sparc 
> mess, the other two pieces should deal with the x86 
> fallout.

This patch breaks x86:

arch/x86/built-in.o: In function `show_stack_log_lvl':
(.text+0xc2c0): undefined reference to `touch_nmi_watchdog'
arch/x86/built-in.o: In function `print_trace_address':
dumpstack.c:(.text+0xd893): undefined reference to `touch_nmi_watchdog'
arch/x86/built-in.o: In function `mce_timed_out':
mce.c:(.text+0x20008): undefined reference to `touch_nmi_watchdog'
arch/x86/built-in.o: In function `enable_lapic_nmi_watchdog':
(.text+0x261f2): undefined reference to `touch_nmi_watchdog'

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_PERF_EVENTS_NMI=y
CONFIG_IPMI_WATCHDOG=m
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_NOWAYOUT=y
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_HP_WATCHDOG=y
CONFIG_SBC_EPX_C3_WATCHDOG=m
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_USBPCWATCHDOG is not set
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_FTRACE_NMI_ENTER=y

I'd _strongly_ suggest to simplify the code. There's 
a few things that could be done to that end:

- just have a single watchdog option and dont split 
  the soft-dog from the hard-dog.

- use config options to define default behavior: i.e.
  whether the soft-dog and hard-dog is enabled by default,
  but otherwise keep them both included.

- provide a smooth pathway for architectures that 
  have an NMI watchdog right now. Dont overlap their 
  symbols for example.

... and similar measures.

Thanks,

	Ingo
