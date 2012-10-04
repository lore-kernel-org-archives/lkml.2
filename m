Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946589Ab2JDVqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:46:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48438 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946116Ab2JDVYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:24:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 16/52] staging: comedi: fix memory leak for saved channel list
Date: Thu,  4 Oct 2012 14:21:07 -0700
Message-Id: <20121004210637.357588660@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit c8cad4c89ee3b15935c532210ae6ebb5c0a2734d upstream.

When `do_cmd_ioctl()` allocates memory for the kernel copy of a channel
list, it frees any previously allocated channel list in
`async->cmd.chanlist` and replaces it with the new one.  However, if the
device is ever removed (or "detached") the cleanup code in
`cleanup_device()` in "drivers.c" does not free this memory so it is
lost.

A sensible place to free the kernel copy of the channel list is in
`do_become_nonbusy()` as at that point the comedi asynchronous command
associated with the channel list is no longer valid.  Free the channel
list in `do_become_nonbusy()` instead of `do_cmd_ioctl()` and clear the
pointer to prevent it being freed more than once.

Note that `cleanup_device()` could be called at an inappropriate time
while the comedi device is open, but that's a separate bug not related
to this this patch.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/comedi_fops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1088,7 +1088,6 @@ static int do_cmd_ioctl(struct comedi_de
 		goto cleanup;
 	}
 
-	kfree(async->cmd.chanlist);
 	async->cmd = user_cmd;
 	async->cmd.data = NULL;
 	/* load channel/gain list */
@@ -1833,6 +1832,8 @@ void do_become_nonbusy(struct comedi_dev
 	if (async) {
 		comedi_reset_async_buf(async);
 		async->inttrig = NULL;
+		kfree(async->cmd.chanlist);
+		async->cmd.chanlist = NULL;
 	} else {
 		printk(KERN_ERR
 		       "BUG: (?) do_become_nonbusy called with async=0\n");


