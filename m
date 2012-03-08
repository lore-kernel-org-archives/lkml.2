Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab2CHSmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:42:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28869 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2CHSmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:42:40 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=WbakQ-yW8tIq98LSCMAA:9 a=WIdUc7wfisL1HtVBT2AA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331232159.25686.456.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 13:42:39 -0500
In-Reply-To: <1331231287.11248.396.camel@twins>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>
	 <1331230991.25686.452.camel@gandalf.stny.rr.com>
	 <1331231287.11248.396.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 19:28 +0100, Peter Zijlstra wrote:
> On Thu, 2012-03-08 at 13:23 -0500, Steven Rostedt wrote:
> > So basically what you tried to do was just set the owner of the lock to
> > have the priority of the task that wants the lock, until it releases it?
> > But by doing it without having this task sleep? 
> 
> No, by having it sleep ;-)
> 

That was the second part of my email.

> So you do the full PI sleeping lock thing, except you return fail if you
> loose the acquisition race on wakeup and you mark this waiter as
> 'special'.
> 
> Then on every rt_mutex block you have to do a deadlock analysis on the
> PI blocking chain (preferably shared with PI boost traversal of said
> chain), during that scan you collect all special tagged waiters.
> 
> If you find a deadlock, wake all these special waiters and have them
> return -EDEADLK.
> 
> I guess you could also do the full spin_deadlock() and do away with the
> try part and purely rely on the deadlock detection.

But do you release the lock first? For example, we have:

@@ -410,7 +411,7 @@ static inline struct dentry *dentry_kill
        if (inode && !spin_trylock(&inode->i_lock)) {
 relock:
                seq_spin_unlock(&dentry->d_lock);
-               cpu_relax();
+               cpu_chill();
                return dentry; /* try again with same dentry */
        }

By doing the test at the trylock, we can easily hit the deadlock,
because we still hold dentry->d_lock. But by moving the block to the
cpu_chill(), then we are less likely to hit the deadlock.

Perhaps call it, cpu_chill_on_lock().

-- Steve


