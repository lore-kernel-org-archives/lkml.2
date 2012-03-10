Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2CJHtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:49:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36719 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2CJHs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:48:59 -0500
Date: Sat, 10 Mar 2012 11:48:54 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120310074854.GA3065@moon>
References: <20120309133555.GA23040@moon>
 <20120309134732.GA3696@redhat.com>
 <20120309141349.GC13346@moon>
 <20120309142620.GA5334@redhat.com>
 <20120309144239.GD13346@moon>
 <20120309152122.GA7802@redhat.com>
 <20120309154224.GE13346@moon>
 <20120309220244.GD19584@count0.beaverton.ibm.com>
 <20120309223932.GB725@moon>
 <20120309235901.GE19584@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309235901.GE19584@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 03:59:01PM -0800, Matt Helsley wrote:
> > Well, in final version I switched back to
> > 
> > +	if (mm->num_exe_file_vmas)
> > +		return -EBUSY;
> > 
> > simply because it's more flexible than mm->exe_file.
> > 
> > With mm->exe_file this prctl option become a one-shot
> > only, and while at moment our user-space tool can perfectly
> > live with that I thought that there is no strict need to
> > limit the option this way from the very beginning.
> 
> As far as backward compatibility, isn't it better to lift that restriction
> later rather than add it? I think the latter would very likely "break"
> things whereas the former would not.

Indeed. But I think any change will mean compatibility broken, programs
may rely on one-shot or multi-shot behaviour. So I personally vote
for more flexible approach here.

> 
> I also prefer that restriction because it establishes a bound on how
> frequently the symlink can change. Keeping it a one-shot deal makes the
> values that show up in tools like top more reliable for admins.

How? Once exe_file changed -- we already cheating the kernel, it's not
bad, not good, just work this way ;) I mean imagine an admin which
runs top and sees some program in 'top' ouput (btw, I'm not sure but
does top really parse /proc/pid/exe?) so say he sees some programs
names -- how would he know if a program did change own /proc/pid/exe
at all? Note it's not that important how many times the symlink was
changed there is simply no way to find out if it was changed at all,
and actually from my POV it's a win for transparent c/r, that was
all the idea.

> > 
> > As far as I understand overall num_exe_file_vmas concept -- we track
> > a number of VM_EXECUTABLE with it, so setting new exe_file should not
> > change num_exe_file_vmas I think.
> 
> True, it's literally correct. However the whole reason for having it
> is to turn the mm->exe_file reference into a sort of weak reference
> which happens to coincide with counting the number of VM_EXECUTABLE vmas
> until you do c/r (really just the restart side of c/r).
> 

Look. We actually have a period of time where exe_file is set but
num_exe_file_vmas = 0 when we start program execution before elf
map get parsed, so I dare to say such state is legitime (yes, userspace
doesn't see this state and yes, we start mapping elf sections pretty
immediately after exe_file assigned). So I don't see much problem in
extending this "state" (exe_file!=0,num_exe_file_vmas = 0).

Thanks for comments, Matt!

	Cyrill
