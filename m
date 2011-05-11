Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab1EKQPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:15:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55156 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab1EKQPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:15:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s+RwB7B8IYy+5G1w336/7VZku5EEFE/vk6gqT7UA+GvX0W5qOjuc6eLZO+MAT+mX2+
         gtjD48bG7j4TcUZ/6NBKyhosYbDbISJgvfJbjGmmNA2ZhEUKsPe/AEgJLkKeIsVIbaHX
         RprL1+Qrm5NZ97aK4+/aV9HMp9pM3GDwKYpGY=
MIME-Version: 1.0
In-Reply-To: <1305071894.2736.50.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1304908814-23369-1-git-send-email-daniel.blueman@gmail.com>
	<20110510073551.GH11595@elte.hu>
	<BANLkTik0GTwV0Z21+UO69JX0cqjxwqu7jw@mail.gmail.com>
	<1305071894.2736.50.camel@sbsiddha-MOBL3.sc.intel.com>
Date: Thu, 12 May 2011 00:15:04 +0800
Message-ID: <BANLkTimvX3YXTxVSHDFm1N9a8vsALufrMg@mail.gmail.com>
Subject: Re: [PATCH] ioapic: fix potential resume deadlock
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 May 2011 07:58, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> On Tue, 2011-05-10 at 03:53 -0700, Daniel J Blueman wrote:
>> On 10 May 2011 15:35, Ingo Molnar <mingo@elte.hu> wrote:
>> > Hm, there must be some other bug here.
>> >
>> > ioapic entries should be allocated on system bootup and should never really be
>> > deallocated.
>> >
>> > The bug might be in the idea to call to enable_IR_x2apic() on resume - why are
>> > ioapic entries reallocated there? That call in default_setup_apic_routing() was
>> > introduced some time ago in:
>> >
>> >  fa47f7e52874: x86, x2apic: Simplify apic init in SMP and UP builds
>> >
>> > and that it results in reallocation in the suspend patch is distinctly wrong.
>> >
>> > I suspect the reason why this has not triggered for others is the relative
>> > rarity of affected systems?
>> >
>> > Suresh?
>
> This will happen only on interrupt-remapping enabled systems and hence
> hidden so far.
>
> enable_IR_x2apic() / default_setup_apic_routing() routines don't get
> called during resume. Problem is with the lapic_resume() path which is
> trying to re-enable x2apic mode and this requires masking io-apic
> entries, re-enabling x2apic and interrupt-remapping, restoring io-apic
> entries etc. ioapic entry allocation that is happening in lapic_resume()
> is just for storing the original io-apic RTE's during the mask/restore
> operations that happen around re-enabling x2apic.
>
> Anyways looking at that code, there is some duplicate code between
> x2apic code and the io-apic suspend/resume sequence. So a better fix
> will be to remove this duplicate code.
>
> Daniel, I appended a quick patch which should fix the problem you
> reported. This is not a final patch, as I can do some more cleanup and
> re-use the io-apic suspend/resume code a bit more.
>
> If this patch works for you, then I can spend some more time to do the
> complete cleanup patch in a day or two. Thanks.
[...]

Superb, this works, tested against 2.6.39-rc7 and addresses the "BUG:
sleeping function called from invalid context at mm/slub.c:824"
warning I was previously seeing. It would be good to get this fix into
2.6.39-final if possible.

Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>

Thanks,
  Daniel
-- 
Daniel J Blueman
