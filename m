Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126Ab2DYLpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:45:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759086Ab2DYLpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:45:25 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] perf, tool: Carry perf_event_attr's bitfield throught endians
Date: Wed, 25 Apr 2012 13:45:01 +0200
Message-Id: <1335354301-5908-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1335354301-5908-1-git-send-email-jolsa@redhat.com>
References: <1335354301-5908-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the perf data file is read cross architectures, the perf_event__attr_swap
function takes care about endianness of all the perf_event_attr's struct fields
except for the bitfield flags.

Flags need to be transformed as well, since the bitfield binary storage differs
for both endians.

ABI says:
  Bit-fields are allocated from right to left (least to most significant)
  on little-endian implementations and from left to right (most to least
  significant) on big-endian implementations.

The above seems to be byte specific, so we need to reverse each
byte of the bitfield. 'Internet' also says this might be implementation
specific and we might probably need proper fix and carry perf_event_attr
bitfield flags in separate data file FEAT_ section. Thought this seems
to work for now.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/session.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1efd3be..c8a53fd 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -481,6 +481,39 @@ static void perf_event__read_swap(union perf_event *event)
 	event->read.id		 = bswap_64(event->read.id);
 }
 
+static u8 revbyte(u8 b)
+{
+	int rev = (b >> 4) | ((b & 0xf) << 4);
+
+	rev = ((rev & 0xcc) >> 2) | ((rev & 0x33) << 2);
+	rev = ((rev & 0xaa) >> 1) | ((rev & 0x55) << 1);
+	return (u8) rev;
+}
+
+/*
+ * XXX this is hack in attempt to carry flags bitfield
+ * throught endian village. ABI says:
+ *
+ * Bit-fields are allocated from right to left (least to most significant)
+ * on little-endian implementations and from left to right (most to least
+ * significant) on big-endian implementations.
+ *
+ * The above seems to be byte specific, so we need to reverse each
+ * byte of the bitfield. 'Internet' also says this might be implementation
+ * specific and we probably need proper fix and carry perf_event_attr
+ * bitfield flags in separate data file FEAT_ section. Thought this seems
+ * to work for now.
+ */
+static void swap_bitfield(u8 *p, unsigned len)
+{
+	unsigned i;
+
+	for (i = 0; i < len; i++) {
+		*p = revbyte(*p);
+		p++;
+	}
+}
+
 /* exported for swapping attributes in file header */
 void perf_event__attr_swap(struct perf_event_attr *attr)
 {
@@ -494,6 +527,8 @@ void perf_event__attr_swap(struct perf_event_attr *attr)
 	attr->bp_type		= bswap_32(attr->bp_type);
 	attr->bp_addr		= bswap_64(attr->bp_addr);
 	attr->bp_len		= bswap_64(attr->bp_len);
+
+	swap_bitfield((u8 *) (&attr->read_format + 1), sizeof(u64));
 }
 
 static void perf_event__hdr_attr_swap(union perf_event *event)
-- 
1.7.7.6

