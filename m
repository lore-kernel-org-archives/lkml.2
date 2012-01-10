Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216Ab2AJXCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:02:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934191Ab2AJXCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:02:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:03 2012
Message-Id: <20120110215603.192527264@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Boaz Harrosh <bharrosh@panasas.com>
Subject: [19/49] ore: Fix crash in case of an IO error.
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit ffefb8eaa367e8a5c14f779233d9da1fbc23d164 upstream.

The users of ore_check_io() expect the reported device
(In case of error) to be indexed relative to the passed-in
ore_components table, and not the logical dev index.

This causes a crash inside objlayoutdriver in case of
an IO error.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exofs/ore.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -445,10 +445,10 @@ int ore_check_io(struct ore_io_state *io
 			u64 residual = ios->reading ?
 					or->in.residual : or->out.residual;
 			u64 offset = (ios->offset + ios->length) - residual;
-			struct ore_dev *od = ios->oc->ods[
-					per_dev->dev - ios->oc->first_dev];
+			unsigned dev = per_dev->dev - ios->oc->first_dev;
+			struct ore_dev *od = ios->oc->ods[dev];
 
-			on_dev_error(ios, od, per_dev->dev, osi.osd_err_pri,
+			on_dev_error(ios, od, dev, osi.osd_err_pri,
 				     offset, residual);
 		}
 		if (osi.osd_err_pri >= acumulated_osd_err) {


