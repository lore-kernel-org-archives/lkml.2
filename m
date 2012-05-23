Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412Ab2EWP1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:27:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40932 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456Ab2EWP1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:27:12 -0400
Date: Wed, 23 May 2012 08:26:31 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-e108c66e2c458f89931189a63a67ad16880d7f51@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, jolsa@redhat.com
In-Reply-To: <1337151548-2396-3-git-send-email-jolsa@redhat.com>
References: <1337151548-2396-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Carry perf_event_attr bitfield throught different endians
Git-Commit-ID: e108c66e2c458f89931189a63a67ad16880d7f51
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:26:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e108c66e2c458f89931189a63a67ad16880d7f51
Gitweb:     http://git.kernel.org/tip/e108c66e2c458f89931189a63a67ad16880d7f51
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 16 May 2012 08:59:03 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 12:48:24 -0300

perf tools: Carry perf_event_attr bitfield throught different endians

When the perf data file is read cross architectures, the
perf_event__attr_swap function takes care about endianness of all the
struct fields except the bitfield flags.

The bitfield flags need to be transformed as well, since the bitfield
binary storage differs for both endians.

ABI says:
  Bit-fields are allocated from right to left (least to most significant)
  on little-endian implementations and from left to right (most to least
  significant) on big-endian implementations.

The above seems to be byte specific, so we need to reverse each byte of
the bitfield. 'Internet' also says this might be implementation specific
and we probably need proper fix and carry perf_event_attr bitfield flags
in separate data file FEAT_ section. Thought this seems to work for now.

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
Reviewed-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337151548-2396-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
