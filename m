Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab2KWPKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:10:05 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:45160 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2KWPKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:10:03 -0500
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: [PATCH 5/8] mmci: replace readsl/writesl with ioread32_rep/iowrite32_rep
Date: Fri, 23 Nov 2012 16:08:27 +0100
Message-Id: <1353683310-23654-6-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all the architectures have readsl/writesl,
use the more portable ioread32_rep/iowrite32_rep functions instead.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mmc/host/mmci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 9446c17..5e39b31 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -863,14 +863,14 @@ static int mmci_pio_read(struct mmci_host *host, char *buffer, unsigned int rema
 		if (unlikely(count & 0x3)) {
 			if (count < 4) {
 				unsigned char buf[4];
-				readsl(base + MMCIFIFO, buf, 1);
+				ioread32_rep(base + MMCIFIFO, buf, 1);
 				memcpy(ptr, buf, count);
 			} else {
-				readsl(base + MMCIFIFO, ptr, count >> 2);
+				ioread32_rep(base + MMCIFIFO, ptr, count >> 2);
 				count &= ~0x3;
 			}
 		} else {
-			readsl(base + MMCIFIFO, ptr, count >> 2);
+			ioread32_rep(base + MMCIFIFO, ptr, count >> 2);
 		}
 
 		ptr += count;
@@ -907,7 +907,7 @@ static int mmci_pio_write(struct mmci_host *host, char *buffer, unsigned int rem
 		 * byte become a 32bit write, 7 bytes will be two
 		 * 32bit writes etc.
 		 */
-		writesl(base + MMCIFIFO, ptr, (count + 3) >> 2);
+		iowrite32_rep(base + MMCIFIFO, ptr, (count + 3) >> 2);
 
 		ptr += count;
 		remain -= count;
-- 
1.7.10.4

