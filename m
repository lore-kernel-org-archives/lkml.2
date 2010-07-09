Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0GINFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:05:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49797 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab0GINFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=qQQA1ucCLFmV08/RNfq3xg4E4NJqC2RzBrCHLlI/hj3pQNeLuW4R+iVp4G4LMjRJwd
         NyR+WrD3JcwDLQBuy62XV2xgb/dfMhtioYn7IYnGF+79LbOW3XrPHD+gUQLMMsWgrJiT
         wy/jGtSZ72U1qBiRCTpjXZO/c/BUXxV5AAQwU=
Date: Fri, 9 Jul 2010 15:04:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zeev Tarantov <zeev.tarantov@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 2.6.35 regression
Message-ID: <20100709130454.GC5291@nowhere>
References: <loom.20100705T144459-919@post.gmane.org> <20100708132237.GA22830@goodmis.org> <AANLkTilsXUjNNDcC4ZA9m8hBDqzcoh5NGbNd4XX5xx5s@mail.gmail.com> <1278645989.1537.133.camel@gandalf.stny.rr.com> <AANLkTinkKVmB0fpVeqUkMeqe3ZYeXJdI8xDuzJEOjYwh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinkKVmB0fpVeqUkMeqe3ZYeXJdI8xDuzJEOjYwh@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 11:45:09AM +0300, Zeev Tarantov wrote:
> On Fri, Jul 9, 2010 at 06:26, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Thu, 2010-07-08 at 21:53 +0300, Zeev Tarantov wrote:
> >
> >> With gcc 4.5.1 rev. 161655 objdump shows:
> >> Disassembly of section .data:
> >>
> >> ffffffff8173c438 <__start_syscalls_metadata>:
> >>         ...
> >>
> >> ffffffff8173c440 <__syscall_meta__mmap>:
> >> ffffffff8173c440:       2b ab 5f 81 ff ff       sub    -0x7ea1(%rbx),%ebp
> >
> > Yeah, this is definitely the issue. It starts off at ffffffff8173c438,
> > when the first item is really at ffffffff8173c440.
> >
> > Can you try this patch out:
> >
> > -- Steve
> >
> > diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> > index 7f614ce..13ebb54 100644
> > --- a/include/linux/syscalls.h
> > +++ b/include/linux/syscalls.h
> > @@ -124,7 +124,8 @@ extern struct trace_event_functions enter_syscall_print_funcs;
> >  extern struct trace_event_functions exit_syscall_print_funcs;
> >
> >  #define SYSCALL_TRACE_ENTER_EVENT(sname)                               \
> > -       static struct syscall_metadata __syscall_meta_##sname;          \
> > +       static struct syscall_metadata                                  \
> > +       __attribute__((__aligned__(4))) __syscall_meta_##sname;         \
> >        static struct ftrace_event_call                                 \
> >        __attribute__((__aligned__(4))) event_enter_##sname;            \
> >        static struct ftrace_event_call __used                          \
> > @@ -138,7 +139,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
> >        }
> >
> >  #define SYSCALL_TRACE_EXIT_EVENT(sname)                                        \
> > -       static struct syscall_metadata __syscall_meta_##sname;          \
> > +       static struct syscall_metadata                                  \
> > +       __attribute__((__aligned__(4))) __syscall_meta_##sname;         \
> >        static struct ftrace_event_call                                 \
> >        __attribute__((__aligned__(4))) event_exit_##sname;             \
> >        static struct ftrace_event_call __used                          \
> >
> >
> >
> >
> 
> Boots fine with this applied.


Great!



> Linux version 2.6.35-rc4 (wolf@wolfpc) (gcc version 4.5.1-pre9999
> 20100701 (prerelease) rev. 161655 (Gentoo SVN) ) #5 SMP Fri Jul 9
> 11:13:08 IDT 2010
> 
> I hope Linus accepts this patch as it seems to me the compiler is
> doing something it is allowed to do.


In fact the alignment is on the definition already, the problem that
appears here is that this version of gcc also requires the alignment
to be on the declaration.

Silly or not, that easily fixes the issue.


> 
> Thank you for the prompt response!



Thanks for your report and testing!


> -Zeev

