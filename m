Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1EPWRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 18:17:50 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:46583 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1EPWRt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 18:17:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ltilo9d9aZ6nyyAEflWLjsQbMNYn4C1OwAR0TBV9n0EFypCjBwLbmZIXNtNilfOnHL
         +ipEyq6om2cwNaHAdVgk5sA3UOhDyZwohlETNUjxqwSZ6++TTsKXSYZPd2vd754PyDgF
         RBlNsy0dkutdvkxD7JVqWJ3TsoTV5B5K7S+xs=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1105162345110.3078@ionos>
References: <cover.1305560561.git.luto@mit.edu> <20110516160943.GC25898@one.firstfloor.org>
 <alpine.LFD.2.02.1105161817120.3078@ionos> <20110516164939.GD25898@one.firstfloor.org>
 <BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com> <m2fwoeo0pf.fsf@firstfloor.org>
 <alpine.LFD.2.02.1105162345110.3078@ionos>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 16 May 2011 18:17:29 -0400
X-Google-Sender-Auth: Jvd9xZ22mlsvz5ARAGxr5xsTQrY
Message-ID: <BANLkTinVnr1ZM2wOxuH-rHZGh+_SBWT-+g@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 5:53 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 16 May 2011, Andi Kleen wrote:
>> Andrew Lutomirski <luto@mit.edu> writes:
>> > Longer term, it would be nice to mark the vsyscall page NX.  That
>> > involves a few things:
>>
>> Why NX? What would make sense is to call the VDSO from it.
>> The problem is that the vDSO is randomized and there's no good memory
>> location to store the pointer to it.
>>
>> The real reason for all this dance is to have some less non randomized
>> code around. What I implemented back then was instead code to patch out
>> the SYSCALL in there if not needed to lower the attack surface (not sure
>> if that still works though, but that was the idea). For most cases
>> (TSC/HPET read) it's not needed.
>>
>> Checking: someone removed the code meanwhile.
>
> For a damned good reason.
>
>> > And we won't have a
>> > syscall instruction sitting at a predictable address.
>>
>> The easy way to fix this is to just re-add the patching.
>
> If you can address _all_ reasons why it was removed then we might
> revisit that issue, but that's going to be an interesting patch.

We're now completely offtopic for the RDTSC patches, but do you have
any moral objection to rigging the vsyscall page to generate a fault
and emulating it after a couple years of deprecation?  If not, I can
see if I can persuade Uli to take accept a glibc patch to stop calling
it in future static glibc versions.

The long-term cost to the kernel will be a special case (and, compare,
unlikely branch) in whichever fault trap gets used.  The best way
might be to use a page full of 0xCC so that an int3 fault (presumably
not a performance-critical path) is taken.

--Andy
