Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0CSC07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 22:26:59 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48792 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0CSC05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 22:26:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f26Zt5ChNPSYJhMUrQKH/cNDFmqjOf1r34OGq/iU8zHU7cGoMKQ+9CkyJP4F62wFpF
         a2LwqZkdSTm2ACHXlhzcBNJjJ1GfP7Jz8IRnU3uz2Ua9MHFsvJ21scEUcrLurMdOmMX4
         gCLdpDP3DkrMIfFyD69a8y2sFA3HU5Ho0nNlo=
Date: Fri, 19 Mar 2010 03:27:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
	lock
Message-ID: <20100319022659.GC22095@nowhere>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1268590435.9440.8.camel@laptop> <20100317013236.GB5258@nowhere> <20100317095230.GD17146@elte.hu> <4BA1C141.8050409@dcl.info.waseda.ac.jp> <20100318211633.GG5103@nowhere> <20100319010857.GC23020@Krystal> <20100319012337.GA22095@nowhere> <20100319013658.GB28456@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319013658.GB28456@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 09:36:58PM -0400, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Thu, Mar 18, 2010 at 09:08:57PM -0400, Mathieu Desnoyers wrote:
> > > > I sometimes wonder which trick between jmp optimization and hot patching
> > > > would be the best to optimize the tracepoints off-cases.
> > > > 
> > > > I should look more closely at the jmp optimization. I don't know if
> > > > it avoids to push the tracepoints parameters in the off case, in
> > > > which case it could be perhaps more efficient than hot patching,
> > > 
> > > yep, tracepoints with jump patching will branch over the whole stack setup in
> > > the off case, which is one of the good reasons for using this solution over
> > > patching only a call (leaving the stack setup in place).
> > 
> > 
> > 
> > Ok that's good to know. It's a pretty good argument against hot
> > patching in this particular case.
> > 
> > 
> >  
> > > Note that if the parameters include side-effects (such as a function call),
> > > these will be executed even when the tracepoint is disabled. This is why people
> > > should implement these calls with side-effects in the appropriate TRACE_EVENT
> > > fields.
> > 
> > 
> > Good to know too.
> > But this makes me curious. So it guarantees stack setup won't happen but
> > can't sort it out with functions as parameters or so?
> > 
> > I have no idea how this thing works. Please Cc me for the next batch,
> > this looks like a cool thing :)
> > 
> 
> Well, the now deceased "Linux Kernel Markers" (which were based on a single
> macro rather than static inline functions) were able to use the preprocessor to
> put function calls passed as argument within the conditional branch. But with
> tracepoints, we rely on static inlines to have flexible parameter declaration,
> so this is not possible.


Ok.



> All the arguments passed to the static inline (eventually used for the stack
> setup of the actual function call within the tracepoint) can be moved into the
> conditional branch by the compiler optimizations, because they are not needed
> otherwise. However, this cannot be done for function calls passed as parameter
> to the tracepoint, because the compiler do not know whether or not the function
> side-effects are needed outside of the "tracing active" branch.
> 
> Mathieu



Ok. I just read this: http://lwn.net/Articles/362752/ and
this: http://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html

What is funky is that the gcc example takes this jmp/nop patching
as an example to explain asm goto, so it all looks clear to me now :-)

But, looking at __DO_TRACE:

	if (it_func) {						\
		do {						\
			((void(*)(proto))(*it_func))(args);	\
		} while (*(++it_func));				\
	}

I would expect the compiler not to load the parameters in the stack
before first checking the branch.
So, the fact that parameters are not loaded before we know we'll call
the tracepoint is something we already have or is it something that the jump
label brings in the package somehow?

Thanks.

