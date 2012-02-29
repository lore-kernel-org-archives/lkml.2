Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab2B2SGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:06:37 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:11563
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757642Ab2B2SGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:06:35 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F4E6915.1010209@am.sony.com>
Date: Wed, 29 Feb 2012 10:06:13 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Questions about ptrace on a dying process
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace maintainers (and interested parties)...

I'm working on a crash handler for Linux, which uses ptrace to retrieve information
about a process during it's coredump.  Specifically, from within a core handler
program (started within do_coredump() as a user_mode_helper), I would like to make
ptrace calls against the dying process.

My problem is that the process state is not entering into TASK_TRACED, when
I do an PTRACE_ATTACH against it.  I have worked around the problem with the
hack below, and am now trying to find a more correct solution to my problem:

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -122,6 +122,8 @@ int ptrace_check_attach(struct task_struct *child, int kill)
                WARN_ON_ONCE(task_is_stopped(child));
                if (task_is_traced(child) || kill)
                        ret = 0;
+               // FIXTHIS - force tracing support for crash handler
+               ret = 0;
                spin_unlock_irq(&child->sighand->siglock);
        }
        read_unlock(&tasklist_lock);


I'm trying to decipher the code, but I'm not sure if I understand it correctly.

Here's the problem I have found:

The code in ptrace_check_attach() tests whether the process state has __TASK_TRACED.
(the above 'task_is_trace(child)' conditional).  This appears to be the gateway
for allowing ptrace operations on the process.

A process usually sets it's state to TASK_TRACED (which includes __TASK_TRACED)
via the function ptrace_stop(), which is usually called (I believe), when a task
processes a STOP signal.  In the case of a dying process, however, it appears
this is never called, since the process never actually returns through the
signal-handling code on it's way back to user-space, since user-space never
runs again.  At least, I tried to send a signal from my crash_handler program
to the dying process, and the dying process never processes the signal.

In ptrace_attach(), a stop signal *is* submitted to the process, but via
a call to send_sig_info(SIGSTOP...), not by calling ptrace_stop().
This ends up adding the STOP signal to the pending bit array, but not
converting the process to TASK_TRACED at that time.

The code in these codes paths looks quite tricky, and I am loathe to make any
changes to the generic state machine for my case.

However, what would you think of having special case code in ptrace_attach()
or ptrace_check_attach() code, for the in-coredump case?

Have you heard of other uses of ptrace on dying processes?  Have other people
gotten thts working successfully?  That is, is there something
simple I'm missing, in terms of manipulating the process state to allow for
ptrace operation in this situation?

Thanks for any help or ideas you can provide.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

