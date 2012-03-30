Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965616Ab2C3VSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:18:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965583Ab2C3VSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:18:10 -0400
Message-Id: <20120330194830.133033514@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Benoit Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [ 029/175] tty: serial: OMAP: Fix oops due to NULL pdata in DT boot
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Cousson, Benoit" <b-cousson@ti.com>

commit a5f43138da9beddc46b00ec31d167143a7176683 upstream.

The following commit: be4b0281956c5cae4f63f31f11d07625a6988766
(tty: serial: OMAP: block idle while the UART is transferring data in PIO mode),
is introducing an oops if OMAP is booted using device tree blob because
the pdata will not be initialized.

Check if pdata is set before de-referencing it.

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Reviewed-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/omap-serial.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -159,7 +159,7 @@ static void serial_omap_stop_tx(struct u
 		serial_out(up, UART_IER, up->ier);
 	}
 
-	if (!up->use_dma && pdata->set_forceidle)
+	if (!up->use_dma && pdata && pdata->set_forceidle)
 		pdata->set_forceidle(up->pdev);
 
 	pm_runtime_mark_last_busy(&up->pdev->dev);
@@ -298,7 +298,7 @@ static void serial_omap_start_tx(struct
 	if (!up->use_dma) {
 		pm_runtime_get_sync(&up->pdev->dev);
 		serial_omap_enable_ier_thri(up);
-		if (pdata->set_noidle)
+		if (pdata && pdata->set_noidle)
 			pdata->set_noidle(up->pdev);
 		pm_runtime_mark_last_busy(&up->pdev->dev);
 		pm_runtime_put_autosuspend(&up->pdev->dev);
@@ -1613,7 +1613,7 @@ static int serial_omap_runtime_resume(st
 	struct uart_omap_port *up = dev_get_drvdata(dev);
 	struct omap_uart_port_info *pdata = dev->platform_data;
 
-	if (up) {
+	if (up && pdata) {
 		if (pdata->get_context_loss_count) {
 			u32 loss_cnt = pdata->get_context_loss_count(dev);
 


