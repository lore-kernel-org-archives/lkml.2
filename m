Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0KCBbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 21:31:45 -0400
Received: from smtp-out.google.com ([74.125.121.35]:35554 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab0KCBaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 21:30:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=E1hpD1WQzla86kGJ+HMGUXnW93NRrADH6d8aMM3e0w53q/9fCct6Uqop/iRHLCO4e
	otoXjGEifJ+7V59MA1GKA==
Subject: [PATCH v1 06/12] netoops: Add x86 specific bits to packet headers
To: simon.kagstrom@netinsight.net, davem@davemloft.net
From: Mike Waychison <mikew@google.com>
Cc: adurbin@google.com, akpm@linux-foundation.org, chavey@google.com,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Date: Tue, 02 Nov 2010 18:30:01 -0700
Message-ID: <20101103013000.4641.50991.stgit@crlf.mtv.corp.google.com>
In-Reply-To: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to be able to gather information about the CPUs that caused the crash.

This commit only handles x86, but it is desirable to come up with some new
packet format that can accommodate any architecture.

Signed-off-by: Mike Waychison <mikew@google.com>
---
TODO: This should be made more general to other architectures.  As is, we are
probably okay exporting some value for the 'arch' field.  Different
architectures though will likely want to gather different data.
---
 drivers/net/netoops.c |   30 +++++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
index e9fdda3..0865212 100644
--- a/drivers/net/netoops.c
+++ b/drivers/net/netoops.c
@@ -55,16 +55,24 @@ struct netoops_msg {
 		u32 packet_count;
 		u32 packet_no;
 		u32 __reserved1;
-		u8 __reserved2;
-		u8 __reserved3;
-		u8 __reserved4;
+		u8 x86_family;
+		u8 x86_model;
+		u8 x86_stepping;
 		/*
 		 * NOTE: fixed length strings for a packet.  NULL
 		 * termination not required.
 		 */
 		char kernel_version[64];
-		char __reserved5[64];
-		char __reserved6[64];
+		char __reserved2[64];
+		char __reserved3[64];
+		/* NOTE: regs is 60 or 168 bytes */
+		struct pt_regs regs; /* arch specific. */
+		/*
+		 * NOTE: The header is potentially ~385 bytes
+		 * already.  That doesn't leave much room for
+		 * expansion unless we reduce the data size
+		 * or truncate above fields.
+		 */
 	} __attribute__ ((packed)) header;
 	char data[NETOOPS_DATA_BYTES];
 } __attribute__ ((packed));
@@ -302,7 +310,8 @@ static void get_netoops_dest(char *buff, int buffsize, u32 *dest, u32 *src)
 	spin_unlock_irqrestore(&netoops_lock, flags);
 }
 
-static void setup_packet_header(int packet_count, int soft_dump)
+static void setup_packet_header(int packet_count, struct pt_regs *regs,
+				int soft_dump)
 {
 	msg.header.version = NETOOPS_VERSION;
 	msg.header.arch = NETOOPS_ARCH;
@@ -311,10 +320,17 @@ static void setup_packet_header(int packet_count, int soft_dump)
 	msg.header.dump_id = (jiffies/HZ) & 0xffff;
 	msg.header.packet_count = packet_count;
 	msg.header.header_size = sizeof(msg.header);
+#ifndef CONFIG_UML
+	msg.header.x86_family = current_cpu_data.x86;
+	msg.header.x86_model = current_cpu_data.x86_model;
+	msg.header.x86_stepping = current_cpu_data.x86_mask;
+#endif
 	strncpy(msg.header.kernel_version,
 		utsname()->release,
 		min(sizeof(msg.header.kernel_version),
 		    sizeof(utsname()->release)));
+	if (regs != NULL)
+		memcpy(&msg.header.regs, regs, sizeof(msg.header.regs));
 }
 
 static int packet_count_from_length(unsigned long l)
@@ -403,7 +419,7 @@ static void netoops(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
 
 	/* setup the non varying parts of the message */
 	memset(&msg, 0, sizeof(msg));
-	setup_packet_header(packet_count_1 + packet_count_2, soft_dump);
+	setup_packet_header(packet_count_1 + packet_count_2, regs, soft_dump);
 
 	/* Transmission loop */
 	for (i = 0; i < NETOOPS_RETRANSMIT_COUNT; i++) {

