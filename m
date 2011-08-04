Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1HDHsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 03:48:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49879 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab1HDHs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 03:48:26 -0400
Date: Thu, 4 Aug 2011 09:48:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] oom: change warning for deprecated oom_adj to avoid
 WARN_ONCE()
Message-ID: <20110804074820.GA22842@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	David Rientjes <rientjes@google.com>,
	Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20110802005206.GA3832@tassilo.jf.intel.com>
 <alpine.DEB.2.00.1108011928530.15596@chino.kir.corp.google.com>
 <m2pqko1h38.fsf@firstfloor.org>
 <alpine.DEB.2.00.1108020236140.18935@chino.kir.corp.google.com>
 <20110803061016.GC16170@liondog.tnic>
 <alpine.DEB.2.00.1108032258200.23444@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108032258200.23444@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 11:04:55PM -0700, David Rientjes wrote:
> > > -	WARN_ONCE(1, "%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
> > > -		  current->comm, task_pid_nr(current), task_pid_nr(task),
> > > -		  task_pid_nr(task));
> > > +	if (!warning_printed) {
> > > +		warning_printed = true;
> > > +		printk("\n===============================================================================\n");
> > > +		printk("%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
> > > +			current->comm, task_pid_nr(current), task_pid_nr(task),
> > > +			task_pid_nr(task));
> > > +		printk("===============================================================================\n\n");
> > 
> > You're missing the KERN_WARNING level.
> 
> It's intentional because (i) I'm using a multi-line notification with 
> newlines and (ii) I don't want to be considered as a kernel warning.  It's 
> just for consumption by userspace and doesn't indicate a kernel issue.

I see.

> > Why don't you use pr_warn_once +
> > pr_cont_once? No need for the warning_printed too, it gets defined in
> > another scope by the pr_warn_once macro automatically.
> > 
> 
> Because using pr_warn_once + pr_cont_once for a multi-line notification is 
> racy and I don't want three separated static variables?  pr_cont_once() 
> shouldn't be used unless synchronized.

Or maybe do:

	pr_info_once("\n===============================================================================\n"
		     "%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n"
		     "===============================================================================\n\n",
		     current->comm, task_pid_nr(current), task_pid_nr(task), task_pid_nr(task));

so as to not be a warning and still hide the warning_printed thing. You
could even save yourself the last repeated argument by enumerating the
format specifiers:

	pr_info_once("\n===============================================================================\n"
		     "%1$s (%2$d): /proc/%3$d/oom_adj is deprecated, please use /proc/%3$d/oom_score_adj instead.\n"
		     "===============================================================================\n\n",
		     current->comm, task_pid_nr(current), task_pid_nr(task));

It seems to build fine here.

Oh well. :-)

-- 
Regards/Gruss,
    Boris.
