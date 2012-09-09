Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2IIXVf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:21:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51561 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756451Ab2IIXRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:18 -0400
Message-Id: <20120909224156.044758790@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yi Zou <yi.zou@intel.com>,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Open-FCoE.org" <devel@open-fcoe.org>
Subject: [ 38/95] target: fix NULL pointer dereference bug alloc_page() fails to get
 memory
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Zou <yi.zou@intel.com>

commit d0e27c88d795fb9647153063ec48051fd84e1731 upstream.

I am hitting this bug when the target is low in memory that fails the
alloc_page() for the newly submitted command. This is a sort of off-by-one
bug causing NULL pointer dereference in __free_page() since 'i' here is
really the counter of total pages that have been successfully allocated here.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Cc: Andy Grover <agrover@redhat.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Open-FCoE.org <devel@open-fcoe.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_transport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0eaae23..a7589cc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2294,9 +2294,9 @@ transport_generic_get_mem(struct se_cmd *cmd)
 	return 0;
 
 out:
-	while (i >= 0) {
-		__free_page(sg_page(&cmd->t_data_sg[i]));
+	while (i > 0) {
 		i--;
+		__free_page(sg_page(&cmd->t_data_sg[i]));
 	}
 	kfree(cmd->t_data_sg);
 	cmd->t_data_sg = NULL;


