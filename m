Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab0LSURz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 15:17:55 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43728 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435Ab0LSURy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 15:17:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=XiwEyMOh5cSAQfZmb2hcLs1MtNEpd7X94znOgrc4FrxpKwn/61Up7EeyfYXgGPgbgo
         Q7tOz67ARrtDaKYQSoDwoKppLkZkapQCxujIR6HAMV9cGfxwfS1ZyFyXG5J5RAIT31Ab
         tulJowyXVJmAkfUkOgGXW3Zie5QZH1lQQXnT4=
MIME-Version: 1.0
In-Reply-To: <20101219091752.GA16150@liondog.tnic>
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
	<AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
	<AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
	<AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>
	<AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>
	<AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
	<4D0BEE1F.7020008@zytor.com>
	<AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
	<AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com>
	<AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com>
	<20101219091752.GA16150@liondog.tnic>
Date: Sun, 19 Dec 2010 12:17:53 -0800
X-Google-Sender-Auth: s7-Qof03rmupnEORPUQwgPgvoI8
Message-ID: <AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com>
Subject: Re: [concept & "good taste" review] persistent store
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 1:17 AM, Borislav Petkov <bp@alien8.de> wrote:
> Before we go and delve into priority-sorting the oopses in the pstore,
> let me ask this: how big an actual persistent storage device are we
> talking?

I'm not sure how big the store is on my system ... the ACPI/ERST
interface on this machine limits each entry to just under 8KB. But
that isn't inherent to to ERST, both larger and smaller values would
be an option. 8K seems quite useful for kmsg_dump purposes as
it grabs a significant number of lines leading up to the oops/panic.

After I dropped the "stupid" part about not saving OOPs, I ran a
test on Friday where I instigated a dozen or so OOPses, and all
were saved without ERST complaining. There is a "how big is the
store" call in the protocol - so the only option is to keep writing
until a failure occurs. I will try this when I'm next in the office,

> Because if it is big enough - for some value of 'big' - we could try to
> never let it fill up.
With the price per GByte of flash memory - the answer *ought* to
be some huge value

> If want to save space we might even do something
> crazy like compressing the oops info. In the rare event it fills up or
> hits some 'almost-full' watermarks, we can kick some userspace daemon
> to start writing the oopses to fs and clear the pstore. This all should
> happen in the case where all you get is non-critical warnings and the
> system is still alive.

This is a good point. In the case that the OOPs that was recorded to
persistent store wasn't fatal - then the normal daemons will log it to
/var/log/messages.  So in the general case, if the system finds that
it isn't dead a few seconds after logging something - it is most likely
safe to assume that the persistent store copy isn't vital, as the data
should be available elsewhere.

> However, in the critical cases, you get a single "stream" of oopses with
> the first one being the most important one and then you panic. And in
> most cases that stream is only a couple of oopses long. For that, the
> pstore should be big enough to easily contain it.

Yes. At least it is for my test system. I know I can fit a dozen messages.

> So, I think what we could do is keep our big enough pstore with enough
> free space for a bunch of oopses in case we panic. In the remaining
> cases, we write them out thus freeing some more space.

Some feedback from syslogd (or whatever it is that gets things from
dmesg into /var/log/messages) would help here ... though to be really
useful it might need "fsync" to /var/log/messages, which might not
be a welcome addition.

-Tony
