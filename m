Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935105Ab1ESVzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:55:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46664 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935018Ab1ESVzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:55:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uJuDZ53oiyQd9MlSNAuS1zm2Gq87YfINYg8mmpfWdUHT9cQkTPxm89xWPjrK5a3nZn
         6LDCm94sO/sgnzA2Mrc8Nk45gU592p2HL+L9UeNTarHd8pd7p2ItYEeY3iZiUtutWffk
         /lpM2zB7sk17ork96Z7soF1fJqrS8nbx6RqUU=
MIME-Version: 1.0
In-Reply-To: <29601.1305840992@neuling.org>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	<1305753895-24845-3-git-send-email-ericvh@gmail.com>
	<425.1305784718@neuling.org>
	<BANLkTimKhApFW8G1-pG0u_9Kv2YB0R1O0w@mail.gmail.com>
	<29601.1305840992@neuling.org>
Date: Thu, 19 May 2011 16:55:06 -0500
Message-ID: <BANLkTi=rc5vZm3xAXHpHSxSH1wBWKhv92A@mail.gmail.com>
Subject: Re: [PATCH 3/7] [RFC] add support for BlueGene/P FPU
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damnit Mikey, just after I hit send on [V2].....

On Thu, May 19, 2011 at 4:36 PM, Michael Neuling <mikey@neuling.org> wrote:
> In message <BANLkTimKhApFW8G1-pG0u_9Kv2YB0R1O0w@mail.gmail.com> you wrote:
>> On Thu, May 19, 2011 at 12:58 AM, Michael Neuling <mikey@neuling.org> wrote=
>> :
>> > Eric,
>> >
>> >> This patch adds save/restore register support for the BlueGene/P
>> >> double hummer FPU.
>> >
>> > What does this mean? =A0Needs more details here.
>> >

okay, I've changed it a bit in [V2], if you want more I can do my best.

>> "Each of the two FPU units contains 32 64-bit floating point registers
>> for a total of 64 FP registers per processor." which would seem to
>> point to the kittyhawk version - but they have a second SAVE_32SFPRS
>> for the second hummer.  What wasn't clear to me with this version of
>> the code was whether or not they were doing something clever like
>> saving the pair of the 64-bit FPU registers in a single 128-bit slot
>> (seems plausible).
>
> Ok, sounds like there is 32*8*2 bytes of data, rather than the normal
> 32*8 bytes for FP only (ignoring VSX).  If this is the case, then you'll
> need make 'fpr' in the thread struct bigger which you can do by setting
> TS_FPRWIDTH = 2 like we do for VSX.
>

Okay, I'll incorporate that into [V3].

> If there is some instruction that saves and restores two of these at a
> time (which LFPDX/STFPDX might I guess), then we can use that, otherwise
> we'll have to do 64 saves/restores.  Double load/stores will be faster
> I'm guessing though.

I assume that's true.

>
> If two at a time, do we need to increase the index in pairs?
>

I don't believe so.

>> If this is not the way to go, I can certainly
>> switch the kittyhawk version of the patch with the *, the extra
>> SAVE32SFPR and the extra double hummer specific storage space in the
>> thread_struct.
>
> I'd be tempted to keep it in the 'fpr' part of the struct so you can
> then access it with ptrace/signals/core dumps.
>
>> If it would help I can post an alternate version of the patch for
>> discussion with the kittyhawk version.
>
> Sure.
>

Kittyhawk version can be seen here:

http://git.kernel.org/?p=linux/kernel/git/ericvh/bluegene.git;a=commitdiff;h=94bffe786324b9bd07187b11afd836e3ec362d95

>
> The most useful thing would be to see the instruction definition for
> STFPDX/LFPDX.
>

https://wiki.alcf.anl.gov/images/d/d9/PPC440_FP2_arch.pdf

>>
>> >> =A0/*
>> >> diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms=
>> /44x/
>> > Kconfig
>> >> index f485fc5f..24a515e 100644
>> >> --- a/arch/powerpc/platforms/44x/Kconfig
>> >> +++ b/arch/powerpc/platforms/44x/Kconfig
>> >> @@ -169,6 +169,15 @@ config YOSEMITE
>> >> =A0 =A0 =A0 help
>> >> =A0 =A0 =A0 =A0 This option enables support for the AMCC PPC440EP evalua=
>> tion board.
>> >>
>> >> +config =A0 =A0 =A0 BGP
>> >
>> > Does this FPU feature have a specific name like double hammer? =A0I'd
>> > rather have the BGP defconfig depend on PPC_FPU_DOUBLE_HUMMER, or
>> > something like that...
>> >
>> >> + =A0 =A0 bool "Blue Gene/P"
>> >> + =A0 =A0 depends on 44x
>> >> + =A0 =A0 default n
>> >> + =A0 =A0 select PPC_FPU
>> >> + =A0 =A0 select PPC_DOUBLE_FPU
>> >
>> > ... in fact, it seem you are doing something like these here but you
>> > don't use PPC_DOUBLE_FPU anywhere?
>> >
>>
>> A fair point.  I'm fine with calling it DOUBLE_HUMMER, but I wasn't sure if
>> that was "too internal" of a name for the kernel.  Let me know and
>> I'll fix it up.
>
> What I'm mostly concerned about is disassociating it with a particular
> CPU.
>
> If it has an external name, then all the better.
>

Since it isn't available on other chips, shoudl it just be PPC_BGP_FPU
or PPC_BGP_DOUBLE_FPU?

      -eric
