Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632Ab2DJWzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 18:55:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab2DJWzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 18:55:41 -0400
Date: Wed, 11 Apr 2012 00:55:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hang opening a pipe written to by a child, with SIGCHLD
Message-ID: <20120410225516.GA13486@redhat.com>
References: <20120409120326.f0ce7a94.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120409120326.f0ce7a94.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Andrew Morton wrote:
>
> Begin forwarded message:
>
> Date: Mon, 2 Apr 2012 16:46:11 +0200
> From: Lluís Batlle i Rossell <viric@viric.name>
> To: linux-kernel@vger.kernel.org
> Subject: Hang opening a pipe written to by a child, with SIGCHLD
>
>
> Hello,
>
> I had troubles running a simple bash script where a child wrote to a named pipe
> before dying, and the parent opened and read the pipe.
>
> On a computer, my script hangs always. Also under 'strace'. Not under 'strace
> -f'. Thinking of some race, I wrote a small script that hangs in the linuxes I
> could try (3.2.11 now):
>
> ----------
> #!/var/run/current-system/sw/bin/bash
>
> PIPE=/tmp/pipe
>
> rm -f $PIPE
> mkfifo $PIPE
>
> function spawn {
>     echo DONE > $PIPE
> }
>
> spawn sleep 1 &
>
> while true; do
>     echo reading
>     while read LINE < $PIPE; do
>         echo $LINE
>         spawn &
>     done
> done

Looks like, it hangs "correctly". At least from the kernel pov.

The parent sleeps in fifo_open()->wait_for_partner(), but there
are no pipe->writers.

Note that the parent (bash) re-opens /tmp/pipe after every "spawn".
Now,

	- the parent (bash) forks the new child

	- the new child sleeps waiting for reader

	- the parent does open(pipe), this wakes up the child

	- the child opens the pipe, writes, and exits

	- the open from the child wakes up the parent, but
	  since it exits quickly fifo_open(FMODE_READ) can
	  notice the pending SIGCHLD and return -EINTR

	- the parent restarts sys_open(), but nobody can
	  open it for writing

May be you can ask bash developers. Perhaps bash can move the
"restore stdin" logic into the child process, I dunno.

Or may be you can "fix" this script, just add "exec < $PIPE"
before the main "while true" loop.

Oleg.

