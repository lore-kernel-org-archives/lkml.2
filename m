Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab1HDGFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 02:05:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:7924 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1HDGFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 02:05:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=dKZ09ZINmfes4oqSnLVuzWf0B4SH6F4Vwh5Wl6tZ6WPrge6qtGhmxPh481upd+lK6
	Yiuvsr960C5I3eEoI1vcw==
Date: Wed, 3 Aug 2011 23:04:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] oom: change warning for deprecated oom_adj to avoid
 WARN_ONCE()
In-Reply-To: <20110803061016.GC16170@liondog.tnic>
Message-ID: <alpine.DEB.2.00.1108032258200.23444@chino.kir.corp.google.com>
References: <20110802005206.GA3832@tassilo.jf.intel.com> <alpine.DEB.2.00.1108011928530.15596@chino.kir.corp.google.com> <m2pqko1h38.fsf@firstfloor.org> <alpine.DEB.2.00.1108020236140.18935@chino.kir.corp.google.com> <20110803061016.GC16170@liondog.tnic>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Aug 2011, Borislav Petkov wrote:

> > oom: change warning for deprecated oom_adj to avoid WARN_ONCE()
> > 
> > WARN_ONCE() emits a stack trace to the kernel log which leads userspace 
> > parsers to interpret it as being a serious error or malfunction within the 
> > kernel.  Change the warning to appear more like a lockdep warning while 
> > still trying to preserve the intention of be8f684d73d8 (oom: make 
> > deprecated use of oom_adj more verbose) to attract more attention to the 
> > use of a deprecated interface.
> > 
> > Reported-by: Andi Kleen <andi@firstfloor.org>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > ---
> >  fs/proc/base.c |   13 ++++++++++---
> >  1 files changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -1066,6 +1066,7 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
> >  	char buffer[PROC_NUMBUF];
> >  	int oom_adjust;
> >  	unsigned long flags;
> > +	static bool warning_printed;
> >  	int err;
> >  
> >  	memset(buffer, 0, sizeof(buffer));
> > @@ -1118,9 +1119,15 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
> >  	 * Warn that /proc/pid/oom_adj is deprecated, see
> >  	 * Documentation/feature-removal-schedule.txt.
> >  	 */
> > -	WARN_ONCE(1, "%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
> > -		  current->comm, task_pid_nr(current), task_pid_nr(task),
> > -		  task_pid_nr(task));
> > +	if (!warning_printed) {
> > +		warning_printed = true;
> > +		printk("\n===============================================================================\n");
> > +		printk("%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
> > +			current->comm, task_pid_nr(current), task_pid_nr(task),
> > +			task_pid_nr(task));
> > +		printk("===============================================================================\n\n");
> 
> You're missing the KERN_WARNING level.

It's intentional because (i) I'm using a multi-line notification with 
newlines and (ii) I don't want to be considered as a kernel warning.  It's 
just for consumption by userspace and doesn't indicate a kernel issue.

> Why don't you use pr_warn_once +
> pr_cont_once? No need for the warning_printed too, it gets defined in
> another scope by the pr_warn_once macro automatically.
> 

Because using pr_warn_once + pr_cont_once for a multi-line notification is 
racy and I don't want three separated static variables?  pr_cont_once() 
shouldn't be used unless synchronized.
