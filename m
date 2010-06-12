Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0FLNfC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 09:35:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:22405 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab0FLNe7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 09:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QqdZdQwwjnO1013bJqLIVcNX4rwXMVpnMGcLkyf+2ZVPWsf3pEBi9Up/MjC7BIW9BR
         o8yObSYNnfqUN9Rr1zcU5sDEWTDEsAYYn57pz9Gc80tZcCP5pUSSYaH0qkv4b0vetpj/
         EpprB9l91YtpTOpcRyoGQS+1qjaSl5+gt7qPA=
MIME-Version: 1.0
In-Reply-To: <4C02D408.1030306@zytor.com>
References: <201005271944.09541.toralf.foerster@gmx.de> <AANLkTimKwxYxM_PExplIDK1WPTQ9e_-CHn5SnIvfjfUg@mail.gmail.com> 
	<20100530150214.GA1565@liondog.tnic> <201005301728.25976.toralf.foerster@gmx.de> 
	<20100530170346.GC1565@liondog.tnic> <4C02B020.2040103@zytor.com> 
	<20100530193956.GA2498@liondog.tnic> <20100530201738.GB2498@liondog.tnic> 
	<4C02D408.1030306@zytor.com>
From: Paolo Giarrusso <p.giarrusso@gmail.com>
Date: Sat, 12 Jun 2010 15:34:38 +0200
Message-ID: <AANLkTimPSQ3K6ulqGV243w__IbMaJTG71VckB8gl701u@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH] x86, hweight: Fix UML boot crash
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Borislav Petkov <borislav.petkov@amd.com>,
       =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 23:09, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/30/2010 01:17 PM, Borislav Petkov wrote:
>>>> This bothers me, because it really feels like something is fundamentally
>>>> broken in UML tryingto track the upstream architecture, and this is just
>>>> a bandage.
>>>
>>> First of all, scratch that patch. It is indeed dumb idea to sprinkle UML
>>> special cases in x86 just because they include it.
>>>
>>> Which begs the question why _is_ UML sucking in x86 stuff and can anyone
>>> provide us with some sensible reasons? Because if there aren't any, it
>>> is their includes that should be fixed. Let me see what I can do to
>>> redirect hweight stuff properly...
>>
>> Ok, AFAICT UML is sucking in the includes of the sub-architecture the
>> UML "guest" is running on. See below¹ for the whole gcc string make
>> executes. Among the switches is
>>
>> "-I/home/boris/kernel/linux-2.6/arch/x86/include"
>>
>> so there will be no untangling today. Instead, we could do another
>> bandaid which is confined to UML include space only and redirect
>> arch_hweight.h includes to the generic ones. Check this out, it seems to
>> work here:
>>
>
> That looks better to me, although I'm still wondering why UML can't
> stomach the register-saving tricks... it is not at all "obvious" why
> that can't be done.
Hi all, and sorry for the delay, I hope you still care about this.

First, ARCH_HWEIGHT_CFLAGS should IMHO be shared with UML. I.e., moved
to arch/x86/Kconfig.cpu (which was born as Kconfig code shared with
UML), or copied in UML (it's not defined, as far as I can see).
Otherwise it just can't work. And I think that's it.

Second, I've been looking at arch_hweight.h to try answering as well,
and my question is: did somebody ever implement ALTERNATIVE support on
UML? When I worked on it, this thing didn't exist at all. The user
declared the host CPU, and we enabled features based on that. There's
barely code for exception tables, and we never used it to implement
copy_from_user and staff like that (I recall the exception handler was
set at run-time).

Indeed, arch/um/kernel/um_arch.c:apply_alternatives() is empty. And I
mean, implementing it is not so trivial (unlike exception handling),
simply because it requires making the binary mapping writable, and I'm
not sure UML does it already.

A third note is that UML links with glibc, so it can have a different
calling convention from the kernel. Say, on x86 32bit regparm doesn't
work (in fact, -mregparm is set in arch/x86/Makefile and not in
arch/x86/Makefile_32.cpu). And since popcnt is supported on 32bit, it
might in theory make a difference for that case. But maybe those flags
are simply fine, I didn't recheck the possible calling conventions.

Good bye!
-- 
Paolo Giarrusso - Ph.D. Student
http://www.informatik.uni-marburg.de/~pgiarrusso/
