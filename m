Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2BCXO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 18:14:57 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34524 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2BCXOz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 18:14:55 -0500
MIME-Version: 1.0
In-Reply-To: <20120202153232.GB4583@sergelap>
References: <1327788715-24076-1-git-send-email-wad@chromium.org>
	<1327788715-24076-2-git-send-email-wad@chromium.org>
	<20120202153232.GB4583@sergelap>
Date: Fri, 3 Feb 2012 15:14:52 -0800
Message-ID: <CABqD9hZ7bckPj+cCC-thGz2eu9iF-psX1EckpAmM6jivneFypA@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk, indan@nul.nu,
        mcgrathr@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 7:32 AM, Serge E. Hallyn
<serge.hallyn@canonical.com> wrote:
> Quoting Will Drewry (wad@chromium.org):
>> [This patch depends on luto@mit.edu's no_new_privs patch:
>>  https://lkml.org/lkml/2012/1/12/446
>> ]
>>
>> This patch adds support for seccomp mode 2.  This mode enables dynamic
>> enforcement of system call filtering policy in the kernel as specified
>> by a userland task.  The policy is expressed in terms of a Berkeley
>> Packet Filter program, as is used for userland-exposed socket filtering.
>> Instead of network data, the BPF program is evaluated over struct
>> seccomp_filter_data at the time of the system call.
>>
>> A filter program may be installed by a userland task by calling
>>   prctl(PR_ATTACH_SECCOMP_FILTER, &fprog);
>> where fprog is of type struct sock_fprog.
>>
>> If the first filter program allows subsequent prctl(2) calls, then
>> additional filter programs may be attached.  All attached programs
>> must be evaluated before a system call will be allowed to proceed.
>>
>> To avoid CONFIG_COMPAT related landmines, once a filter program is
>> installed using specific is_compat_task() value, it is not allowed to
>> make system calls using the alternate entry point.
>>
>> Filter programs will be inherited across fork/clone and execve, however
>> the installation of filters must be preceded by setting 'no_new_privs'
>> to ensure that unprivileged tasks cannot attach filters that affect
>> privileged tasks (e.g., setuid binary).  Tasks with CAP_SYS_ADMIN
>> in their namespace may install inheritable filters without setting
>> the no_new_privs bit.
>>
>> There are a number of benefits to this approach. A few of which are
>> as follows:
>> - BPF has been exposed to userland for a long time.
>> - Userland already knows its ABI: system call numbers and desired
>>   arguments
>> - No time-of-check-time-of-use vulnerable data accesses are possible.
>> - system call arguments are loaded on demand only to minimize copying
>>   required for system call number-only policy decisions.
>>
>> This patch includes its own BPF evaluator, but relies on the
>> net/core/filter.c BPF checking code.  It is possible to share
>> evaluators, but the performance sensitive nature of the network
>> filtering path makes it an iterative optimization which (I think :) can
>> be tackled separately via separate patchsets. (And at some point sharing
>> BPF JIT code!)
>>
>>  v6: - fix memory leak on attach compat check failure
>>      - require no_new_privs || CAP_SYS_ADMIN prior to filter
>>        installation. (luto@mit.edu)
>>      - s/seccomp_struct_/seccomp_/ for macros/functions
>>        (amwang@redhat.com)
>>      - cleaned up Kconfig (amwang@redhat.com)
>>      - on block, note if the call was compat (so the # means something)
>>  v5: - uses syscall_get_arguments
>>        (indan@nul.nu,oleg@redhat.com, mcgrathr@chromium.org)
>>      - uses union-based arg storage with hi/lo struct to
>>        handle endianness.  Compromises between the two alternate
>>        proposals to minimize extra arg shuffling and account for
>>        endianness assuming userspace uses offsetof().
>>        (mcgrathr@chromium.org, indan@nul.nu)
>>      - update Kconfig description
>>      - add include/seccomp_filter.h and add its installation
>>      - (naive) on-demand syscall argument loading
>>      - drop seccomp_t (eparis@redhat.com)
>>  v4: - adjusted prctl to make room for PR_[SG]ET_NO_NEW_PRIVS
>>      - now uses current->no_new_privs
>>          (luto@mit.edu,torvalds@linux-foundation.com)
>>      - assign names to seccomp modes (rdunlap@xenotime.net)
>>      - fix style issues (rdunlap@xenotime.net)
>>      - reworded Kconfig entry (rdunlap@xenotime.net)
>>  v3: - macros to inline (oleg@redhat.com)
>>      - init_task behavior fixed (oleg@redhat.com)
>>      - drop creator entry and extra NULL check (oleg@redhat.com)
>>      - alloc returns -EINVAL on bad sizing (serge.hallyn@canonical.com)
>>      - adds tentative use of "always_unprivileged" as per
>>        torvalds@linux-foundation.org and luto@mit.edu
>>  v2: - (patch 2 only)
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>
> Hi Will,
>
> as far as I can tell based on changelog I suspect you could have
> kept my Acked-by (from v3?).  However, I'll wait until your next
> submission (as I see there were a few change requests), and do a
> final complete new review of that.

Thanks, Serge!  I just failed at the proper protocol and didn't mean
to not include your Acked-by.   However, I am changing a fair amount
of the internals this time around, so I'll be happy to have another
full review.

> Thanks for continuing to push on this.

Definitely! I've been traveling this week, so it's been a bit slow
going, but I hope to have the next rev up early next week if not
sooner.

Cheers!
will
