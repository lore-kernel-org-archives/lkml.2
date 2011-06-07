Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab1FGVSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:18:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52722 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab1FGVSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=lIXrtPA+kZ9fYtePGHSG1JjmoIOHxZ3i1K2liVgceS8f134DwIPsEm7l1kbK4yWN8F
         Rk5QY0tW0fP7ksW190UctyY6L9XBy1ogr/gQn/vGWsXnhSOmSG6LmZK+ODhEigoMEMkW
         AmHTdEu4d5/YwGF1+I3Z9a9hoa5/SNTDQR/vg=
MIME-Version: 1.0
In-Reply-To: <1307480780.3163.68.camel@work-vm>
References: <cover.1307474707.git.luto@mit.edu> <4a233d5b7421ef8f7805139e3eba68c52c2d0d57.1307474707.git.luto@mit.edu>
 <1307478514.3163.49.camel@work-vm> <BANLkTimU75BNGxTSDicAf5uJdaxqDUu57Q@mail.gmail.com>
 <1307480780.3163.68.camel@work-vm>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 7 Jun 2011 17:18:16 -0400
X-Google-Sender-Auth: 0gVNeuuwpSdIchCLeu6oTsGE-tE
Message-ID: <BANLkTimfnCJgv-YKGx3rR=F3qKT4uqjjjg@mail.gmail.com>
Subject: Re: [PATCH 4/5] clocksource: Replace vread and fsys_mmio with generic
 arch data
To: john stultz <johnstul@us.ibm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Clemens Ladisch <clemens@ladisch.de>, linux-ia64@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc: linux-arch]

On Tue, Jun 7, 2011 at 5:06 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Tue, 2011-06-07 at 16:35 -0400, Andrew Lutomirski wrote:
>> On Tue, Jun 7, 2011 at 4:28 PM, john stultz <johnstul@us.ibm.com> wrote:
>> >
>> > While having the ifdefs in the clocksource structure wasn't great, I'm
>> > not super excited about pushing all of this back into arch-specific
>> > code. The hope was that folks like ppc and ia64 would convert over from
>> > their own implementations to using more generic vread() implementations,
>> > or atleast new arches with vdso implementations would make use of it
>> > (possibly even allowing for a generic vdso gettime implementation).
>> >
>> > Are there at least some hard numbers that help justify this? Or maybe
>> > could you provide some thoughts on your future plans?
>>
>> No numbers because there's no speedup (yet).  Although I do want to
>> inline at least the TSC implementation eventually.
>>
>> The real reason is security.  Having vread be a function pointer
>> implies that userspace code can find that function at a fixed address,
>> which is a bad idea from a security POV (and I hope it's not even true
>> on any architecture except x86-64).
>
> Something to this effect should go into the change-log then.

Will do.

>> The followup change (patch 5) changes vread on x86-64 to specify TSC,
>
> Oh, sorry, I didn't see the rest of the patchset. Apologies. :)

No problem.  I guess I should have cc'd you on at least the interesting one.

>
>
>> HPET, or fallback to syscall, and the vDSO reads it and acts
>> accordingly.  This is unfortunate in that it hardcodes assumptions
>> about the clocksources.
>
> Yea, that is unfortunate. Hmm.
>
>> The only other way I can think of to do it is to make the pointer
>> point into the vDSO.  That would involve making it relative to
>> something in the vDSO, which would IMO be messier both in terms of
>> computing the pointer and in terms of calling whatever it points to.
>
> Hrm. I'm not super familiar with how the vDSO randomization works, so I
> can't really provide any informed insight here.
>
> But I'd def like to someday get the vDSO stuff to be as generic as
> possible. I already have some timekeeping changes I'd like to do which
> affect the update_vsyscall path. And that is a total pain to do, since I
> have to sync changes with x86, powerpc and ia64 (and the ia64 asm isn't
> something I'm likely to touch :) and get those changes in all at once,
> or introduce some redundant call or have lots of ifdef magic to keep
> compatibility while each arch adapts to the changes.

The vDSO is just like a regular DSO.  It's a bunch of code that's the
same in every process, but it's mapped in a different place for each
process.  The kernel knows how to find it if needed.

One idea: Add a directory linux/vDSO (i.e. a vDSO directory in the
root of the tree) that contains files that get compiled into the
vDSO).  Then generic timekeeping code can go in there.  That could
replace the duplicate clock_gettime implementation that currently
lives in the x86_64 vDSO, for example.

There could be a generic (or at least common) mechanism to compute a
"pointer" (i.e. some pointer-sized blob) to a vDSO function from the
kernel and another mechanism to resolve the pointer from the vDSO.
That pointer could go into vread.


Simpler idea: Make the clock_gettime implementation common (stick it
in a header, for example), but require the arch to supply functions to
check whether vread is available and to actually call vread.

--Andy
