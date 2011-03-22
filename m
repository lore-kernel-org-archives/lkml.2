Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab1CVVGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 17:06:35 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:58371 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab1CVVGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:06:32 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmxtMZ80VwmRVV7cZ5
X-RZG-CLASS-ID: mo00
Date: Tue, 22 Mar 2011 22:06:28 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hv: pass u32 to process_chn_event()
Message-ID: <20110322210627.GB17724@aepfle.de>
References: <20110322210207.GA17724@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110322210207.GA17724@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change types in vmbus_on_event() to u32 since the input is u32 as well.
Pass u32 to process_chn_event() instead of casting arg to void* and back.
Update printk to reflect type change.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
compile tested only.

 drivers/staging/hv/connection.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/staging/hv/connection.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/connection.c
+++ linux-2.6/drivers/staging/hv/connection.c
@@ -255,10 +255,9 @@ struct vmbus_channel *relid2channel(u32
 /*
  * process_chn_event - Process a channel event notification
  */
-static void process_chn_event(void *context)
+static void process_chn_event(u32 relid)
 {
 	struct vmbus_channel *channel;
-	u32 relid = (u32)(unsigned long)context;
 
 	/* ASSERT(relId > 0); */
 
@@ -276,7 +275,7 @@ static void process_chn_event(void *cont
 		 *			  (void*)channel);
 		 */
 	} else {
-		DPRINT_ERR(VMBUS, "channel not found for relid - %d.", relid);
+		DPRINT_ERR(VMBUS, "channel not found for relid - %u.", relid);
 	}
 }
 
@@ -285,10 +284,10 @@ static void process_chn_event(void *cont
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
@@ -300,14 +299,14 @@ void vmbus_on_event(unsigned long data)
 		for (bit = 0; bit < 32; bit++) {
 			if (sync_test_and_clear_bit(bit, (unsigned long *)&recv_int_page[dword])) {
 				relid = (dword << 5) + bit;
-				DPRINT_DBG(VMBUS, "event detected for relid - %d", relid);
+				DPRINT_DBG(VMBUS, "event detected for relid - %u", relid);
 
 				if (relid == 0) {
 					/* special case - vmbus channel protocol msg */
-					DPRINT_DBG(VMBUS, "invalid relid - %d", relid);
+					DPRINT_DBG(VMBUS, "invalid relid - %u", relid);
 					continue;
 				}
-				process_chn_event((void *) (unsigned long)relid);
+				process_chn_event(relid);
 			}
 		}
 	}
