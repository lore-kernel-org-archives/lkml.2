Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab1BKGHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 01:07:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34553 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750981Ab1BKGHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 01:07:06 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+ks1FY0sqkq9c6y+44MN0D9ZfilDmjq+8UrLETQT
	ogXcElewk6tOZZ
Subject: [PATCH 30/28] kernel/user.c: add lock release annotation on
 free_user()
From: Mike Galbraith <efault@gmx.de>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <AANLkTimbHE9H5_vmS3=L84z=OkL0GNAxg4xOUjnco5SL@mail.gmail.com>
References: <1297340643.5512.1.camel@marge.simson.net>
	 <AANLkTikLM=Q_p0dk3USsYtLJ6GXKZsNoQuK3J+dA_z9V@mail.gmail.com>
	 <AANLkTimbHE9H5_vmS3=L84z=OkL0GNAxg4xOUjnco5SL@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 07:07:01 +0100
Message-ID: <1297404421.7865.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 19:35 +0100, Dhaval Giani wrote:
> >
> > There were a few more patches after this which cleaned up a few things
> > as well. Let me search them out and let you know the commit IDs.
> >

> 571428be550fbe37160596995e96ad398873fcbd

From: Namhyung Kim <namhyung@gmail.com>
Date: Tue, 26 Oct 2010 14:22:43 -0700
Subject: kernel/user.c: add lock release annotation on free_user()


commit 571428be550fbe37160596995e96ad398873fcbd upstream.

free_user() releases uidhash_lock but was missing annotation.  Add it.
This removes following sparse warnings:

 include/linux/spinlock.h:339:9: warning: context imbalance in 'free_user' - unexpected unlock
 kernel/user.c:120:6: warning: context imbalance in 'free_uid' - wrong count at exit

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/user.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 8e1c8c0..1b91701 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -91,6 +91,7 @@ static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
  * upon function exit.
  */
 static void free_user(struct user_struct *up, unsigned long flags)
+	__releases(&uidhash_lock)
 {
 	uid_hash_remove(up);
 	spin_unlock_irqrestore(&uidhash_lock, flags);


