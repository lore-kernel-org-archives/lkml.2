Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2LNCMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:12:17 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37672 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab2LNCMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:12:16 -0500
MIME-Version: 1.0
In-Reply-To: <50CA85BD.7070502@zytor.com>
References: <1355343572-23074-1-git-send-email-stefani@seibold.net>
 <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e>
 <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com> <1355379433.24701.1.camel@wall-e>
 <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com> <1355383038.18653.2.camel@wall-e>
 <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com>
 <50CA6E4C.6000305@zytor.com> <CALCETrV1kvhOvDpzTavGb1X9HT+PdEPXJ0H8afs7jzxpcF7Kjg@mail.gmail.com>
 <50CA81A4.9040702@zytor.com> <CALCETrWCMQys5MCbd6E_7c+Bsvph5cfkrDDm5tNpyBdgVE-YeQ@mail.gmail.com>
 <50CA85BD.7070502@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Dec 2012 18:11:55 -0800
Message-ID: <CALCETrWKDJd1T_VCRNAzD-KTtYBbmvgE_ZYvb8uN4nBUYQvkgA@mail.gmail.com>
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
To: "H. Peter Anvin" <hpa@zytor.com>, criu@openvz.org
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 5:49 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/13/2012 05:42 PM, Andy Lutomirski wrote:
>>
>> The 64-bit/x32 case is currently very simple and fast because it uses
>> absolute addressing.  Admittedly, pcrel references are free, so
>> changing this wouldn't cost much.  For native, it'll be slower, but
>> maybe no one cares.  I seem to care about this more than anyone else,
>> and I don't use 32 bit code. :)
>>
>
> pcrel is actually cheaper than absolute addressing in 64-bit mode.
>
>> The benefit of switching is that the vdso code could be the same in
>> all three cases.  (Actually, it's even better than that.  All of the
>> VVAR magic could be the same in the vdso and the kernel -- the kernel
>> linker script would just have to have an appropriate symbol to see the
>> appropriate mapping.)
>>
>>
>> This:
>>
>> __attribute__((visibility("hidden"))) int foo;
>>
>> int get_foo(void)
>> {
>>   return foo;
>> }
>>
>> generates a rip-relative access on 64 bits and GOTOFF on 32 bits.
>>
>> The only reason I didn't use a real symbol in the first place is
>> because I couldn't figure out how to get gcc to emit an absolute
>> relocation in pic code.
>
> Well, then, we wouldn't need to do that... this is starting to sound
> like a significant win.

How will this avoid breaking checkpoint/restore in userspace?  If the
vdso is not just plain old code, criu presumably needs to know about
it.  Should there be an arch_prctl(ARCH_MAP_VDSO, addr) to create a
vdso mapping somewhere?

--Andy
