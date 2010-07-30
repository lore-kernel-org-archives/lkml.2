Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687Ab0G3SqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:46:23 -0400
Received: from kroah.org ([198.145.64.141]:35798 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759275Ab0G3Rev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:51 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:08 2010
Message-Id: <20100730173108.233919115@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>
Subject: [061/140] tpm_tis: fix subsequent suspend failures
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

commit 59f6fbe4291fcc078ba26ce4edf8373a7620a13a upstream.

Fix subsequent suspends by issuing tpm_continue_selftest during resume.
Otherwise, the tpm chip seems to be not fully initialized and will reject
the save state command during suspend, thus preventing the whole system
to suspend.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16256

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: David Safford <safford@watson.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm_tis.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -622,7 +622,14 @@ static int tpm_tis_pnp_suspend(struct pn
 
 static int tpm_tis_pnp_resume(struct pnp_dev *dev)
 {
-	return tpm_pm_resume(&dev->dev);
+	struct tpm_chip *chip = pnp_get_drvdata(dev);
+	int ret;
+
+	ret = tpm_pm_resume(&dev->dev);
+	if (!ret)
+		tpm_continue_selftest(chip);
+
+	return ret;
 }
 
 static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {


