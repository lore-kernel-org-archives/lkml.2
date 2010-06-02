Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab0FBMUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:20:00 -0400
Received: from crca.org.au ([74.207.252.120]:46700 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab0FBMT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:19:58 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 01/21] Hibernation: Swap iteration functions.
Date: Wed,  2 Jun 2010 22:19:00 +1000
Message-Id: <1275481160-31150-2-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
References: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the data structure 'storage_position' and routines that allow
a caller to iterate over swap in sector order. Note that calling
reset_storage_pos only resets the position. next_swapdev_block
must also be called to get the address of the first (and subsequent
sectors).

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/swap.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index b0bb217..829f7b4 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -86,6 +86,45 @@ struct swsusp_extent {
 
 static struct rb_root swsusp_extents = RB_ROOT;
 
+struct storage_position {
+	struct rb_node *node;
+	struct swsusp_extent *cur_ext;
+	unsigned long offset;
+};
+
+static struct storage_position pos;
+
+static void reset_storage_pos(void)
+{
+	pos.node = rb_first(&swsusp_extents);
+
+	if (!pos.node) {
+		pos.cur_ext = NULL;
+		pos.offset = 0;
+		return;
+	}
+
+	pos.cur_ext = container_of(pos.node, struct swsusp_extent, node);
+	pos.offset = pos.cur_ext->start;
+}
+
+static sector_t next_swapdev_block(void)
+{
+	if (!pos.node)
+		return 0;
+
+	if (pos.cur_ext->end >= pos.offset)
+		return pos.offset++;
+
+	pos.node = rb_next(pos.node);
+	if (!pos.node)
+		return 0;
+
+	pos.cur_ext = container_of(pos.node, struct swsusp_extent, node);
+	pos.offset = pos.cur_ext->start;
+	return pos.offset;
+}
+
 static int swsusp_extents_insert(unsigned long swap_offset)
 {
 	struct rb_node **new = &(swsusp_extents.rb_node);
-- 
1.7.0.4

