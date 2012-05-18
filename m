Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031058Ab2ERDEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:04:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40459 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762553Ab2ERCwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:35 -0400
Message-Id: <20120518023258.316703628@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mike Snitzer <snitzer@redhat.com>,
        Ben Marzinski <bmarzins@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 29/53] dm mpath: check if scsi_dh module already loaded before trying to load
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 510193a2d3d2e03ae53b95c0ae4f33cdff02cbf8 upstream.

If the requested scsi_dh module is already loaded then skip
request_module().

Multipath table loads can hang in an unnecessary __request_module.

Reported-by: Ben Marzinski <bmarzins@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-mpath.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 922a338..754f38f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -718,8 +718,8 @@ static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 		return 0;
 
 	m->hw_handler_name = kstrdup(dm_shift_arg(as), GFP_KERNEL);
-	request_module("scsi_dh_%s", m->hw_handler_name);
-	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
+	if (!try_then_request_module(scsi_dh_handler_exist(m->hw_handler_name),
+				     "scsi_dh_%s", m->hw_handler_name)) {
 		ti->error = "unknown hardware handler type";
 		ret = -EINVAL;
 		goto fail;
-- 
1.7.10



