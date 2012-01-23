Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2AWUxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:53:38 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38518 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2AWUxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:53:33 -0500
Date: Tue, 24 Jan 2012 00:53:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [patch 3/4] c/r: procfs: add arg_start/end, env_start/end and
 exit_code members to /proc/$pid/stat
Message-ID: <20120123205328.GM1907@moon>
References: <20120123142036.025893883@openvz.org>
 <20120123142436.336126707@openvz.org>
 <CAGXu5jJtum19tEKdDAKU3pZYF6k76gpPpwP8ananKhpQDJ8=VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jJtum19tEKdDAKU3pZYF6k76gpPpwP8ananKhpQDJ8=VQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 12:42:28PM -0800, Kees Cook wrote:
> On Mon, Jan 23, 2012 at 6:20 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > We would like to have an ability to restore command line
> > arguments and envirion pointers so the task being restored
> > would print appropriate values in /proc/pid/cmdline and
> > /proc/pid/envirion. The exit_code is needed to restore
> > zombie tasks.
> >
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > Cc: Pavel Emelyanov <xemul@parallels.com>
> > Cc: Serge Hallyn <serge.hallyn@canonical.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Alexey Dobriyan <adobriyan@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Andrew Vagin <avagin@openvz.org>
> > Cc: Vasiliy Kulikov <segoon@openwall.com>
> > Cc: Alexey Dobriyan <adobriyan@gmail.com>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > ---
> >  fs/proc/array.c |   10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > Index: linux-2.6.git/fs/proc/array.c
> > ===================================================================
> > --- linux-2.6.git.orig/fs/proc/array.c
> > +++ linux-2.6.git/fs/proc/array.c
> > @@ -464,7 +464,8 @@ static int do_task_stat(struct seq_file
> >
> >        seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
> >  %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
> > -%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
> > +%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu \
> > +%lu %lu %lu %lu %d\n",
> >                pid_nr_ns(pid, ns),
> >                tcomm,
> >                state,
> > @@ -514,7 +515,12 @@ static int do_task_stat(struct seq_file
> >                cputime_to_clock_t(cgtime),
> >                (mm && permitted) ? mm->start_data : 0,
> >                (mm && permitted) ? mm->end_data : 0,
> > -               (mm && permitted) ? mm->start_brk : 0);
> > +               (mm && permitted) ? mm->start_brk : 0,
> > +               (mm && permitted) ? mm->arg_start : 0,
> > +               (mm && permitted) ? mm->arg_end : 0,
> > +               (mm && permitted) ? mm->env_start : 0,
> > +               (mm && permitted) ? mm->env_end : 0,
> > +               task->exit_code);
> >        if (mm)
> >                mmput(mm);
> >        return 0;
> 
> You're not exposing auxv here? In your testing, what situations ended
> up using auxv after initial startup? Or is your intention to be able
> to freeze a process potentially before libc has examined auxv?
> 

auxv already available via /proc/pid/auxv so I thought it would be
redundant to put it into different place. Or you meant something
else?

In testing I simply read auxv values from /proc/pid/auxv and restore
them back via prctl at restore time. (prctl patch is in this series
but it's slightly buggy so I post correct version later).

And intention is simply dump this vector at checkpoint time and
restore when needed.

	Cyrill
