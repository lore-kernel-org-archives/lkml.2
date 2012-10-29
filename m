Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617Ab2J2WP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:15:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:47368 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952Ab2J2Vg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 030/101] staging: comedi: ni_labpc: fix possible NULL deref during detach
Date: Mon, 29 Oct 2012 14:34:43 -0700
Message-Id: <20121029213243.560072655@linuxfoundation.org>
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

commit 922b67c1ac53014d80649a961a2fde700cd065d8 upstream.

`labpc_common_detach()` is called by the comedi core to clean up if
either `labpc_attach()` (including the one in the "ni_labpc_cs" module)
or `labpc_attach_pci()` returns an error.  It assumes the `thisboard`
macro (expanding to `((struct labpc_board_struct *)dev->board_ptr)`) is
non-null.  This is a valid assumption if `labpc_attach()` fails, but not
if `labpc_attach_pci()` fails, leading to a possible NULL pointer
dereference.

Check `thisboard` at the top of `labpc_common_detach()` and return early
if it is `NULL`.  This is okay because the only other thing that could
have been allocated is `dev->private` and that is freed by the comedi
core, not by this function.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/ni_labpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -809,6 +809,8 @@ static int labpc_find_device(struct come
 
 void labpc_common_detach(struct comedi_device *dev)
 {
+	if (!thisboard)
+		return;
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 #ifdef CONFIG_ISA_DMA_API


