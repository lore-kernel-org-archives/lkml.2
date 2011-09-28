Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab1I1XB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:01:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933183Ab1I1WsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:46 2011
Message-Id: <20110928220146.453607297@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Skirvin <jeffrey.d.skirvin@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [200/244] [SCSI] isci: Leave requests alone if already terminating.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

commit 39ea2c5b5ffaa344467da53e885cfa4ac0105050 upstream.

Instead of immediately completing any request that has a second
termination call made on it, wait for the TC done/abort HW event.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/isci/request.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -732,12 +732,20 @@ sci_io_request_terminate(struct isci_req
 		sci_change_state(&ireq->sm, SCI_REQ_ABORTING);
 		return SCI_SUCCESS;
 	case SCI_REQ_TASK_WAIT_TC_RESP:
+		/* The task frame was already confirmed to have been
+		 * sent by the SCU HW.  Since the state machine is
+		 * now only waiting for the task response itself,
+		 * abort the request and complete it immediately
+		 * and don't wait for the task response.
+		 */
 		sci_change_state(&ireq->sm, SCI_REQ_ABORTING);
 		sci_change_state(&ireq->sm, SCI_REQ_COMPLETED);
 		return SCI_SUCCESS;
 	case SCI_REQ_ABORTING:
-		sci_change_state(&ireq->sm, SCI_REQ_COMPLETED);
-		return SCI_SUCCESS;
+		/* If a request has a termination requested twice, return
+		 * a failure indication, since HW confirmation of the first
+		 * abort is still outstanding.
+		 */
 	case SCI_REQ_COMPLETED:
 	default:
 		dev_warn(&ireq->owning_controller->pdev->dev,


