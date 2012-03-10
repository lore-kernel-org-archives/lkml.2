Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2CJPQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 10:16:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36226 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956Ab2CJPQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 10:16:12 -0500
Date: Sat, 10 Mar 2012 16:16:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.3-rc6
Message-ID: <20120310151608.GA2755@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFxHj-7fQ0+yJv4WaeKCGha5+a+J=gtHi6m6EWg58q7Ljw@mail.gmail.com>
 <20120307103227.GA5237@x1.osrc.amd.com>
 <20120307121138.GB5237@x1.osrc.amd.com>
 <20120308211832.GU2348@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120308211832.GU2348@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 01:18:32PM -0800, Paul E. McKenney wrote:
> This one, which defines RCU_NONIDLE(): https://lkml.org/lkml/2012/2/3/498
> 
> And then the following patch on top of that.

Thanks Paul, almost though. You still need to obfuscate :) the other
printk in the function:

--
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b185a3294c86..221d117a0b4a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -568,8 +568,9 @@ static void amd_e400_idle(void)
 			 */
 			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
 					   &cpu);
-			printk(KERN_INFO "Switch to broadcast mode on CPU%d\n",
-			       cpu);
+			RCU_NONIDLE(
+				printk(KERN_INFO "Switch to broadcast mode on CPU%d\n", cpu);
+			);
 		}
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
--

Then it flies. Otherwise, you get the WARN_ON_ONCE with a bit different
backtrace:

[    0.028246] System has AMD C1E enabled
[    0.028398] Switch to broadcast mode on CPU0
[    0.028416] ------------[ cut here ]------------
[    0.028421] WARNING: at include/linux/rcupdate.h:269 __atomic_notifier_call_chain+0x4d/0xe9()
[    0.028423] Hardware name: System Product Name
[    0.028424] Modules linked in:
[    0.028427] Pid: 0, comm: swapper/0 Not tainted 3.3.0-rc6-00242-g41657bb1a217 #3
[    0.028429] Call Trace:
[    0.028433]  [<ffffffff81029d98>] warn_slowpath_common+0x83/0x9b
[    0.028436]  [<ffffffff81029dca>] warn_slowpath_null+0x1a/0x1c
[    0.028439]  [<ffffffff8104ff34>] __atomic_notifier_call_chain+0x4d/0xe9
[    0.028441]  [<ffffffff8104ffe4>] atomic_notifier_call_chain+0x14/0x16
[    0.028445]  [<ffffffff8122c079>] notify_write+0x29/0x2b
[    0.028447]  [<ffffffff8122efbb>] vt_console_print+0x243/0x2fe
[    0.028450]  [<ffffffff8102a039>] __call_console_drivers+0x77/0x89
[    0.028453]  [<ffffffff8102a222>] _call_console_drivers+0x5c/0x60
[    0.028456]  [<ffffffff8102a59a>] console_unlock+0x118/0x212
[    0.028458]  [<ffffffff8102ab4e>] vprintk+0x3be/0x403
[    0.028461]  [<ffffffff813e7dab>] ? _raw_spin_unlock_irqrestore+0x38/0x69
[    0.028464]  [<ffffffff813df4ee>] printk+0x41/0x43
[    0.028467]  [<ffffffff813e7dab>] ? _raw_spin_unlock_irqrestore+0x38/0x69
[    0.028470]  [<ffffffff8105a8ab>] ? local_clock+0xf/0x3b
[    0.028473]  [<ffffffff81009dc6>] amd_e400_idle+0xbb/0xf1
[    0.028476]  [<ffffffff81000801>] cpu_idle+0x6c/0xc8
[    0.028478]  [<ffffffff813cd1d0>] rest_init+0x124/0x12b
[    0.028480]  [<ffffffff813cd116>] ? rest_init+0x6a/0x12b
[    0.028484]  [<ffffffff8185aa18>] start_kernel+0x2d5/0x2e2
[    0.028486]  [<ffffffff8185a26e>] x86_64_start_reservations+0x7e/0x82
[    0.028489]  [<ffffffff8185a362>] x86_64_start_kernel+0xf0/0xf7
[    0.028494] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.028496] ------------[ cut here ]------------
[    0.028498] WARNING: at include/linux/rcupdate.h:275 __atomic_notifier_call_chain+0xb4/0xe9()
[    0.028500] Hardware name: System Product Name
[    0.028501] Modules linked in:
[    0.028503] Pid: 0, comm: swapper/0 Tainted: G        W    3.3.0-rc6-00242-g41657bb1a217 #3
[    0.028505] Call Trace:
[    0.028507]  [<ffffffff81029d98>] warn_slowpath_common+0x83/0x9b
[    0.028510]  [<ffffffff81029dca>] warn_slowpath_null+0x1a/0x1c
[    0.028512]  [<ffffffff8104ff9b>] __atomic_notifier_call_chain+0xb4/0xe9
[    0.028515]  [<ffffffff8104ff3b>] ? __atomic_notifier_call_chain+0x54/0xe9
[    0.028517]  [<ffffffff8104ffe4>] atomic_notifier_call_chain+0x14/0x16
[    0.028520]  [<ffffffff8122c079>] notify_write+0x29/0x2b
[    0.028522]  [<ffffffff8122efbb>] vt_console_print+0x243/0x2fe
[    0.028525]  [<ffffffff8102a039>] __call_console_drivers+0x77/0x89
[    0.028527]  [<ffffffff8102a222>] _call_console_drivers+0x5c/0x60
[    0.028530]  [<ffffffff8102a59a>] console_unlock+0x118/0x212
[    0.028532]  [<ffffffff8102ab4e>] vprintk+0x3be/0x403
[    0.028535]  [<ffffffff813e7dab>] ? _raw_spin_unlock_irqrestore+0x38/0x69
[    0.028537]  [<ffffffff813df4ee>] printk+0x41/0x43
[    0.028539]  [<ffffffff813e7dab>] ? _raw_spin_unlock_irqrestore+0x38/0x69
[    0.028542]  [<ffffffff8105a8ab>] ? local_clock+0xf/0x3b
[    0.028544]  [<ffffffff81009dc6>] amd_e400_idle+0xbb/0xf1
[    0.028546]  [<ffffffff81000801>] cpu_idle+0x6c/0xc8
[    0.028548]  [<ffffffff813cd1d0>] rest_init+0x124/0x12b
[    0.028550]  [<ffffffff813cd116>] ? rest_init+0x6a/0x12b
[    0.028553]  [<ffffffff8185aa18>] start_kernel+0x2d5/0x2e2
[    0.028555]  [<ffffffff8185a26e>] x86_64_start_reservations+0x7e/0x82
[    0.028557]  [<ffffffff8185a362>] x86_64_start_kernel+0xf0/0xf7
[    0.028559] ---[ end trace 4eaa2a86a8e2da23 ]---

Thanks.

-- 
Regards/Gruss,
    Boris.
