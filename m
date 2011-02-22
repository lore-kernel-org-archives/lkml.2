Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1BVRtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:49:12 -0500
Received: from mail-bw0-f51.google.com ([209.85.214.51]:51744 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1BVRtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:49:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=F8UMHCMOf9iSlhfBe2sV8Iq5PbZb1oM+peJokUegfcj6MM1zi15c27DC6JfChM6vEq
         0//aSFz1U3fBP5Wbb/u4b1Sic/bXBKwiPRVk6TZ2jnOd+NRLaCbO/XeGfE/pO/Fbz0ph
         Hr79CIZ2bfyUGsyKPVTuAo4rkQAmVKwaKvxfE=
Date: Tue, 22 Feb 2011 18:47:15 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] perf lock: fix sorting by wait_min
Message-ID: <20110222174715.GC9687@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if lock was uncontended, wait_time_min == ULLONG_MAX, so we need to handle
this case differently to show high wait times first

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 tools/perf/builtin-lock.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 0305a40..812ad26 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -202,9 +202,20 @@ static struct thread_stat *thread_stat_findnew_first(u32 tid)
 SINGLE_KEY(nr_acquired)
 SINGLE_KEY(nr_contended)
 SINGLE_KEY(wait_time_total)
-SINGLE_KEY(wait_time_min)
 SINGLE_KEY(wait_time_max)
 
+static int lock_stat_key_wait_time_min(struct lock_stat *one,
+					struct lock_stat *two)
+{
+	u64 s1 = one->wait_time_min;
+	u64 s2 = two->wait_time_min;
+	if (s1 == ULLONG_MAX)
+		s1 = 0;
+	if (s2 == ULLONG_MAX)
+		s2 = 0;
+	return s1 > s2;
+}
+
 struct lock_key {
 	/*
 	 * name: the value for specify by user
-- 
1.7.4.rc3

