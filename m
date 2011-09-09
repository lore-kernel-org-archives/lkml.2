Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab1IINPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:15:41 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:55992 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758899Ab1IINPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:15:38 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in 'data'
Date: Fri, 9 Sep 2011 14:15:33 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com> <201109091212.59889.pedro@codesourcery.com> <1315571337.4127.3.camel@dhcp-25-63.brq.redhat.com>
In-Reply-To: <1315571337.4127.3.camel@dhcp-25-63.brq.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109091415.33503.pedro@codesourcery.com>
X-OriginalArrivalTime: 09 Sep 2011 13:15:36.0138 (UTC) FILETIME=[8FD89AA0:01CC6EF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 September 2011 13:28:55, Denys Vlasenko wrote:
> On Fri, 2011-09-09 at 12:12 +0100, Pedro Alves wrote:
> > On Thursday 08 September 2011 19:22:04, Denys Vlasenko wrote:
> > > Make PTRACE_SEIZE set ptrace options specified in 'data' parameter
> > >     
> > > This can be used to close a few corner cases in strace where we get
> > > unwanted racy behavior after attach, but before we have a chance
> > > to set options (the notorious post-execve SIGTRAP comes to mind),
> > 
> > I'm still confused on why you're raising the SIGTRAP argument.  Did you see
> > 
> >  https://lkml.org/lkml/2011/9/8/7
> > 
> > From previous discussions, I understood that PTRACE_SEIZE _always_
> > disables
> > the post-execve SIGTRAP, so I don't believe that race actually exists.
> > Or is that not the case?
> 
> 
> I believe it is not the case. And I object to making it the case.

Well, if you'll remember, back in <https://lkml.org/lkml/2011/5/19/704> I
raised this exact problem with that pesky racy post-execve SIGTRAP showing
through on SEIZE, and Tejun a few replies later mentioned that the SIGTRAP
was to be removed on SEIZE.   I'm sure it was said before even, but I'm
not finding the emails now.

> My sense of taste says the approach "you need to use SEIZE to affect
> feature <foo>" for various unrelated <foo> makes ptrace API ugly.

Yes, very much agreed!

> Especially that in this case, we already have a method in API
> to suppress post-execve SIGTRAP.

Right, but we end up with no way to make the tracee _not ever
stop_ at execve if the tracer wants to, like you can make
the tracee not ever stop on forks or syscalls, by not enabling
the corresponding PTRACE_O_FOO or not PTRACE_SYSCALL.  Not
specifying PTRACE_O_TRACEEXEC coupled with `SEIZE not stopping
tracees for that magic SIGTRAP' got you that.  In a way, it looked to
me to make the API a bit less ugly.  That said I'm not seeing GDB
_not_ using PTRACE_O_TRACEEXEC...

Anyway, could you please check (or Tejun please confirm)
that that magic SIGTRAP is really still there on SEIZE?

-- 
Pedro Alves
