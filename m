Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1DPQvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 12:51:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:50043 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab1DPQuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 12:50:50 -0400
Message-Id: <20110416165045.219471357@aepfle.de>
User-Agent: quilt/0.47-15.10
Date: Sat, 16 Apr 2011 18:50:40 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 2/5] hv: pass u32 to process_chn_event()
References: <20110416165038.986214764@aepfle.de>
Content-Disposition: inline; filename=bug679942-process_chn_event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change types in vmbus_on_event() to u32 since the input is u32 as well.
Pass u32 to process_chn_event() instead of casting arg to void* and back.
Update printk to reflect type change.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
compile tested.

 drivers/staging/hv/connection.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux-next/drivers/staging/hv/connection.c
===================================================================
--- linux-next.orig/drivers/staging/hv/connection.c
+++ linux-next/drivers/staging/hv/connection.c
@@ -250,10 +250,9 @@ struct vmbus_channel *relid2channel(u32
 /*
  * process_chn_event - Process a channel event notification
  */
-static void process_chn_event(void *context)
+static void process_chn_event(u32 relid)
 {
 	struct vmbus_channel *channel;
-	u32 relid = (u32)(unsigned long)context;
 
 	/* ASSERT(relId > 0); */
 
@@ -271,7 +270,7 @@ static void process_chn_event(void *cont
 		 *			  (void*)channel);
 		 */
 	} else {
-		pr_err("channel not found for relid - %d\n", relid);
+		pr_err("channel not found for relid - %u\n", relid);
 	}
 }
 
@@ -280,10 +279,10 @@ static void process_chn_event(void *cont
  */
 void vmbus_on_event(unsigned long data)
 {
-	int dword;
-	int maxdword = MAX_NUM_CHANNELS_SUPPORTED >> 5;
+	u32 dword;
+	u32 maxdword = MAX_NUM_CHANNELS_SUPPORTED >> 5;
 	int bit;
-	int relid;
+	u32 relid;
 	u32 *recv_int_page = vmbus_connection.recv_int_page;
 
 	/* Check events */
@@ -300,7 +299,7 @@ void vmbus_on_event(unsigned long data)
 					/* special case - vmbus channel protocol msg */
 					continue;
 				}
-				process_chn_event((void *) (unsigned long)relid);
+				process_chn_event(relid);
 			}
 		}
 	}

