Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab2HUNFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:05:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45218 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2HUNFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:05:21 -0400
Subject: [PATCH] task_work: add a scheduling point in task_work_run()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
In-Reply-To: <1341240603.2086.1.camel@falcor>
References: <1341014197.2342.7.camel@falcor.watson.ibm.com>
	 <20120630050238.GZ14083@ZenIV.linux.org.uk>
	 <1341172202.2556.13.camel@falcor>
	 <20120701205722.GD22927@ZenIV.linux.org.uk>
	 <1341193591.2249.3.camel@falcor>
	 <20120702034310.GE22927@ZenIV.linux.org.uk>
	 <20120702051155.GF22927@ZenIV.linux.org.uk>
	 <1341229790.2350.1.camel@falcor>
	 <20120702120259.GG22927@ZenIV.linux.org.uk>
	 <1341234091.2166.5.camel@falcor>
	 <20120702133329.GH22927@ZenIV.linux.org.uk>
	 <1341240603.2086.1.camel@falcor>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Aug 2012 15:05:14 +0200
Message-ID: <1345554314.5158.490.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

It seems commit 4a9d4b02 (switch fput to task_work_add) reintroduced
the problem addressed in commit 944be0b2 (close_files(): add scheduling
point)

If a server process with a lot of files (say 2 million tcp sockets)
is killed, we can spend a lot of time in task_work_run() and trigger
a soft lockup.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 kernel/task_work.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 91d4e17..d320d44 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -75,6 +75,7 @@ void task_work_run(void)
 			p = q->next;
 			q->func(q);
 			q = p;
+			cond_resched();
 		}
 	}
 }


