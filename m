Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2CMCq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 22:46:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33906 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2CMCqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 22:46:24 -0400
Date: Mon, 12 Mar 2012 19:45:11 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120313024511.GF19584@count0.beaverton.ibm.com>
References: <20120309134732.GA3696@redhat.com>
 <20120309141349.GC13346@moon>
 <20120309142620.GA5334@redhat.com>
 <20120309144239.GD13346@moon>
 <20120309152122.GA7802@redhat.com>
 <20120309154224.GE13346@moon>
 <20120309220244.GD19584@count0.beaverton.ibm.com>
 <20120309223932.GB725@moon>
 <20120309235901.GE19584@count0.beaverton.ibm.com>
 <20120310074854.GA3065@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120310074854.GA3065@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031302-6148-0000-0000-00000432B82E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 11:48:54AM +0400, Cyrill Gorcunov wrote:
> On Fri, Mar 09, 2012 at 03:59:01PM -0800, Matt Helsley wrote:
> > > Well, in final version I switched back to
> > > 
> > > +	if (mm->num_exe_file_vmas)
> > > +		return -EBUSY;
> > > 
> > > simply because it's more flexible than mm->exe_file.
> > > 
> > > With mm->exe_file this prctl option become a one-shot
> > > only, and while at moment our user-space tool can perfectly
> > > live with that I thought that there is no strict need to
> > > limit the option this way from the very beginning.
> > 
> > As far as backward compatibility, isn't it better to lift that restriction
> > later rather than add it? I think the latter would very likely "break"
> > things whereas the former would not.
> 
> Indeed. But I think any change will mean compatibility broken, programs
> may rely on one-shot or multi-shot behaviour. So I personally vote
> for more flexible approach here.

Very true. In fact thinking about this prctl a bit more makes me more certain
that one-shot is better and it ought to stay that way forever. The
flexibility to change the /proc/pid/exe symlink could be yet another
way for malicious code to obscure a compromised program and
masquerade as a benign process. That's a problem inherent in this prctl
whether its one-shot or multi-shot. However, if you use the one-shot
approach then a security-concious program can use this prctl once
during its early initialization to ensure the prctl cannot later be abused
for this purpose.

> 
> > 
> > I also prefer that restriction because it establishes a bound on how
> > frequently the symlink can change. Keeping it a one-shot deal makes the
> > values that show up in tools like top more reliable for admins.
> 
> How? Once exe_file changed -- we already cheating the kernel, it's not
> bad, not good, just work this way ;) I mean imagine an admin which
> runs top and sees some program in 'top' ouput (btw, I'm not sure but
> does top really parse /proc/pid/exe?) so say he sees some programs

Sorry, my phrase "tools like top" was ambiguous. I was trying to succinctly
refer to top as one type of program which might rely on this information.
I don't know if top itself uses this file but it would be reasonable for
tools of that kind to use/display it to an administrator.

> names -- how would he know if a program did change own /proc/pid/exe
> at all? Note it's not that important how many times the symlink was
> changed there is simply no way to find out if it was changed at all,
> and actually from my POV it's a win for transparent c/r, that was
> all the idea.

I am quite aware of the c/r use for this prctl :). However I also
wonder if there aren't serious malicious uses of it. I'm not saying the
symlink has to be perfectly accurate at all times,  but it's easy and
reasonable to make it much harder to abuse this particular prctl for
malicious purposes by making it one-shot.

> 
> > > 
> > > As far as I understand overall num_exe_file_vmas concept -- we track
> > > a number of VM_EXECUTABLE with it, so setting new exe_file should not
> > > change num_exe_file_vmas I think.
> > 
> > True, it's literally correct. However the whole reason for having it
> > is to turn the mm->exe_file reference into a sort of weak reference
> > which happens to coincide with counting the number of VM_EXECUTABLE vmas
> > until you do c/r (really just the restart side of c/r).
> > 
> 
> Look. We actually have a period of time where exe_file is set but
> num_exe_file_vmas = 0 when we start program execution before elf
> map get parsed, so I dare to say such state is legitime (yes, userspace
> doesn't see this state and yes, we start mapping elf sections pretty
> immediately after exe_file assigned). So I don't see much problem in
> extending this "state" (exe_file!=0,num_exe_file_vmas = 0).

True, there is a time when that combination of values occurs. However
who sets those values and when is the important difference.

Before this patch that state was rather ephemeral and almost entirely
under the control of the kernel. The only way userspace could change it
was by unmapping the region(s) mapped during exec*(). At that point it
could not "lie" and insert some other symlink there and the admin would
be better able to determine what had happened.

With this patch -- especially the multi-shot form -- the symlink will
be entirely under the control of (potentially untrusted) userspace code
and the admin is totally at the mercy of the userspace code. In
single-shot form programs could use the prctl() to ensure the symlink
could not be changed later -- the restart tool would be the only program
that would need to ensure that prctl() had not been used since the last
exec*().

If we're going to let userspace do arbitrary things to the symlink I can't
help but wonder why we can't skip the prctl() altogether and just enable
MAP_EXECUTABLE in mmap().

Cheers,
	-Matt Helsley

