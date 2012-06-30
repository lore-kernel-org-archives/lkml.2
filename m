Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2F3AlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 20:41:22 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:52688 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab2F3AlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 20:41:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1341016879!12961993!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/10] staging: comedi: ni_670x: cleanup ni_670x_dio_insn_bits()
Date: Fri, 29 Jun 2012 17:41:10 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291741.11258.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add local variable for the io_addr, mask. and bits used in this
function so that the comments are not needed and the writel/readl
calls are a bit cleaner.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_670x.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index 1d3590e..86e9e70 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -146,19 +146,19 @@ static int ni_670x_dio_insn_bits(struct comedi_device *dev,
 				 struct comedi_insn *insn, unsigned int *data)
 {
 	struct ni_670x_private *devpriv = dev->private;
+	void __iomem *io_addr = devpriv->mite->daq_io_addr +
+					DIO_PORT0_DATA_OFFSET;
+	unsigned int mask = data[0];
+	unsigned int bits = data[1];
 
-	/* The insn data is a mask in data[0] and the new data
-	 * in data[1], each channel cooresponding to a bit. */
-	if (data[0]) {
-		s->state &= ~data[0];
-		s->state |= data[0] & data[1];
-		writel(s->state,
-		       devpriv->mite->daq_io_addr + DIO_PORT0_DATA_OFFSET);
+	if (mask) {
+		s->state &= ~mask;
+		s->state |= (bits & mask);
+
+		writel(s->state, io_addr);
 	}
 
-	/* on return, data[1] contains the value of the digital
-	 * input lines. */
-	data[1] = readl(devpriv->mite->daq_io_addr + DIO_PORT0_DATA_OFFSET);
+	data[1] = readl(io_addr);
 
 	return insn->n;
 }
-- 
1.7.11

