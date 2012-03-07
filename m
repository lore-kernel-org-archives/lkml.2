Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872Ab2CGSBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:01:54 -0500
Received: from mtantr2.softathome.com ([82.138.70.70]:11078 "EHLO
	mtantr2.softathome.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2CGSBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:01:53 -0500
X-Greylist: delayed 635 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2012 13:01:53 EST
X-Amavis-Modified: Mail body modified (using disclaimer) -
	mtantr2.softathome.com
X-Spam-Flag: NO
X-Spam-Score: -4.379
Date: Wed, 7 Mar 2012 18:51:13 +0100 (CET)
From: "Dmitry ADAMUSHKA (EXT)" <dmitry.adamushka_ext@softathome.com>
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: wouter.cloetens@softathome.com,
        dmitry adamushko <dmitry.adamushko@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <1830531676.59669.1331142673402.JavaMail.root@storentr1.softathome.com>
In-Reply-To: <1144797072.59663.1331142646789.JavaMail.root@storentr1.softathome.com>
Subject: 'khelper' (child) is stuck in endless loop: do_signal() and
 !user_mode(regs)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.64.166]
X-Mailer: Zimbra 6.0.6_GA_2330.UBUNTU8_64 (ZimbraWebClient - FF3.0 (Linux)/6.0.6_GA_2330.UBUNTU8_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi All,

The issue described below has been observed on a MIPS board running 2.6.30, but, according to my analysis (no need to panic, I may well be wrong :-)),
the recent kernel and other archs (at least x86) are also affected.

Problem:

a CPU ends up looping endlessly with interrupts disabled. ftrace's function tracer (triggered via SysRq, luckily it's an SMP system) shows:

khelper-1818    0d... 285882000us : do_notify_resume <-work_notifysig
khelper-1818    0d... 285882000us : do_notify_resume <-work_notifysig
khelper-1818    0d... 285882000us : do_notify_resume <-work_notifysig
[...]

At this moment, there are 2 'khelper' tasks on the system [1], the original (parent) 'khelper' is ok.

Now, the assumptions (the question is whether these are true for the recent kernels):

1) TIF_SIGPENDING can be set for 'khelper' while it's running in ____call_usermodehelper()
   between (a) flush_signal_handlers() and (b) kernel_execve() => so TIF_SIGPENDING is set;

2) kernel_execve() can fail in ____call_usermodehelper().

The later one is less of an assumption; let's say, it fails due to a shortage of memory (or whatever).

If (1) is true, then

the pre-conditions:

- a kernel space task;  

'khelper' running ____call_usermodehelper() in our case.

- TIF_SIGPENDING is set.

A signal has been delivered, say, as a result of kill(-1, SIGKILL).

The endless loop is as follows:

* syscall_exit_work:
 - work_pending:            // start_of_the_loop
 - work_notify_sig:
   - do_notify_resume()
     - do_signal()          ==> if (!user_mode(regs)) return; so signals are not handled
 - resume_userspace         // TIF_SIGPENDING is still set
 - work_pending		    // so we call work_pending => goto start_of_the_loop


And we enter this loop when both assumptions above are true. That's, kernel_execve() fails in ____call_usermodehelper() and there is a pending signal for 'khelper'.

I'm actually able to trigger the loop (with 2.6.30 on MIPS) by deliberately setting up a pending signal in ____call_usermodehelper() and then letting kernel_execve() fail. In real life, the issue is triggered sporadically when a board reboots (busybox's init calls kill(-1, SIGKILL)).

Have I overlooked something in the recent kernel that makes it immune to this problem?

Thanks for comments,

--Dmitry


[1] SysRq list-all-tasks output:

helper       D 7fffffff     0    26      2
[...]
Call Trace:
[<80440fc4>] __schedule+0x3c4/0xa60
[<80441690>] schedule+0x30/0x60
[<80441d1c>] schedule_timeout+0x19c/0x1d0
[<804409f8>] wait_for_common+0xc4/0x184
[<80440bec>] wait_for_completion+0x2c/0x40
[<8003f774>] do_fork+0x1d0/0x3cc
[<80015cd8>] kernel_thread+0x90/0xb4
[<80058754>] __call_usermodehelper+0x64/0xc4
[<80059cf4>] worker_thread+0x15c/0x2b0

khelper       R running      0  1818     26
[...]
Call Trace:
[<80440fc4>] __schedule+0x3c4/0xa60


This message and any attachments herein are confidential, intended solely for the addressees and are SoftAtHome's ownership. Any unauthorized use or dissemination is prohibited. If you are not the intended addressee of this message, please cancel it immediately and inform the sender.
