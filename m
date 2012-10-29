Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215Ab2J2VhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:37:12 -0400
Received: from mail.kernel.org ([198.145.19.201]:47390 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932958Ab2J2VhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 032/101] staging: comedi: amplc_pc263: fix possible NULL deref during detach
Date: Mon, 29 Oct 2012 14:34:45 -0700
Message-Id: <20121029213243.787014490@linuxfoundation.org>
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

commit 1d1171ffda585c1cab7bd7cf4bd8f8fd5923fb4a upstream.

`pc263_detach()` is called by the comedi core to clean up if either
`pc263_attach()` or `pc263_attach_pci()` returns an error.  It sets
`thisboard` to the return value of `comedi_board(dev)` and assumes it is
non-null.  This is a valid assumption if `pc263_attach()` fails, but not
if `pc263_attach_pci()` fails, leading to a possible NULL pointer
dereference.

Check `thisboard` at the top of `pc263_detach()` and return early if it
is `NULL`.  This is okay because no other resources need cleaning up in
this case.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/amplc_pc263.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -310,8 +310,11 @@ static int __devinit pc263_attach_pci(st
 
 static void pc263_detach(struct comedi_device *dev)
 {
+	const struct pc263_board *thisboard = comedi_board(dev);
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
+	if (!thisboard)
+		return;
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);


