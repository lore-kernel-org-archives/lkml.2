Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0C0A6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 20:58:01 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62812 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0C0A57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 20:57:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a7/7FyRLGFja0mdp1ZqgIiUhDajWfGUBRzcGXgN0PUOi+o5dZoCOWft8DTQTlqoosl
         zBobSW9rSeYzPkcKNRMWUkrNX8ilr/EtRqdhnQQAoJbA/NFCFUXMZPnVX3p6Ivuh5vkh
         pPcMmOAcirevrUviZxlcnXnzGGg+tzUhDBNUU=
Date: Sat, 27 Mar 2010 01:57:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC PATCH 0/7] perf: 'live mode'
Message-ID: <20100327005757.GM7166@nowhere>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 01:05:22AM -0600, Tom Zanussi wrote:
> Currently, a perf session entails two steps: first 'perf record' or
> 'perf trace record' records the perf data to disk, then 'perf report'
> or 'perf trace report' reads the saved data from disk and reports the
> results.
> 
> This experimental patchset makes some changes to perf that instead
> allow the perf data to be piped directly from the record step to the
> report step, without ever touching the disk.
> 
> This is especially useful for 'perf trace' - adding this capability
> means that the trace scripts are no longer relegated to simple
> post-processing, but can be run in a continuous 'live mode', forever
> processing the event stream and e.g. periodically dumping current
> results, essentially becoming special-purpose 'top' applications, or
> continuously scanning the event stream for arbitrarily complex
> conditions to flag, etc...
> 
> Being able to feed the event stream over a pipe also makes it possible
> to do things like trace over the network using e.g. netcat.
> 
> It turns out that perf is pretty close to being able to do this
> already, with the exception of the header data; most of the work of
> this patchset deals with changing that.  It does so in a mainly
> additive way: it doesn't make any changes to the existing disk format
> or normal disk-mode processing, just adds special treatment for the
> cases when 'perf [trace] record' records to stdout or 'perf [trace]
> report reads from stdin.
> 
> Here are some quick examples.  Basically using '-' as the filename to
> the -o and -i options send/read the data from stdout/stdin:
> 
> Here's a simple 'perf record' | 'perf report' run:
> 
> root@tropicana:~# perf record -o - -c 1 -f -a -M -R -e raw_syscalls:sys_enter | perf report -i -
> ^C# Samples: 120234
> #
> # Overhead          Command              Shared Object  Symbol
> # ........  ...............  .........................  ......
> #
>     98.65%             perf  libpthread-2.8.90.so       [.] __read
>      0.46%             perf  libpthread-2.8.90.so       [.] __write_nocancel
>      0.32%             perf  libpthread-2.8.90.so       [.] __open_nocancel
>      0.29%             perf  libpthread-2.8.90.so       [.] __libc_close
>      0.07%             perf  libc-2.8.90.so             [.] 0x000000000a4b15
>      0.03%             perf  libc-2.8.90.so             [.] __fxstat64
>      0.03%             perf  libc-2.8.90.so             [.] __open
>      0.03%             perf  libc-2.8.90.so             [.] close
>      0.02%             Xorg  libc-2.8.90.so             [.] __select
>      0.01%             Xorg  libpthread-2.8.90.so       [.] __read
>      0.01%             perf  libpthread-2.8.90.so       [.] __libc_lseek
>      0.01%             Xorg  libc-2.8.90.so             [.] setitimer
>      0.01%             perf  libc-2.8.90.so             [.] __xstat64
>      0.01%          firefox  libpthread-2.8.90.so       [.] __read
>      0.00%             perf  libc-2.8.90.so             [.] llseek
>      0.00%             Xorg  libpthread-2.8.90.so       [.] __restore_rt
>      0.00%             Xorg  libc-2.8.90.so             [.] sigprocmask
>      0.00%             Xorg  libc-2.8.90.so             [.] __poll
>      0.00%            wterm  libc-2.8.90.so             [.] __read
>      0.00%  gnome-screensav  libpthread-2.8.90.so       [.] __read
>      0.00%          firefox  libc-2.8.90.so             [.] __poll
>      0.00%             Xorg  libc-2.8.90.so             [.] writev
>      0.00%  gnome-settings-  libpthread-2.8.90.so       [.] __read
>      0.00%            wterm  libc-2.8.90.so             [.] __select
>      0.00%             perf  libc-2.8.90.so             [.] statfs
>      0.00%           mysqld  libc-2.8.90.so             [.] __select
>      0.00%          firefox  libpthread-2.8.90.so       [.] __pthread_cond_timedwait
>      0.00%          firefox  libpthread-2.8.90.so       [.] __lll_unlock_wake
>      0.00%          firefox  libpthread-2.8.90.so       [.] 0x0000000000decb
>      0.00%          firefox  libc-2.8.90.so             [.] __select
>      0.00%             perf  libc-2.8.90.so             [.] getcwd
>      0.00%             perf  libc-2.8.90.so             [.] mmap64
>      0.00%  gnome-settings-  libc-2.8.90.so             [.] __poll
>      0.00%  gnome-screensav  libc-2.8.90.so             [.] __poll
>      0.00%          firefox  libc-2.8.90.so             [.] writev
>      0.00%          apache2  libpthread-2.8.90.so       [.] __waitpid
>      0.00%          apache2  libc-2.8.90.so             [.] __select
> #
> # (For a higher level overview, try: perf report --sort comm,dso)
> #
> 
> Included in this patchset are a couple of 'top' scripts, rwtop and
> sctop, that are essentially just modifications of existing scripts.
> Basically the original scripts were modified to add a 5 second timer.
> In the handler for the timer, the current output summary is printed,
> and the state is cleared and begun anew, ad infinitum.
> 
> Here are the new scripts as shown in the perf trace list:
> 
> root@tropicana:~# perf trace -l
> List of available trace scripts:
>   workqueue-stats                      workqueue stats (ins/exe/create/destroy)
>   wakeup-latency                       system-wide min/max/avg wakeup latency
>   rw-by-file <comm>                    r/w activity for a program, by file
>   rwtop                                system-wide r/w top
>   failed-syscalls [comm]               system-wide failed syscalls
>   rw-by-pid                            system-wide r/w activity
>   syscall-counts-by-pid [comm]         system-wide syscall counts, by pid
>   failed-syscalls-by-pid [comm]        system-wide failed syscalls, by pid
>   sctop [comm]                         syscall top
>   syscall-counts [comm]                system-wide syscall counts
> 
> 
> And here's a few iterations of the output of the 'sctop' Python
> script:
> 
> root@tropicana:~# perf trace record sctop | perf trace report sctop
> perf trace started with Python script /root/libexec/perf-core/scripts/python/sctop.py
> 
> syscall events:
> 
> event                                          count
> ----------------------------------------  -----------
> 2                                                179
> 3                                                158
> 0                                                 79
> 78                                                24
> 5                                                 13
> 1                                                  3
> 16                                                 2
> 298                                                1
> 137                                                1
> 79                                                 1
> 72                                                 1
> 8                                                  1
> 
> syscall events:
> 
> event                                          count
> ----------------------------------------  -----------
> 0                                             659287
> 202                                             1995
> 1                                                812
> 2                                                246
> 3                                                224
> 78                                                56
> 12                                                51
> 5                                                 23
> 23                                                22
> 8                                                 18
> 7                                                 18
> 4                                                  9
> 38                                                 6
> 61                                                 5
> 254                                                4
> 20                                                 2
> 16                                                 2
> 137                                                1
> 15                                                 1
> 14                                                 1
> 9                                                  1
> 
> syscall events:
> 
> event                                          count
> ----------------------------------------  -----------
> 0                                             647178
> 202                                             1209
> 1                                                324
> 12                                                52
> 7                                                 29
> 14                                                 6
> 16                                                 4
> 23                                                 3
> 3                                                  3
> 72                                                 2
> 21                                                 1
> 11                                                 1
> 9                                                  1
> 5                                                  1
> 4                                                  1
> 2                                                  1
> 
> .
> .
> .
> 
> Obviously, it would be better to have a real top-like display for
> these rather than a continuously scrolling mode like this, and of
> course it will be much more useful once we get the syscall name
> injection events going (the column on the left shows syscall numbers
> only).
> 



That's a very nice thing. I guess that we could make
the scripting API to provide something to write such top
like things.

Providing a simple dict must be enough, something organized like
this:

topdict = {
	"colname" : [val1, val2, val3],
	"col2name" : [val4, val5, val6]
}

Or may be a callback that returns a dict.

