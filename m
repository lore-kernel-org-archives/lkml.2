Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2LNV10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:27:26 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38258 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab2LNV1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:27:25 -0500
MIME-Version: 1.0
In-Reply-To: <50CB9553.7050808@zytor.com>
References: <50CA81A4.9040702@zytor.com> <CALCETrWCMQys5MCbd6E_7c+Bsvph5cfkrDDm5tNpyBdgVE-YeQ@mail.gmail.com>
 <50CA85BD.7070502@zytor.com> <CALCETrWKDJd1T_VCRNAzD-KTtYBbmvgE_ZYvb8uN4nBUYQvkgA@mail.gmail.com>
 <8c3585bc-fc7d-4826-913c-f4581494d91d@email.android.com> <CALCETrX5KUiQaV7dsAFa1SYyWPjUVwh43HvbPwqPStMxqE0ctQ@mail.gmail.com>
 <50CAE485.5020608@parallels.com> <50CB716D.6020501@zytor.com>
 <CALCETrWazriQVbQPc8u+KFyNUaa=kJUc=jdh9w7z6rS+kWEX1w@mail.gmail.com>
 <50CB7459.7010107@zytor.com> <20121214201217.GE6582@moon> <50CB9553.7050808@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 14 Dec 2012 13:27:04 -0800
Message-ID: <CALCETrUS7JDtLd0jYy7cRNoBm1VHhMw3sTPRjhsm3uDwoPQrCA@mail.gmail.com>
Subject: Re: [CRIU] [PATCH] Add VDSO time function support for x86 32-bit kernel
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, aarcange@redhat.com,
        ak@linux.intel.com, Pavel Emelyanov <xemul@parallels.com>,
        Stefani Seibold <stefani@seibold.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, criu@openvz.org, mingo@redhat.com,
        john.stultz@linaro.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 1:08 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/14/2012 12:12 PM, Cyrill Gorcunov wrote:
>>>>
>>> The real issue is that happens if the process is checkpointed while
>>> inside the vdso and now eip/rip or a stack frame points into the vdso.
>>> This is not impossible or even unlikely, especially on 32 bits it is
>>> downright likely.
>>
>> I fear if there are stacked ip which point to vdso -- we simply won't
>> be able to restore properly if vdso internal format changed significantly
>> between kernel versions. (At moment we restore vdso exactly at same position
>> it was on checkpoint stage with same content, iirc).
>>
>
> I don't think there is a way around that.  It is completely unreasonable
> to say that the vdso cannot change between kernel versions, for obvious
> reasons.  It's worse than "significantly"... changing even one
> instruction makes it plausible your eip/rip will point into the middle
> of an instruction.

It's not just kernel versions -- different toolchains may generate
different code.  Heck, building from a different directory can
sometimes generate different output.

The ABI of each vdso function is stable, though -- a sufficiently
clever tool could (maybe) use that knowledge along with unwind data in
the vdso to fix everything up.  This would be interesting, perhaps,
but certainly not easy.

I say we declare "if you want a working vdso in a weird location,
mremap it".  But how does userspace figure out what size to pass to
mremap?  If it's one vma, it's easy.

I don't know all that much about the linux vm.  Can we create a
special vdso address_space or struct inode or something so that a
single vma can contain pages with different flags?

--Andy
