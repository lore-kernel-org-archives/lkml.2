Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2ACNSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 08:18:25 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:63175 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2ACNSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 08:18:21 -0500
Date: Tue, 3 Jan 2012 16:17:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] TPM: handle errors from probe_itpm()
Message-ID: <20120103131748.GA11575@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehw6sesk.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F030007.00A6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently made itpm a bool in linux-next and it broke the error
handling here.  This patch also preserves the return codes from
probe_itpm() instead of always returning -ENODEV.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index a174862..08c6a07 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -538,11 +538,11 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
 	if (!itpm) {
-		itpm = probe_itpm(chip);
-		if (itpm < 0) {
-			rc = -ENODEV;
+		rc = probe_itpm(chip);
+		if (rc < 0)
 			goto out_err;
-		}
+		itpm = rc;
+		rc = 0;
 	}
 
 	if (itpm)
