Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1AUWht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:37:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50662 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1AUWhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:37:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:content-type;
        b=OdLKlpSCx0lZhq5FP6/jOJ0uQrwDEyxln93MBuOq5XLXZoJoIhmOzsjXVygzvyGhHE
         dropO6xLbiLHWucpZXIzzc8NzBEDSVMrYiQZ/DaltWMybIE5aY1dOK8S/jj+1Pg2ipyL
         yGgM8tZ/7FFHSgdgowmDP46FWIUFXVtf8wRFQ=
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Fri, 21 Jan 2011 16:37:24 -0600
Message-ID: <AANLkTimKqkWT9=8xfMnak9DCUd=EiY6WJgqTOrYouwv3@mail.gmail.com>
Subject: FYI: BUG: deadlock workqueues + OOM
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been working on a new arch (patches to be submitted "real soon now")
and have started seeing a deadlock in the workqueues.  This email is "FYI",
as I don't have much in the way of good evidence yet, but it seems like an
arch-indep bug so I thought I'd report it :-)

kernel: linux-2.6.37-rc8
system: 768K RAM, 4-way cpu, rootfs on NFS, no local block storage, no swap.

scenario: run a "mempig" that occasionally triggers the OOM killer, while
also running a pthread-create bomb (like fork-bomb but for threads) (but
each thread returns immediately).

Deadlock: two cpu's in idle loop, two cpu's spinning on spinlock in
kernel/workqueue.c, interrupts disabled.  A pair of "typical" stack
traces below:

c0288484 _raw_spin_lock_irqsave
c0041224 __queue_work  -- kernel/workqueue.c
spin_lock_irqsave(&gcwq->lock, flags);
c0041500 queue_work_on
c025d7d0 xprt_force_disconnect
xs_tcp_write_space
tcp_fin
svc_drop
tcp_rcv_established
 ... etc.

c02883c4 _raw_spin_lock_irq
c0042d80 start_flush_work kernel/workqueue.c
c00435d0 flush_work
c01aed54 n_tty_read
c01a99cc tty_read
... etc.

The precise stack traces vary, but they always end up with one cpu
in start_flush_work()  and the other in __queue_work()

I was wondering if this reminds anyone of anything.  I'll provide
more if/when I narrow it down.

--linas
