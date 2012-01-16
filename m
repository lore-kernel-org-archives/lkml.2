Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab2APU2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:28:40 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35712 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab2APU21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:28:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAObL_7FMuomx-fAKUHA2mHAQrLSOOKF0=4ugkvk2b8rfFXk3EQ@mail.gmail.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<CAObL_7FMuomx-fAKUHA2mHAQrLSOOKF0=4ugkvk2b8rfFXk3EQ@mail.gmail.com>
Date: Mon, 16 Jan 2012 14:28:25 -0600
Message-ID: <CABqD9hZ5vZwDNcD37pGRcU+=qvffzJshqSU2pYPF+weMkhY8vg@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 11:02 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Wed, Jan 11, 2012 at 9:25 AM, Will Drewry <wad@chromium.org> wrote:
>> This patch adds support for seccomp mode 2.  This mode enables dynamic
>> enforcement of system call filtering policy in the kernel as specified
>> by a userland task.  The policy is expressed in terms of a BPF program,
>> as is used for userland-exposed socket filtering.  Instead of network
>> data, the BPF program is evaluated over struct user_regs_struct at the
>> time of the system call (as retrieved using regviews).
>>
>https://www.google.com/calendar?tab=mc&authuser=1
> There's some seccomp-related code in the vsyscall emulation path in
> arch/x86/kernel/vsyscall_64.c.  How should time(), getcpu(), and
> gettimeofday() be handled?

Nice catch:
  lxr.linux.no/linux+v3.2.1/arch/x86/kernel/vsyscall_64.c#L180
I'd missed it.

> If you want filtering to work, there
> aren't any real syscall registers to inspect, but they could be
> synthesized.

Hrm, I wonder if making sure orig_eax is populated with the
vsyscall_nr would be enough.  Unless I'm misreading, args 0 and 1 are
correct, so there may be other noise, but performing a call to
__secure_computing() (either in the case or with a pre-validate
syscall nr: 0-2) should send the do_exit.  Does that sound reasonable?

I'll try to do the right thing in my next patch set.

> Preventing a malicious task from figuring out approximately what time
> it is is basically impossible because of the way that vvars work.  I
> don't know how to change that efficiently.

There are other ways to guess the time too, so I don't think it's that
bad.  For those that are really worried, they could disable or
otherwise attempt to limit vsyscall access from their sandbox.

thanks!
will
