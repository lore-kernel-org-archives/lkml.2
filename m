Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1HRTPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:15:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48420 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab1HRTMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:12:40 -0400
Date: Thu, 18 Aug 2011 20:12:39 +0100
To: richard@nod.at
Subject: Subject: [PATCH 82/91] um: kill useless argument of free_chan()
 and free_one_chan()
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu819-00085K-Vv@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


delay_free_irq is always 0 for those...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/drivers/chan_kern.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index e040683..420e2c8 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -358,11 +358,11 @@ int chan_window_size(struct list_head *chans, unsigned short *rows_out,
 	return 0;
 }
 
-static void free_one_chan(struct chan *chan, int delay_free_irq)
+static void free_one_chan(struct chan *chan)
 {
 	list_del(&chan->list);
 
-	close_one_chan(chan, delay_free_irq);
+	close_one_chan(chan, 0);
 
 	if (chan->ops->free != NULL)
 		(*chan->ops->free)(chan->data);
@@ -372,14 +372,14 @@ static void free_one_chan(struct chan *chan, int delay_free_irq)
 	kfree(chan);
 }
 
-static void free_chan(struct list_head *chans, int delay_free_irq)
+static void free_chan(struct list_head *chans)
 {
 	struct list_head *ele, *next;
 	struct chan *chan;
 
 	list_for_each_safe(ele, next, chans) {
 		chan = list_entry(ele, struct chan, list);
-		free_one_chan(chan, delay_free_irq);
+		free_one_chan(chan);
 	}
 }
 
@@ -547,7 +547,7 @@ int parse_chan_pair(char *str, struct line *line, int device,
 	char *in, *out;
 
 	if (!list_empty(chans)) {
-		free_chan(chans, 0);
+		free_chan(chans);
 		INIT_LIST_HEAD(chans);
 	}
 
-- 
1.7.2.5


