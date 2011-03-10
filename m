Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1CJUhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:37:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24310 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1CJUhS (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Mar 2011 15:37:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/hvc: Disable probe_irq_on/off from poking the hvc-console IRQ line.
Date: Thu, 10 Mar 2011 15:36:45 -0500
Message-Id: <1299789405-30802-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299789405-30802-1-git-send-email-konrad.wilk@oracle.com>
References: <1299789405-30802-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D793670.0222,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a particular nasty racing problem found when using
Xen hypervisor with the console (hvc) output being routed to the
serial port and the serial port receiving data when
probe_irq_off(probe_irq_on) is running.

Specifically the bug manifests itself with:

[    4.470693] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[    4.470693] IP: [<ffffffff810a8c65>] handle_IRQ_event+0xe/0xc9
..snip..
[    4.470693] Call Trace:
[    4.470693]  <IRQ>
[    4.470693]  [<ffffffff810aa645>] handle_percpu_irq+0x3c/0x69
[    4.470693]  [<ffffffff8123cda7>] __xen_evtchn_do_upcall+0xfd/0x195
[    4.470693]  [<ffffffff810308cf>] ? xen_restore_fl_direct_end+0x0/0x1
[    4.470693]  [<ffffffff8123d873>] xen_evtchn_do_upcall+0x32/0x47
[    4.470693]  [<ffffffff81034dfe>] xen_do_hypervisor_callback+0x1e/0x30
[    4.470693]  <EOI>
[    4.470693]  [<ffffffff8100922a>] ? hypercall_page+0x22a/0x1000
[    4.470693]  [<ffffffff8100922a>] ? hypercall_page+0x22a/0x1000
[    4.470693]  [<ffffffff810301c5>] ? xen_force_evtchn_callback+0xd/0xf
[    4.470693]  [<ffffffff810308e2>] ? check_events+0x12/0x20
[    4.470693]  [<ffffffff81030889>] ? xen_irq_enable_direct_end+0x0/0x7
[    4.470693]  [<ffffffff810ab0a0>] ? probe_irq_on+0x8f/0x1d7
[    4.470693]  [<ffffffff812b105e>] ? serial8250_config_port+0x7b7/0x9e6
[    4.470693]  [<ffffffff812ad66c>] ? uart_add_one_port+0x11b/0x305

The bug is trigged by three actors working together:
 A). serial_8250_config_port calling
	probe_irq_off(probe_irq_on())
     wherein all of the IRQ handlers are being started and shut off.
     The functions utilize the sleep functions so the minimum time
     they are run is 120 msec.
 B). Xen hypervisor receiving on the serial line any character and
     setting the bits in the event channel - during this 120 msec timeframe.
 C). The hvc API makes a call to 'request_irq' (and hence setting desc->action
     to a valid value), much much later - when user space opens
     /dev/console (hvc_open). To make the console usable during bootup,
     the Xen HVC implementation sets the IRQ chip (and correspondingly
     the event channel) much earlier. The IRQ chip handler that is used
     is the handle_percpu_irq (aaca49642b92c8a57d3ca5029a5a94019c7af69f)

Back to the issue. When A) is being called it ends up calling the
xen_percpu_chip's chip->startup twice and chip->shutdown once. Those
are set to the default_startup and mask_irq (events.c) respectivly.
If (and this seems to depend on what serial concentrator you use), B)
gets data from the serial port it sets in the event channel a pending bit.
When A) calls chip->startup(), the masking of the pending bit, and
unmasking of the event channel mask, and also setting of the upcall_pending
flag is done (since there is data present on the event channel).
If before the 120 msec has elapsed, any IRQ handler (Xen IRQ has one
IRQ handler, which checks the event channels bitmap to figure which one
to call) is called we end up calling the handle_percpu_irq. The
handle_percpu_irq calls desc->action (which is NULL) and we blow up.

Caveats: I could only reproduce this on 2.6.32 pvops. I am not sure
why this is not showing up on 2.6.38 kernel.

The probe_irq_on/off has code to disable poking specific IRQ lines. This is
done by using the set_irq_noprobe() and then we do not have to
worry about the handle_percpu_irq being called before the IRQ action
handler has been installed.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/tty/hvc/hvc_xen.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 3740e32..c35f1a7 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -177,6 +177,8 @@ static int __init xen_hvc_init(void)
 	}
 	if (xencons_irq < 0)
 		xencons_irq = 0; /* NO_IRQ */
+	else
+		set_irq_noprobe(xencons_irq);
 
 	hp = hvc_alloc(HVC_COOKIE, xencons_irq, ops, 256);
 	if (IS_ERR(hp))
-- 
1.7.1

