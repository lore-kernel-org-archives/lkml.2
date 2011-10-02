Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1JBXJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 19:09:45 -0400
Received: from mail.klingt.org ([86.59.21.178]:47171 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab1JBXJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 19:09:34 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Oct 2011 19:09:34 EDT
From: Tim Blechmann <tim@klingt.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: threadirqs && irq nobody cared
Date: Mon, 03 Oct 2011 01:01:57 +0200
Message-ID: <1515462.kJuO53sx2E@moka>
X-KMail-UnExpanded-To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8+; KDE/4.7.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (klingt.org [86.59.21.178]); Mon, 03 Oct 2011 01:01:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

i've experienced problems with recent kernels that irqs are disabled. there
was a similar report some time ago on lkml, suggesting that it might be an
issue with threaded irqs [1].

my issue looked similar:
[   14.726028] irq 16: nobody cared (try booting with the "irqpoll" option)
[   14.726032] Pid: 46, comm: irq/16-uhci_hcd Tainted: P            3.0.1 #12
[   14.726035] Call Trace:
[   14.726042]  [<ffffffff810cb936>] __report_bad_irq+0x36/0xd0
[   14.726045]  [<ffffffff810cbd56>] note_interrupt+0x136/0x1f0
[   14.726049]  [<ffffffff81062c07>] ? local_bh_enable+0x57/0xc0
[   14.726052]  [<ffffffff810caa90>] ? irq_thread_fn+0x50/0x50
[   14.726054]  [<ffffffff810caa0f>] irq_thread+0x1af/0x1e0
[   14.726057]  [<ffffffff810ca860>] ? irq_finalize_oneshot+0x110/0x110
[   14.726060]  [<ffffffff8107e83c>] kthread+0x8c/0xa0
[   14.726065]  [<ffffffff815d33a4>] kernel_thread_helper+0x4/0x10
[   14.726068]  [<ffffffff8107e7b0>] ? kthread_worker_fn+0x190/0x190
[   14.726071]  [<ffffffff815d33a0>] ? gs_change+0x13/0x13
[   14.726072] handlers:
[   14.726074] [<ffffffff810ca090>] irq_default_primary_handler threaded [<ffffffff8142fd80>] usb_hcd_irq
[   14.726080] [<ffffffff810ca090>] irq_default_primary_handler threaded [<ffffffffa001dce0>] ahci_interrupt
[   14.726093] [<ffffffff810ca090>] irq_default_primary_handler threaded [<ffffffffa1baea40>] snd_hdsp_interrupt
[   14.726098] Disabling IRQ #16

for me the issue mainly occurs under high cpu load. the issue in [1] is related
to radeon_driver_irq_handler_kms and usb_hcd_irq. however i have mutually
unloaded the ahci, uhci-hcd and snd-hdsp modules and the problem always
occurred sooner or later, so it does not seem to be related to one of the
drivers. however i haven't experienced it before 3.0.

i've currently booted my kernel without the threadirqs options and it seems to
resolve this issue for me, running for a few hours with a rather high cpu load.
however the latency of the system becomes rather high, and i have quite a lot
of audio dropouts (xruns of abour 30ms) ...

how can i help to resolve this isse?

thanks, tim

[1] https://lkml.org/lkml/2011/7/11/119
