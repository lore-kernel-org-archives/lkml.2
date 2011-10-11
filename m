Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1JKRHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:07:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518Ab1JKRHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:07:10 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:11 2011
Message-Id: <20111011165711.350745036@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:30 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Richard Cochran <richard.cochran@omicron.at>,
        "David S. Miller" <davem@davemloft.net>
Subject: [20/38] ptp: fix L2 event message recognition
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Richard Cochran <richardcochran@gmail.com>

commit f75159e9936143177b442afc78150b7a7ad8aa07 upstream.

The IEEE 1588 standard defines two kinds of messages, event and general
messages. Event messages require time stamping, and general do not. When
using UDP transport, two separate ports are used for the two message
types.

The BPF designed to recognize event messages incorrectly classifies L2
general messages as event messages. This commit fixes the issue by
extending the filter to check the message type field for L2 PTP packets.
Event messages are be distinguished from general messages by testing
the "general" bit.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/ptp_classify.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -51,6 +51,7 @@
 #define PTP_CLASS_V2_VLAN (PTP_CLASS_V2 | PTP_CLASS_VLAN)
 
 #define PTP_EV_PORT 319
+#define PTP_GEN_BIT 0x08 /* indicates general message, if set in message type */
 
 #define OFF_ETYPE	12
 #define OFF_IHL		14
@@ -116,14 +117,20 @@ static inline int ptp_filter_init(struct
 	{OP_OR,		0,   0, PTP_CLASS_IPV6		}, /*              */ \
 	{OP_RETA,	0,   0, 0			}, /*              */ \
 /*L3x*/	{OP_RETK,	0,   0, PTP_CLASS_NONE		}, /*              */ \
-/*L40*/	{OP_JEQ,	0,   6, ETH_P_8021Q		}, /* f goto L50   */ \
+/*L40*/	{OP_JEQ,	0,   9, ETH_P_8021Q		}, /* f goto L50   */ \
 	{OP_LDH,	0,   0, OFF_ETYPE + 4		}, /*              */ \
-	{OP_JEQ,	0,   9, ETH_P_1588		}, /* f goto L60   */ \
+	{OP_JEQ,	0,  15, ETH_P_1588		}, /* f goto L60   */ \
+	{OP_LDB,	0,   0, ETH_HLEN + VLAN_HLEN	}, /*              */ \
+	{OP_AND,	0,   0, PTP_GEN_BIT		}, /*              */ \
+	{OP_JEQ,	0,  12, 0			}, /* f goto L6x   */ \
 	{OP_LDH,	0,   0, ETH_HLEN + VLAN_HLEN	}, /*              */ \
 	{OP_AND,	0,   0, PTP_CLASS_VMASK		}, /*              */ \
 	{OP_OR,		0,   0, PTP_CLASS_VLAN		}, /*              */ \
 	{OP_RETA,	0,   0, 0			}, /*              */ \
-/*L50*/	{OP_JEQ,	0,   4, ETH_P_1588		}, /* f goto L61   */ \
+/*L50*/	{OP_JEQ,	0,   7, ETH_P_1588		}, /* f goto L61   */ \
+	{OP_LDB,	0,   0, ETH_HLEN		}, /*              */ \
+	{OP_AND,	0,   0, PTP_GEN_BIT		}, /*              */ \
+	{OP_JEQ,	0,   4, 0			}, /* f goto L6x   */ \
 	{OP_LDH,	0,   0, ETH_HLEN		}, /*              */ \
 	{OP_AND,	0,   0, PTP_CLASS_VMASK		}, /*              */ \
 	{OP_OR,		0,   0, PTP_CLASS_L2		}, /*              */ \


