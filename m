Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2L0CCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:02:07 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40272 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2L0CBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:01:05 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: [PATCH 31/32] mtip32xx: Convert to batch completion
Date: Wed, 26 Dec 2012 18:00:10 -0800
Message-Id: <1356573611-18590-34-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1356573611-18590-1-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/block/mtip32xx/mtip32xx.c | 68 ++++++++++++++++++---------------------
 drivers/block/mtip32xx/mtip32xx.h |  8 ++---
 2 files changed, 34 insertions(+), 42 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 9694dd9..5a9982b 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -159,11 +159,9 @@ static void mtip_command_cleanup(struct driver_data *dd)
 			command = &port->commands[commandindex];
 
 			if (atomic_read(&command->active)
-			    && (command->async_callback)) {
-				command->async_callback(command->async_data,
-					-ENODEV);
-				command->async_callback = NULL;
-				command->async_data = NULL;
+			    && (command->bio)) {
+				bio_endio(command->bio, -ENODEV);
+				command->bio = NULL;
 			}
 
 			dma_unmap_sg(&port->dd->pdev->dev,
@@ -603,11 +601,9 @@ static void mtip_timeout_function(unsigned long int data)
 			writel(1 << bit, port->completed[group]);
 
 			/* Call the async completion callback. */
-			if (likely(command->async_callback))
-				command->async_callback(command->async_data,
-							 -EIO);
-			command->async_callback = NULL;
-			command->comp_func = NULL;
+			if (likely(command->bio))
+				bio_endio(command->bio, -EIO);
+			command->bio = NULL;
 
 			/* Unmap the DMA scatter list entries */
 			dma_unmap_sg(&port->dd->pdev->dev,
@@ -675,7 +671,8 @@ static void mtip_timeout_function(unsigned long int data)
 static void mtip_async_complete(struct mtip_port *port,
 				int tag,
 				void *data,
-				int status)
+				int status,
+				struct batch_complete *batch)
 {
 	struct mtip_cmd *command;
 	struct driver_data *dd = data;
@@ -692,11 +689,10 @@ static void mtip_async_complete(struct mtip_port *port,
 	}
 
 	/* Upper layer callback */
-	if (likely(command->async_callback))
-		command->async_callback(command->async_data, cb_status);
+	if (likely(command->bio))
+		bio_endio_batch(command->bio, cb_status, batch);
 
-	command->async_callback = NULL;
-	command->comp_func = NULL;
+	command->bio = NULL;
 
 	/* Unmap the DMA scatter list entries */
 	dma_unmap_sg(&dd->pdev->dev,
@@ -729,24 +725,22 @@ static void mtip_async_complete(struct mtip_port *port,
 static void mtip_completion(struct mtip_port *port,
 			    int tag,
 			    void *data,
-			    int status)
+			    int status,
+			    struct batch_complete *batch)
 {
-	struct mtip_cmd *command = &port->commands[tag];
 	struct completion *waiting = data;
 	if (unlikely(status == PORT_IRQ_TF_ERR))
 		dev_warn(&port->dd->pdev->dev,
 			"Internal command %d completed with TFE\n", tag);
 
-	command->async_callback = NULL;
-	command->comp_func = NULL;
-
 	complete(waiting);
 }
 
 static void mtip_null_completion(struct mtip_port *port,
 			    int tag,
 			    void *data,
-			    int status)
+			    int status,
+			    struct batch_complete *batch)
 {
 	return;
 }
@@ -792,7 +786,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 		atomic_inc(&cmd->active); /* active > 1 indicates error */
 		if (cmd->comp_data && cmd->comp_func) {
 			cmd->comp_func(port, MTIP_TAG_INTERNAL,
-					cmd->comp_data, PORT_IRQ_TF_ERR);
+					cmd->comp_data, PORT_IRQ_TF_ERR, NULL);
 		}
 		goto handle_tfe_exit;
 	}
@@ -825,7 +819,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 				cmd->comp_func(port,
 					 tag,
 					 cmd->comp_data,
-					 0);
+					 0, NULL);
 			} else {
 				dev_err(&port->dd->pdev->dev,
 					"Missing completion func for tag %d",
@@ -912,7 +906,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 					if (cmd->comp_func) {
 						cmd->comp_func(port, tag,
 							cmd->comp_data,
-							-ENODATA);
+							-ENODATA, NULL);
 					}
 					continue;
 				}
@@ -942,7 +936,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 					port,
 					tag,
 					cmd->comp_data,
-					PORT_IRQ_TF_ERR);
+					PORT_IRQ_TF_ERR, NULL);
 			else
 				dev_warn(&port->dd->pdev->dev,
 					"Bad completion for tag %d\n",
@@ -969,6 +963,9 @@ static inline void mtip_process_sdbf(struct driver_data *dd)
 	int group, tag, bit;
 	u32 completed;
 	struct mtip_cmd *command;
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	/* walk all bits in all slot groups */
 	for (group = 0; group < dd->slot_groups; group++) {
@@ -997,7 +994,8 @@ static inline void mtip_process_sdbf(struct driver_data *dd)
 						port,
 						tag,
 						command->comp_data,
-						0);
+						0,
+						&batch);
 				} else {
 					dev_warn(&dd->pdev->dev,
 						"Null completion "
@@ -1007,12 +1005,14 @@ static inline void mtip_process_sdbf(struct driver_data *dd)
 					if (mtip_check_surprise_removal(
 						dd->pdev)) {
 						mtip_command_cleanup(dd);
-						return;
+						goto out;
 					}
 				}
 			}
 		}
 	}
+out:
+	batch_complete(&batch);
 }
 
 /*
@@ -1030,7 +1030,7 @@ static inline void mtip_process_legacy(struct driver_data *dd, u32 port_stat)
 			cmd->comp_func(port,
 				MTIP_TAG_INTERNAL,
 				cmd->comp_data,
-				0);
+				0, NULL);
 			return;
 		}
 	}
@@ -2441,8 +2441,8 @@ static int mtip_hw_ioctl(struct driver_data *dd, unsigned int cmd,
  *	None
  */
 static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
-			      int nsect, int nents, int tag, void *callback,
-			      void *data, int dir)
+			      int nsect, int nents, int tag,
+			      struct bio *bio, int dir)
 {
 	struct host_to_dev_fis	*fis;
 	struct mtip_port *port = dd->port;
@@ -2497,12 +2497,7 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
 	command->comp_func = mtip_async_complete;
 	command->direction = dma_dir;
 
-	/*
-	 * Set the completion function and data for the command passed
-	 * from the upper layer.
-	 */
-	command->async_data = data;
-	command->async_callback = callback;
+	command->bio = bio;
 
 	/*
 	 * To prevent this command from being issued
@@ -3672,7 +3667,6 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 				bio_sectors(bio),
 				nents,
 				tag,
-				bio_endio,
 				bio,
 				bio_data_dir(bio));
 	} else
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index b174264..5e094e8 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -296,11 +296,9 @@ struct mtip_cmd {
 	void (*comp_func)(struct mtip_port *port,
 				int tag,
 				void *data,
-				int status);
-	/* Additional callback function that may be called by comp_func() */
-	void (*async_callback)(void *data, int status);
-
-	void *async_data; /* Addl. data passed to async_callback() */
+				int status,
+				struct batch_complete *batch);
+	struct bio *bio;
 
 	int scatter_ents; /* Number of scatter list entries used */
 
-- 
1.7.12

