Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab1D2NTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 09:19:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37533 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757985Ab1D2NTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 09:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ZfbESzLvQOptyxSf/kC03DL803IH+FCCm+jly0ZfpcIvJK/melHJFbkel/xbDOtPCs
         aHuQ8BBncE+mdgtamqxA8zflJfuKDqIoCwSC0NZCVTDM4GT6D5b+ZO1OavdneiQfE9VF
         AKb/C7wQbRiOF/1vFBzSzyrnYIrHFTiVlTwJ8=
Date: Fri, 29 Apr 2011 15:18:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Drewry <wad@chromium.org>
Cc: Eric Paris <eparis@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        agl@chromium.org, jmorris@namei.org, rostedt@goodmis.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is
 and how it works.
Message-ID: <20110429131845.GA1768@nowhere>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
 <1303960136-14298-4-git-send-email-wad@chromium.org>
 <20110428070636.GC952@elte.hu>
 <1304002571.2101.38.camel@localhost.localdomain>
 <BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 01:37:33PM -0500, Will Drewry wrote:
> On Thu, Apr 28, 2011 at 9:56 AM, Eric Paris <eparis@redhat.com> wrote:
> > On Thu, 2011-04-28 at 09:06 +0200, Ingo Molnar wrote:
> >> * Will Drewry <wad@chromium.org> wrote:
> >>
> >> > +A collection of filters may be supplied via prctl, and the current set of
> >> > +filters is exposed in /proc/<pid>/seccomp_filter.
> >> > +
> >> > +For instance,
> >> > +  const char filters[] =
> >> > +    "sys_read: (fd == 1) || (fd == 2)\n"
> >> > +    "sys_write: (fd == 0)\n"
> >> > +    "sys_exit: 1\n"
> >> > +    "sys_exit_group: 1\n"
> >> > +    "on_next_syscall: 1";
> >> > +  prctl(PR_SET_SECCOMP, 2, filters);
> >> > +
> >> > +This will setup system call filters for read, write, and exit where reading can
> >> > +be done only from fds 1 and 2 and writing to fd 0.  The "on_next_syscall" directive tells
> >> > +seccomp to not enforce the ruleset until after the next system call is run.  This allows
> >> > +for launchers to apply system call filters to a binary before executing it.
> >> > +
> >> > +Once enabled, the access may only be reduced.  For example, a set of filters may be:
> >> > +
> >> > +  sys_read: 1
> >> > +  sys_write: 1
> >> > +  sys_mmap: 1
> >> > +  sys_prctl: 1
> >> > +
> >> > +Then it may call the following to drop mmap access:
> >> > +  prctl(PR_SET_SECCOMP, 2, "sys_mmap: 0");
> >>
> >> Ok, color me thoroughly impressed
> >
> > Me too!
> >
> >> I've Cc:-ed Linus and Andrew: are you guys opposed to such flexible, dynamic
> >> filters conceptually? I think we should really think hard about the actual ABI
> >> as this could easily spread to more applications than Chrome/Chromium.
> 
> Would it make sense to start, as Frederic has pointed out, by using
> the existing ABI - system call numbers - and not system call names?
> We could leave name resolution to userspace as it is for all other
> system call consumers now.  It might leave the interface for this
> support looking more like:
>   prctl(PR_SET_SECCOMP, 2, _NR_mmap, "fd == 1");
>   prctl(PR_SET_SECCOMP_FILTER_APPLY, now|on_exec);

PR_SET_SECCOMP_FILTER_APPLY seems only useful if you think there
are other cases than enable_on_exec that would be useful for these
filters.

We can think about a default enable on exec behaviour as Steve pointed
out.

But I have no idea if other cases may be desirable to apply these
filters.
