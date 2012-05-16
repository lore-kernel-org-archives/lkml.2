Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab2EPG7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:59:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759428Ab2EPG7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:59:33 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/7] perf, tool: Carry perf_event_attr bitfield throught different endians
Date: Wed, 16 May 2012 08:59:03 +0200
Message-Id: <1337151548-2396-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337151548-2396-1-git-send-email-jolsa@redhat.com>
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the perf data file is read cross architectures, the perf_event__attr_swap
function takes care about endianness of all the struct fields except the
bitfield flags.

The bitfield flags need to be transformed as well, since the bitfield
binary storage differs for both endians.

ABI says:
  Bit-fields are allocated from right to left (least to most significant)
  on little-endian implementations and from left to right (most to least
  significant) on big-endian implementations.

The above seems to be byte specific, so we need to reverse each
byte of the bitfield. 'Internet' also says this might be implementation
specific and we probably need proper fix and carry perf_event_attr
bitfield flags in separate data file FEAT_ section. Thought this seems
to work for now.

Note, running following to test perf endianity handling:
test 1)
  - origin system:
    # perf record -a -- sleep 10 (any perf record will do)
    # perf report > report.origin
    # perf archive perf.data

  - copy the perf.data, report.origin and perf.data.tar.bz2
    to a target system and run:
    # tar xjvf perf.data.tar.bz2 -C ~/.debug
    # perf report > report.target
    # diff -u report.origin report.target

  - the diff should produce no output
    (besides some white space stuff and possibly different
     date/TZ output)

test 2)
  - origin system:
    # perf record -ag -fo /tmp/perf.data -- sleep 1
  - mount origin system root to the target system on /mnt/origin
  - target system:
    # perf script --symfs /mnt/origin -I -i /mnt/origin/tmp/perf.data \
     --kallsyms /mnt/origin/proc/kallsyms
  - complete perf.data header is displayed

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/session.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4dcc8f3..17c9ace 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -481,6 +481,38 @@ static void perf_event__read_swap(union perf_event *event)
 	event->read.id		 = bswap_64(event->read.id);
 }
 
+static u8 revbyte(u8 b)
+{
+	int rev = (b >> 4) | ((b & 0xf) << 4);
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
@@ -494,6 +526,8 @@ void perf_event__attr_swap(struct perf_event_attr *attr)
 	attr->bp_type		= bswap_32(attr->bp_type);
 	attr->bp_addr		= bswap_64(attr->bp_addr);
 	attr->bp_len		= bswap_64(attr->bp_len);
+
+	swap_bitfield((u8 *) (&attr->read_format + 1), sizeof(u64));
 }
 
 static void perf_event__hdr_attr_swap(union perf_event *event)
-- 
1.7.7.6

