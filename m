Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab0FKRSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 13:18:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16112 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab0FKRSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 13:18:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:date:message-id:user-agent:mime-version:
	content-type:content-transfer-encoding;
	b=wumKQtftaIWMzJvZLoXkzzRdr/DXzvet0yoVA1q29TTFeoWDjr03Gq3hdtUfEijFN
	ntUyhW9HzNe7XAiNomU6w==
Subject: [PATCH] Fix a race in pid generation that causes pids to be reused
	immediately.
To: peterz@infradead.org, linux-kernel@vger.kernel.org, tytso@google.com,
       akpm@linux-foundation.org, walken@google.com,
       torvalds@linux-foundation.org, mingo@elte.hu
From: Salman <sqazi@google.com>
Date: Fri, 11 Jun 2010 10:17:40 -0700
Message-ID: <20100611171603.23510.58768.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the whitespace issue that Michel pointed out.

Btw., who is responsible for ACKing this?

--

A program that repeatedly forks and waits is susceptible to having the
same pid repeated, especially when it competes with another instance of the
same program.  This is really bad for bash implementation.  Furthermore,
many shell scripts assume that pid numbers will not be used for some length
of time.

Race Description:

A                                    B

// pid == offset == n                // pid == offset == n + 1
test_and_set_bit(offset, map->page)
                                     test_and_set_bit(offset, map->page);
                                     pid_ns->last_pid = pid;
pid_ns->last_pid = pid;
                                     // pid == n + 1 is freed (wait())

                                     // Next fork()...
                                     last = pid_ns->last_pid; // == n
                                     pid = last + 1;

Code to reproduce it (Running multiple instances is more effective):

#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

// The distance mod 32768 between two pids, where the first pid is expected
// to be smaller than the second.
int PidDistance(pid_t first, pid_t second) {
  return (second + 32768 - first) % 32768;
}

int main(int argc, char* argv[]) {
  int failed = 0;
  pid_t last_pid = 0;
  int i;
  printf("%d\n", sizeof(pid_t));
  for (i = 0; i < 10000000; ++i) {
    if (i % 32786 == 0)
      printf("Iter: %d\n", i/32768);
    int child_exit_code = i % 256;
    pid_t pid = fork();
    if (pid == -1) {
      fprintf(stderr, "fork failed, iteration %d, errno=%d", i, errno);
      exit(1);
    }
    if (pid == 0) {
      // Child
      exit(child_exit_code);
    } else {
      // Parent
      if (i > 0) {
        int distance = PidDistance(last_pid, pid);
        if (distance == 0 || distance > 30000) {
          fprintf(stderr,
                  "Unexpected pid sequence: previous fork: pid=%d, "
                  "current fork: pid=%d for iteration=%d.\n",
                  last_pid, pid, i);
          failed = 1;
        }
      }
      last_pid = pid;
      int status;
      int reaped = wait(&status);
      if (reaped != pid) {
        fprintf(stderr,
                "Wait return value: expected pid=%d, "
                "got %d, iteration %d\n",
                pid, reaped, i);
        failed = 1;
      } else if (WEXITSTATUS(status) != child_exit_code) {
        fprintf(stderr,
                "Unexpected exit status %x, iteration %d\n",
                WEXITSTATUS(status), i);
        failed = 1;
      }
    }
  }
  exit(failed);
}


Thanks to Ted Tso for the key ideas of this implementation.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 kernel/pid.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index e9fd8c1..8e9067c 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -122,6 +122,20 @@ static void free_pidmap(struct upid *upid)
 	atomic_inc(&map->nr_free);
 }
 
+/*
+ * If we started walking pids at 'base', is 'a' seen before 'b'?
+ */
+static int pid_before(int base, int a, int b)
+{
+	/*
+	 * This is the same as saying
+	 *
+	 * (a - base + MAXUINT) % MAXUINT < (b - base + MAXUINT) % MAXUINT
+	 * and that mapping orders 'a' and 'b' with respect to 'base'.
+	 */
+	return (unsigned)(a - base) < (unsigned)(b - base);
+}
+
 static int alloc_pidmap(struct pid_namespace *pid_ns)
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
@@ -153,8 +167,32 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 		if (likely(atomic_read(&map->nr_free))) {
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
+					int prev;
+					int last_write = last;
 					atomic_dec(&map->nr_free);
-					pid_ns->last_pid = pid;
+
+					/*
+					 * We might be racing with someone else
+					 * trying to set pid_ns->last_pid.
+					 * We want the winner to have the
+					 * "later" value, because if the
+					 * "earlier" value prevails, then
+					 * a pid may get reused immediately.
+					 *
+					 * Since pids rollover, it is not
+					 * sufficent to just pick the bigger
+					 * value.  We have to consider
+					 * where we started counting from.
+					 */
+					do {
+						prev = last_write;
+						last_write = cmpxchg(
+							&pid_ns->last_pid,
+							prev, pid);
+					} while ((prev != last_write) &&
+						 (pid_before(last, last_write,
+						  pid)));
+
 					return pid;
 				}
 				offset = find_next_offset(map, offset);

