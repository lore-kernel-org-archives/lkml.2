Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab0LTWjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 17:39:25 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15558 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0LTWjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 17:39:24 -0500
Date: Mon, 20 Dec 2010 23:30:38 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH][RFC] Always unlock 'tasklist_lock' in
 kernel/exit.c::do_wait()
Message-ID: <alpine.LNX.2.00.1012202324540.23785@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Coverity checker spotted this. I think it has a point, but I'm not 
intimate with this code so there could be somethingI'm missing.

It seems that kernel/exit.c::do_wait() does not always release 
'tasklist_lock'. There are multiple ways the code could be changed to make 
sure it's always released, I just picked the most straight forward one.

Does this look right to everyone else or is it just me?
I've only compile tested the patch so far.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 exit.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 676149a..456b13d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1647,12 +1647,16 @@ repeat:
 	tsk = current;
 	do {
 		retval = do_wait_thread(wo, tsk);
-		if (retval)
+		if (retval) {
+			read_unlock(&tasklist_lock);
 			goto end;
+		}
 
 		retval = ptrace_do_wait(wo, tsk);
-		if (retval)
+		if (retval) {
+			read_unlock(&tasklist_lock);
 			goto end;
+		}
 
 		if (wo->wo_flags & __WNOTHREAD)
 			break;



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

