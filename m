Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab0H3LEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:04:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab0H3LEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:04:21 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: David Miller <davem@davemloft.net>
Subject: Re: aligned_{u64,be64,le64} defined in #ifdef __KERNEL__
Date: Mon, 30 Aug 2010 12:58:32 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; i686; ; )
Cc: netfilter@vger.kernel.org, eparis@redhat.com, linux-kernel@vger.kernel.org,
        schwab@redhat.com, Harald Welte <laforge@netfilter.org>,
        Andi Kleen <andi@firstfloor.org>
References: <1282682582-15980-1-git-send-email-eparis@redhat.com> <201008300326.30233.agruen@suse.de> <20100829.212156.229740543.davem@davemloft.net>
In-Reply-To: <20100829.212156.229740543.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201008301258.33113.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 August 2010 06:21:56 David Miller wrote:
> From: Andreas Gruenbacher <agruen@suse.de>
> Date: Mon, 30 Aug 2010 03:26:29 +0200
> 
> > On Saturday 28 August 2010 01:51:53 Eric Paris wrote:
> >> I liked this version until I realized that userspace doesn't have
> >> aligned_u64 as a valid type.
> > 
> > This looks like an error in include/linux/types.h.  The aligned types
> > should probably not be defined inside #ifdef __KERNEL__.
> 
> You can't do this, as it would pollute the POSIX namespace.

Good point.

> If we want a version of this type visible to userspace, it needs to,
> for example, have double underscores prepended to the type name just
> as we do for things like __u16 and __u32.

How about something like this?

Thanks,
Andreas

~

>From 3bec018a4835d4fdbe35595366a51bd09e3cc1d0 Mon Sep 17 00:00:00 2001
From: Andreas Gruenbacher <agruen@suse.de>
Date: Mon, 30 Aug 2010 12:51:01 +0200
Subject: [PATCH] Define __aligned_{u64,le64,be64} types with 8-byte alignment

Convert the existing #defines into typedefs, prepend two underscores to
avoid POSIX namespace pollution, and expose the types to user space.

These types are useful for enforcing the same alignment on 32-bit and
64-bit architectures.  (Some 32-bit architectures only align 64-bit
values on 4-byte boundaries by default.)

(The aligned types are used by some netfilter user-space headers
already.)

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
---
 include/linux/if_ppp.h                    |   16 +++++++-------
 include/linux/netfilter/nfnetlink_log.h   |    4 +-
 include/linux/netfilter/nfnetlink_queue.h |    4 +-
 include/linux/netfilter/xt_connbytes.h    |    4 +-
 include/linux/netfilter/xt_quota.h        |    2 +-
 include/linux/types.h                     |   10 ++++----
 include/scsi/scsi_tgt_if.h                |   30 ++++++++++++++--------------
 include/xen/interface/hvm/hvm_op.h        |    2 +-
 8 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/include/linux/if_ppp.h b/include/linux/if_ppp.h
index fcef103..c9ad383 100644
--- a/include/linux/if_ppp.h
+++ b/include/linux/if_ppp.h
@@ -114,14 +114,14 @@ struct pppol2tp_ioc_stats {
 	__u16		tunnel_id;	/* redundant */
 	__u16		session_id;	/* if zero, get tunnel stats */
 	__u32		using_ipsec:1;	/* valid only for session_id == 0 */
-	aligned_u64	tx_packets;
-	aligned_u64	tx_bytes;
-	aligned_u64	tx_errors;
-	aligned_u64	rx_packets;
-	aligned_u64	rx_bytes;
-	aligned_u64	rx_seq_discards;
-	aligned_u64	rx_oos_packets;
-	aligned_u64	rx_errors;
+	__aligned_u64	tx_packets;
+	__aligned_u64	tx_bytes;
+	__aligned_u64	tx_errors;
+	__aligned_u64	rx_packets;
+	__aligned_u64	rx_bytes;
+	__aligned_u64	rx_seq_discards;
+	__aligned_u64	rx_oos_packets;
+	__aligned_u64	rx_errors;
 };
 
 #define ifr__name       b.ifr_ifrn.ifrn_name
diff --git a/include/linux/netfilter/nfnetlink_log.h b/include/linux/netfilter/nfnetlink_log.h
index ea9b8d3..90c2c95 100644
--- a/include/linux/netfilter/nfnetlink_log.h
+++ b/include/linux/netfilter/nfnetlink_log.h
@@ -28,8 +28,8 @@ struct nfulnl_msg_packet_hw {
 };
 
 struct nfulnl_msg_packet_timestamp {
-	aligned_be64	sec;
-	aligned_be64	usec;
+	__aligned_be64	sec;
+	__aligned_be64	usec;
 };
 
 enum nfulnl_attr_type {
diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
index 2455fe5..af94e00 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -25,8 +25,8 @@ struct nfqnl_msg_packet_hw {
 };
 
 struct nfqnl_msg_packet_timestamp {
-	aligned_be64	sec;
-	aligned_be64	usec;
+	__aligned_be64	sec;
+	__aligned_be64	usec;
 };
 
 enum nfqnl_attr_type {
diff --git a/include/linux/netfilter/xt_connbytes.h b/include/linux/netfilter/xt_connbytes.h
index 92fcbb0..f1d6c15 100644
--- a/include/linux/netfilter/xt_connbytes.h
+++ b/include/linux/netfilter/xt_connbytes.h
@@ -17,8 +17,8 @@ enum xt_connbytes_direction {
 
 struct xt_connbytes_info {
 	struct {
-		aligned_u64 from;	/* count to be matched */
-		aligned_u64 to;		/* count to be matched */
+		__aligned_u64 from;	/* count to be matched */
+		__aligned_u64 to;	/* count to be matched */
 	} count;
 	__u8 what;		/* ipt_connbytes_what */
 	__u8 direction;	/* ipt_connbytes_direction */
diff --git a/include/linux/netfilter/xt_quota.h b/include/linux/netfilter/xt_quota.h
index b0d28c6..468c4e9 100644
--- a/include/linux/netfilter/xt_quota.h
+++ b/include/linux/netfilter/xt_quota.h
@@ -11,7 +11,7 @@ struct xt_quota_priv;
 struct xt_quota_info {
 	u_int32_t		flags;
 	u_int32_t		pad;
-	aligned_u64		quota;
+	__aligned_u64		quota;
 
 	/* Used internally by the kernel */
 	struct xt_quota_priv	*master;
diff --git a/include/linux/types.h b/include/linux/types.h
index 01a082f..1b17aa8 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -121,11 +121,6 @@ typedef		__u64		u_int64_t;
 typedef		__s64		int64_t;
 #endif
 
-/* this is a special 64bit data type that is 8-byte aligned */
-#define aligned_u64 __u64 __attribute__((aligned(8)))
-#define aligned_be64 __be64 __attribute__((aligned(8)))
-#define aligned_le64 __le64 __attribute__((aligned(8)))
-
 /**
  * The type used for indexing onto a disc or disc partition.
  *
@@ -178,6 +173,11 @@ typedef __u64 __bitwise __be64;
 typedef __u16 __bitwise __sum16;
 typedef __u32 __bitwise __wsum;
 
+/* special 64bit data types that are 8-byte aligned */
+typedef __u64 __aligned_u64 __attribute__((aligned(8)));
+typedef __be64 __aligned_be64 __attribute__((aligned(8)));
+typedef __le64 __aligned_le64 __attribute__((aligned(8)));
+
 #ifdef __KERNEL__
 typedef unsigned __bitwise__ gfp_t;
 typedef unsigned __bitwise__ fmode_t;
diff --git a/include/scsi/scsi_tgt_if.h b/include/scsi/scsi_tgt_if.h
index f2ee7c2..8f3c5e4 100644
--- a/include/scsi/scsi_tgt_if.h
+++ b/include/scsi/scsi_tgt_if.h
@@ -48,10 +48,10 @@ struct tgt_event {
 		struct {
 			int host_no;
 			int result;
-			aligned_u64 itn_id;
-			aligned_u64 tag;
-			aligned_u64 uaddr;
-			aligned_u64 sense_uaddr;
+			__aligned_u64 itn_id;
+			__aligned_u64 tag;
+			__aligned_u64 uaddr;
+			__aligned_u64 sense_uaddr;
 			uint32_t len;
 			uint32_t sense_len;
 			uint8_t rw;
@@ -59,13 +59,13 @@ struct tgt_event {
 		struct {
 			int host_no;
 			int result;
-			aligned_u64 itn_id;
-			aligned_u64 mid;
+			__aligned_u64 itn_id;
+			__aligned_u64 mid;
 		} tsk_mgmt_rsp;
 		struct {
 			__s32 host_no;
 			__s32 result;
-			aligned_u64 itn_id;
+			__aligned_u64 itn_id;
 			__u32 function;
 		} it_nexus_rsp;
 
@@ -73,30 +73,30 @@ struct tgt_event {
 		struct {
 			int host_no;
 			uint32_t data_len;
-			aligned_u64 itn_id;
+			__aligned_u64 itn_id;
 			uint8_t scb[16];
 			uint8_t lun[8];
 			int attribute;
-			aligned_u64 tag;
+			__aligned_u64 tag;
 		} cmd_req;
 		struct {
 			int host_no;
 			int result;
-			aligned_u64 itn_id;
-			aligned_u64 tag;
+			__aligned_u64 itn_id;
+			__aligned_u64 tag;
 		} cmd_done;
 		struct {
 			int host_no;
 			int function;
-			aligned_u64 itn_id;
-			aligned_u64 tag;
+			__aligned_u64 itn_id;
+			__aligned_u64 tag;
 			uint8_t lun[8];
-			aligned_u64 mid;
+			__aligned_u64 mid;
 		} tsk_mgmt_req;
 		struct {
 			__s32 host_no;
 			__u32 function;
-			aligned_u64 itn_id;
+			__aligned_u64 itn_id;
 			__u32 max_cmds;
 			__u8 initiator_id[16];
 		} it_nexus_req;
diff --git a/include/xen/interface/hvm/hvm_op.h b/include/xen/interface/hvm/hvm_op.h
index a4827f4..80c3141 100644
--- a/include/xen/interface/hvm/hvm_op.h
+++ b/include/xen/interface/hvm/hvm_op.h
@@ -38,7 +38,7 @@ struct xen_hvm_pagetable_dying {
     /* Domain with a pagetable about to be destroyed. */
     domid_t  domid;
     /* guest physical address of the toplevel pagetable dying */
-    aligned_u64 gpa;
+    __aligned_u64 gpa;
 };
 typedef struct xen_hvm_pagetable_dying xen_hvm_pagetable_dying_t;
 DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_pagetable_dying_t);
