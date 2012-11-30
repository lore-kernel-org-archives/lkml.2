Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab2K3TqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:46:22 -0500
Received: from atl4mhob11.myregisteredsite.com ([209.17.115.49]:56121 "EHLO
	atl4mhob11.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab2K3TqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:46:19 -0500
Message-ID: <50B90D0D.9040401@microgate.com>
Date: Fri, 30 Nov 2012 13:46:21 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Chen Gang <gang.chen@asianux.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] synclink fix ldisc buffer argument
References: <50B6E751.9000000@asianux.com> <20121129051335.GA4375@kroah.com> <50B6F967.3050000@asianux.com> <20121129183207.GA4688@kroah.com> <50B81F76.8020508@asianux.com> <50B8DDAC.8070901@microgate.com>
In-Reply-To: <50B8DDAC.8070901@microgate.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix call to line discipline receive_buf by synclink drivers.
Dummy flag buffer argument is ignored by N_HDLC line discipline but might
be of insufficient size if accessed by a different line discipline
selected by mistake. Calls are changed to use data buffer argument for
both data and flag buffer so valid memory is provided if the wrong
line discipline is used. Unused char_buf and flag_buf are removed.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>


--- a/drivers/char/pcmcia/synclink_cs.c	2012-11-26 14:15:45.000000000 -0600
+++ b/drivers/char/pcmcia/synclink_cs.c	2012-11-30 12:50:23.000000000 -0600
@@ -210,7 +210,6 @@ typedef struct _mgslpc_info {
 	char testing_irq;
 	unsigned int init_error;	/* startup error (DIAGS)	*/
 
-	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
 	bool drop_rts_on_tx_done;
 
 	struct	_input_signal_events	input_signal_events;
@@ -3707,7 +3706,16 @@ static bool rx_get_frame(MGSLPC_INFO *in
 				hdlcdev_rx(info, buf->data, framesize);
 			else
 #endif
-				ldisc_receive_buf(tty, buf->data, info->flag_buf, framesize);
+			{
+				/*
+				 * Call N_HDLC line discipline directly to maintain
+				 * frame boundaries. Reuse the data buffer argument for the
+				 * flag buffer argument. The flag buffer is ignored by N_HDLC.
+				 * If a different line discipline is selected by mistake it
+				 * will have valid memory for both arguments.
+				 */
+				ldisc_receive_buf(tty, buf->data, buf->data, framesize);
+			}
 		}
 	}
 
--- a/drivers/tty/synclink.c	2012-11-26 14:15:45.000000000 -0600
+++ b/drivers/tty/synclink.c	2012-11-30 12:59:29.000000000 -0600
@@ -291,8 +291,6 @@ struct mgsl_struct {
 	bool lcr_mem_requested;
 
 	u32 misc_ctrl_value;
-	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
-	char char_buf[MAX_ASYNC_BUFFER_SIZE];	
 	bool drop_rts_on_tx_done;
 
 	bool loopmode_insert_requested;
@@ -6661,7 +6659,17 @@ static bool mgsl_get_rx_frame(struct mgs
 				hdlcdev_rx(info,info->intermediate_rxbuffer,framesize);
 			else
 #endif
-				ldisc_receive_buf(tty, info->intermediate_rxbuffer, info->flag_buf, framesize);
+			{
+				/*
+				 * Call N_HDLC line discipline directly to maintain
+				 * frame boundaries. Reuse the data buffer argument for the
+				 * flag buffer argument. The flag buffer is ignored by N_HDLC.
+				 * If a different line discipline is selected by mistake it
+				 * will have valid memory for both arguments.
+				 */
+				ldisc_receive_buf(tty, info->intermediate_rxbuffer,
+						  info->intermediate_rxbuffer, framesize);
+			}
 		}
 	}
 	/* Free the buffers used by this frame. */
@@ -6833,7 +6841,15 @@ static bool mgsl_get_raw_rx_frame(struct
 			memcpy( info->intermediate_rxbuffer, pBufEntry->virt_addr, framesize);
 			info->icount.rxok++;
 
-			ldisc_receive_buf(tty, info->intermediate_rxbuffer, info->flag_buf, framesize);
+			/*
+			 * Call N_HDLC line discipline directly to maintain
+			 * block boundaries. Reuse the data buffer argument for the
+			 * flag buffer argument. The flag buffer is ignored by N_HDLC.
+			 * If a different line discipline is selected by mistake it
+			 * will have valid memory for both arguments.
+			 */
+			ldisc_receive_buf(tty, info->intermediate_rxbuffer,
+					   info->intermediate_rxbuffer, framesize);
 		}
 
 		/* Free the buffers used by this frame. */
--- a/drivers/tty/synclinkmp.c	2012-11-26 14:15:45.000000000 -0600
+++ b/drivers/tty/synclinkmp.c	2012-11-30 13:01:36.000000000 -0600
@@ -262,8 +262,6 @@ typedef struct _synclinkmp_info {
 	bool sca_statctrl_requested;
 
 	u32 misc_ctrl_value;
-	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
-	char char_buf[MAX_ASYNC_BUFFER_SIZE];
 	bool drop_rts_on_tx_done;
 
 	struct	_input_signal_events	input_signal_events;
@@ -4979,8 +4977,17 @@ CheckAgain:
 				hdlcdev_rx(info,info->tmp_rx_buf,framesize);
 			else
 #endif
-				ldisc_receive_buf(tty,info->tmp_rx_buf,
-						  info->flag_buf, framesize);
+			{
+				/*
+				 * Call N_HDLC line discipline directly to maintain
+				 * frame boundaries. Reuse the data buffer argument for the
+				 * flag buffer argument. The flag buffer is ignored by N_HDLC.
+				 * If a different line discipline is selected by mistake it
+				 * will have valid memory for both arguments.
+				 */
+				ldisc_receive_buf(tty, info->tmp_rx_buf,
+						  info->tmp_rx_buf, framesize);
+			}
 		}
 	}
 	/* Free the buffers used by this frame. */
--- a/drivers/tty/synclink_gt.c	2012-11-26 14:15:45.000000000 -0600
+++ b/drivers/tty/synclink_gt.c	2012-11-30 12:53:25.000000000 -0600
@@ -317,8 +317,6 @@ struct slgt_info {
 	unsigned char *tx_buf;
 	int tx_count;
 
-	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
-	char char_buf[MAX_ASYNC_BUFFER_SIZE];
 	bool drop_rts_on_tx_done;
 	struct	_input_signal_events	input_signal_events;
 
@@ -4760,7 +4758,16 @@ check_again:
 				hdlcdev_rx(info,info->tmp_rbuf, framesize);
 			else
 #endif
-				ldisc_receive_buf(tty, info->tmp_rbuf, info->flag_buf, framesize);
+			{
+				/*
+				 * Call N_HDLC line discipline directly to maintain
+				 * frame boundaries. Reuse the data buffer argument for the
+				 * flag buffer argument. The flag buffer is ignored by N_HDLC.
+				 * If a different line discipline is selected by mistake it
+				 * will have valid memory for both arguments.
+				 */
+				ldisc_receive_buf(tty, info->tmp_rbuf, info->tmp_rbuf, framesize);
+			}
 		}
 	}
 	free_rbufs(info, start, end);
@@ -4793,9 +4800,17 @@ static bool rx_get_buf(struct slgt_info 
 	}
 	DBGDATA(info, info->rbufs[i].buf, count, "rx");
 	DBGINFO(("rx_get_buf size=%d\n", count));
-	if (count)
+	if (count) {
+		/*
+		 * Call N_HDLC line discipline directly to maintain
+		 * block boundaries. Reuse the data buffer argument for the
+		 * flag buffer argument. The flag buffer is ignored by N_HDLC.
+		 * If a different line discipline is selected by mistake it
+		 * will have valid memory for both arguments.
+		 */
 		ldisc_receive_buf(info->port.tty, info->rbufs[i].buf,
-				  info->flag_buf, count);
+				  info->rbufs[i].buf, count);
+	}
 	free_rbufs(info, i, i);
 	return true;
 }

