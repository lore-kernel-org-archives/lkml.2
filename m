Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2BQAYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:24:19 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39708 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470Ab2BQAYO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:24:14 -0500
MIME-Version: 1.0
In-Reply-To: <CABqD9hZd41AWZub+wxGWwxJtGWfk+pVWQhn7DM_0q0tS9r_wDA@mail.gmail.com>
References: <1329422549-16407-1-git-send-email-wad@chromium.org>
 <1329422549-16407-3-git-send-email-wad@chromium.org> <4F3D61CB.2000301@zytor.com>
 <CABqD9hb3WxKxLZ2GuUrbDM--koW+a3ser5TU8y6+e0sAhOT9dw@mail.gmail.com>
 <4F3D7250.6040504@zytor.com> <CAE6n16kweRehdozft0tKOB1P5LtGFJDCLQP=2EXfm8P0enyH=A@mail.gmail.com>
 <4F3D766E.7040205@zytor.com> <CABqD9haWxRLac1w3m9rSmyDvcg8jxYcxdmAAsgB7pEEBMHr=2g@mail.gmail.com>
 <4F3D7DD4.6070103@zytor.com> <CABqD9hZd41AWZub+wxGWwxJtGWfk+pVWQhn7DM_0q0tS9r_wDA@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 16 Feb 2012 16:23:53 -0800
X-Google-Sender-Auth: rSdR-UYHmyMlY6x5P1l9nO7sH5Q
Message-ID: <CAObL_7GJ2TdKpdvJRpiLh1c9KPGcTsELdhw7v4Vj39a0P0JxZg@mail.gmail.com>
Subject: Re: [PATCH v8 3/8] seccomp: add system call filtering using BPF
To: Will Drewry <wad@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Markus Gutschke <markus@chromium.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, keescook@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 3:00 PM, Will Drewry <wad@chromium.org> wrote:
> On Thu, Feb 16, 2012 at 4:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 02/16/2012 01:51 PM, Will Drewry wrote:
>>>>
>>>> Put the bloody bit in there and let the pattern program make that decision.
>>>
>>> Easy enough to add a bit for the mode: 32-bit or 64-bit.  It seemed
>>> like a waste of cycles for every 32-bit program or every 64-bit
>>> program to check to see that its calling convention hadn't changed,
>>> but it does take away a valid decision the pattern program should be
>>> making.
>>>
>>> I'll add a flag for 32bit/64bit while cleaning up seccomp_data. I
>>> think that will properly encapsulate the is_compat_task() behavior in
>>> a way that is stable for compat and non-compat tasks to use.  If
>>> there's a more obvious way, I'm all ears.
>>>
>>
>> is_compat_task() is not going to be the right thing for x86 going
>> forward, as we're introducing the x32 ABI (which uses the normal x86-64
>> entry point, but with different eax numbers, and bit 30 set.)
>>
>> The actual state is the TS_COMPAT flag in the thread_info structure,
>> which currently matches is_compat_task(), but perhaps we should add a
>> new helper function syscall_namespace() or something like that...
>
> Without the addition of x32, it is still the intersection of
> is_compat_task()/TS_COMPAT and CONFIG_64BIT for all arches to
> determine if the call is 32-bit or 64-bit, but this will add another
> wrinkle.  Would it make sense to assume that system call namespaces
> may be ever expanding and offer up an unsigned integer value?
>
> struct seccomp_data {
>  int nr;
>  u32 namespace;
>  u64 instruction_pointer;
>  u64 args[6];
> }
>
> Then syscall_namespace(current, regs) returns
> * 0 - SYSCALL_NS_32 (for existing 32 and config_compat)
> * 1 - SYSCALL_NS_64 (for existing 64 bit)
> * 2 - SYSCALL_NS_X32 (everything after 2 is arch specific)
> * ..
>
> This patch series is pegged to x86 right now, so it's not a big deal
> to add a simple syscall_namespace to asm/syscall.h.  Of course, the
> code is always the easy part.  Even easier would be to only assign 0
> and 1 in the seccomp_data for 32-bit or 64-bit, then leave the rest of
> the u32 untouched until x32 stabilizes and the TS_COMPAT interactions
> are sorted.
>
> The other option, of course, is to hide it from the users and peg to
> is_compat_task and later to however x32 is exposed, but that might
> just be me trying to avoid adding more dependencies to this patch
> series :)
>
>> Either that or we can just use another bit in the syscall number field...
>
> That would simplify the case here. The seccomp_data bit would say the
> call is 64-bit and then the syscall number with the extra bit would
> say that it is x32 and wouldn't collide with the existing 64-bit
> numbering, and the filter program author wouldn't make a filter
> program that allows a call that it shouldn't.

Presumably this works for x32 (since bit 30 might as well be part of
the syscall number), but the namespace or whatever it's called would
be nice to distinguish between the three 32-bit entry points.

For 32-bit code, I can easily see two different entry points getting
used in the same program -- some library could issue int80 directly,
but other code (in the vdso, for example, if it ever starts being
useful) could hit the other entry.  And if 64-bit code ever gets a new
entry point, the same problem would happen.

Of course, if the args are magically fixed up in the 32-bit case, then
maybe the multiple entries are a nonissue.  (Sorry, I haven't kept
track of that part of this patch set.)

--Andy
