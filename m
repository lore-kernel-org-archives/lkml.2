Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab2JNOoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:44:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46740 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932412Ab2JNOoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:13 -0400
Message-Id: <20121014143539.106176918@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 039/147] staging: comedi: fix memory leak for saved channel list
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


