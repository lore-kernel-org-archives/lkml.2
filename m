Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab0JPCQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 22:16:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42856 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab0JPCQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 22:16:12 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=gJRBYOTBAWgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=qdpvMonyYMaConWHANkA:9 a=yPJJauQzswNFJ6AmKDNUDZiiK0sA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 4/9] jump label: Fix deadlock b/w jump_label_mutex vs.
 text_mutex
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <1287176134.1998.113.camel@laptop>
References: <20101015200949.134732894@goodmis.org>
	 <20101015201036.691801067@goodmis.org>  <1287176134.1998.113.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Oct 2010 22:16:10 -0400
Message-ID: <1287195370.16971.41.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 22:55 +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:
> > +void jump_label_lock(void)
> > +{
> > +       mutex_lock(&jump_label_mutex);
> > +}
> > +
> 
> > +++ b/kernel/kprobes.c
> > @@ -1145,13 +1145,16 @@ int __kprobes register_kprobe(struct kprobe *p)
> >                 return ret;
> >  
> >         preempt_disable();
> > +       jump_label_lock();
> 
> How exactly does that work?

Ouch! Good catch!

I'll do the James Bottomley and blame jet lag ;-)

-- Steve

> 
> >         if (!kernel_text_address((unsigned long) p->addr) ||
> >             in_kprobes_functions((unsigned long) p->addr) ||
> >             ftrace_text_reserved(p->addr, p->addr) ||
> >             jump_label_text_reserved(p->addr, p->addr)) {
> >                 preempt_enable();
> > +               jump_label_unlock();
> >                 return -EINVAL;
> >         }
> > +       jump_label_unlock(); 


