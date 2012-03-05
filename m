Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab2CEPrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:47:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab2CEPrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:47:37 -0500
Date: Mon, 5 Mar 2012 16:40:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120305154029.GB12427@redhat.com>
References: <20120301180616.GA7652@redhat.com> <20120301191714.GF9930@moon> <20120301194120.GA11400@redhat.com> <20120302142630.GK8681@moon> <20120302152621.GA29744@redhat.com> <20120302161247.GO8681@moon> <20120303223333.GB26846@moon> <20120305142130.GA9393@redhat.com> <20120305142655.GC9393@redhat.com> <20120305144648.GA12341@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305144648.GA12341@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Cyrill Gorcunov wrote:
>
> On Mon, Mar 05, 2012 at 03:26:55PM +0100, Oleg Nesterov wrote:
> > > OK, I won't argue, probably this makes sense to make sure that
> > > admin can't get a heart attack looking at /proc/pid/exe.
> > >
> > > But the O_RDONLY check looks strange. We are not going to write
> > > to this file, we only set the name (and that is why I think it
> > > should be mm->exe_path). What is the point to check that the file
> > > was opened without FMODE_WRITE? Even if there were any security
> > > risk the apllication can open this file again with the different
> > > flags.
> >
>
> Hi Oleg!
>
> Replying to both your email -- I wanted to be as close to open_exec
> as possible.

I see. But open_exec() is different, it returns the file we are going
to read/mmap. PR_SET_MM_EXE_FILE is different, I think O_RDONLY buys
nothing and looks confusing.

Anyway, as I said I won't argue.

> This prctl does cheat the kernel

Yep. Except, well, it cheats the user-space.

> but with this tests
> the cheating should be minimized (it's almost the same as open_exec
> does).

I don't reallt understand "minimized" ;) With this tests
proc/pid/exe can't look "obviously wrong", I agree. But that is all.

> > Seriously, I think we should cleanup this before c/r adds more
> > ugliness. I'll try to make the patch today.
>
> Cleanup what? If you mean this patch -- just point me what
> should I do.

I just sent the patch, "turn mm->exe_file into mm->exe_path"

> > And with all these checks I am no longer sure that fd is better
> > than filename ;)
>
> This security tests was a reason why I've used open_exec in
> first version of the patch

Yes, but me and Pavel forced you to use "int fd" ;)

> (and I still would prefer to
> have open_exec here instead of fd).

With the patch I sent "struct file *" is not needed at all.
I think prctl() can use user_path().

> As to allow-write-access -- it should be cleaned once process
> finished, no?

Exactly! And who will increment ->i_writecount? Nobody, that is
the problem.

Oleg.

