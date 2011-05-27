Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab1E0Lge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 07:36:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58897 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab1E0Lgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 07:36:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=YDfehf6q+Y0xVZuJnCjOpK5K1AsTRwC9dQpRh/RYHRCznV6oISMVbC3bJMjDI56cr+
         k5HL2YQMEGT5E/yQIPt8iwS851LZD097ReyVFfcZR9q5sqP9y8u5TtXTv2nlhx4RzBhL
         Nphu7GUGz6gYzK9YNjsAeUGen6MiDR4Hx2UyA=
MIME-Version: 1.0
In-Reply-To: <20110527061208.GB9260@elte.hu>
References: <alpine.LFD.2.02.1105262049180.3078@ionos> <4DDEC589.3010201@mit.edu>
 <20110527061208.GB9260@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 27 May 2011 07:36:12 -0400
X-Google-Sender-Auth: pq6-NKUqSV-WarFdMHPCCJkIVsU
Message-ID: <BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
Subject: Re: [GIT pull] x86 vdso updates
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 2:12 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andy Lutomirski <luto@mit.edu> wrote:
>
>> On 05/26/2011 02:50 PM, Thomas Gleixner wrote:
>> >       x86-64: Add time to vDSO
>>
>> And here's the glibc bug:
>>
>> http://sourceware.org/bugzilla/show_bug.cgi?id=12813
>>
>> Let the deprecation of the vsyscall page begin :)
>
> Yeah :-)
>
> On a related note, now that these bits are upstream, what are your
> rough plans for doing the int81 vsyscall emulation patch?
>
> The int81 patch would actually be (much!) more important to the
> average Linux user than getting rid of the vsyscall from static
> binaries: the vsyscall is the last predictable executable address in
> PIE daemons with a dangerous SYSENTER instruction in it ...
>
> I'd actually consider accelerating it into v2.6.40.

Working on it slowly.  In principle I'm writing my thesis right now on
things that have very little to do with software :)

My rough plans for the near-term stuff are:

1. Move vvars out of the vsyscall page.  Otherwise we have at least
one predictable syscall instruction every 1<<16 seconds because the
time is executable.  It's prettier that way, too.

2. Remove the vsyscall64 sysctl.  That will reduce the number of
vsyscalls that require the kernel's help to one.  (This is a bit
unfortunate for UML users, but I'm not sure what to do about that.
UML vgetcpu is already terminally broken.)

3. Add int 0xcc and use it from vgettimeofday.  It will SIGSEGV if
called from a user address (so it has no risk of ever becoming ABI)
and it will do gettimeofday if called from the right address.  (I like
0xcc better than 0x81 because then I don't have to wonder whether any
syscall-like instructions start with 0x81.)  I'm not convinced that
the existing syscall entries are usable, because syscall itself has a
different calling convention and int 0x80 is a compat syscall.


I might get this done in something resembling time for 2.6.40, but no
guarantees.

For later, the whole vsyscall page could become 0xcd <0xcc * 1023>,
repeated four times.

To save me a bunch of spec reading and code dissection, can you
explain the difference between zeroentry and paranoidzeroentry?

>
> Thanks,
>
>        Ingo
>
