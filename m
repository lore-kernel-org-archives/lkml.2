Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2BBRRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:17:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47981 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab2BBRRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:17:04 -0500
Date: Thu, 2 Feb 2012 21:16:59 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>, Greg KH <gregkh@suse.de>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] staging: android/lowmemorykiller: Don't grab
 tasklist_lock
Message-ID: <20120202171659.GA29378@oksana.dev.rtsoft.ru>
References: <20120201043330.GA25511@oksana.dev.rtsoft.ru>
 <20120202125441.GA32229@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120202125441.GA32229@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 01:54:41PM +0100, Oleg Nesterov wrote:
> On 02/01, Anton Vorontsov wrote:
> >
> > @@ -132,7 +133,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
> >  	}
> >  	selected_oom_adj = min_adj;
> >
> > -	read_lock(&tasklist_lock);
> > +	rcu_read_lock();
> 
> This has the same problem, force_sig() becomes unsafe.

Ouch, I think I finally got it. So, lock_task_sighand() is trying to
gracefully grab the lock, checking if the sighand is not NULL (which means,
per __exit_signal(), that the task is halfway into the grave).

Well, it seems that such a behaviour of force_sig() is not quite obvious,
and there are other offenders out there. E.g. in sysrq code I don't see
anything that prevent the same race.

static void send_sig_all(int sig)
{      
        struct task_struct *p;

        for_each_process(p) {
                if (p->mm && !is_global_init(p))
                        /* Not swapper, init nor kernel thread */
                        force_sig(sig, p);
        }
}

Would the following fix work for the sysrq?

- - - -
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [PATCH] sysrq: Fix unsafe operations on tasks

sysrq should grab the tasklist lock, otherwise calling force_sig() is
not safe, as it might race with exiting task, which ->sighand might be
set to NULL already.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/tty/sysrq.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 7867b7c..a1bcad7 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -322,11 +322,13 @@ static void send_sig_all(int sig)
 {
 	struct task_struct *p;
 
+	read_lock(&tasklist_lock);
 	for_each_process(p) {
 		if (p->mm && !is_global_init(p))
 			/* Not swapper, init nor kernel thread */
 			force_sig(sig, p);
 	}
+	read_unlock(&tasklist_lock);
 }
 
 static void sysrq_handle_term(int key)
- - - -

But for LMK I will use send_signal(), as LMK is special.

Plus, while I'm at it, might want to review a bit closer other offenders,
and fix them as well.

> Why do you need force_? Do you really want to kill /sbin/init (or sub-namespace
> init) ?

Nope.

> We could change force_sig_info() to use lock_task_sighand(), but I'd like to
> avoid this. Imho, this interface should be cleanuped, and it should be used
> for synchronous signals only.

OK. Then we should fix the users?

> With or without this patch, sig == NULL is not possible but !mm is not right,
> there could be other other threads with mm != NULL.

I'm not sure I completely follow. In the current LMK code, we check for !mm
because otherwise the potential victim is useless for us (i.e. killing it
will not free much memory anyway).

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
