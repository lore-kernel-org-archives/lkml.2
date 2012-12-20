Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab2LTQSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:18:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54339 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab2LTQSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:18:42 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1355989294.24672.9.camel@wall-e>
References: <1355823656-13902-1-git-send-email-stefani@seibold.net> <1355823656-13902-7-git-send-email-stefani@seibold.net> <50D09733.3080502@zytor.com> <1355849558.26967.24.camel@wall-e> <50D0B986.7020009@zytor.com> <1355862759.28056.14.camel@wall-e> <CALCETrX2zAA-X7fjoPNSERq0kVDDY43O_u=Oqjq77_ggf64j9A@mail.gmail.com> <1355989294.24672.9.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 6/6] Add 32 bit VDSO support for 32 and 64 bit kernels
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 20 Dec 2012 08:17:41 -0800
To: Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Message-ID: <a881f355-720c-40aa-ad96-60fc86e96d53@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole point is to avoid fixed addresses.  We already install a list of pages as the vdso; the vvar and hpet pages can simply be part of that list.

Stefani Seibold <stefani@seibold.net> wrote:

>Am Dienstag, den 18.12.2012, 12:37 -0800 schrieb Andy Lutomirski:
>> On Tue, Dec 18, 2012 at 12:32 PM, Stefani Seibold
><stefani@seibold.net> wrote:
>> > Am Dienstag, den 18.12.2012, 10:44 -0800 schrieb H. Peter Anvin:
>> >> On 12/18/2012 08:52 AM, Stefani Seibold wrote:
>> >> >
>> >> > Pardon, i never disregarded nor i have agreed that this is going
>to be a
>> >> > part of the VDSO. I currently have also no idea how to do this
>and i see
>> >> > no need at the moment to do this revamp. The 64 bit VDSO lives
>since
>> >> > more than 6 years with this kind of implementation.
>> >> >
>> >>
>> >> It was part of this discussion thread, about how to best manage
>the
>> >> address space.  Fixed addresses are a major problem, and
>introducing new
>> >> ones are extremely undesirable.
>> >>
>> >
>> > There is no introduce of new fix address. There are still there for
>> > x86_64. If this will currently not a major problem on this
>architecture
>> > than it will not for x86_32 too.
>> 
>> Not necessarily true.  On x86-64 (non-compat) the fixmap address is
>in
>> kernel space (high bit set), so it can't conflict with anything in
>> user space.  On true 32-bit mode, the same applies.  In compat mode,
>> the fixed address is in *user* space and might conflict with existing
>> uses.
>> 
>> >
>> >> Hence I wrote:
>> >>
>> >> > IMO it seems this is making it way more complicated than it is.
>Just
>> >> > make sure you have a section in the vdso where you can map in a
>data
>> >> > page with the symbols in the right offsets. Extra points for
>doing
>> >> > magic so that it is at the beginning or end, but I think that
>might
>> >> > be harder than necessary.
>> >>
>> >> Basically, make the vvar and hpet pages part of the vdso page
>list.
>> >> Optionally they can be mapped without the MAYWRITE option -- in
>fact, we
>> >> could easily split the vdso into an executable area which gets
>MAYWRITE
>> >> to be able to set breakpoints and a data area which doesn't -- but
>that
>> >> is a minor tweak IMO.
>> >>
>> >
>> > I see the benefits, but it will not work under all circumstance.
>The
>> > VDSO compat mode for x86_32 requires a fix address and there is no
>room
>> > behind this. So since this must preserved, i see no real gain for
>this.
>> 
>> Not true.  It can be mapped with the vdso at a variable address using
>> GOTOFF addressing.  See my earlier email with
>> __attribute__((visibility("hidden")).
>> 
>> --Andy
>
>I am not sure that we talking about the same.
>
>In a 32 bit kernel a VDSO can mapped on an fix address VDSO_HIGH_BASE
>(kernel parameter vdso32=2 or CONFIG_COMPAT_VDSO), which is 0xffffe000.
>There is no available page before nor after this page, so there is no
>space for a multi page VDSO.
>
>The only way i see is to do this is a test in the vdso_...() functions
>for running on this address and than access the old fixmap addresses
>for
>VVAR and HPET. This can be done for example by a tweaking macro.
>
>If this is okay, i can do it. Otherwise i have no idea how to.
>
>- Stefani

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
