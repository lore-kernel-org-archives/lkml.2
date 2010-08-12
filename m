Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab0HLAHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:07:31 -0400
Received: from kroah.org ([198.145.64.141]:60363 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820Ab0HLAEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:42 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:27 2010
Message-Id: <20100812000127.764225887@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:01:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [49/54] xen: Do not suspend IPI IRQs.
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit 4877c737283813bdb4bebfa3168c1585f6e3a8ca upstream.

In general the semantics of IPIs are that they are are expected to
continue functioning after dpm_suspend_noirq().

Specifically I have seen a deadlock between the callfunc IPI and the
stop machine used by xen's do_suspend() routine. If one CPU has already
called dpm_suspend_noirq() then there is a window where it can be sent
a callfunc IPI before all the other CPUs have entered stop_cpu().

If this happens then the first CPU ends up spinning in stop_cpu()
waiting for the other to rendezvous in state STOPMACHINE_PREPARE while
the other is spinning in csd_lock_wait().

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com
LKML-Reference: <1280398595-29708-4-git-send-email-ian.campbell@citrix.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/events.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -536,6 +536,7 @@ int bind_ipi_to_irqhandler(enum ipi_vect
 	if (irq < 0)
 		return irq;
 
+	irqflags |= IRQF_NO_SUSPEND;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);


