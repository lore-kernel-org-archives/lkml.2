Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0GATkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:40:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59902 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab0GATkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:40:17 -0400
X-Authority-Analysis: v=1.1 cv=RMSK0oVkrNZuN7pkD/X189OVmun+VAHcENC0e9b8U0s= c=1 sm=0 a=ZH2kpZb4ggcA:10 a=GQCbJdZ--msA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=DfNHnWVPAAAA:8 a=Qst4DkAlstULiUn2-PwA:9 a=8VqR0I8tYwfO_uEIYawA:7 a=jxH2NM-tWGgXkH8p-CIx1phpHDEA:4 a=CjuIK1q_8ugA:10 a=lBRciGGoxdUA:10 wl=env:18 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Thu, 1 Jul 2010 14:41:03 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Yama: add PTRACE exception tracking
Message-ID: <20100701194103.GA26620@hallyn.com>
References: <20100630003844.GE4837@outflux.net>
 <20100630073158.GA4453@infradead.org>
 <alpine.LRH.2.00.1007011057520.24202@tundra.namei.org>
 <20100701044401.GY4837@outflux.net>
 <20100701132038.GA24394@hallyn.com>
 <20100701171624.GZ4837@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701171624.GZ4837@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (kees.cook@canonical.com):
> On Thu, Jul 01, 2010 at 08:20:39AM -0500, Serge E. Hallyn wrote:
> > First off, if you consider PTRACE_PTRACEME, and just consider this a more
> > finegrained targeted version of that, it doesn't seem all that gross.  So
> > maybe that's my fault for suggesting prctl as an easier-to-use in LSMs
> > api, bc using a PTRACE_PTRACEDBY might just look cleaner.
> 
> Right, this was my thinking -- there is already one kind of declared
> relationship via TRACEME (though it's utility is for "pure" debugging).
> The other "regular" use of PTRACE is crash handlers, for which this is no
> declared relationship.  (If you ignore simple DAC, of course.)  The third
> PTRACE use is "arbitrary" debugging -- sysadmins or the like saying "wtf is
> that process DOING?"
> 
> When thinking about the PTRACE stuff originally, I hadn't realized the
> "crash handler" case.  So "pure" was done via TRACEME, and "arbitrary" was
> done via CAP_SYS_PTRACE, but there wasn't a clear way to declare the
> "crash" case.
> 
> > Still, you say 'ptrace is too permissive', but a rebuttal to that is that,
> > in a DAC system, ptrace uses what credentials it knows of to authorize.
> > *You* can make it more finegrained by not insisting on running everything
> > as a single user.
> > 
> > What you now are trying to do is find a new, natural relationship between
> > tasks on a plain DAC system to provide finer-grained control.  The one you
> > picked - process ancestry - doesn't perfectly fit, so you add changes and
> > make it less clean.  The criticism of that is valid and needs to be
> > discusssed.
> 
> Actually, if you throw out process ancestry completely, and just use
> TRACEME and TRACEBY, everything still works.  The idea would be to just
> toss out the old definition of DAC PTRACE permissions.
> 
> > One q then is whether YAMA wants to provide task tracking of its own, or
> > stack with apparmor.
> 
> This is why I asked the question below... I don't want to reinvent the
> wheel, but from what I can see, no other LSM can do what I want...

(see below)

> > > Sure.  I am curious, though, is there a way for SELinux (or maybe Smack,
> > > since it has more dynamic labels) to declare this kind of on-runtime PTRACE
> > > relationship?  Maybe I overlooked some options for this.  I didn't see any
> > 
> > In SELinux, you could give a debugger or crash handler an unprivileged, but
> > allowed-to-ptrace-the-main-app domain.
> 
> Right, same for AppArmor.  With either system I can declare a binary as
> able to PTRACE another binary.  This is _still_ too permissive, IMO.  I

In SELinux you can specify which security contexts can be targets too.
I.e.

	allow serge_t serge_firefox_t:process ptrace;

I guess that in apparmor, it probably wouldn't quite be conventional to
specify '/usr/bin/firefox' as a target meaning any task confined in the
/usr/bin/firefox profile...

In smack, tasks have simple labels just like objects, and I believe
ptrace is taken as rw access to the label.

So, you say that

	> wheel, but from what I can see, no other LSM can do what I want...

It depends on if you want exactly what you say you want.  You can do
fine-grained ptrace controls based on security domains of both source
and target.  As for specifying one specific pid of a task which may
ptrace me, no, that doesn't work right now, but I'm not convinced it'd
be a good thing.

> want a process to directly specify which other process should be allowed to
> do a PTRACE.  The logic for this is, by its nature, only known to the
> tracee.  (i.e. "Oh, I'm crashing now... trigger handler... allow PTRACE.")
> 
> (Though obviously this isn't safe if the crasher handler allows arbitrary
> control of the process -- otherwise "kill -SEGV ..." is all that's needed
> to subvert the tracee.  The handler by its nature should just collect
> details and quit.  It's not a "debugging" case, it's a "crash" case.)
> 
> > > I still think simple chaining is the way to go.  I want to review the
> > > earlier discussions first (I think Serge said it was in 2004ish?) before I
> > > write up anything.  There is, I think, one sticking point, which is
> > > /proc/self/attr/current, but beyond that, I think some simple
> > > reorganization of LSM initialization routines and a list that security_*
> > > walks would be sufficient.
> > 
> > In the past, output results for each LSM were simply split by \n or a :
> > or something, and input was prepended by the LSM name.
> 
> This doesn't appear to be true anymore.  Looking at the fs/proc/base.c and
> security/selinux/hooks.c code, there is no checking for a prepended LSM
> name.  Maybe that's the first chaining limitation -- you can't chain 2 LSMs
> that both declare setprocattr hooks.

No no, Stephen and I were talking about in the stacker patchset, again
around 2004-2005.  Never went upstream (per 2005 or 2006 ksummit
agreement).

-serge
