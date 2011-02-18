Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1BRFyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 00:54:35 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:25319 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab1BRFx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 00:53:58 -0500
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.62,185,1297036800"; 
   d="scan'208";a="312084263"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@ghostprotocols.net,
        paulus@samba.org, David Ahern <daahern@cisco.com>
Subject: [PATCH 1/3] perf events: fix WARN_ON_ONCE for 64-bit raw data, SW events
Date: Thu, 17 Feb 2011 22:53:51 -0700
Message-Id: <1298008433-22911-2-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298008433-22911-1-git-send-email-daahern@cisco.com>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This check does not work out for 64-bit counter:

    sizeof(u32) + sizeof(u64) = 4 + 8 = 12

which does not pass the WARN_ON_ONCE test. I'm guessing (hoping
really) that the intent is that the size of the raw data is a
multiple of 4 bytes, not 8.

Signed-off-by: David Ahern <daahern@cisco.com>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a0a6987..3280671 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4351,7 +4351,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 		else
 			size += sizeof(u32);
 
-		WARN_ON_ONCE(size & (sizeof(u64)-1));
+		WARN_ON_ONCE(size & (sizeof(u32)-1));
 		header->size += size;
 	}
 }
-- 
1.7.3.4

