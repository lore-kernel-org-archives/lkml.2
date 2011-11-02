Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1KBI3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 04:29:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab1KBI3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 04:29:06 -0400
Message-ID: <4EB0FF81.90808@redhat.com>
Date: Wed, 02 Nov 2011 16:29:53 +0800
From: hank <pyu@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: oleg@redhat.com, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] set wo_stat to an init value in do_wait function
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 23323ae46453f506df6647715042483548ea149e Mon Sep 17 00:00:00 2001
From: hank <pyu@redhat.com>
Date: Wed, 2 Nov 2011 15:28:58 +0800
Subject: [PATCH 1/1] set wo_stat to an init value in do_wait function

When all of the below conditions become true:
1 parent fork a child
2 parent ignore SIGCHLD signal
3 parent call waitpid function
do_wait function won't touch the wo->stat variable.

Below is a test program can reproduce this problem:
========================================================

int main(int argc, char *argv[])
{
        int pid, child;
        int status;
        int *p;

        signal(SIGCHLD, SIG_IGN);

        child = fork();
        if (child == 0) {
                sleep(1);
                exit(0);
        } else if (child < 0) {
                perror("fork");
                exit(1);
        } else {
                status = 0xa5a5;
                p = &status;
                printf("status addr: %p\n", p);
                pid = waitpid(-1, &status, WUNTRACED);
                printf("pid=%d status=0x%x\n", pid, status);
                exit(0);
        }
        return 0;
}
========================================================

After run this program, we can see the value of status is still
0xa5a5,so kernel do not touch this value.
It may be dangerous. Because lots of programs such as 'su' don't set
an init value for the variable 'status' when it call waitpid function,
and after the waitpid function return, the program may check the value
of 'status' to see the state of child. If kernel don't set a value to
'status', it may be a random value.
Of course, it only happens when the father program ignore SIGCHLD
signal, and the father should not ignore this signal if it want to
check the state of its child. But maybe some other programs let the
father program ignore the SIGCHLD signal. For example, the grandfather
program ignore SIGCHLD signal and it fork the father program, so the
father program ignore SIGCHLD signal...

Signed-off-by: hank <pyu@redhat.com>
---
 kernel/exit.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index d0b7d98..972f5ae 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1683,6 +1683,12 @@ static long do_wait(struct wait_opts *wo)
 
 	trace_sched_process_wait(wo->wo_pid);
 
+	if (wo->wo_stat) {
+		retval = put_user(0, wo->wo_stat);
+		if (unlikely(retval))
+			return retval;
+	}
+
 	init_waitqueue_func_entry(&wo->child_wait, child_wait_callback);
 	wo->child_wait.private = current;
 	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
-- 
1.7.4.4

