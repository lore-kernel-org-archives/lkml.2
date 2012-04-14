Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab2DNQUz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:20:55 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41546 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2DNQUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:20:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, torvalds@linux-foundation.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC 5/7] fs: Silence bogus copy_to_user() build errors
Date: Sat, 14 Apr 2012 09:20:35 -0700
Message-Id: <1334420437-19264-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1334420437-19264-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120414161953.GA18140@linux.vnet.ibm.com>
 <1334420437-19264-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041416-2398-0000-0000-000005D1BC0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The copy_to_user() function now does some compile-time buffer-size
checks, but these checks can be fooled by pointers, which always
appear to be 4 or 8 bytes long for 32-bit and 64-bit builds, respectively.
Take care of the warnings in fs/binfmt_misc.c by invoking the underlying
_copy_to_user() function.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 fs/binfmt_misc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a9198df..e5ea8c3 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -310,7 +310,7 @@ static Node *create_entry(const char __user *buffer, size_t count)
 	p = buf = (char *)e + sizeof(Node);
 
 	memset(e, 0, sizeof(Node));
-	if (copy_from_user(buf, buffer, count))
+	if (_copy_from_user(buf, buffer, count))
 		goto Efault;
 
 	del = *p++;	/* delimeter */
@@ -418,7 +418,7 @@ static int parse_command(const char __user *buffer, size_t count)
 		return 0;
 	if (count > 3)
 		return -EINVAL;
-	if (copy_from_user(s, buffer, count))
+	if (_copy_from_user(s, buffer, count))
 		return -EFAULT;
 	if (s[count-1] == '\n')
 		count--;
-- 
1.7.8

