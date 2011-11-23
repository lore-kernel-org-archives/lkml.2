Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab1KWAth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:49:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33529 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759151Ab1KWAte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:49:34 -0500
From: Xi Wang <xi.wang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] comedi: integer overflow in do_insnlist_ioctl()
Date: Tue, 22 Nov 2011 19:49:29 -0500
Message-Id: <5C0D372F-F03E-4EB8-8440-83A8D1C95363@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>, Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mark Pearson <markpearson_de@yahoo.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Franky Lin <frankyl@broadcom.com>, devel@driverdev.osuosl.org,
        security@kernel.org
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential integer overflow in do_insnlist_ioctl() if userspace passes in a large insnlist.n_insns.  The call to kmalloc() would allocate a small buffer, which would result in a memory corruption.

Reported-by: Haogang Chen <haogangchen@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 21d8c1c..66bb49d 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -650,6 +650,7 @@ static int parse_insn(struct comedi_device *dev, struct comedi_insn *insn,
  *		data (for reads)
  */
 /* arbitrary limits */
+#define MAX_INSNS   256
 #define MAX_SAMPLES 256
 static int do_insnlist_ioctl(struct comedi_device *dev,
 			     struct comedi_insnlist __user *arg, void *file)
@@ -663,6 +664,12 @@ static int do_insnlist_ioctl(struct comedi_device *dev,
 	if (copy_from_user(&insnlist, arg, sizeof(struct comedi_insnlist)))
 		return -EFAULT;
 
+	if (insnlist.n_insns > MAX_INSNS) {
+		DPRINTK("invalid number of instructions\n");
+		ret = -EINVAL;
+		goto error;
+	}
+
 	data = kmalloc(sizeof(unsigned int) * MAX_SAMPLES, GFP_KERNEL);
 	if (!data) {
 		DPRINTK("kmalloc failed\n");
-- 
1.7.5.4

