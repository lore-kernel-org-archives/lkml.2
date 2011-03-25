Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375Ab1CYBfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 21:35:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44255 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab1CYBfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 21:35:38 -0400
Date: Fri, 25 Mar 2011 12:35:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Juan J. Garcia de Soria" <skandalfo@gmail.com>,
        Jarod Wilson <jarod@redhat.com>
Subject: linux-next: build failure after merge of the Linus' tree
Message-Id: <20110325123535.f980dfe8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In Linus' tree, today's linux-next build (x86_64 allmodconfig) failed
like this:

drivers/media/rc/ite-cir.c: In function 'ite_decode_bytes':
drivers/media/rc/ite-cir.c:190: error: implicit declaration of function 'generic_find_next_le_bit'
drivers/media/rc/ite-cir.c:199: error: implicit declaration of function 'generic_find_next_zero_le_bit'

Caused by commit 620a32bba4a2 ("[media] rc: New rc-based ite-cir driver
for several ITE CIRs") interacting with commit c4945b9ed472
("asm-generic: rename generic little-endian bitops functions").

I applied the patch below for today.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 25 Mar 2011 12:30:05 +1100
Subject: [PATCH] [media] rc: update for bitop name changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/media/rc/ite-cir.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 9be6a83..ac0e42b 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -187,7 +187,7 @@ static void ite_decode_bytes(struct ite_dev *dev, const u8 * data, int
 	sample_period = dev->params.sample_period;
 	ldata = (unsigned long *)data;
 	size = length << 3;
-	next_one = generic_find_next_le_bit(ldata, size, 0);
+	next_one = find_next_bit_le(ldata, size, 0);
 	if (next_one > 0) {
 		ev.pulse = true;
 		ev.duration =
@@ -196,14 +196,14 @@ static void ite_decode_bytes(struct ite_dev *dev, const u8 * data, int
 	}
 
 	while (next_one < size) {
-		next_zero = generic_find_next_zero_le_bit(ldata, size, next_one + 1);
+		next_zero = find_next_zero_bit_le(ldata, size, next_one + 1);
 		ev.pulse = false;
 		ev.duration = ITE_BITS_TO_NS(next_zero - next_one, sample_period);
 		ir_raw_event_store_with_filter(dev->rdev, &ev);
 
 		if (next_zero < size) {
 			next_one =
-			    generic_find_next_le_bit(ldata,
+			    find_next_bit_le(ldata,
 						     size,
 						     next_zero + 1);
 			ev.pulse = true;
-- 
1.7.4.1

