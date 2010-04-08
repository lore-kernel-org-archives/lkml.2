Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644Ab0DHUuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:50:06 -0400
Received: from smtp-out.google.com ([74.125.121.35]:25199 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241Ab0DHUuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:50:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=ph+edP/O5podCRCgjRxjt8InFkJ90UUHkS3ChI3FwZkE+6gq1OXvaFp0ZZnEXdkSP
	qItSwCfnhwuGKjWsS34Og==
Message-ID: <4bbe4175.5124cc0a.5bd3.22d6@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Thu, 8 Apr 2010 22:45:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf_events: fix bogus warn_on(_once) in perf_prepare_sample()
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	There is a warn_on_once() check for PERF_SAMPLE_RAW which trips
	when using PEBS on both Core and Nehalem. Core PEBS sample size is 144
	bytes and 176 bytes for Nehalem. Both are multiples of 8, but the size
	field is encoded as int, thus the total is never a multiple of 8 which
	trips the check. I think the size should have been u64, but now it is
	too late to change given it is ABI.

	Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8143e77..fffeb95 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3311,7 +3311,6 @@ void perf_prepare_sample(struct perf_event_header *header,
 		else
 			size += sizeof(u32);
 
-		WARN_ON_ONCE(size & (sizeof(u64)-1));
 		header->size += size;
 	}
 
