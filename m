Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137Ab2CSS3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:29:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40596 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965049Ab2CSS3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:29:46 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <201203170116.11342.vda.linux@googlemail.com>
References: <CAKgNAkhiHKHSJofXNjCx-NTajzZ5L5Ak_y3YereSJn8dwE=npA@mail.gmail.com>
 <201203170116.11342.vda.linux@googlemail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 20 Mar 2012 07:29:23 +1300
Message-ID: <CAKgNAkjZszURpgoJFevRHcDwXzgjAHaryfjsrb9Gx8d7ttK=SQ@mail.gmail.com>
Subject: Re: man-pages-3.37 is released
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Denys,

On Sat, Mar 17, 2012 at 1:16 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> On Friday 09 March 2012 18:27, Michael Kerrisk (man-pages) wrote:
>> ptrace.2
>>     Denys Vlasenko  [Oleg Nesterov, Tejun Heo]
>>         add extended description of various ptrace quirks
>
> Pulled current git and spotted a few broken places.

I made a few light edits to your patch, but basically applied it as
given for man-pages-3.38.

Thanks for checking the page over one more time!

Cheers,

Michael



>       The  following  kinds  of  ptrace-stops  exist:  signal-delivery-stops,
>       group-stop,  PTRACE_EVENT   stops,   syscall-stops   PTRACE_SINGLESTEP,
>       PTRACE_SYSEMU,  and  They  all  are  reported  by  waitpid(2) with WIF-
>       STOPPED(status) true.
>
> The text is broken after "syscall-stops" word. Corresponding source is:
>
> group-stop, PTRACE_EVENT stops, syscall-stops
> .BR PTRACE_SINGLESTEP ,
> .BR PTRACE_SYSEMU ,
> and
> .BE PTRACE_SYSEMU_SINGLESTEP .
>
>
>
>       Signal-delivery-stop  is observed by the tracer as waitpid(2) returning
>       with WIFSTOPPED(status) true, with  the  stopping  signal  returned  by
>       WSTOPSIG(status).   If  the  stopping  signal is SIGTRAP, this may be a
>       different kind of ptrace-stop; ...
>
> The two instances of word "stopping" above are wrong and need to be deleted:
> ANY signal is reported this way, not only four signals which stop processes.
> This is an especially bad disinformation because in the sentences below
> we again use word "stopping":
>
>       ... see  the  "Syscall-stops"  and  "execve"
>       sections  below  for  details.   If WSTOPSIG(status) returns a stopping
>       signal, this may be a group-stop; see below.
>
> but here, we do mean "stopping" = "SIGSTOP/TSTP/TTIN/TTOU".
>
>
>
>       Note  that  a  suppressed  signal  still  causes system calls to return
>       prematurely.  Restartable system calls will be  restarted  (the  tracer
>       will  observe  the  tracee  to execute restart_syscall(2) if the tracer
>       uses PTRACE_SYSCALL); non-restartable system calls may fail with  EINTR
>       even though no observable signal is injected to the tracee.
>
> I learned more about this mechanism and the above text is wrong.
> A better text would be:
>
>       Note that a suppressed signal still causes system calls to return  pre-
>       maturely.  In this case system calls will be restarted: the tracer will
>       observe  the  tracee  to  re-execute  interrupted   system   call   (or
>       restart_syscall(2) system call for a few syscalls which use a different
>       mechanism for restarting) if the tracer uses PTRACE_SYSCALL.  Even sys-
>       tem  calls (such as poll(2)) which are not restartable after signal are
>       restarted after signal is suppressed; however, kernel bugs exist  which
>       cause some syscalls to fail with EINTR even though no observable signal
>       is injected to the tracee.
>
>
>
>       *  All  other  threads  stop  in   PTRACE_EVENT_EXIT   stop,   if   the
>          PTRACE_O_TRACEEXIT  option  was  turned  on.  Then all other threads
>          except the thread group leader report death as if  they  exited  via
>          _exit(2) with exit code 0.
>
>       *  Then  a  PTRACE_EVENT_EXEC  stop  happens, if the PTRACE_O_TRACEEXEC
>          option was turned on.
>
>       *  The execing tracee  changes  its  thread  ID  while  it  is  in  the
>          execve(2).   (Remember,  under ptrace, the "pid" returned from wait-
>          pid(2), or fed into ptrace calls, is the tracee's thread ID.)   That
>          is,  the  tracee's  thread ID is reset to be the same as its process
>          ID, which is the same as the thread group leader's thread ID.
>
> Above, bullet points 2 and 3 need to be swapped: thread ID change happens
> before PTRACE_EVENT_EXEC.
>
>
>       *  If the thread group leader has reported its death by this  time,  it
>          appears  to  the  tracer that the dead thread leader "reappears from
>          nowhere".
>
> Thread group leader does not report its death until there is
> at least one other live thread.
>
>
>
>       The PTRACE_O_TRACEEXEC option is the recommended tool for dealing  with
>       this situation.  It enables PTRACE_EVENT_EXEC stop, which occurs before
>       execve(2) returns.  First,  it  enables  PTRACE_EVENT_EXEC-stop,  which
>       occurs  before  execve(2)  returns.
>
> Duplicate sentence.
>
>       Currently, there is no way to retrieve the  former  thread  ID  of  the
>       execing  tracee.   If  the  tracer  doesn't  keep track of its tracees'
>       thread group relations, it may be unable to know  which  tracee  execed
>       and  therefore no longer exists under the old thread ID due to a thread
>       ID change.
>
> Two paragraphs above, we just said "In  this  stop,  the   tracer   can   use
>       PTRACE_GETEVENTMSG  to  retrieve  the tracee's former thread ID.  (This
>       feature was introduced in Linux 3.0)."
> So it is no longer true.
>
>
>
> Also, I propose the following additon to BUGS:
>
>       Some syscalls return with EINTR if a signal was sent to a  tracee,  but
>       delivery was suppressed by the tracer. (This is very typical operation:
>       it is usually done by debuggers on every attach, in order to not intro-
>       duce  a  bogus  SIGSTOP).   As of Linux-3.2, the following syscalls are
>       affected: epoll_wait(2), read(2) from inotify file descriptor. The list
>       is likely incomplete.
>
>
> The patch against current git is below.
> --
> vda
>
>
>
> diff --git a/man2/ptrace.2 b/man2/ptrace.2
> index 37c4dff..7f3c219 100644
> --- a/man2/ptrace.2
> +++ b/man2/ptrace.2
> @@ -722,11 +722,7 @@ Example:
>  .\"     describe how wait notifications queue (or not queue)
>  .LP
>  The following kinds of ptrace-stops exist: signal-delivery-stops,
> -group-stop, PTRACE_EVENT stops, syscall-stops
> -.BR PTRACE_SINGLESTEP ,
> -.BR PTRACE_SYSEMU ,
> -and
> -.BE PTRACE_SYSEMU_SINGLESTEP .
> +group-stop, PTRACE_EVENT stops, syscall-stops.
>  They all are reported by
>  .BR waitpid (2)
>  with
> @@ -766,9 +762,9 @@ Signal-delivery-stop is observed by the tracer as
>  .BR waitpid (2)
>  returning with
>  .I WIFSTOPPED(status)
> -true, with the stopping signal returned by
> +true, with the signal returned by
>  .IR WSTOPSIG(status) .
> -If the stopping signal is
> +If the signal is
>  .BR SIGTRAP ,
>  this may be a different kind of ptrace-stop;
>  see the "Syscall-stops" and "execve" sections below for details.
> @@ -802,12 +798,17 @@ value: the tracer can cause a different signal to be injected.
>  .LP
>  Note that a suppressed signal still causes system calls to return
>  prematurely.
> -Restartable system calls will be restarted (the tracer will
> -observe the tracee to execute
> +In this case system calls will be restarted: the tracer will
> +observe the tracee to re-execute interrupted system call (or
>  .BR restart_syscall(2)
> -if the tracer uses
> -.BR PTRACE_SYSCALL );
> -non-restartable system calls may fail with
> +system call for a few syscalls which use a different mechanism
> +for restarting) if the tracer uses
> +.BR PTRACE_SYSCALL .
> +Even system calls (such as
> +.BR poll(2) )
> +which are not restartable after signal are restarted after
> +signal is suppressed; however, kernel bugs exist which cause
> +some syscalls to fail with
>  .B EINTR
>  even though no observable signal is injected to the tracee.
>  .LP
> @@ -1406,12 +1407,6 @@ death as if they exited via
>  .BR _exit (2)
>  with exit code 0.
>  .IP *
> -Then a
> -.B PTRACE_EVENT_EXEC
> -stop happens, if the
> -.BR PTRACE_O_TRACEEXEC
> -option was turned on.
> -.IP *
>  The execing tracee changes its thread ID while it is in the
>  .BR execve (2).
>  (Remember, under ptrace, the "pid" returned from
> @@ -1420,9 +1415,22 @@ or fed into ptrace calls, is the tracee's thread ID.)
>  That is, the tracee's thread ID is reset to be the same as its process ID,
>  which is the same as the thread group leader's thread ID.
>  .IP *
> -If the thread group leader has reported its death by this time,
> +Then a
> +.B PTRACE_EVENT_EXEC
> +stop happens, if the
> +.BR PTRACE_O_TRACEEXEC
> +option was turned on.
> +.IP *
> +If the thread group leader has reported its
> +.B PTRACE_EVENT_EXIT
> +stop by this time,
>  it appears to the tracer that
>  the dead thread leader "reappears from nowhere".
> +(Note: thread group leader does not report death via
> +.I WIFEXITED(status)
> +until there is at least one other live thread.
> +This eliminates possibility that tracer will see
> +it dying and then reappearing.)
>  If the thread group leader was still alive,
>  for the tracer this may look as if thread group leader
>  returns from a different system call than it entered,
> @@ -1440,11 +1448,6 @@ the thread ID change in the tracee.
>  The
>  .B PTRACE_O_TRACEEXEC
>  option is the recommended tool for dealing with this situation.
> -It enables
> -.B PTRACE_EVENT_EXEC
> -stop, which occurs before
> -.BR execve (2)
> -returns.
>  First, it enables
>  .BR PTRACE_EVENT_EXEC -stop,
>  which occurs before
> @@ -1475,13 +1478,7 @@ data structures describing the threads of this process,
>  and retain only one data structure\(emone which
>  describes the single still running tracee, with
>
> -    thread ID == thread group ID == process id.
> -.LP
> -Currently, there is no way to retrieve the former
> -thread ID of the execing tracee.
> -If the tracer doesn't keep track of its tracees' thread group relations,
> -it may be unable to know which tracee execed and therefore no longer
> -exists under the old thread ID due to a thread ID change.
> +    thread ID == thread group ID == process ID.
>  .LP
>  Example: two threads call
>  .BR execve (2)
> @@ -1499,10 +1496,6 @@ PID2 execve("/bin/bar", "bar" <unfinished ...>
>  PID0 <... execve resumed> )             = 0
>  .fi
>  .LP
> -In this situation, there is no way to know which
> -.BR execve (2)
> -succeeded.
> -.LP
>  If the
>  .B PTRACE_O_TRACEEXEC
>  option is
> @@ -1713,6 +1706,17 @@ This may be changed in the future;
>  .B SIGKILL
>  is meant to always immediately kill tasks even under ptrace.
>  Last confirmed on 2.6.38.6.
> +.LP
> +Some syscalls return with
> +.B EINTR
> +if a signal was sent to a tracee, but delivery was suppressed
> +by the tracer. (This is very typical operation: it is usually
> +done by debuggers on every attach, in order to not introduce
> +a bogus SIGSTOP).
> +As of linux 3.2.9, the following syscalls are affected:
> +.BR epoll_wait (2),
> +.BR read (2)
> +from inotify file descriptor. The list is likely incomplete.
>  .SH "SEE ALSO"
>  .BR gdb (1),
>  .BR strace (1),



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
