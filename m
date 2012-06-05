Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab2FESMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 14:12:34 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:50601 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab2FESMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 14:12:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-160.messagelabs.com!1338919912!8574808!81
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: ni_labpc: unlock spinlock on command error
Date: Tue, 5 Jun 2012 11:12:18 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206051112.19276.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When starting the acquisition the labpc_ai_cmd function was
exiting without unlocking the spinlock. This results in a
sparse warning:

warning: context imbalance in 'labpc_ai_cmd' - different lock contexts for basic block

Add the missing spin_unlock_irqrestore calls.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 5334977..1d739b2 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -1386,6 +1386,7 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		break;
 	default:
 		comedi_error(dev, "bug with start_src");
+		spin_unlock_irqrestore(&dev->spinlock, flags);
 		return -1;
 		break;
 	}
@@ -1398,6 +1399,7 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		break;
 	default:
 		comedi_error(dev, "bug with stop_src");
+		spin_unlock_irqrestore(&dev->spinlock, flags);
 		return -1;
 	}
 	devpriv->write_byte(devpriv->command2_bits, dev->iobase + COMMAND2_REG);
