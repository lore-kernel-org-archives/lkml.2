Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab1H0KnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 06:43:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36237 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1H0KnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 06:43:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 27 Aug 2011 12:42:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire fix
Message-ID: <20110827124256.0ca474ff@stein>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the fixes branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git fixes

for a fix to a regression since v3.0-rc1.  Thanks.

Chris Boot (1):
      firewire: sbp2: fix panic after rmmod with slow targets

 drivers/firewire/sbp2.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


commit 0278ccd9d53e07c4e699432b2fed9de6c56f506c
Author: Chris Boot <bootc@bootc.net>
Date:   Mon Aug 22 21:38:38 2011 +0100

    firewire: sbp2: fix panic after rmmod with slow targets
    
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

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 41841a3..17cef86 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1198,6 +1198,10 @@ static int sbp2_remove(struct device *dev)
 {
 	struct fw_unit *unit = fw_unit(dev);
 	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
+	struct sbp2_logical_unit *lu;
+
+	list_for_each_entry(lu, &tgt->lu_list, link)
+		cancel_delayed_work_sync(&lu->work);
 
 	sbp2_target_put(tgt);
 	return 0;

-- 
Stefan Richter
-=====-==-== =--- ==-==
http://arcgraph.de/sr/
