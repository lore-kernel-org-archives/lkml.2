Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686Ab1D1SXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:23:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33421 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab1D1SXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:23:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110428084621.5517ec8a.rdunlap@xenotime.net>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	<1303960136-14298-4-git-send-email-wad@chromium.org>
	<20110428084621.5517ec8a.rdunlap@xenotime.net>
Date: Thu, 28 Apr 2011 13:23:00 -0500
Message-ID: <BANLkTi=LpryxATT2=U2i2xHTTqatY0B4eg@mail.gmail.com>
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
From: Will Drewry <wad@chromium.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        rostedt@goodmis.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 10:46 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 27 Apr 2011 22:08:49 -0500 Will Drewry wrote:
>
>> Adds a text file covering what CONFIG_SECCOMP_FILTER is, how it is
>> implemented presently, and what it may be used for.  In addition,
>> the limitations and caveats of the proposed implementation are
>> included.
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>> ---
>>  Documentation/trace/seccomp_filter.txt |   75 ++++++++++++++++++++++++++++++++
>>  1 files changed, 75 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/trace/seccomp_filter.txt
>>
>> diff --git a/Documentation/trace/seccomp_filter.txt b/Documentation/trace/seccomp_filter.txt
>> new file mode 100644
>> index 0000000..6a0fd33
>> --- /dev/null
>> +++ b/Documentation/trace/seccomp_filter.txt
>> @@ -0,0 +1,75 @@
>> +             Seccomp filtering
>> +             =================
>> +
>> +Introduction
>> +------------
>> +
>> +A large number of system calls are exposed to every userland process
>> +with many of them going unused for the entire lifetime of the
>> +application.  As system calls change and mature, bugs are found and
>> +quashed.  A certain subset of userland applications benefit by having
>> +a reduce set of available system calls.  The reduced set reduces the
>
>     reduced
>
>> +total kernel surface exposed to the application.  System call filtering
>> +is meant for use with those applications.
>> +
>> +The implementation currently leverages both the existing seccomp
>> +infrastructure and the kernel tracing infrastructure.  By centralizing
>> +hooks for attack surface reduction in seccomp, it is possible to assure
>> +attention to security that is less relevant in normal ftrace scenarios,
>> +such as time of check, time of use attacks.  However, ftrace provides a
>> +rich, human-friendly environment for specifying system calls by name and
>> +expected arguments.  (As such, this requires FTRACE_SYSCALLS.)
>> +
>> +
>> +What it isn't
>> +-------------
>> +
>> +System call filtering isn't a sandbox.  It provides a clearly defined
>> +mechanism for minimizing the exposed kernel surface.  Beyond that, policy for
>> +logical behavior and information flow should be managed with an LSM of your
>> +choosing.
>> +
>> +
>> +Usage
>> +-----
>> +
>> +An additional seccomp mode is exposed through mode '2'.  This mode
>> +depends on CONFIG_SECCOMP_FILTER which in turn depends on
>> +CONFIG_FTRACE_SYSCALLS.
>> +
>> +A collection of filters may be supplied via prctl, and the current set of
>> +filters is exposed in /proc/<pid>/seccomp_filter.
>> +
>> +For instance,
>> +  const char filters[] =
>> +    "sys_read: (fd == 1) || (fd == 2)\n"
>> +    "sys_write: (fd == 0)\n"
>> +    "sys_exit: 1\n"
>> +    "sys_exit_group: 1\n"
>> +    "on_next_syscall: 1";
>> +  prctl(PR_SET_SECCOMP, 2, filters);
>> +
>> +This will setup system call filters for read, write, and exit where reading can
>> +be done only from fds 1 and 2 and writing to fd 0.  The "on_next_syscall" directive tells
>> +seccomp to not enforce the ruleset until after the next system call is run.  This allows
>> +for launchers to apply system call filters to a binary before executing it.
>> +
>> +Once enabled, the access may only be reduced.  For example, a set of filters may be:
>> +
>> +  sys_read: 1
>> +  sys_write: 1
>> +  sys_mmap: 1
>> +  sys_prctl: 1
>> +
>> +Then it may call the following to drop mmap access:
>> +  prctl(PR_SET_SECCOMP, 2, "sys_mmap: 0");
>> +
>> +
>> +Caveats
>> +-------
>> +
>> +The system call names come from ftrace events.  At present, many system
>> +calls are not hooked - such as x86's ptregs wrapped system calls.
>> +
>> +In addition compat_task()s will not be supported until a sys32s begin
>> +being hooked.
>
> Last sentence is hard to read IMO:
> a. what are compat_task()s?
> b. what is a sys32s begin?
> c. awkward wording, maybe change to:   until a sys32s begin has been hooked.

I'll clean it up and try again.  I believe the other thread discussing
the interface will change this last sentence anyway, so once it
settles, I'll update this patch to reflect the new reality.

thanks!
