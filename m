Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab0FIGYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 02:24:55 -0400
Received: from smtp-out.google.com ([74.125.121.35]:25915 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab0FIGYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 02:24:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding;
	b=lylo4BNuu7X2SGABa8P1ddY2DLHysT6WdvGG51KsuHjHADcUEilyIlUYycxI+bplY
	r9m3S4fnC2vUQjPn4HvUA==
Subject: [PATCH] Fix a race in pid generation that causes pids to be reused
	immediately.
To: peterz@infradead.org, mingo@elte.hu, akpm@inux-foundation.org,
       linux-kernel@vger.kernel.org
From: Salman <sqazi@google.com>
Cc: tytso@google.com
Date: Tue, 08 Jun 2010 23:24:38 -0700
Message-ID: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A program that repeatedly forks and waits is susceptible to having the
same pid repeated, especially when it competes with another instance of the
same program.  This is really bad for bash implementation.  Furthermore, many shell
scripts assume that pid numbers will not be used for some length of time.

Thanks to Ted Tso for the key ideas of this implementation.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 kernel/pid.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index e9fd8c1..8cedeab 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -153,8 +153,17 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 		if (likely(atomic_read(&map->nr_free))) {
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
+					int prev;
 					atomic_dec(&map->nr_free);
-					pid_ns->last_pid = pid;
+
+					do {
+						prev = last;
+						last = cmpxchg(&pid_ns->last_pid,
+							       prev, pid);
+						if (last >= pid)
+							break;
+					} while (prev != last);
+
 					return pid;
 				}
 				offset = find_next_offset(map, offset);

