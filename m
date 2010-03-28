Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0C1Ozi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 10:55:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51388 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0C1Ozf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 10:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H8Hnjvr5S0uK4/XYtoddKRnJ1z6hGb4+Om5TWF1P3MfzSZLmHqyUj/ou3q0ne9PnHD
         0eeEw7MiMfad12sxzkBxOTzJ7HuWumOrs+CL2Q0ZUd7FiUt7ReOK6cvm/mO72Gl8U7cp
         cXFeUAk1jHLP/v0ZGeXD7kHkb6mLJF3QH1Cf4=
Date: Sun, 28 Mar 2010 22:55:28 +0800
From: anfei <anfei.zhou@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rientjes@google.com,
       kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom killer: break from infinite loop
Message-ID: <20100328145528.GA14622@desktop>
References: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com>
 <20100326150805.f5853d1c.akpm@linux-foundation.org>
 <20100326223356.GA20833@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326223356.GA20833@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 11:33:56PM +0100, Oleg Nesterov wrote:
> On 03/26, Andrew Morton wrote:
> >
> > On Thu, 25 Mar 2010 00:25:05 +0800
> > Anfei Zhou <anfei.zhou@gmail.com> wrote:
> >
> > > --- a/mm/oom_kill.c
> > > +++ b/mm/oom_kill.c
> > > @@ -381,6 +381,8 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
> > >   */
> > >  static void __oom_kill_task(struct task_struct *p, int verbose)
> > >  {
> > > +	struct task_struct *t;
> > > +
> > >  	if (is_global_init(p)) {
> > >  		WARN_ON(1);
> > >  		printk(KERN_WARNING "tried to kill init!\n");
> > > @@ -412,6 +414,8 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
> > >  	 */
> > >  	p->rt.time_slice = HZ;
> > >  	set_tsk_thread_flag(p, TIF_MEMDIE);
> > > +	for (t = next_thread(p); t != p; t = next_thread(t))
> > > +		set_tsk_thread_flag(t, TIF_MEMDIE);
> > >
> > >  	force_sig(SIGKILL, p);
> >
> > Don't we need some sort of locking while walking that ring?
> 
> This should be always called under tasklist_lock, I think.
> At least this seems to be true in Linus's tree.
> 
Yes, this function is always called with read_lock(&tasklist_lock), so
it should be okay.

> I'd suggest to do
> 
> 	- set_tsk_thread_flag(p, TIF_MEMDIE);
> 	+ t = p;
> 	+ do {
> 	+	 set_tsk_thread_flag(t, TIF_MEMDIE);
> 	+ } while_each_thread(p, t);
> 
> but this is matter of taste.
> 
Yes, this is better.

> Off-topic, but we shouldn't use force_sig(), SIGKILL doesn't
> need "force" semantics.
> 
This may need a dedicated patch, there are some other places to
force_sig(SIGKILL, ...) too.

> I'd wish I could understand the changelog ;)
> 
Assume thread A and B are in the same group.  If A runs into the oom,
and selects B as the victim, B won't exit because at least in exit_mm(),
it can not get the mm->mmap_sem semaphore which A has already got.  So
no memory is freed, and no other task will be selected to kill.

I formatted the patch for -mm tree as David suggested.


---
 mm/oom_kill.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -418,8 +418,15 @@ static void dump_header(struct task_stru
  */
 static void __oom_kill_task(struct task_struct *p)
 {
+	struct task_struct *t;
+
 	p->rt.time_slice = HZ;
-	set_tsk_thread_flag(p, TIF_MEMDIE);
+
+	t = p;
+	do {
+		set_tsk_thread_flag(t, TIF_MEMDIE);
+	} while_each_thread(p, t);
+
 	force_sig(SIGKILL, p);
 }
 
