Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2APBlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 20:41:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51007 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab2APBlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 20:41:06 -0500
MIME-Version: 1.0
In-Reply-To: <4F12316E.6050204@xenotime.net>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
	<1326411506-16894-3-git-send-email-wad@chromium.org>
	<4F12316E.6050204@xenotime.net>
Date: Sun, 15 Jan 2012 19:41:03 -0600
Message-ID: <CABqD9hYg79C6ctW6dzsV1CQ8e3zDpAWiiRP+C1PgC2M6huubvA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] Documentation: prctl/seccomp_filter
From: Will Drewry <wad@chromium.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 7:52 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 01/12/2012 03:38 PM, Will Drewry wrote:
>> Documents how system call filtering using Berkeley Packet
>> Filter programs works and how it may be used.
>> Includes an example for x86 (32-bit).
>>
>> v3: - call out BPF <-> Berkeley Packet Filter (rdunlap@xenotime.net)
>>     - document use of tentative always-unprivileged
>>     - guard sample compilation for i386 and x86_64
>> v2: - move code to samples (corbet@lwn.net)
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>> ---
>>  Documentation/prctl/seccomp_filter.txt |   94 ++++++++++++++++++++++++++++++++
>>  samples/Makefile                       |    2 +-
>>  samples/seccomp/Makefile               |   18 ++++++
>>  samples/seccomp/bpf-example.c          |   74 +++++++++++++++++++++++++
>>  4 files changed, 187 insertions(+), 1 deletions(-)
>>  create mode 100644 Documentation/prctl/seccomp_filter.txt
>>  create mode 100644 samples/seccomp/Makefile
>>  create mode 100644 samples/seccomp/bpf-example.c
>>
>> diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
>> new file mode 100644
>> index 0000000..2db8b89
>> --- /dev/null
>> +++ b/Documentation/prctl/seccomp_filter.txt
>> @@ -0,0 +1,94 @@
>> +             Seccomp filtering
>> +             =================
>> +
>> +Introduction
>> +------------
>> +
>> +A large number of system calls are exposed to every userland process
>> +with many of them going unused for the entire lifetime of the process.
>> +As system calls change and mature, bugs are found and eradicated.  A
>> +certain subset of userland applications benefit by having a reduced set
>> +of available system calls.  The resulting set reduces the total kernel
>> +surface exposed to the application.  System call filtering is meant for
>> +use with those applications.
>> +
>> +Seccomp filtering provides a means for a process to specify a filter
>> +for incoming system calls.  The filter is expressed as a Berkeley Packet
>> +Filter (BPF) program, as with socket filters, except that the data
>> +operated on is the current user_regs_struct.  This allows for expressive
>> +filtering of system calls using the pre-existing system call ABI and
>> +using a filter program language with a long history of being exposed to
>> +userland.  Additionally, BPF makes it impossible for users of seccomp to
>> +fall prey to time-of-check-time-of-use (TOCTOU) attacks that are common
>> +in system call interposition frameworks because the evaluated data is
>> +solely register state just after system call entry.
>> +
>> +What it isn't
>> +-------------
>> +
>> +System call filtering isn't a sandbox.  It provides a clearly defined
>> +mechanism for minimizing the exposed kernel surface.  Beyond that,
>> +policy for logical behavior and information flow should be managed with
>> +a combinations of other system hardening techniques and, potentially, a
>
>     combination                                                         an
>
>> +LSM of your choosing.  Expressive, dynamic filters provide further options down
>> +this path (avoiding pathological sizes or selecting which of the multiplexed
>> +system calls in socketcall() is allowed, for instance) which could be
>> +construed, incorrectly, as a more complete sandboxing solution.
>> +
>> +Usage
>> +-----
>> +
>> +An additional seccomp mode is added, but they are not directly set by the
>> +consuming process.  The new mode, '2', is only available if
>> +CONFIG_SECCOMP_FILTER is set and enabled using prctl with the
>> +PR_ATTACH_SECCOMP_FILTER argument.
>> +
>> +Interacting with seccomp filters is done using one prctl(2) call.
>> +
>> +PR_ATTACH_SECCOMP_FILTER:
>> +     Allows the specification of a new filter using a BPF program.
>> +     The BPF program will be executed over a user_regs_struct data
>> +     reflecting system call time except with the system call number
>> +     resident in orig_[register].  To allow a system call, the size
>> +     of the data must be returned.  At present, all other return values
>> +     result in the system call being blocked, but it is recommended to
>> +     return 0 in those cases.  This will allow for future custom return
>> +     values to be introduced, if ever desired.
>> +
>> +     Usage:
>> +             prctl(PR_ATTACH_SECCOMP_FILTER, prog);
>> +
>> +     The 'prog' argument is a pointer to a struct sock_fprog which will
>> +     contain the filter program.  If the program is invalid, the call
>> +     will return -1 and set errno to -EINVAL.
>
>                                        EINVAL.
> (I think)
>
>> +
>> +     The struct user_regs_struct the @prog will see is based on the
>> +     personality of the task at the time of this prctl call.  Additionally,
>> +     is_compat_task is also tracked for the @prog.  This means that once set
>> +     the calling task will have all of its system calls blocked if it
>> +     switches its system call ABI (via personality or other means).
>> +
>> +     If fork/clone and execve are allowed by @prog, any child processes will
>> +     be constrained to the same filters and syscal call ABI as the parent.
>
>                                               syscall
>
>> +
>> +     When called from an unprivileged process (lacking CAP_SYS_ADMIN), the
>> +     "always_unprivileged" bit is enabled for the process.
>> +
>> +     Additionally, if prctl(2) is allowed by the attached filter,
>> +     additional filters may be layered on which will increase evaluation
>> +     time, but allow for further decreasing the attack surface during
>> +     execution of a process.
>> +
>> +The above call returns 0 on success and non-zero on error.
>> +
>> +Example
>> +-------
>> +
>> +samples/seccomp-bpf-example.c shows an example process that allows read from stdin,
>
>   samples/seccomp/bpf-example.c
>
>> +write to stdout/err, exit and signal returns for 32-bit x86.
>
>                  /stderr,
>

Thanks for the close reading! I've got another patchset mostly rolled
and I'll pull these in too.
will
