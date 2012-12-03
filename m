Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2LCRNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:13:13 -0500
Received: from atl4mhob07.myregisteredsite.com ([209.17.115.45]:58841 "EHLO
	atl4mhob07.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754869Ab2LCRNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:13:11 -0500
Message-ID: <50BCDDB4.6010608@microgate.com>
Date: Mon, 03 Dec 2012 11:13:24 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Chen Gang <gang.chen@asianux.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] synclink fix ldisc buffer argument
References: <50B6E751.9000000@asianux.com> <20121129051335.GA4375@kroah.com> <50B6F967.3050000@asianux.com> <20121129183207.GA4688@kroah.com> <50B81F76.8020508@asianux.com> <50B8DDAC.8070901@microgate.com> <50B90D0D.9040401@microgate.com>
In-Reply-To: <50B90D0D.9040401@microgate.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix call to line discipline receive_buf by synclink drivers.
Dummy flag buffer argument is ignored by N_HDLC line discipline but might
be of insufficient size if accessed by a different line discipline
selected by mistake. flag buffer allocation now matches max size of data
buffer. Unused char_buf buffers are removed.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/pcmcia/synclink_cs.c	2012-11-26 14:15:45.000000000 -0600
+++ b/drivers/char/pcmcia/synclink_cs.c	2012-12-03 10:51:40.000000000 -0600
@@ -210,7 +210,7 @@ typedef struct _mgslpc_info {
 	char testing_irq;
 	unsigned int init_error;	/* startup error (DIAGS)	*/
 
-	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
+	char *flag_buf;
 	bool drop_rts_on_tx_done;
 
 	struct	_input_signal_events	input_signal_events;
@@ -2666,6 +2666,14 @@ static int rx_alloc_buffers(MGSLPC_INFO 
 	if (info->rx_buf == NULL)
 		return -ENOMEM;
 
+	/* unused flag buffer to satisfy receive_buf calling interface */
+	info->flag_buf = kzalloc(info->max_frame_size, GFP_KERNEL);
+	if (!info->flag_buf) {
+		kfree(info->rx_buf);
+		info->rx_buf = NULL;
+		return -ENOMEM;
+	}
+	
 	rx_reset_buffers(info);
 	return 0;
 }
@@ -2674,6 +2682,8 @@ static void rx_free_buffers(MGSLPC_INFO 
 {
 	kfree(info->rx_buf);
 	info->rx_buf = NULL;
+	kfree(info->flag_buf);
+	info->flag_buf = NULL;
 }
 
 static int claim_resources(MGSLPC_INFO *info)
--- a/drivers/tty/synclink.c	2012-11-26 14:15:45.000000000 -0600
+++ b/drivers/tty/synclink.c	2012-12-03 10:51:56.000000000 -0600
@@ -291,8 +291,7 @@ struct mgsl_struct {
 	bool lcr_mem_requested;
 
 	u32 misc_ctrl_value;
-	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
-	char char_buf[MAX_ASYNC_BUFFER_SIZE];	
+	char *flag_buf;
 	bool drop_rts_on_tx_done;
 
 	bool loopmode_insert_requested;
@@ -3891,7 +3890,13 @@ static int mgsl_alloc_intermediate_rxbuf
 	info->intermediate_rxbuffer = kmalloc(info->max_frame_size, GFP_KERNEL | GFP_DMA);
 	if ( info->intermediate_rxbuffer == NULL )
 		return -ENOMEM;
-
+	/* unused flag buffer to satisfy receive_buf calling interface */
+	info->flag_buf = kzalloc(info->max_frame_size, GFP_KERNEL);
+	if (!info->flag_buf) {
+		kfree(info->intermediate_rxbuffer);
+		info->intermediate_rxbuffer = NULL;
+		return -ENOMEM;
+	}
 	return 0;
 
 }	/* end of mgsl_alloc_intermediate_rxbuffer_memory() */
@@ -3910,6 +3915,8 @@ static void mgsl_free_intermediate_rxbuf
 {
 	kfree(info->intermediate_rxbuffer);
 	info->intermediate_rxbuffer = NULL;
+	kfree(info->flag_buf);
+	info->flag_buf = NULL;
 
 }	/* end of mgsl_free_intermediate_rxbuffer_memory() */
 
--- a/drivers/tty/synclinkmp.c	2012-11-26 14:15:45.000000000 -0600
+++ b/drivers/tty/synclinkmp.c	2012-12-03 10:52:09.000000000 -0600
@@ -262,8 +262,7 @@ typedef struct _synclinkmp_info {
 	bool sca_statctrl_requested;
 
 	u32 misc_ctrl_value;
-	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
-	char char_buf[MAX_ASYNC_BUFFER_SIZE];
+	char *flag_buf;
 	bool drop_rts_on_tx_done;
 
 	struct	_input_signal_events	input_signal_events;
@@ -3544,6 +3543,13 @@ static int alloc_tmp_rx_buf(SLMP_INFO *i
 	info->tmp_rx_buf = kmalloc(info->max_frame_size, GFP_KERNEL);
 	if (info->tmp_rx_buf == NULL)
 		return -ENOMEM;
+	/* unused flag buffer to satisfy receive_buf calling interface */
+	info->flag_buf = kzalloc(info->max_frame_size, GFP_KERNEL);
+	if (!info->flag_buf) {
+		kfree(info->tmp_rx_buf);
+		info->tmp_rx_buf = NULL;
+		return -ENOMEM;
+	}
 	return 0;
 }
 
@@ -3551,6 +3557,8 @@ static void free_tmp_rx_buf(SLMP_INFO *i
 {
 	kfree(info->tmp_rx_buf);
 	info->tmp_rx_buf = NULL;
+	kfree(info->flag_buf);
+	info->flag_buf = NULL;
 }
 
 static int claim_resources(SLMP_INFO *info)
--- a/drivers/tty/synclink_gt.c	2012-11-26 14:15:45.000000000 -0600
+++ b/drivers/tty/synclink_gt.c	2012-12-03 11:00:15.000000000 -0600
@@ -317,8 +317,7 @@ struct slgt_info {
 	unsigned char *tx_buf;
 	int tx_count;
 
-	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
-	char char_buf[MAX_ASYNC_BUFFER_SIZE];
+	char *flag_buf;
 	bool drop_rts_on_tx_done;
 	struct	_input_signal_events	input_signal_events;
 
@@ -3355,11 +3354,24 @@ static int block_til_ready(struct tty_st
 	return retval;
 }
 
+/*
+ * allocate buffers used for calling line discipline receive_buf
+ * directly in synchronous mode
+ * note: add 5 bytes to max frame size to allow appending
+ * 32-bit CRC and status byte when configured to do so
+ */
 static int alloc_tmp_rbuf(struct slgt_info *info)
 {
 	info->tmp_rbuf = kmalloc(info->max_frame_size + 5, GFP_KERNEL);
 	if (info->tmp_rbuf == NULL)
 		return -ENOMEM;
+	/* unused flag buffer to satisfy receive_buf calling interface */
+	info->flag_buf = kzalloc(info->max_frame_size + 5, GFP_KERNEL);
+	if (!info->flag_buf) {
+		kfree(info->tmp_rbuf);
+		info->tmp_rbuf = NULL;
+		return -ENOMEM;
+	}
 	return 0;
 }
 
@@ -3367,6 +3379,8 @@ static void free_tmp_rbuf(struct slgt_in
 {
 	kfree(info->tmp_rbuf);
 	info->tmp_rbuf = NULL;
+	kfree(info->flag_buf);
+	info->flag_buf = NULL;
 }
 
 /*

