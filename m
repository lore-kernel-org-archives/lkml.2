Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271Ab2J2WNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:13:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:47454 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761199Ab2J2VhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 031/101] staging: comedi: amplc_dio200: fix possible NULL deref during detach
Date: Mon, 29 Oct 2012 14:34:44 -0700
Message-Id: <20121029213243.670493260@linuxfoundation.org>
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

commit dfb2540e91e1f63765bc3ff497ad0b714d774261 upstream.

`dio200_detach()` is called by the comedi core to clean up if either
`dio200_attach()` or `dio200_attach_pci()` return an error.  It assigns
`thisboard` to the return value of `comedi_board(dev)` and assumes it is
non-null.  In the case of a previous call to `dio200_attach()` it won't
be `NULL` because the comedi core will have pointed it to one of the
elements of `dio200_boards[]`, but in the case of a previous call to
`dio200_attach_pci()` it could be `NULL`, leading to a null pointer
dereference.

Check that `thisboard` is valid at the top of `dio200_detach()` and
return early if it is `NULL`.  This is okay because the only other thing
that could have been allocated is `dev->private` and that is freed by
the comedi core, not by this function.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/amplc_dio200.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -1429,6 +1429,8 @@ static void dio200_detach(struct comedi_
 	const struct dio200_layout_struct *layout;
 	unsigned n;
 
+	if (!thisboard)
+		return;
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->subdevices) {


