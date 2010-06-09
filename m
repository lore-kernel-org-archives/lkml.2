Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab0FIMRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:17:20 -0400
Received: from thunk.org ([69.25.196.29]:36795 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187Ab0FIMRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:17:17 -0400
Date: Wed, 9 Jun 2010 08:17:06 -0400
From: tytso@mit.edu
To: Salman <sqazi@google.com>
Cc: peterz@infradead.org, mingo@elte.hu, akpm@inux-foundation.org,
       linux-kernel@vger.kernel.org, tytso@google.com
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-ID: <20100609121706.GD6529@thunk.org>
Mail-Followup-To: tytso@mit.edu, Salman <sqazi@google.com>,
	peterz@infradead.org, mingo@elte.hu, akpm@inux-foundation.org,
	linux-kernel@vger.kernel.org, tytso@google.com
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 11:24:38PM -0700, Salman wrote:

> A program that repeatedly forks and waits is susceptible to having
> the same pid repeated, especially when it competes with another
> instance of the same program.  This is really bad for bash
> implementation.  Furthermore, many shell scripts assume that pid
> numbers will not be used for some length of time.
> 
> Thanks to Ted Tso for the key ideas of this implementation.
> 
> Signed-off-by: Salman Qazi <sqazi@google.com>

Here's a slightly more succint way of expressing it.  Others will have
decide if it's easier to understand.  (It is for me, but I wrote it.  :-P)

       	       	      	 	      	  - Ted

 kernel/pid.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)
diff --git a/kernel/pid.c b/kernel/pid.c
index e9fd8c1..c51f413 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -154,8 +154,13 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
 					atomic_dec(&map->nr_free);
-					pid_ns->last_pid = pid;
-					return pid;
+					while (1) {
+						i = cmpxchg(&pid_ns->last_pid,
+							    last, pid);
+						if (i == last || i >= pid)
+							return pid;
+						last = i;
+					}
 				}
 				offset = find_next_offset(map, offset);
 				pid = mk_pid(pid_ns, map, offset);


