Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab1CUXYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:24:37 -0400
Received: from kroah.org ([198.145.64.141]:52734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374Ab1CUXSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:27 2011
Message-Id: <20110321230327.598847567@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joseph Gruher <joseph.r.gruher@intel.com>,
        Ilgu Hong <ilgu.hong@promise.com>, Mike Snitzer <snitzer@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [57/78] [SCSI] scsi_dh_alua: fix deadlock in stpg_endio
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joseph Gruher <joseph.r.gruher@intel.com>

commit ed0f36bc5719b25659b637f80ceea85494b84502 upstream.

The use of blk_execute_rq_nowait() implies __blk_put_request() is needed
in stpg_endio() rather than blk_put_request() -- blk_finish_request() is
called with queue lock already held.

Signed-off-by: Joseph Gruher <joseph.r.gruher@intel.com>
Signed-off-by: Ilgu Hong <ilgu.hong@promise.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/device_handler/scsi_dh_alua.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -285,7 +285,8 @@ static void stpg_endio(struct request *r
 			    print_alua_state(h->state));
 	}
 done:
-	blk_put_request(req);
+	req->end_io_data = NULL;
+	__blk_put_request(req->q, req);
 	if (h->callback_fn) {
 		h->callback_fn(h->callback_data, err);
 		h->callback_fn = h->callback_data = NULL;


