Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab2BIQpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:45:25 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36815 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2BIQpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:45:24 -0500
Date: Thu, 9 Feb 2012 20:45:19 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: [PATCH] sched: Turn lock_task_sighand() into a static inline
Message-ID: <20120209164519.GA10266@oksana.dev.rtsoft.ru>
References: <20120203163056.GA4190@redhat.com>
 <20120206162930.GA5117@oksana.dev.rtsoft.ru>
 <20120206163542.GA10104@kroah.com>
 <20120206185909.GB7741@oksana.dev.rtsoft.ru>
 <20120206191854.GA16702@kroah.com>
 <CAHGf_=r+nReQSfdvU7+FAhMRBkZPzQ2Jg6Puw9SmvW7WijpN7A@mail.gmail.com>
 <20120207044816.GA31271@oksana.dev.rtsoft.ru>
 <20120208152750.GA15782@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120208152750.GA15782@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that sparse tool understands static inline functions for
context balance checking, so let's turn the macros into an inline func.

This makes the code a little bit more robust.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---

On Wed, Feb 08, 2012 at 04:27:50PM +0100, Oleg Nesterov wrote:
> On 02/07, Anton Vorontsov wrote:
> >
> > On Mon, Feb 06, 2012 at 04:27:32PM -0500, KOSAKI Motohiro wrote:
> > >
> > > Some __cond_lock() caller are inline functions. Is this bad?
> >
> > No, that's great, actually. :-) Not obvious, but seems like
> > sparse understands __cond_lock in inline functions, so I'd
> > better use it.
> 
> Hmm, great...
> 
> may be you can update lock_task_sighand() too ? (in a separate
> patch of course).

Sure thing. Here it goes...

 include/linux/sched.h |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e82f721..22ae10e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2394,12 +2394,15 @@ static inline void task_unlock(struct task_struct *p)
 extern struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 							unsigned long *flags);
 
-#define lock_task_sighand(tsk, flags)					\
-({	struct sighand_struct *__ss;					\
-	__cond_lock(&(tsk)->sighand->siglock,				\
-		    (__ss = __lock_task_sighand(tsk, flags)));		\
-	__ss;								\
-})									\
+static inline struct sighand_struct *lock_task_sighand(struct task_struct *tsk,
+						       unsigned long *flags)
+{
+	struct sighand_struct *ret;
+
+	ret = __lock_task_sighand(tsk, flags);
+	(void)__cond_lock(&tsk->sighand->siglock, ret);
+	return ret;
+}
 
 static inline void unlock_task_sighand(struct task_struct *tsk,
 						unsigned long *flags)
-- 
1.7.8.3

