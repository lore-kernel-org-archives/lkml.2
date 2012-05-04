Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab2EDUrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:47:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab2EDUrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:47:18 -0400
Message-Id: <20120504204229.842991791@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lin Ming <ming.m.lin@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 64/75] libata: skip old error history when counting probe trials
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ming <ming.m.lin@intel.com>

commit 6868225e3e92399068be9a5f1635752d91012ad5 upstream.

Commit d902747("[libata] Add ATA transport class") introduced
ATA_EFLAG_OLD_ER to mark entries in the error ring as cleared.

But ata_count_probe_trials_cb() didn't check this flag and it still
counts the old error history. So wrong probe trials count is returned
and it causes problem, for example, SATA link speed is slowed down from
3.0Gbps to 1.5Gbps.

Fix it by checking ATA_EFLAG_OLD_ER in ata_count_probe_trials_cb().

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-eh.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3500,7 +3500,8 @@ static int ata_count_probe_trials_cb(str
 	u64 now = get_jiffies_64();
 	int *trials = void_arg;
 
-	if (ent->timestamp < now - min(now, interval))
+	if ((ent->eflags & ATA_EFLAG_OLD_ER) ||
+	    (ent->timestamp < now - min(now, interval)))
 		return -1;
 
 	(*trials)++;


