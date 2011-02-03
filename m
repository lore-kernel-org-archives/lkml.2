Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab1BCRfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:35:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46633 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab1BCRfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:35:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HPtM8uwdRX8LfBF3MDVrMySI3Abj0WmXXhjDhc3+5kjGf3twBL+MdFK7lBJ1okXAdF
         iitQW0W6jSl8n98Yy0c8not9MHsuDmRBzzmPm9cdv59bhkALpONY5GR9VF4Bfk/STHnZ
         lDp83mouCrbcAQGAIsPonFTglHFeHlxhqAASw=
Date: Thu, 3 Feb 2011 18:35:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC 0/4] tracing,x86_64 - function/graph trace without
 mcount/-pg/framepointer
Message-ID: <20110203173543.GA1769@nowhere>
References: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
 <1296750805.10797.87.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296750805.10797.87.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 11:33:25AM -0500, Steven Rostedt wrote:
> On Thu, 2011-02-03 at 16:42 +0100, Jiri Olsa wrote:
> > hi,
> > 
> > I recently saw the direct jump probing made for kprobes
> > and tried to use it inside the trace framework.
> > 
> > The global idea is patching the function entry with direct
> > jump to the trace code, instead of using pregenerated gcc
> > profile code.
> 
> Interesting, but ideally, it would be nice if gcc provided a better
> "mcount" mechanism. One that calls mcount (or whatever new name it would
> have) before it does anything with the stack.
> 
> > 
> > I started this just to see if it would be even possible
> > to hook with new probing to the current trace code. It
> > appears it's not that bad. I was able to run function
> > and function_graph trace on x86_64.
> > 
> > For details on direct jumps probe, please check:
> > http://www.linuxinsight.com/ols2007-djprobe-kernel-probing-with-the-smallest-overhead.html
> > 
> > 
> > I realize using this way to hook the functions has some
> > drawbacks, from what I can see it's roughly:
> > - no all functions could be patched
> 
> What's the reason for not all functions?

Because of those that kprobes calls, so to avoid recursion.
kprobes has some recursion detection mechanism, IIRC, but
until we reach that checkpoint, I think there are some functions
in the path.

Well, ftrace has the same problem. That's just due to the nature of
function tracing.

There may be some places too fragile to use kprobes there too.

Ah, the whole trap path for example :-(

> > - need to find a way to say which function is safe to patch
> > - memory consumption for detour buffers and symbol records
> > 
> > but seems there're some advantages as well:
> > - trace code could be in a module
> 
> What makes this allow module code?
> 
> ftrace could do that now, but it would require a separate handler. I
> would need to disable preemption before calling the module code function
> handler.

Kprobes takes care of handlers from modules already.
I'm not sure we want that, it makes the tracing code more sensitive.

Look, for example I think kprobes doesn't trace kernel faults path
because module space is allocated through vmalloc (hmm, is it still
the case?).

> > - no profiling code is needed
> > - framepointer can be disabled (framepointer is needed for
> >   generating profile code)
> 
> Again ideally, gcc should fix this.

As another drawback of using kprobes, there is also the overhead.
I can't imagine a trap triggering for every functions. But then
yeah we have the jmp optimisation. But then it needs that detour
buffer that we can avoid with mcount.

So like Steve I think mcount is still a better backend for function
tracing. More optimized by nature, even though it indeed needs
some fixes.
