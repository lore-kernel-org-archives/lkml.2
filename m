Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423230Ab2I1VI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:08:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35513 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423176Ab2I1VFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:05:54 -0400
X-Sasl-enc: FDwhjkvFq+RNap9dHyfS6cKfjlnaUsJTcvi7NOIzOn9N 1348866353
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kenth Eriksson <kenth.eriksson@transmode.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alfredo Capella <alfredo.capella@gmail.com>
Subject: [ 123/127] spi/mpc83xx: fix NULL pdata dereference bug
Date: Fri, 28 Sep 2012 13:34:56 -0700
Message-Id: <20120928203100.269953704@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenth Eriksson <kenth.eriksson@transmode.com>

commit 5039a86973cd35bdb2f64d28ee12f13fe2bb5a4c upstream.

Commit 178db7d3, "spi: Fix device unregistration when unregistering
the bus master", changed device initialization to be children of the
bus master, not children of the bus masters parent device. The pdata
pointer used in fsl_spi_chipselect must updated to reflect the changed
initialization.

Signed-off-by: Kenth Eriksson <kenth.eriksson@transmode.com>
Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Alfredo Capella <alfredo.capella@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi_fsl_spi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi_fsl_spi.c
+++ b/drivers/spi/spi_fsl_spi.c
@@ -139,10 +139,12 @@ static void fsl_spi_change_mode(struct s
 static void fsl_spi_chipselect(struct spi_device *spi, int value)
 {
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
-	struct fsl_spi_platform_data *pdata = spi->dev.parent->platform_data;
+	struct fsl_spi_platform_data *pdata;
 	bool pol = spi->mode & SPI_CS_HIGH;
 	struct spi_mpc8xxx_cs	*cs = spi->controller_state;
 
+	pdata = spi->dev.parent->parent->platform_data;
+
 	if (value == BITBANG_CS_INACTIVE) {
 		if (pdata->cs_control)
 			pdata->cs_control(spi, !pol);


