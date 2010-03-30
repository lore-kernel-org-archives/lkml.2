Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab0CaAdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:33:04 -0400
Received: from kroah.org ([198.145.64.141]:48798 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308Ab0C3XL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:11:58 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:16 2010
Message-Id: <20100330225815.618223674@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Xiaotian Feng <dfeng@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jeff Mahoney <jeffm@suse.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [12/89] clockevent: Dont remove broadcast device when cpu is dead
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Xiaotian Feng <dfeng@redhat.com>

commit ea9d8e3f45404d411c00ae67b45cc35c58265bb7 upstream.

Marc reported that the BUG_ON in clockevents_notify() triggers on his
system. This happens because the kernel tries to remove an active
clock event device (used for broadcasting) from the device list.

The handling of devices which can be used as per cpu device and as a
global broadcast device is suboptimal.

The simplest solution for now (and for stable) is to check whether the
device is used as global broadcast device, but this needs to be
revisited.

[ tglx: restored the cpuweight check and massaged the changelog ]

Reported-by: Marc Dionne <marc.c.dionne@gmail.com>
Tested-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
LKML-Reference: <1262834564-13033-1-git-send-email-dfeng@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/clockevents.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -20,6 +20,8 @@
 #include <linux/sysdev.h>
 #include <linux/tick.h>
 
+#include "tick-internal.h"
+
 /* The registered clock event devices */
 static LIST_HEAD(clockevent_devices);
 static LIST_HEAD(clockevents_released);
@@ -258,7 +260,8 @@ void clockevents_notify(unsigned long re
 		cpu = *((int *)arg);
 		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
 			if (cpumask_test_cpu(cpu, dev->cpumask) &&
-			    cpumask_weight(dev->cpumask) == 1) {
+			    cpumask_weight(dev->cpumask) == 1 &&
+			    !tick_is_broadcast_device(dev)) {
 				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
 				list_del(&dev->list);
 			}


