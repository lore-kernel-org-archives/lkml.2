Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab1JWGe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:34:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab1JWGeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:23 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:40 2011
Message-Id: <20111023062540.528834786@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:49 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Boot <bootc@bootc.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [21/27] firewire: sbp2: fix panic after rmmod with slow targets
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Boot <bootc@bootc.net>

commit 0278ccd9d53e07c4e699432b2fed9de6c56f506c upstream.

If firewire-sbp2 starts a login to a target that doesn't complete ORBs
in a timely manner (and has to retry the login), and the module is
removed before the operation times out, you end up with a null-pointer
dereference and a kernel panic.

[SR:  This happens because sbp2_target_get/put() do not maintain
module references.  scsi_device_get/put() do, but at occasions like
Chris describes one, nobody holds a reference to an SBP-2 sdev.]

This patch cancels pending work for each unit in sbp2_remove(), which
hopefully means there are no extra references around that prevent us
from unloading. This fixes my crash.

Signed-off-by: Chris Boot <bootc@bootc.net>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/sbp2.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1198,6 +1198,10 @@ static int sbp2_remove(struct device *de
 {
 	struct fw_unit *unit = fw_unit(dev);
 	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
+	struct sbp2_logical_unit *lu;
+
+	list_for_each_entry(lu, &tgt->lu_list, link)
+		cancel_delayed_work_sync(&lu->work);
 
 	sbp2_target_put(tgt);
 	return 0;


