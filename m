Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab1DYUqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:46:39 -0400
Received: from 1wt.eu ([62.212.114.60]:34287 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255Ab1DYUYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:45 -0400
Message-Id: <20110425200235.817787956@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Yuansong Qiao <ysqiao@research.ait.ie>,
        Shuaijun Zhang <szhang@research.ait.ie>,
        Vlad Yasevich <vladislav.yasevich@hp.com>,
        "David S. Miller" <davem@davemloft.net>,
        maximilian attems <max@stro.at>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 065/173] sctp: Fix oops when sending queued ASCONF chunks
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vlad Yasevich <vladislav.yasevich@hp.com>

commit c0786693404cffd80ca3cb6e75ee7b35186b2825 upstream.

When we finish processing ASCONF_ACK chunk, we try to send
the next queued ASCONF.  This action runs the sctp state
machine recursively and it's not prepared to do so.

kernel BUG at kernel/timer.c:790!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/module/ipv6/initstate
Modules linked in: sha256_generic sctp libcrc32c ipv6 dm_multipath
uinput 8139too i2c_piix4 8139cp mii i2c_core pcspkr virtio_net joydev
floppy virtio_blk virtio_pci [last unloaded: scsi_wait_scan]

Pid: 0, comm: swapper Not tainted 2.6.34-rc4 #15 /Bochs
EIP: 0060:[<c044a2ef>] EFLAGS: 00010286 CPU: 0
EIP is at add_timer+0xd/0x1b
EAX: cecbab14 EBX: 000000f0 ECX: c0957b1c EDX: 03595cf4
ESI: cecba800 EDI: cf276f00 EBP: c0957aa0 ESP: c0957aa0
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process swapper (pid: 0, ti=c0956000 task=c0988ba0 task.ti=c0956000)
Stack:
 c0957ae0 d1851214 c0ab62e4 c0ab5f26 0500ffff 00000004 00000005 00000004
<0> 00000000 d18694fd 00000004 1666b892 cecba800 cecba800 c0957b14
00000004
<0> c0957b94 d1851b11 ceda8b00 cecba800 cf276f00 00000001 c0957b14
000000d0
Call Trace:
 [<d1851214>] ? sctp_side_effects+0x607/0xdfc [sctp]
 [<d1851b11>] ? sctp_do_sm+0x108/0x159 [sctp]
 [<d1863386>] ? sctp_pname+0x0/0x1d [sctp]
 [<d1861a56>] ? sctp_primitive_ASCONF+0x36/0x3b [sctp]
 [<d185657c>] ? sctp_process_asconf_ack+0x2a4/0x2d3 [sctp]
 [<d184e35c>] ? sctp_sf_do_asconf_ack+0x1dd/0x2b4 [sctp]
 [<d1851ac1>] ? sctp_do_sm+0xb8/0x159 [sctp]
 [<d1863334>] ? sctp_cname+0x0/0x52 [sctp]
 [<d1854377>] ? sctp_assoc_bh_rcv+0xac/0xe1 [sctp]
 [<d1858f0f>] ? sctp_inq_push+0x2d/0x30 [sctp]
 [<d186329d>] ? sctp_rcv+0x797/0x82e [sctp]

Tested-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Yuansong Qiao <ysqiao@research.ait.ie>
Signed-off-by: Shuaijun Zhang <szhang@research.ait.ie>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/sctp/command.h |    1 +
 net/sctp/sm_make_chunk.c   |   15 ---------------
 net/sctp/sm_sideeffect.c   |   26 ++++++++++++++++++++++++++
 net/sctp/sm_statefuns.c    |    8 +++++++-
 4 files changed, 34 insertions(+), 16 deletions(-)

Index: longterm-2.6.27/include/net/sctp/command.h
===================================================================
--- longterm-2.6.27.orig/include/net/sctp/command.h	2011-01-23 10:52:36.000000000 +0100
+++ longterm-2.6.27/include/net/sctp/command.h	2011-04-25 15:17:08.670279565 +0200
@@ -105,6 +105,7 @@
 	SCTP_CMD_ASSOC_SHKEY,    /* generate the association shared keys */
 	SCTP_CMD_T1_RETRAN,	 /* Mark for retransmission after T1 timeout  */
 	SCTP_CMD_UPDATE_INITTAG, /* Update peer inittag */
+	SCTP_CMD_SEND_NEXT_ASCONF, /* Send the next ASCONF after ACK */
 	SCTP_CMD_LAST
 } sctp_verb_t;
 
Index: longterm-2.6.27/net/sctp/sm_make_chunk.c
===================================================================
--- longterm-2.6.27.orig/net/sctp/sm_make_chunk.c	2011-01-23 10:52:39.000000000 +0100
+++ longterm-2.6.27/net/sctp/sm_make_chunk.c	2011-04-25 15:16:30.299279806 +0200
@@ -3342,21 +3342,6 @@
 	sctp_chunk_free(asconf);
 	asoc->addip_last_asconf = NULL;
 
-	/* Send the next asconf chunk from the addip chunk queue. */
-	if (!list_empty(&asoc->addip_chunk_list)) {
-		struct list_head *entry = asoc->addip_chunk_list.next;
-		asconf = list_entry(entry, struct sctp_chunk, list);
-
-		list_del_init(entry);
-
-		/* Hold the chunk until an ASCONF_ACK is received. */
-		sctp_chunk_hold(asconf);
-		if (sctp_primitive_ASCONF(asoc, asconf))
-			sctp_chunk_free(asconf);
-		else
-			asoc->addip_last_asconf = asconf;
-	}
-
 	return retval;
 }
 
Index: longterm-2.6.27/net/sctp/sm_sideeffect.c
===================================================================
--- longterm-2.6.27.orig/net/sctp/sm_sideeffect.c	2011-02-09 22:45:33.000000000 +0100
+++ longterm-2.6.27/net/sctp/sm_sideeffect.c	2011-04-25 15:16:30.304279699 +0200
@@ -630,6 +630,29 @@
 	}
 }
 
+/* Sent the next ASCONF packet currently stored in the association.
+ * This happens after the ASCONF_ACK was succeffully processed.
+ */
+static void sctp_cmd_send_asconf(struct sctp_association *asoc)
+{
+	/* Send the next asconf chunk from the addip chunk
+	 * queue.
+	 */
+	if (!list_empty(&asoc->addip_chunk_list)) {
+		struct list_head *entry = asoc->addip_chunk_list.next;
+		struct sctp_chunk *asconf = list_entry(entry,
+						struct sctp_chunk, list);
+		list_del_init(entry);
+
+		/* Hold the chunk until an ASCONF_ACK is received. */
+		sctp_chunk_hold(asconf);
+		if (sctp_primitive_ASCONF(asoc, asconf))
+			sctp_chunk_free(asconf);
+		else
+			asoc->addip_last_asconf = asconf;
+	}
+}
+
 
 /* Helper function to update the heartbeat timer. */
 static void sctp_cmd_hb_timer_update(sctp_cmd_seq_t *cmds,
@@ -845,6 +868,9 @@
 			sctp_add_cmd_sf(cmds, SCTP_CMD_TIMER_STOP,
 					SCTP_TO(SCTP_EVENT_TIMEOUT_T4_RTO));
 			break;
+		case SCTP_CMD_SEND_NEXT_ASCONF:
+			sctp_cmd_send_asconf(asoc);
+			break;
 		default:
 			break;
 		}
Index: longterm-2.6.27/net/sctp/sm_statefuns.c
===================================================================
--- longterm-2.6.27.orig/net/sctp/sm_statefuns.c	2011-01-23 10:52:39.000000000 +0100
+++ longterm-2.6.27/net/sctp/sm_statefuns.c	2011-04-25 15:16:30.312281199 +0200
@@ -3587,8 +3587,14 @@
 				SCTP_TO(SCTP_EVENT_TIMEOUT_T4_RTO));
 
 		if (!sctp_process_asconf_ack((struct sctp_association *)asoc,
-					     asconf_ack))
+					     asconf_ack)) {
+			/* Successfully processed ASCONF_ACK.  We can
+			 * release the next asconf if we have one.
+			 */
+			sctp_add_cmd_sf(commands, SCTP_CMD_SEND_NEXT_ASCONF,
+					SCTP_NULL());
 			return SCTP_DISPOSITION_CONSUME;
+		}
 
 		abort = sctp_make_abort(asoc, asconf_ack,
 					sizeof(sctp_errhdr_t));


