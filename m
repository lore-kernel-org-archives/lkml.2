Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224Ab2I1TBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:01:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030209Ab2I1TBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:01:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [ 157/262] usb: chipidea: udc: dont stall endpoint if request list is empty in isr_tr_complete_low
Date: Fri, 28 Sep 2012 11:51:26 -0700
Message-Id: <20120928183016.519334717@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit db89960e50f45274c07dc60926b5a49489b8a7a0 upstream.

When attaching an imx28 or imx53 in USB gadget mode to a Windows host and
starting a rndis connection we see this message every 4-10 seconds:

    g_ether gadget: high speed config #2: RNDIS

Analysis shows that each time this message is printed, the rndis connection is
re-establish due to a reset because of a stalled endpoint (ep 0, dir 1). The
endpoint is stalled because the reqeust complete bit on that endpoint is set,
but in isr_tr_complete_low() the endpoint request list (mEp->qh.queue) is
empty.

This patch removed this check, because the code doesn't take the following
situation into account:

The loop over all endpoints in isr_tr_complete_handler() will call ep_nuke() on
both ep0/dir0 and ep/dir1 in the first loop. Pending reqeusts will be flushed
and completed here. There seems to be a race condition, the request is nuked,
but the request complete bit will be set, too. The subsequent check (in
ep0/dir1's loop cycle) for endpoint request list (mEp->qh.queue) empty will
fail.

Both other mainline chipidea drivers (mv_udc_core.c and fsl_udc_core.c) don't
have this check.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/udc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -771,10 +771,7 @@ __acquires(mEp->lock)
 {
 	struct ci13xxx_req *mReq, *mReqTemp;
 	struct ci13xxx_ep *mEpTemp = mEp;
-	int uninitialized_var(retval);
-
-	if (list_empty(&mEp->qh.queue))
-		return -EINVAL;
+	int retval = 0;
 
 	list_for_each_entry_safe(mReq, mReqTemp, &mEp->qh.queue,
 			queue) {


