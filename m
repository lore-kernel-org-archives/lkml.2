Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483Ab2J2WPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:15:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:47411 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932962Ab2J2VhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 034/101] staging: comedi: amplc_pc236: fix possible NULL deref during detach
Date: Mon, 29 Oct 2012 14:34:47 -0700
Message-Id: <20121029213244.023015684@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 2db012bd40b889d8e5483d3daa07af04c4c109d8 upstream.

`pc236_detach()` is called by the comedi core to clean up if either
`pc236_attach()` or `pc236_attach_pci()` returns an error.  It sets
`thisboard` to the return value of `comedi_board(dev)` and assumes it is
non-null.  This is a valid assumption if `pc236_attach()` fails, but not
if `pc236_attach_pci()` fails, leading to a possible NULL pointer
dereference.

Check `thisboard` at the top of `pc236_detach()` and return early if it
is `NULL`.  This is okay because the only other thing that could have
been allocated is `dev->private` and that is freed by the comedi core,
not by this function.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/amplc_pc236.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -577,8 +577,11 @@ static int __devinit pc236_attach_pci(st
 
 static void pc236_detach(struct comedi_device *dev)
 {
+	const struct pc236_board *thisboard = comedi_board(dev);
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
+	if (!thisboard)
+		return;
 	if (dev->iobase)
 		pc236_intr_disable(dev);
 	if (dev->irq)


