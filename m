Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab2K3Ldz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:33:55 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44555 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab2K3Ldy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:33:54 -0500
MIME-Version: 1.0
Date: Fri, 30 Nov 2012 17:03:53 +0530
Message-ID: <CACBffj90HufSBwL5fcmCzLjvQJ_QOMfT=3KJgbkgjn55kudwNw@mail.gmail.com>
Subject: panic doesn't get invoked on oops when panic_on_oops is set
From: Kalash Nainwal <kalash@aristanetworks.com>
To: linux-kernel@vger.kernel.org
Cc: Kalash Nainwal <kalash@aristanetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

An oops doesn't result in panic() call even when panic_on_oops
is set (if we've a crash kernel loaded). The reason seems to be
that from oops codepath before calling panic(), we call
crash_kexec() if panic_on_oops is set:

void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)

{
       if (regs && kexec_should_crash(current))
                crash_kexec(regs);  <====== I'm hitting this
        .
        .
        if (panic_on_oops)
                 panic("Fatal exception");  <==== I want this to be hit
        do_exit(signr);
}

int kexec_should_crash(struct task_struct *p)
{
          if (in_interrupt() || !p->pid || is_global_init(p) || panic_on_oops)
                   return 1;
           return 0;
}

If we let panic() get called from oops_end(), we would eventually
call crash_kexec() from panic() anyway. Isn't it?

Then is the panic_on_oops check in kexec_should_crash()
redundant? Or there's reason behind this behavior?

Would greatly appreciate any response here. Also please CC me
as I am not part of linux-kernel list.

Regards,
-Kalash
