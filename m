Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab2FMWmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:42:55 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:52564 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab2FMWmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:42:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1339627371!1174968!2
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/15] staging: comedi: 8255: refactor subdev_8255_insn function
Date: Wed, 13 Jun 2012 15:42:45 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131542.46112.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the subdev_8255_insn function to follow what the user
space library is doing.

1) This function requires 'data' to contain 2 parameters. Add a
sanity check for this (insn->n != 2).

2) The 'data' parameters are actually a 'mask' of the valid bits and
the actual 'bits' to modify. Create local variables of these names
to help with maintainability.

3) The value returned in data[1] reflects the actual state of the
8255 io pins after the update of the masked bits. Fetch this data
in a local variable and then set data[1].

4) The user space library only checks for a < 0 return to indicate
an error. It appears that the 'return 2' in this function is supposed
to indicate the number of data parameters used to perform the command.
Return the insn->n value for this, the open coded '2' looks wrong.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Iam Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c |   42 +++++++++++++++++++++-----------
 1 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 1f4b24c..da374de 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -135,26 +135,38 @@ static int subdev_8255_insn(struct comedi_device *dev,
 {
 	struct subdev_8255_private *spriv = s->private;
 	unsigned long iobase = spriv->iobase;
+	unsigned int mask;
+	unsigned int bits;
+	unsigned int v;
+
+	if (insn->n != 2)
+		return -EINVAL;
 
-	if (data[0]) {
-		s->state &= ~data[0];
-		s->state |= (data[0] & data[1]);
+	mask = data[0];
+	bits = data[1];
 
-		if (data[0] & 0xff)
-			spriv->io(1, _8255_DATA, s->state & 0xff, iobase);
-		if (data[0] & 0xff00)
-			spriv->io(1, _8255_DATA + 1,
-				  (s->state >> 8) & 0xff, iobase);
-		if (data[0] & 0xff0000)
-			spriv->io(1, _8255_DATA + 2,
-				  (s->state >> 16) & 0xff, iobase);
+	if (mask) {
+		v = s->state;
+		v &= ~mask;
+		v |= (bits & mask);
+
+		if (mask & 0xff)
+			spriv->io(1, _8255_DATA, v & 0xff, iobase);
+		if (mask & 0xff00)
+			spriv->io(1, _8255_DATA + 1, (v >> 8) & 0xff, iobase);
+		if (mask & 0xff0000)
+			spriv->io(1, _8255_DATA + 2, (v >> 16) & 0xff, iobase);
+
+		s->state = v;
 	}
 
-	data[1] = spriv->io(0, _8255_DATA, 0, iobase);
-	data[1] |= (spriv->io(0, _8255_DATA + 1, 0, iobase) << 8);
-	data[1] |= (spriv->io(0, _8255_DATA + 2, 0, iobase) << 16);
+	v = spriv->io(0, _8255_DATA, 0, iobase);
+	v |= (spriv->io(0, _8255_DATA + 1, 0, iobase) << 8);
+	v |= (spriv->io(0, _8255_DATA + 2, 0, iobase) << 16);
+
+	data[1] = v;
 
-	return 2;
+	return insn->n;
 }
 
 static void do_config(struct comedi_device *dev, struct comedi_subdevice *s)
-- 
1.7.7

