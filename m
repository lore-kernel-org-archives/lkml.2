Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2FNIkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:40:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60704 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab2FNIk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:40:29 -0400
Date: Thu, 14 Jun 2012 01:40:14 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-25f42985825dd93f0593efe454e54c2aa13f7830@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, asharma@fb.com
In-Reply-To: <20120611134426.GA7542@quad>
References: <20120611134426.GA7542@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Fix broken LBR fixup code
Git-Commit-ID: 25f42985825dd93f0593efe454e54c2aa13f7830
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 14 Jun 2012 01:40:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25f42985825dd93f0593efe454e54c2aa13f7830
Gitweb:     http://git.kernel.org/tip/25f42985825dd93f0593efe454e54c2aa13f7830
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 11 Jun 2012 15:44:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Jun 2012 15:00:28 +0200

perf/x86: Fix broken LBR fixup code

I noticed that the LBR fixups were not working anymore
on programs where they used to. I tracked this down to
a recent change to copy_from_user_nmi():

 db0dc75d640 ("perf/x86: Check user address explicitly in copy_from_user_nmi()")

This commit added a call to __range_not_ok() to the
copy_from_user_nmi() routine. The problem is that the logic
of the test must be reversed. __range_not_ok() returns 0 if the
range is VALID. We want to return early from copy_from_user_nmi()
if the range is NOT valid.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arun Sharma <asharma@fb.com>
Link: http://lkml.kernel.org/r/20120611134426.GA7542@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/lib/usercopy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index 677b1ed..4f74d94 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -22,7 +22,7 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	void *map;
 	int ret;
 
-	if (__range_not_ok(from, n, TASK_SIZE) == 0)
+	if (__range_not_ok(from, n, TASK_SIZE))
 		return len;
 
 	do {
