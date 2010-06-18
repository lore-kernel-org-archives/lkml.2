Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab0FRMgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 08:36:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37845 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab0FRMgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 08:36:33 -0400
X-Authority-Analysis: v=1.1 cv=GMC9ctHN+mfn2UjahXKMz1Fs9q6RIMVHs8P/za7PD7k= c=1 sm=0 a=_xeo1-vZUxgA:10 a=hO-oPbc3tlwA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=20KFwNOVAAAA:8 a=DfNHnWVPAAAA:8 a=jdlfCpmRHRKfWezIqOkA:9 a=7WEOXm7nsFuc0qo20-oA:7 a=dWSqtB15hUsXEImff2a5wv8jya8A:4 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=lBRciGGoxdUA:10 a=pobgSg4GrmgARGDm:21 a=KX59jSY6W4RboyHU:21 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Fri, 18 Jun 2010 07:36:53 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Roland McGrath <roland@redhat.com>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100618123653.GA5427@hallyn.com>
References: <20100616221833.GM24749@outflux.net>
 <20100616231006.34A28403D2@magilla.sf.frob.com>
 <20100616233937.GQ24749@outflux.net>
 <20100617001114.A90F5403D2@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617001114.A90F5403D2@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Roland McGrath (roland@redhat.com):
> > Though, honestly, just trying to get rid of PTRACE seems like the better
> > place to spend time.
> 
> Crushing irony of telling *me* this duly noted.  ;-)
> I am not really sure what deeply different set of security constraints
> you envision on any other kind of new debugger interface that would be
> any different for the concerns you've expressed, though.
> 
> > > I don't think "task->pid > 0" is a sort of check that is used elsewhere in
> > > the kernel for this.  Perhaps "task == &init_task" would be better.
> > 
> > Is this correct for pid_ns?  I thought pid 1 (regardless of NS) would have
> > a NULL parent?
> 
> Don't ask me.  I just mentioned pid_ns to get those who really know about
> it to feel obliged to review your code.

task->pid always holds the global pid, so 0 and 1 will be the global idle
and init tasks.

As for this particular patch,

Quoting Kees Cook (kees.cook@canonical.com):

>> running state of any of their processes. For example, if one application
>>(e.g. Pidgin) was compromised, it would be possible for an attacker to
>>attach to other running processes (e.g. Firefox, SSH sessions, GPG agent,
>>etc) to extract additional credentials and continue to expand the scope
>>of their attack without resorting to user-assisted phishing.

Well that's why I like to run things like firefox, irc clients, etc each
as their own userid.  That also protects my ssh keys from irc client.  But
things like clicking urls in terminals to fire them up in a browser
aren't usually hooked up right when you do that.  Not that it'd be
impossible to do right.

Anyway, if you're going to do this (sounds like, as a tiny-lsm?), how
about replacing the sysctl with a per-task flag which, once set,
can't be unset?  Then firefox can mark itself unable-to-ptrace (or I
can do so in a wrapper before calling firefox.real), after which it
cannot strace anything which isn't its descendent, but I can still
strace firefox from my shell.  Of course, don't bother with that
change unless someone seconds the suggestion, in case ppl don't like
it and ask you to change it back :)

-serge
