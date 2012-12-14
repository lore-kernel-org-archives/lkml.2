Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab2LNBmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:42:37 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34415 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab2LNBmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:42:35 -0500
MIME-Version: 1.0
In-Reply-To: <50CA81A4.9040702@zytor.com>
References: <1355343572-23074-1-git-send-email-stefani@seibold.net>
 <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e>
 <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com> <1355379433.24701.1.camel@wall-e>
 <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com> <1355383038.18653.2.camel@wall-e>
 <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com>
 <50CA6E4C.6000305@zytor.com> <CALCETrV1kvhOvDpzTavGb1X9HT+PdEPXJ0H8afs7jzxpcF7Kjg@mail.gmail.com>
 <50CA81A4.9040702@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Dec 2012 17:42:15 -0800
Message-ID: <CALCETrWCMQys5MCbd6E_7c+Bsvph5cfkrDDm5tNpyBdgVE-YeQ@mail.gmail.com>
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 5:32 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/13/2012 04:20 PM, Andy Lutomirski wrote:
>>
>>
>> What you could do is probably arrange (using some linker script magic)
>> for a symbol to exist that points at the page *before* the vdso
>> starts.  Then just map the vvar page there when starting a compat
>> task.  You could then address it using a normal symbol reference by
>> tweaking the vvar macro.  (I think this'll access it via the GOT.)
>> Alternatively, you could just pick an absolute address -- the page is
>> NX, so you don't really need to worry about randomization.
>>
>
> The best would probably if we could generate GOTOFF references rather than
> GOT, which again probably means making the vvar page part of the vdso
> proper.  Then, when building the list of vdso pages, we need to substitute
> in the vvar page in the proper place.
>
> I have to admit to kind of thinking this might work well even for the
> 64-bit/x32 case, and perhaps even for native 32 bits.

The 64-bit/x32 case is currently very simple and fast because it uses
absolute addressing.  Admittedly, pcrel references are free, so
changing this wouldn't cost much.  For native, it'll be slower, but
maybe no one cares.  I seem to care about this more than anyone else,
and I don't use 32 bit code. :)

The benefit of switching is that the vdso code could be the same in
all three cases.  (Actually, it's even better than that.  All of the
VVAR magic could be the same in the vdso and the kernel -- the kernel
linker script would just have to have an appropriate symbol to see the
appropriate mapping.)


This:

__attribute__((visibility("hidden"))) int foo;

int get_foo(void)
{
  return foo;
}

generates a rip-relative access on 64 bits and GOTOFF on 32 bits.

The only reason I didn't use a real symbol in the first place is
because I couldn't figure out how to get gcc to emit an absolute
relocation in pic code.

--Andy
