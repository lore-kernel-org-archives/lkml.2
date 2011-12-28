Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1L1Xmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 18:42:44 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61829 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1L1Xmm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 18:42:42 -0500
MIME-Version: 1.0
In-Reply-To: <20111228224536.GA1025@dev3310.snc6.facebook.com>
References: <cover.1324831829.git.luto@amacapital.net> <16ecaa6abb8b7a25ef31970f71a42c7e2ba5416c.1324831829.git.luto@amacapital.net>
 <4EFB67AB.7060707@fb.com> <CALCETrVz1ADNxeLzPmeWXPU5ApfKURH2vnged2A2Vng8-hUxcw@mail.gmail.com>
 <20111228224536.GA1025@dev3310.snc6.facebook.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 28 Dec 2011 15:42:20 -0800
Message-ID: <CALCETrW+9OoEQnP1+9MJX+JO5Ch42QhUeo8i=k9YdaCwWhg=Xw@mail.gmail.com>
Subject: Re: [PATCH 1/4] Add clock_gettime_ns syscall
To: Arun Sharma <asharma@fb.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Kumar Sundararajan <kumar@fb.com>, linux-kernel@vger.kernel.org,
        john stultz <johnstul@us.ibm.com>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 2:45 PM, Arun Sharma <asharma@fb.com> wrote:
> On Wed, Dec 28, 2011 at 12:13:37PM -0800, Andy Lutomirski wrote:
>> > How about returning a (signed) long as the time in ns? This way, we save
>> a store and a load and the value can be passed in registers.
>> >
>> > This shouldn't preclude future expansion via extra args.
>>
>> With an unconditional store to a pointer?  If a null pointer is allowed,
>> the branch will probably kill any performance gain.
>
> No - please see the patch below.
>
>>
>> The downside is that this is probably a non-starter for a syscall on 32-bit
>> architectures.  I'll see what the i386 ABI says.  I wonder if returning a
>> struct will use registers for future expansion.
>>
>
> I was thinking of doing something similar to lseek() on 32 bit archs
> (i.e. by using a type similar to off_t that maps to the right thing for
> both 32 and 64 bit).

Huh?  That nanosecond count really needs to be 64 bits (or more).
2^32 nanoseconds is a rather short time.

>
> I used the code below to benchmark the performance of clock_gettime()
> vs clock_gettime_ns() when the client is interested in a nanosec based
> interface.
>
> gettimespec: 3.19 secs
> getns: 2.54 secs (21% faster)
>
>  -Arun
>
> PS: I didn't have to delete struct timens. I meant to drop timens.ns
> (since its the return value now).

How are you keeping the ability to add extra fields?

FWIW, returning a long long on i386 generates nice code (two registers
used), but returning a struct bigger than 64 bits uses a pointer
passed in via the stack (i.e. worse than passing a pointer as a
parameter).  Returning a struct with two 64-bit ints on x86-64 uses
registers, which is rather unfortunate.

Something like:

u64 __vdso_clock_gettime_ns(clock_t clockid, struct timens_extra *extra)
{
  extra->padding = 0;
  return <the time>;
}


might be okay.
