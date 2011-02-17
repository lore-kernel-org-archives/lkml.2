Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1BQWXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:23:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab1BQWXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:23:38 -0500
Date: Thu, 17 Feb 2011 17:23:36 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>
Subject: [PATCH] random: update interface comments to reflect reality
Message-ID: <20110217222336.GF2621@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, the comment header in random.c makes no mention of
add_disk_randomness, and instead, suggests that disk activity adds to the
random pool by way of add_interrupt_randomness, which appears to not have
been the case since sometime prior to the existence of git, and even prior
to bitkeeper. Didn't look any further back. At least, as far as I can
tell, there are no storage drivers setting IRQF_SAMPLE_RANDOM, which is a
requirement for add_interrupt_randomness to trigger, so the only way for a
disk to contribute entropy is by way of add_disk_randomness. Update
comments accordingly, complete with special mention about solid state
drives being a crappy source of entropy (see e2e1a148bc for reference).

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 drivers/char/random.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 908ac1f..3dba627 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -128,6 +128,7 @@
  * 	void add_input_randomness(unsigned int type, unsigned int code,
  *                                unsigned int value);
  * 	void add_interrupt_randomness(int irq);
+ * 	void add_disk_randomness(struct gendisk *disk);
  *
  * add_input_randomness() uses the input layer interrupt timing, as well as
  * the event type information from the hardware.
@@ -136,9 +137,15 @@
  * inputs to the entropy pool.  Note that not all interrupts are good
  * sources of randomness!  For example, the timer interrupts is not a
  * good choice, because the periodicity of the interrupts is too
- * regular, and hence predictable to an attacker.  Disk interrupts are
- * a better measure, since the timing of the disk interrupts are more
- * unpredictable.
+ * regular, and hence predictable to an attacker.  Network Interface
+ * Controller interrupts are a better measure, since the timing of the
+ * NIC interrupts are more unpredictable.
+ *
+ * add_disk_randomness() uses what amounts to the seek time of block
+ * layer request events, on a per-disk_devt basis, as input to the
+ * entropy pool. Note that high-speed solid state drives with very low
+ * seek times do not make for good sources of entropy, as their seek
+ * times are usually fairly consistent.
  *
  * All of these routines try to estimate how many bits of randomness a
  * particular randomness source.  They do this by keeping track of the


-- 
Jarod Wilson
jarod@redhat.com

