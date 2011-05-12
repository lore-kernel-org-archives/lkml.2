Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887Ab1ELWKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:10:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29656 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851Ab1ELWKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:10:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=gZ+XVWdjoGJuMEJPn7xi/gcBjeicp/w+VsvhqDW6rnq5JE2x3Ph1ntRgWDAK0l/9Yt
         tPT1YqUec+XS70CstwLg==
Date: Thu, 12 May 2011 15:10:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: John Stultz <john.stultz@linaro.org>
cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
In-Reply-To: <1305076246.2939.67.camel@work-vm>
Message-ID: <alpine.DEB.2.00.1105121508030.9130@chino.kir.corp.google.com>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org> <1305073386-4810-3-git-send-email-john.stultz@linaro.org> <1305075090.19586.189.camel@Joe-Laptop> <1305076246.2939.67.camel@work-vm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 May 2011, John Stultz wrote:

> > > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> > > index bc0ac6b..b9c97b8 100644
> > > --- a/lib/vsprintf.c
> > > +++ b/lib/vsprintf.c
> > > @@ -797,6 +797,26 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
> > >  	return string(buf, end, uuid, spec);
> > >  }
> > >  
> > > +static noinline_for_stack
> > > +char *task_comm_string(char *buf, char *end, u8 *addr,
> > > +			 struct printf_spec spec, const char *fmt)
> > 
> > addr should be void * not u8 *
> > 
> > > +{
> > > +	struct task_struct *tsk = (struct task_struct *) addr;
> > 
> > no cast.
> > 
> > Maybe it'd be better to use current inside this routine and not
> > pass the pointer at all.
> 
> That sounds reasonable. Most users are current, so forcing the more rare
> non-current users to copy it to a buffer first and use the normal %s
> would not be of much impact.
> 

Please still require an argument, otherwise the oom killer (which could 
potentially called right before a stack overflow) would be required to use 
buffers for the commands printed in the tasklist dump.

> Although I'm not sure if there's precedent for a %p value that didn't
> take a argument. Thoughts on that? Anyone else have an opinion here?
> 

After the cleanups are addressed:

	Acked-by: David Rientjes <rientjes@google.com>

It would have been nice if we could force %ptc to expect a 
struct task_struct * rather than a void *, however.
