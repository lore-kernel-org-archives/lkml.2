Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1EQLL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 07:11:27 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:54711 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab1EQLL0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 07:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=SPEIjrgGE6mUW5t5/O1kdo/GgJLvtEojLpdpmSVBQQ1BeG0O+3gZ+2VfCrrvrufCah
         gOicxidiy35pLRR7I7CM7dNGdjCX/gHsjYrJtduUp8wOyTbWievb5JE7N+lyZRUovw/O
         AUGBc5/eJiaXzVMuv0+y2ZCnBzY+f00d6hpWA=
MIME-Version: 1.0
In-Reply-To: <20110517080029.GB22093@elte.hu>
References: <cover.1305560561.git.luto@mit.edu> <20110516160943.GC25898@one.firstfloor.org>
 <alpine.LFD.2.02.1105161817120.3078@ionos> <20110516164939.GD25898@one.firstfloor.org>
 <BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com> <m2fwoeo0pf.fsf@firstfloor.org>
 <alpine.LFD.2.02.1105162345110.3078@ionos> <BANLkTinVnr1ZM2wOxuH-rHZGh+_SBWT-+g@mail.gmail.com>
 <alpine.LFD.2.02.1105170022430.3078@ionos> <20110517080029.GB22093@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 17 May 2011 07:11:06 -0400
X-Google-Sender-Auth: dyyOzZ5vifJCdMZgEzIt6a7vsOE
Message-ID: <BANLkTimpEfb3P9FWgrCDwSSVr6RA8nXb5w@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
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

On Tue, May 17, 2011 at 4:00 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> > see if I can persuade Uli to take accept a glibc patch to stop calling it
>> > in future static glibc versions.
>>
>> How wide spread is this in reality on 64bit systems ?
>>
>> IOW, what's the damage if we take a trap and emulate it in the most painful
>> way we can come up with ?

I dunno.  I'll measure it.

>
> Well, how does that differ from having the real syscall instruction there? How
> are we going to filter real (old-)glibc calls from exploits?

Because there are only four vsyscalls: vgettimeofday, vtime, vgetcpu,
and venosys.  None of them have side-effects, so they only allow an
attacker to write something to user memory somewhere.  The
implementation of vgettimeofday needs a syscall instruction internally
for its fallback, which means that an attack could jump there instead
of to the start of the vsyscall implementation.

>
> If it can be filtered in a meaningful way then we should just do that and
> perhaps offer a (default enabled) .config COMPAT_VDSO_EMU=y switch to turn the
> emulation off.
>
> That way we keep the ABI and also have a way out for users who *really* need
> this to work in a performant way.

Yeah, that probably makes more sense.  It'll make for an uglier
diffstat, though -- there's a lot of ugly duplicate code around to
make vgettimeofday and vgetcpu work.

--Andy

>
> Thanks,
>
>        Ingo
>
