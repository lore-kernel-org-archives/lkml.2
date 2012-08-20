Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2HTTxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:53:12 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:40758 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab2HTTxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:53:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1345492295!8957027!168
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] staging: comedi: comedi_bond: remove devpriv macro
Date: Mon, 20 Aug 2012 12:52:58 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201252.58983.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro relies on a local variable having a specific name.
Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/comedi_bond.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 6918439..6829910 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -93,7 +93,7 @@ struct BondedDevice {
 /* this structure is for data unique to this hardware driver.  If
    several hardware drivers keep similar information in this structure,
    feel free to suggest moving the variable to the struct comedi_device struct.  */
-struct Private {
+struct comedi_bond_private {
 # define MAX_BOARD_NAME 256
 	char name[MAX_BOARD_NAME];
 	struct BondedDevice **devs;
@@ -102,12 +102,6 @@ struct Private {
 	unsigned nchans;
 };
 
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct Private *)dev->private)
-
 /* DIO devices are slightly special.  Although it is possible to
  * implement the insn_read/insn_write interface, it is much more
  * useful to applications if you implement the insn_bits interface.
@@ -117,6 +111,7 @@ static int bonding_dio_insn_bits(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct comedi_bond_private *devpriv = dev->private;
 #define LSAMPL_BITS (sizeof(unsigned int)*8)
 	unsigned nchans = LSAMPL_BITS, num_done = 0, i;
 
@@ -163,6 +158,7 @@ static int bonding_dio_insn_config(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn, unsigned int *data)
 {
+	struct comedi_bond_private *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec), ret, io_bits = s->io_bits;
 	unsigned int io;
 	struct BondedDevice *bdev;
@@ -216,6 +212,7 @@ static void *Realloc(const void *oldmem, size_t newlen, size_t oldlen)
 
 static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	struct comedi_bond_private *devpriv = dev->private;
 	int i;
 	struct comedi_device *devs_opened[COMEDI_NUM_BOARD_MINORS];
 
@@ -319,20 +316,19 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 static int bonding_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	struct comedi_bond_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
 
 	LOG_MSG("comedi%d\n", dev->minor);
 
-	/*
-	 * Allocate the private structure area.  alloc_private() is a
-	 * convenient macro defined in comedidev.h.
-	 */
-	if (alloc_private(dev, sizeof(struct Private)) < 0)
-		return -ENOMEM;
+	ret = alloc_private(dev, sizeof(*devpriv));
+	if (ret)
+		return ret;
+	devpriv = dev->private;
 
 	/*
-	 * Setup our bonding from config params.. sets up our Private struct..
+	 * Setup our bonding from config params.. sets up our private struct..
 	 */
 	if (!doDevConfig(dev, it))
 		return -EINVAL;
@@ -362,6 +358,7 @@ static int bonding_attach(struct comedi_device *dev,
 
 static void bonding_detach(struct comedi_device *dev)
 {
+	struct comedi_bond_private *devpriv = dev->private;
 	unsigned long devs_closed = 0;
 
 	if (devpriv) {
-- 
1.7.11

