Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1BFXqD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:46:03 -0500
Received: from 1wt.eu ([62.212.114.60]:60302 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab1BFXp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:45:59 -0500
Message-Id: <20110206232253.208964302@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:23:08 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 16/23] sctp: Fix a race between ICMP protocol unreachable and connect()
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vlad Yasevich <vladislav.yasevich@hp.com>

commit 50b5d6ad63821cea324a5a7a19854d4de1a0a819 upstream.

ICMP protocol unreachable handling completely disregarded
the fact that the user may have locked the socket.  It proceeded
to destroy the association, even though the user may have
held the lock and had a ref on the association.  This resulted
in the following:

Attempt to release alive inet socket f6afcc00

=========================
[ BUG: held lock freed! ]
-------------------------
somenu/2672 is freeing memory f6afcc00-f6afcfff, with a lock still held
there!
 (sk_lock-AF_INET){+.+.+.}, at: [<c122098a>] sctp_connect+0x13/0x4c
1 lock held by somenu/2672:
 #0:  (sk_lock-AF_INET){+.+.+.}, at: [<c122098a>] sctp_connect+0x13/0x4c

stack backtrace:
Pid: 2672, comm: somenu Not tainted 2.6.32-telco #55
Call Trace:
 [<c1232266>] ? printk+0xf/0x11
 [<c1038553>] debug_check_no_locks_freed+0xce/0xff
 [<c10620b4>] kmem_cache_free+0x21/0x66
 [<c1185f25>] __sk_free+0x9d/0xab
 [<c1185f9c>] sk_free+0x1c/0x1e
 [<c1216e38>] sctp_association_put+0x32/0x89
 [<c1220865>] __sctp_connect+0x36d/0x3f4
 [<c122098a>] ? sctp_connect+0x13/0x4c
 [<c102d073>] ? autoremove_wake_function+0x0/0x33
 [<c12209a8>] sctp_connect+0x31/0x4c
 [<c11d1e80>] inet_dgram_connect+0x4b/0x55
 [<c11834fa>] sys_connect+0x54/0x71
 [<c103a3a2>] ? lock_release_non_nested+0x88/0x239
 [<c1054026>] ? might_fault+0x42/0x7c
 [<c1054026>] ? might_fault+0x42/0x7c
 [<c11847ab>] sys_socketcall+0x6d/0x178
 [<c10da994>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002959>] syscall_call+0x7/0xb

This was because the sctp_wait_for_connect() would aqcure the socket
lock and then proceed to release the last reference count on the
association, thus cause the fully destruction path to finish freeing
the socket.

The simplest solution is to start a very short timer in case the socket
is owned by user.  When the timer expires, we can do some verification
and be able to do the release properly.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 include/net/sctp/sm.h      |    1 +
 include/net/sctp/structs.h |    3 +++
 net/sctp/input.c           |   22 ++++++++++++++++++----
 net/sctp/sm_sideeffect.c   |   35 +++++++++++++++++++++++++++++++++++
 net/sctp/transport.c       |    2 ++
 5 files changed, 59 insertions(+), 4 deletions(-)

Index: longterm-2.6.27/include/net/sctp/sm.h
===================================================================
--- longterm-2.6.27.orig/include/net/sctp/sm.h	2011-01-29 11:19:14.709063960 +0100
+++ longterm-2.6.27/include/net/sctp/sm.h	2011-01-29 11:27:18.740064435 +0100
@@ -277,6 +277,7 @@
 /* 2nd level prototypes */
 void sctp_generate_t3_rtx_event(unsigned long peer);
 void sctp_generate_heartbeat_event(unsigned long peer);
+void sctp_generate_proto_unreach_event(unsigned long peer);
 
 void sctp_ootb_pkt_free(struct sctp_packet *);
 
Index: longterm-2.6.27/include/net/sctp/structs.h
===================================================================
--- longterm-2.6.27.orig/include/net/sctp/structs.h	2011-01-29 11:19:14.713065031 +0100
+++ longterm-2.6.27/include/net/sctp/structs.h	2011-01-29 11:27:18.745065220 +0100
@@ -998,6 +998,9 @@
 	/* Heartbeat timer is per destination. */
 	struct timer_list hb_timer;
 
+	/* Timer to handle ICMP proto unreachable envets */
+	struct timer_list proto_unreach_timer;
+
 	/* Since we're using per-destination retransmission timers
 	 * (see above), we're also using per-destination "transmitted"
 	 * queues.  This probably ought to be a private struct
Index: longterm-2.6.27/net/sctp/input.c
===================================================================
--- longterm-2.6.27.orig/net/sctp/input.c	2011-01-29 11:19:14.722065417 +0100
+++ longterm-2.6.27/net/sctp/input.c	2011-01-29 11:27:18.751064926 +0100
@@ -425,11 +425,25 @@
 {
 	SCTP_DEBUG_PRINTK("%s\n",  __func__);
 
-	sctp_do_sm(SCTP_EVENT_T_OTHER,
-		   SCTP_ST_OTHER(SCTP_EVENT_ICMP_PROTO_UNREACH),
-		   asoc->state, asoc->ep, asoc, t,
-		   GFP_ATOMIC);
+	if (sock_owned_by_user(sk)) {
+		if (timer_pending(&t->proto_unreach_timer))
+			return;
+		else {
+			if (!mod_timer(&t->proto_unreach_timer,
+						jiffies + (HZ/20)))
+				sctp_association_hold(asoc);
+		}
 
+	} else {
+		if (timer_pending(&t->proto_unreach_timer) &&
+		    del_timer(&t->proto_unreach_timer))
+			sctp_association_put(asoc);
+
+		sctp_do_sm(SCTP_EVENT_T_OTHER,
+			   SCTP_ST_OTHER(SCTP_EVENT_ICMP_PROTO_UNREACH),
+			   asoc->state, asoc->ep, asoc, t,
+			   GFP_ATOMIC);
+	}
 }
 
 /* Common lookup code for icmp/icmpv6 error handler. */
Index: longterm-2.6.27/net/sctp/sm_sideeffect.c
===================================================================
--- longterm-2.6.27.orig/net/sctp/sm_sideeffect.c	2011-01-29 11:19:14.726064976 +0100
+++ longterm-2.6.27/net/sctp/sm_sideeffect.c	2011-01-29 11:27:18.754064379 +0100
@@ -397,6 +397,41 @@
 	sctp_transport_put(transport);
 }
 
+/* Handle the timeout of the ICMP protocol unreachable timer.  Trigger
+ * the correct state machine transition that will close the association.
+ */
+void sctp_generate_proto_unreach_event(unsigned long data)
+{
+	struct sctp_transport *transport = (struct sctp_transport *) data;
+	struct sctp_association *asoc = transport->asoc;
+
+	sctp_bh_lock_sock(asoc->base.sk);
+	if (sock_owned_by_user(asoc->base.sk)) {
+		SCTP_DEBUG_PRINTK("%s:Sock is busy.\n", __func__);
+
+		/* Try again later.  */
+		if (!mod_timer(&transport->proto_unreach_timer,
+				jiffies + (HZ/20)))
+			sctp_association_hold(asoc);
+		goto out_unlock;
+	}
+
+	/* Is this structure just waiting around for us to actually
+	 * get destroyed?
+	 */
+	if (asoc->base.dead)
+		goto out_unlock;
+
+	sctp_do_sm(SCTP_EVENT_T_OTHER,
+		   SCTP_ST_OTHER(SCTP_EVENT_ICMP_PROTO_UNREACH),
+		   asoc->state, asoc->ep, asoc, transport, GFP_ATOMIC);
+
+out_unlock:
+	sctp_bh_unlock_sock(asoc->base.sk);
+	sctp_association_put(asoc);
+}
+
+
 /* Inject a SACK Timeout event into the state machine.  */
 static void sctp_generate_sack_event(unsigned long data)
 {
Index: longterm-2.6.27/net/sctp/transport.c
===================================================================
--- longterm-2.6.27.orig/net/sctp/transport.c	2011-01-29 11:19:14.728063852 +0100
+++ longterm-2.6.27/net/sctp/transport.c	2011-01-29 11:27:18.758064715 +0100
@@ -107,6 +107,8 @@
 			(unsigned long)peer);
 	setup_timer(&peer->hb_timer, sctp_generate_heartbeat_event,
 			(unsigned long)peer);
+	setup_timer(&peer->proto_unreach_timer,
+		    sctp_generate_proto_unreach_event, (unsigned long)peer);
 
 	/* Initialize the 64-bit random nonce sent with heartbeat. */
 	get_random_bytes(&peer->hb_nonce, sizeof(peer->hb_nonce));


