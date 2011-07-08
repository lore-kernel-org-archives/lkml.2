Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1GHFDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:03:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589Ab1GHFDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:03:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:58 2011
Message-Id: <20110708001658.467881723@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [059/107] [media] rc: fix ghost keypresses with certain hw
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarod Wilson <jarod@redhat.com>

commit 3f5c4c73322e4d6f3d40b697dac3073d2adffe41 upstream.

With hardware that has to use ir_raw_event_store_edge to collect IR
sample durations, we were not doing an event reset unless
IR_MAX_DURATION had passed. That's around 4 seconds. So if someone
presses up, then down, with less than 4 seconds in between, they'd get
the initial up, then up and down upon pressing down.

To fix this, I've lowered the "send a reset event" logic's threshold to
the input device's REP_DELAY (defaults to 500ms), and with an
saa7134-based GPIO-driven IR receiver in a Hauppauge HVR-1150, I get
*much* better behavior out of the remote now. Special thanks to Devin
for providing the hardware to investigate this issue.

CC: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/rc/ir-raw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -114,18 +114,20 @@ int ir_raw_event_store_edge(struct rc_de
 	s64			delta; /* ns */
 	DEFINE_IR_RAW_EVENT(ev);
 	int			rc = 0;
+	int			delay;
 
 	if (!dev->raw)
 		return -EINVAL;
 
 	now = ktime_get();
 	delta = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
+	delay = MS_TO_NS(dev->input_dev->rep[REP_DELAY]);
 
 	/* Check for a long duration since last event or if we're
 	 * being called for the first time, note that delta can't
 	 * possibly be negative.
 	 */
-	if (delta > IR_MAX_DURATION || !dev->raw->last_type)
+	if (delta > delay || !dev->raw->last_type)
 		type |= IR_START_EVENT;
 	else
 		ev.duration = delta;


