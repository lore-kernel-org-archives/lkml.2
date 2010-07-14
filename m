Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab0GNWMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:12:24 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3840 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab0GNWMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:12:16 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH] trace-cmd: Don't try to read unmapped memory.
Date: Wed, 14 Jul 2010 15:12:10 -0700
Message-Id: <1279145530-782-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.6.1
X-OriginalArrivalTime: 14 Jul 2010 22:12:15.0576 (UTC) FILETIME=[9DE26D80:01CB23A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tracecmd_peek_data() reads the last event by calling
translate_data(), it will get type_len = 0, length = -4.  It had to
read 8 bytes of data, but it adjusts the index by -4, for a net
increment of 4.  The invariant that the index points to an entire
event ceases to hold.

If the index were already at the last event in the mapped area, a
subsequent tracecmd_peek_data() checks that the index is not beyond
the end of the mapping (which it isn't), but it assumes that the
entire event will fit (which it doesn't).  It then attempts to read an
entire event (8 bytes), but the last 4 bytes are now beyond the end of
the mapping causing a fault.

My fix is to keep the index pointing at the last record when the
negative length is encountered.

On my x86_64 workstation, the mappings of the trace data were always
contiguous with other mapped memory, so the reading of 4 bytes past the
end of the mapping always fell on another piece of mapped memory, so
no fault was produced.  Running under valgrind or on a MIPS64 host was
necessary to produce the fault.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 trace-input.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/trace-input.c b/trace-input.c
index 398d0f9..2ba346d 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -1530,6 +1530,18 @@ read_again:
 
 	type_len = translate_data(handle, &ptr, &extend, &length);
 
+	if (length < 0) {
+		/*
+		 * Negative length indicates the end.  Back up ptr so
+		 * subsequent reads don't fall off the end of the
+		 * mapping.
+		 */
+		ptr -= 8;
+		handle->cpu_data[cpu].index = calc_index(handle, ptr, cpu);
+		handle->cpu_data[cpu].next = NULL;
+		return NULL;
+	}
+
 	switch (type_len) {
 	case RINGBUF_TYPE_PADDING:
 		if (!extend) {
-- 
1.6.6.1

