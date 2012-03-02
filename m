Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab2CBVXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:23:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763Ab2CBVXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:23:34 -0500
Date: Fri, 2 Mar 2012 13:23:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: ODEBUG: selftest warnings failed 4 != 5 (WARNING: at
 lib/debugobjects.c:908 check_results.constprop.9)
Message-Id: <20120302132332.f5d28264.akpm@linux-foundation.org>
In-Reply-To: <4F513995.6050509@codeaurora.org>
References: <20120218023521.GB13538@smp.if.uj.edu.pl>
	<CAFLxGvy0yWe2utG-+vFw4BhfH-i0vfjNy3k6kUsxkN7M4BSWQg@mail.gmail.com>
	<20120302131756.32e7f788.akpm@linux-foundation.org>
	<4F513995.6050509@codeaurora.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2012 13:20:21 -0800
Stephen Boyd <sboyd@codeaurora.org> wrote:

> > Dunno, sorry.  There are only two patches to bisect through - try
> > reverting b84d435cc228e ("debugobjects: Extend to assert that an object
> > is initialized") and then feac18dda25134 ("debugobjects: Be smarter
> > about static objects")?  
> 
> The fix is in -mm. Can we send the patch to Linus directly? Or perhaps
> go through Ingo since he sent the pull request in the first place?

Oh, OK, I had that queued for Thomas to mull over.  I'll send it in
for 3.3.


From: Stephen Boyd <sboyd@codeaurora.org>
Subject: debugobjects: Fix selftest for static warnings

debugobjects is now printing a warning when a fixup for a NOTAVAILABLE
object is run.  This causes the selftest to fail like:

[    0.000000] ODEBUG: selftest warnings failed 4 != 5

We could just increase the number of warnings that the selftest is
expecting to see because that is actually what has changed.  But, it turns
out that fixup_activate() was written with inverted logic and thus a fixup
for a static object returned 1 indicating the object had been fixed, and 0
otherwise.  Fix the logic to be correct and update the counts to reflect
that nothing needed fixing for a static object.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff -puN lib/debugobjects.c~debugobjects-fix-selftest-for-static-warnings lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-fix-selftest-for-static-warnings
+++ a/lib/debugobjects.c
@@ -818,17 +818,9 @@ static int __init fixup_activate(void *a
 		if (obj->static_init == 1) {
 			debug_object_init(obj, &descr_type_test);
 			debug_object_activate(obj, &descr_type_test);
-			/*
-			 * Real code should return 0 here ! This is
-			 * not a fixup of some bad behaviour. We
-			 * merily call the debug_init function to keep
-			 * track of the object.
-			 */
-			return 1;
-		} else {
-			/* Real code needs to emit a warning here */
+			return 0;
 		}
-		return 0;
+		return 1;
 
 	case ODEBUG_STATE_ACTIVE:
 		debug_object_deactivate(obj, &descr_type_test);
@@ -967,7 +959,7 @@ static void __init debug_objects_selftes
 
 	obj.static_init = 1;
 	debug_object_activate(&obj, &descr_type_test);
-	if (check_results(&obj, ODEBUG_STATE_ACTIVE, ++fixups, warnings))
+	if (check_results(&obj, ODEBUG_STATE_ACTIVE, fixups, warnings))
 		goto out;
 	debug_object_init(&obj, &descr_type_test);
 	if (check_results(&obj, ODEBUG_STATE_INIT, ++fixups, ++warnings))
_

