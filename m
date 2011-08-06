Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab1HFATF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:19:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab1HFALN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:11:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:13 2011
Message-Id: <20110806000413.901050765@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luben Tuikov <ltuikov@yahoo.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [23/50] [SCSI] libsas: remove expander from dev list on error
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Luben Tuikov <ltuikov@yahoo.com>

commit 5911e963d3718e306bcac387b83e259aa4228896 upstream.

If expander discovery fails (sas_discover_expander()), remove the
expander from the port device list (sas_ex_discover_expander()),
before freeing it. Else the list is corrupted and, e.g., when we
attempt to send SMP commands to other devices, the kernel oopses.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
Reviewed-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libsas/sas_expander.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -840,6 +840,9 @@ static struct domain_device *sas_ex_disc
 
 	res = sas_discover_expander(child);
 	if (res) {
+		spin_lock_irq(&parent->port->dev_list_lock);
+		list_del(&child->dev_list_node);
+		spin_unlock_irq(&parent->port->dev_list_lock);
 		kfree(child);
 		return NULL;
 	}


