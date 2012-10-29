Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560Ab2J2WQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:16:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:47346 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932921Ab2J2Vg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 028/101] staging: comedi: das08: fix possible NULL deref during detach
Date: Mon, 29 Oct 2012 14:34:41 -0700
Message-Id: <20121029213243.341990180@linuxfoundation.org>
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

commit ee280d134f2e05e0172369a53fbe202dbfc527fa upstream.

`das08_detach()` is called by the comedi core to clean up if either
`das08_attach()` or `das08_attach_pci()` returns an error.  It sets
`thisboard` to the return value of `comedi_board(dev)` and assumes it is
non-null.  This is a valid assumption if `das08_attach()` fails, but not
if `das08_attach_pci()` fails, leading to a possible NULL pointer
dereference.

Check `thisboard` at the top of `das08_detach()` and return early if it
is `NULL`.  This is okay because the only other thing that could have
been allocated is `dev->private` and that is freed by the comedi core,
not by this function.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/das08.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -1028,6 +1028,8 @@ static void __maybe_unused das08_detach(
 	const struct das08_board_struct *thisboard = comedi_board(dev);
 	struct das08_private_struct *devpriv = dev->private;
 
+	if (!thisboard)
+		return;
 	das08_common_detach(dev);
 	if (IS_ENABLED(CONFIG_COMEDI_DAS08_ISA) &&
 	    (thisboard->bustype == isa || thisboard->bustype == pc104)) {


