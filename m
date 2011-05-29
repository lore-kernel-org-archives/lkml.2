Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab1E2Blq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 21:41:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51910 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab1E2Blp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 21:41:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Y3xvoh/599Ce7EFIZToYGSrm0Bv/24n+v4ThhMYraHlxALS1SIA6LO8y866nqRBFMS
         H+xNqXJk1lTQejXtmcXA5uckAciofas5lpBGG6AHzgJHLjFOKdwVwrGZXXVoQuE67ZqI
         4t8CD+ofw9HVNdriQASl+um7EcOfBaCdronEM=
MIME-Version: 1.0
In-Reply-To: <20110528153536.GB27104@elte.hu>
References: <alpine.LFD.2.02.1105262049180.3078@ionos> <4DDEC589.3010201@mit.edu>
 <20110527061208.GB9260@elte.hu> <BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
 <BANLkTikKAx=KXZuECAXaskhZOre-2ZHutw@mail.gmail.com> <20110528153536.GB27104@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 28 May 2011 21:41:25 -0400
X-Google-Sender-Auth: WcNflLhJw-IXYKjvnXnMY5k0tKc
Message-ID: <BANLkTimhK2d2C=U2umD_JqwiJD=jOf-kGA@mail.gmail.com>
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

On Sat, May 28, 2011 at 11:35 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Lutomirski <luto@mit.edu> wrote:
>
>> On Fri, May 27, 2011 at 7:36 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>> > 3. Add int 0xcc and use it from vgettimeofday.  It will SIGSEGV if
>> > called from a user address (so it has no risk of ever becoming ABI)
>> > and it will do gettimeofday if called from the right address.  (I like
>> > 0xcc better than 0x81 because then I don't have to wonder whether any
>> > syscall-like instructions start with 0x81.)  I'm not convinced that
>> > the existing syscall entries are usable, because syscall itself has a
>> > different calling convention and int 0x80 is a compat syscall.
>> >
>>
>> I started looking at what needs to be done and I wanted to get your
>> opinion before I wrote a bunch of code that you'd reject.  Here are
>> three ideas for how the int 0xcc / int 0x81 entry could work:
>>
>> *** Idea 1 ***
>>
>> Make it a real syscall but with extra constraints.  It would have the
>> same calling convention as the syscall instruction, but it would turn
>> into SIGKILL if the calling address isn't in the VSYSCALL page or if
>> the syscall number isn't __NR_clock_gettimeofday.  It would BUG() if
>> called from kernel mode.  There are two ways to implement this:
>>
>> 1. Have the interrupt entry check constraints, twiddle its stack frame
>> to look like a syscall instruction, and jump to the syscall entry.
>> This way there's little code duplication.  (Is it safe to sysret back
>> to userspace from an interrupt gate?  I don't see why not, but it
>> seems to violate the spirit of the thing.)
>
> Yeah, i think it should be safe. Lets try this? It looks like the
> simplest variant.

The code's in the thread "[PATCH 0/5] x86-64: Remove syscall
instructions at fixed addresses".

The interrupt handler ought to be reviewed especially carefully for
security since user code can call it at will.  It has two glaring
problems that I've found already, and I'll send a v2 out soon.

--Andy
