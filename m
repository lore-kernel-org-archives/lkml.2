Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2F3Ajv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 20:39:51 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:54366 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab2F3Aju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 20:39:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1341016788!12979227!2
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/10] staging: comedi: ni_670x: fix dereference of an invalid pointer
Date: Fri, 29 Jun 2012 17:39:45 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291739.46219.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attach if this driver can fail before the subdevices are
allocated. If the attach fails the comedi core will call the
detach routine to allow the driver to do it's cleanup.

We need to make sure that the subdevice allocation was successful
before trying to dereference subdevice[0] to free the allocated
range table list.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_670x.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index bab9644..46f373a 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -301,8 +301,13 @@ static int ni_670x_attach(struct comedi_device *dev,
 static void ni_670x_detach(struct comedi_device *dev)
 {
 	struct ni_670x_private *devpriv = dev->private;
+	struct comedi_subdevice *s;
 
-	kfree(dev->subdevices[0].range_table_list);
+	if (dev->n_subdevices) {
+		s = dev->subdevices + 0;
+		if (s)
+			kfree(s->range_table_list);
+	}
 	if (devpriv && devpriv->mite)
 		mite_unsetup(devpriv->mite);
 	if (dev->irq)
-- 
1.7.11

