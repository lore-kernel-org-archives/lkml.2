Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1EKBK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 21:10:59 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48131 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1EKBK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 21:10:58 -0400
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
From: John Stultz <john.stultz@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <1305075090.19586.189.camel@Joe-Laptop>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
	 <1305073386-4810-3-git-send-email-john.stultz@linaro.org>
	 <1305075090.19586.189.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 18:10:46 -0700
Message-ID: <1305076246.2939.67.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 17:51 -0700, Joe Perches wrote:
> On Tue, 2011-05-10 at 17:23 -0700, John Stultz wrote:
> > Acessing task->comm requires proper locking. However in the past
> > access to current->comm could be done without locking. This
> > is no longer the case, so all comm access needs to be done
> > while holding the comm_lock.
> > 
> > In my attempt to clean up unprotected comm access, I've noticed
> > most comm access is done for printk output. To simpify correct
> > locking in these cases, I've introduced a new %ptc format,
> > which will safely print the corresponding task's comm.
> 
> Hi John.
> 
> Couple of tyops for Accessing and simplify in your commit message
> and a few comments on the patch.

Ah. Yes. Thanks!

> Could misuse of %ptc (not using current) cause system lockup?

It very well could. Although I don't see other %p options tring to
handle invalid pointers. Any suggestions on how to best handle this?


> > Example use:
> > printk("%ptc: unaligned epc - sending SIGBUS.\n", current);
> 
> 
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> > index bc0ac6b..b9c97b8 100644
> > --- a/lib/vsprintf.c
> > +++ b/lib/vsprintf.c
> > @@ -797,6 +797,26 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
> >  	return string(buf, end, uuid, spec);
> >  }
> >  
> > +static noinline_for_stack
> > +char *task_comm_string(char *buf, char *end, u8 *addr,
> > +			 struct printf_spec spec, const char *fmt)
> 
> addr should be void * not u8 *
> 
> > +{
> > +	struct task_struct *tsk = (struct task_struct *) addr;
> 
> no cast.
> 
> Maybe it'd be better to use current inside this routine and not
> pass the pointer at all.

That sounds reasonable. Most users are current, so forcing the more rare
non-current users to copy it to a buffer first and use the normal %s
would not be of much impact.

Although I'm not sure if there's precedent for a %p value that didn't
take a argument. Thoughts on that? Anyone else have an opinion here?

Thanks so much for the review and feedback!
-john

