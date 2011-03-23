Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab1CWS3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 14:29:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42567 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab1CWS3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 14:29:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=K4oIA41e+40Cei0nkslW9LqOOctN+mR+qzO553xu65h72A6UKp/d/E+tXVbr5OFzDd
         1NCCfdL21oleFZA31euGt31UG8IhQAPLjELN9rBvRx8tV407ZWtAVciVrIYOLxTZ+hTo
         kQzI/NIIdvkt3JvPJfON6egsVZv3CU1zXsVMk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Stable <stable@kernel.org>
Subject: [PATCH] perf: Better fit max unprivileged mlock pages for tools needs
Date: Wed, 23 Mar 2011 19:29:39 +0100
Message-Id: <1300904979-5508-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maximum kilobytes of locked memory that an unprivileged user can
reserve is of 512 kB = 128 pages by default, scaled to the number of
onlined CPUs, which fits well with the tools that use 128 data pages
by default.

However tools actually use 129 pages, because they need one more for
the user control page. Thus the default mlock threshold is not
sufficient for the default tools needs and we always end up to
evaluate the constant mlock rlimit policy, which doesn't have this
scaling with the number of online CPUs.

Hence, on systems that have more than 16 CPUs, we overlap the rlimit
threshold and fail to mmap:

	$ perf record ls
	Error: failed to mmap with 1 (Operation not permitted)

Just increase the max unprivileged mlock threshold by one page so
that it supports well perf tools even after 16 CPUs.

Reported-by: Han Pingtian <phan@redhat.com>
Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>
Cc: Stable <stable@kernel.org>
---
 kernel/perf_event.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3472bb1..d5943b0 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -145,7 +145,8 @@ static struct srcu_struct pmus_srcu;
  */
 int sysctl_perf_event_paranoid __read_mostly = 1;
 
-int sysctl_perf_event_mlock __read_mostly = 512; /* 'free' kb per user */
+/* Minimum for 128 pages + 1 for the user control page */
+int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
 
 /*
  * max perf event sample rate
-- 
1.7.3.2

