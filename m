Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab1AOAFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 19:05:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320Ab1AOAFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 19:05:46 -0500
Date: Fri, 14 Jan 2011 16:05:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Jack Stone <jwjstone@fastmail.fm>, Viresh Kumar <viresh.kumar@st.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH resend] fs/eventpoll.c: fix compilation warning
Message-Id: <20110114160508.41105533.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikQwgzTZrTVQ_kfxwNdT-_8Ly5FjCxiXB2gxj3W@mail.gmail.com>
References: <1295005953-12173-1-git-send-email-viresh.kumar@st.com>
	<4D304A84.1000601@fastmail.fm>
	<AANLkTikQwgzTZrTVQ_kfxwNdT-_8Ly5FjCxiXB2gxj3W@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011 08:48:11 -0600
Shawn Bohrer <shawn.bohrer@gmail.com> wrote:

> On Fri, Jan 14, 2011 at 7:07 AM, Jack Stone <jwjstone@fastmail.fm> wrote:
> > [cc Al Viro and Shawn Bohrer]
> > On 14/01/2011 11:52, Viresh Kumar wrote:
> >> This patch fixes following compilation warning
> >> fs/eventpoll.c:1119: warning: 'slack' may be used uninitialized in this function
> >>
> >> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> >> ---
> >>  fs/eventpoll.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> >> index 8cf0724..89b5e98 100644
> >> --- a/fs/eventpoll.c
> >> +++ b/fs/eventpoll.c
> >> @@ -1116,7 +1116,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event  user *events,
> >>  {
> >>       int res, eavail, timed_out = 0;
> >>       unsigned long flags;
> >> -     long slack;
> >> +     long uninitialized_var(slack);
> >>       wait_queue_t wait;
> >>       struct timespec end_time;
> >>       ktime_t expires, *to = NULL;
> >
> > Hi Viresh,
> >
> > This is certainly the correct thing to do if timeout cannot be negative.
> >
> > Al, Shawn
> >
> > Can timeout be negative, and if so what does it mean?
> 
> Yes timeout can be negative.  When timeout is negative it signifies an
> infinite timeout.  Therefore I think the correct fix is to initialize
> slack to 0.  I actually sent a patch to fix this back in November, but
> it looks like it was never applied.
> 
> https://lkml.org/lkml/2010/11/27/143
> 
> Andrew, can you apply this patch?  Let me know if I need to resend.

I've looked at this warning several times - the code is non-buggy and
it's a bit sad to add extra instructions unnecessarily.  It would be
better to make this warning go away by cleaning up or restructuring the
code.  

And the code _is_ pretty stupid.  If timed_out is set to 1 then the
function does a great pile of useless junk.  I had a quick tinkle, made
things worse and gave up:

--- a/fs/eventpoll.c~a
+++ a/fs/eventpoll.c
@@ -1124,16 +1124,20 @@ static int ep_poll(struct eventpoll *ep,
 	struct timespec end_time;
 	ktime_t expires, *to = NULL;
 
-	if (timeout > 0) {
-		ktime_get_ts(&end_time);
-		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
-		slack = select_estimate_accuracy(&end_time);
-		to = &expires;
-		*to = timespec_to_ktime(end_time);
-	} else if (timeout == 0) {
-		timed_out = 1;
+	if (timeout == 0) {
+		/*
+		 * explanation of what timeout==0 means goes here
+		 */
+		spin_lock_irqsave(&ep->lock, flags);
+		goto skip;
 	}
 
+	ktime_get_ts(&end_time);
+	timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
+	slack = select_estimate_accuracy(&end_time);
+	to = &expires;
+	*to = timespec_to_ktime(end_time);
+
 retry:
 	spin_lock_irqsave(&ep->lock, flags);
 
@@ -1149,9 +1153,10 @@ retry:
 
 		for (;;) {
 			/*
-			 * We don't want to sleep if the ep_poll_callback() sends us
-			 * a wakeup in between. That's why we set the task state
-			 * to TASK_INTERRUPTIBLE before doing the checks.
+			 * We don't want to sleep if the ep_poll_callback()
+			 * sends us a wakeup in between. That's why we set the
+			 * task state to TASK_INTERRUPTIBLE before doing the
+			 * checks.
 			 */
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (!list_empty(&ep->rdllist) || timed_out)
@@ -1171,6 +1176,7 @@ retry:
 
 		set_current_state(TASK_RUNNING);
 	}
+skip:
 	/* Is it worth to try to dig for events ? */
 	eavail = !list_empty(&ep->rdllist) || ep->ovflist != EP_UNACTIVE_PTR;
 
_


but you get the idea ;)

I think the attempt to munge the "timeout==0" spacial case into the
main body of the polling loop was a mistake, and that the code would be
better/cleaner if that special case was handled quite separately.

