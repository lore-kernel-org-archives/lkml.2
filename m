Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1FXHYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 03:24:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35058 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1FXHY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 03:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f/GnHgYIRGoeF6BdTTBH4upo6toyobf8o5qeNH+/vQZ3iU77cszQV4aw/3Ckhq0Nem
         7EGtGl9VuJSJV6fu7BajVVU2e1RMTexPiC/Y62CY7voSzYFxpLjqE4HMUj40HyRfzOpy
         1G2Rc+4izUgDf5GPqaYwp0KP9rdn4ptz/h3SM=
MIME-Version: 1.0
In-Reply-To: <1308875813-20122-5-git-send-email-wad@chromium.org>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
	<1308875813-20122-5-git-send-email-wad@chromium.org>
Date: Fri, 24 Jun 2011 00:24:27 -0700
Message-ID: <BANLkTik=s+Sr4dwRzo0-6jOFWCAr0pcLvQ@mail.gmail.com>
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
From: Chris Evans <scarybeasts@gmail.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        djm@mindrot.org, segoon@openwall.com, kees.cook@canonical.com,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        fweisbec@gmail.com, tglx@linutronix.de,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just wanted to add a +1 for this facility, now that it has undergone
extensive review and tweaking. I've wanted something similar in the
Linux kernel for a long time.

With patches like these, there can be the concern: will anyone actually use it??

I will definitely be using this in vsftpd, Chromium and internally at Google.


Cheers
Chris

On Thu, Jun 23, 2011 at 5:36 PM, Will Drewry <wad@chromium.org> wrote:
>
> Adds a text file covering what CONFIG_SECCOMP_FILTER is, how it is
> implemented presently, and what it may be used for.  In addition,
> the limitations and caveats of the proposed implementation are
> included.
>
> v9: rebase on to bccaeafd7c117acee36e90d37c7e05c19be9e7bf
> v8: -
> v7: Add a caveat around fork behavior and execve
> v6: -
> v5: -
> v4: rewording (courtesy kees.cook@canonical.com)
>    reflect support for event ids
>    add a small section on adding per-arch support
> v3: a little more cleanup
> v2: moved to prctl/
>    updated for the v2 syntax.
>    adds a note about compat behavior
>
> Signed-off-by: Will Drewry <wad@chromium.org>
> ---
>  Documentation/prctl/seccomp_filter.txt |  189 ++++++++++++++++++++++++++++++++
>  1 files changed, 189 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/prctl/seccomp_filter.txt
>
> diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
> new file mode 100644
> index 0000000..a9cddc2
> --- /dev/null
> +++ b/Documentation/prctl/seccomp_filter.txt
> @@ -0,0 +1,189 @@
> +               Seccomp filtering
> +               =================
> +
> +Introduction
> +------------
> +
> +A large number of system calls are exposed to every userland process
> +with many of them going unused for the entire lifetime of the process.
> +As system calls change and mature, bugs are found and eradicated.  A
> +certain subset of userland applications benefit by having a reduced set
> +of available system calls.  The resulting set reduces the total kernel
> +surface exposed to the application.  System call filtering is meant for
> +use with those applications.
> +
> +The implementation currently leverages both the existing seccomp
> +infrastructure and the kernel tracing infrastructure.  By centralizing
> +hooks for attack surface reduction in seccomp, it is possible to assure
> +attention to security that is less relevant in normal ftrace scenarios,
> +such as time-of-check, time-of-use attacks.  However, ftrace provides a
> +rich, human-friendly environment for interfacing with system call
> +specific arguments.  (As such, this requires FTRACE_SYSCALLS for any
> +introspective filtering support.)
> +
> +
> +What it isn't
> +-------------
> +
> +System call filtering isn't a sandbox.  It provides a clearly defined
> +mechanism for minimizing the exposed kernel surface.  Beyond that,
> +policy for logical behavior and information flow should be managed with
> +a combinations of other system hardening techniques and, potentially, a
> +LSM of your choosing.  Expressive, dynamic filters based on the ftrace
> +filter engine provide further options down this path (avoiding
> +pathological sizes or selecting which of the multiplexed system calls in
> +socketcall() is allowed, for instance) which could be construed,
> +incorrectly, as a more complete sandboxing solution.
> +
> +
> +Usage
> +-----
> +
> +An additional seccomp mode is exposed through mode '2'.
> +This mode depends on CONFIG_SECCOMP_FILTER.  By default, it provides
> +only the most trivial of filter support "1" or cleared.  However, if
> +CONFIG_FTRACE_SYSCALLS is enabled, the ftrace filter engine may be used
> +for more expressive filters.
> +
> +A collection of filters may be supplied via prctl, and the current set
> +of filters is exposed in /proc/<pid>/seccomp_filter.
> +
> +Interacting with seccomp filters can be done through three new prctl calls
> +and one existing one.
> +
> +PR_SET_SECCOMP:
> +       A pre-existing option for enabling strict seccomp mode (1) or
> +       filtering seccomp (2).
> +
> +       Usage:
> +               prctl(PR_SET_SECCOMP, 1);  /* strict */
> +               prctl(PR_SET_SECCOMP, 2);  /* filters */
> +
> +PR_SET_SECCOMP_FILTER:
> +       Allows the specification of a new filter for a given system
> +       call, by number, and filter string.  By default, the filter
> +       string may only be "1".  However, if CONFIG_FTRACE_SYSCALLS is
> +       supported, the filter string may make use of the ftrace
> +       filtering language's awareness of system call arguments.
> +
> +       In addition, the event id for the system call entry may be
> +       specified in lieu of the system call number itself, as
> +       determined by the 'type' argument.  This allows for the future
> +       addition of seccomp-based filtering on other registered,
> +       relevant ftrace events.
> +
> +       All calls to PR_SET_SECCOMP_FILTER for a given system
> +       call will append the supplied string to any existing filters.
> +       Filter construction looks as follows:
> +               (Nothing) + "fd == 1 || fd == 2" => fd == 1 || fd == 2
> +               ... + "fd != 2" => (fd == 1 || fd == 2) && fd != 2
> +               ... + "size < 100" =>
> +                       ((fd == 1 || fd == 2) && fd != 2) && size < 100
> +       If there is no filter and the seccomp mode has already
> +       transitioned to filtering, additions cannot be made.  Filters
> +       may only be added that reduce the available kernel surface.
> +
> +       Usage (per the construction example above):
> +               unsigned long type = PR_SECCOMP_FILTER_SYSCALL;
> +               prctl(PR_SET_SECCOMP_FILTER, type, __NR_write,
> +                       "fd == 1 || fd == 2");
> +               prctl(PR_SET_SECCOMP_FILTER, type, __NR_write,
> +                       "fd != 2");
> +               prctl(PR_SET_SECCOMP_FILTER, type, __NR_write,
> +                       "size < 100");
> +
> +       The 'type' argument may be one of PR_SECCOMP_FILTER_SYSCALL or
> +       PR_SECCOMP_FILTER_EVENT.
> +
> +PR_CLEAR_SECCOMP_FILTER:
> +       Removes all filter entries for a given system call number or
> +       event id.  When called prior to entering seccomp filtering mode,
> +       it allows for new filters to be applied to the same system call.
> +       After transition, however, it completely drops access to the
> +       call.
> +
> +       Usage:
> +               prctl(PR_CLEAR_SECCOMP_FILTER,
> +                       PR_SECCOMP_FILTER_SYSCALL, __NR_open);
> +
> +PR_GET_SECCOMP_FILTER:
> +       Returns the aggregated filter string for a system call into a
> +       user-supplied buffer of a given length.
> +
> +       Usage:
> +               prctl(PR_GET_SECCOMP_FILTER,
> +                       PR_SECCOMP_FILTER_SYSCALL, __NR_write, buf,
> +                       sizeof(buf));
> +
> +All of the above calls return 0 on success and non-zero on error.  If
> +CONFIG_FTRACE_SYSCALLS is not supported and a rich-filter was specified,
> +the caller may check the errno for -ENOSYS.  The same is true if
> +specifying an filter by the event id fails to discover any relevant
> +event entries.
> +
> +
> +Example
> +-------
> +
> +Assume a process would like to cleanly read and write to stdin/out/err
> +as well as access its filters after seccomp enforcement begins.  This
> +may be done as follows:
> +
> +  int filter_syscall(int nr, char *buf) {
> +    return prctl(PR_SET_SECCOMP_FILTER, PR_SECCOMP_FILTER_SYSCALL,
> +                 nr, buf);
> +  }
> +
> +  filter_syscall(__NR_read, "fd == 0");
> +  filter_syscall(_NR_write, "fd == 1 || fd == 2");
> +  filter_syscall(__NR_exit, "1");
> +  filter_syscall(__NR_prctl, "1");
> +  prctl(PR_SET_SECCOMP, 2);
> +
> +  /* Do stuff with fdset . . .*/
> +
> +  /* Drop read access and keep only write access to fd 1. */
> +  prctl(PR_CLEAR_SECCOMP_FILTER, PR_SECCOMP_FILTER_SYSCALL, __NR_read);
> +  filter_syscall(__NR_write, "fd != 2");
> +
> +  /* Perform any final processing . . . */
> +  syscall(__NR_exit, 0);
> +
> +
> +Caveats
> +-------
> +
> +- Avoid using a filter of "0" to disable a filter.  Always favor calling
> +  prctl(PR_CLEAR_SECCOMP_FILTER, ...).  Otherwise the behavior may vary
> +  depending on if CONFIG_FTRACE_SYSCALLS support exists -- though an
> +  error will be returned if the support is missing.
> +
> +- execve is always blocked.  seccomp filters may not cross that boundary.
> +
> +- Filters can be inherited across fork/clone but only when they are
> +  active (e.g., PR_SET_SECCOMP has been set to 2), but not prior to use.
> +  This stops the parent process from adding filters that may undermine
> +  the child process security or create unexpected behavior after an
> +  execve.
> +
> +- Some platforms support a 32-bit userspace with 64-bit kernels.  In
> +  these cases (CONFIG_COMPAT), system call numbers may not match across
> +  64-bit and 32-bit system calls. When the first PRCTL_SET_SECCOMP_FILTER
> +  is called, the in-memory filters state is annotated with whether the
> +  call has been made via the compat interface.  All subsequent calls will
> +  be checked for compat call mismatch.  In the long run, it may make sense
> +  to store compat and non-compat filters separately, but that is not
> +  supported at present. Once one type of system call interface has been
> +  used, it must be continued to be used.
> +
> +
> +Adding architecture support
> +-----------------------
> +
> +Any platform with seccomp support should be able to support the bare
> +minimum of seccomp filter features.  However, since seccomp_filter
> +requires that execve be blocked, it expects the architecture to expose a
> +__NR_seccomp_execve define that maps to the execve system call number.
> +On platforms where CONFIG_COMPAT applies, __NR_seccomp_execve_32 must
> +also be provided.  Once those macros exist, "select HAVE_SECCOMP_FILTER"
> +support may be added to the architectures Kconfig.
> --
> 1.7.0.4
>
