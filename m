Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1HEUp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 16:45:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45097 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab1HEUpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 16:45:23 -0400
MIME-Version: 1.0
In-Reply-To: <4E3C5154.2050307@zytor.com>
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 5 Aug 2011 16:45:02 -0400
X-Google-Sender-Auth: eGcidA792d60CW5OvQM_dN_tJ4U
Message-ID: <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com>
Subject: Re: New vsyscall emulation breaks JITs
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 4:23 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/05/2011 01:09 PM, Andi Kleen wrote:
>>
>> Andy,
>>
>> We found that your new vsyscall emulation in
>>
>> commit 5cec93c216db77c45f7ce970d46283bcb1933884
>> Author: Andy Lutomirski <luto@MIT.EDU>
>> Date:   Sun Jun 5 13:50:24 2011 -0400
>>
>>     x86-64: Emulate legacy vsyscalls
>>
>> breaks JITs that execute x86 code and use the legacy vsyscalls.
>>
>> The problem is that the JIT translates the vsyscall page into
>> its code buffer and executes the "int 0xcc" there. Then
>> when the kernel gets the interrupt it doesn't see the vsyscall
>> page as the source and crashes the program.
>>
>> For some reason several modern executables also seem
>> to still use the old vsyscall page, so this problem can be hit
>> quickly.
>>
>> This happened with pin (http://www.pintool.org/), however
>> I expect it will affect all user space x86 JITs (valgrind,
>> dynamo, qemu-user, etc.)
>>
>> What to do? Right now this broke existing setups.
>>
>
> I have to say I believe that trying to JIT the vdso or vsyscall pages is
> extremely dubious at best.  They are fundamentally different from normal
> user space in that the kernel can muck with them any time, without
> notifying userspace about it.  The other aspect of this is that this is
> about the legacy vsyscall page, which we're trying to get rid of, partly
> because of security problems.

Valgrind in particular is already smart enough not to JIT
gettimeofday().  It crashes on the getcpu vsyscall with or without the
vsyscall emulation patch, so we get off easy there.  (I haven't tried
to debug it.)

I suspect that qemu-user won't have this problem either because I
doubt it looks into the vsyscall page in the first place.  Presumably
it just maps the original program.  In any case, it's a full emulator,
and I don't see why the host kernel should matter.

I'm a bit disinclined to play with Pin, because the license tells me
that I shouldn't reverse-engineer anything, and that would be the
whole point.  It claims to be pre-release code.

If by dynamo you mean DynamoRIO, I can't get it to build.


An older version of the vsyscall emulation code used a fancier
sequence that would survive relocation, although it involved a 'ret'
instruction and it would be nice not to put 'ret' into the vsyscall
page.


hpa: time is supported (as of 3.0) by the vdso, and very new glibc
uses the vdso version.  We could add a native time implementation back
to the vsyscall page without too much pain as a short-term fix, but
that would be less than ideal.

>
> As such, it's not entirely obvious what the right thing to do here is.
> On one hand, it "break user space" but on the other hand that is
> userspace doing something fundamentally broken in the first place.
>
>        -hpa
>
>
