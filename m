Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab2LNAUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:20:36 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51881 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab2LNAUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:20:35 -0500
MIME-Version: 1.0
In-Reply-To: <50CA6E4C.6000305@zytor.com>
References: <1355343572-23074-1-git-send-email-stefani@seibold.net>
 <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e>
 <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com> <1355379433.24701.1.camel@wall-e>
 <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com> <1355383038.18653.2.camel@wall-e>
 <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com> <50CA6E4C.6000305@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Dec 2012 16:20:14 -0800
Message-ID: <CALCETrV1kvhOvDpzTavGb1X9HT+PdEPXJ0H8afs7jzxpcF7Kjg@mail.gmail.com>
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 4:09 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/13/2012 11:32 AM, Andy Lutomirski wrote:
>>
>>
>> x32's vdso cheats -- x32 code can see high addresses just fine.  The
>> toolchain just makes it difficult.
>>
>> Your best bet is probably to just map the vvar page twice -- once at
>> the same address as native 32-bit mode (but only for compat tasks)
>> would use and once in the usual fixmap location.  You can't use the
>> fixmap for the compat mapping, though, since it would be a *user*
>> address.
>>
>> For HPET support, you'd have to have special support.  I'd say to skip
>> it for compat mode.
>>
>
> Whatever data you need you can just map it into the vdso range.  There
> really shouldn't be anything special about that at all.
>
> The fixmap stuff is an x86-64 legacy that you don't have to worry about,
> obviously.

The fixmap page is new.  It's not ABI -- the layout can freely change,
but the vdso needs to be able to see.  It would make no sense to cow
that page, and it would be more complicated to make it be part of the
(64-bit) vdso, so I left it as a fixmap when I did the vvar cleanups.

For compat mode, though, I don't think it can be in the fixmap unless
there are segmentation games that I think are impossible, or unless
the vdso wants to do a far call (which I would guess is not much
faster than a system call, although I haven't benchmarked it).  This
is because there are no addresses at all that can be seen from 32-bit
code segments and that are in the kernel address range.

What you could do is probably arrange (using some linker script magic)
for a symbol to exist that points at the page *before* the vdso
starts.  Then just map the vvar page there when starting a compat
task.  You could then address it using a normal symbol reference by
tweaking the vvar macro.  (I think this'll access it via the GOT.)
Alternatively, you could just pick an absolute address -- the page is
NX, so you don't really need to worry about randomization.

--Andy
