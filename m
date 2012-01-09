Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab2AITmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:42:07 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61921 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933064Ab2AITmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:42:06 -0500
MIME-Version: 1.0
In-Reply-To: <20120109112207.7f993845@jbarnes-desktop>
References: <bug-41722-5003@https.bugzilla.kernel.org/> <201109062222.p86MMlK9023363@demeter2.kernel.org>
 <CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
 <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
 <20120108221342.GA7058@ime.usp.br> <CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
 <20120109112207.7f993845@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Jan 2012 11:41:44 -0800
X-Google-Sender-Auth: vMQYcrfJnxFTA8-X9pJt_x3R8Kg
Message-ID: <CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>,
        bugzilla-daemon@bugzilla.kernel.org,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?M=E1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>, Ram Pai <linuxram@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 11:22 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> I don't remember what problems we hit, but if Ram and Yinghai are
> willing to take a look at them we should go ahead and try again.

So the two bugzilla entries quoted in the revert are

  http://bugzilla.kernel.org/show_bug.cgi?id=10080
  http://bugzilla.kernel.org/show_bug.cgi?id=9961

 with at least one real smoking gun in this one:

  https://lkml.org/lkml/2008/3/26/94

however at least *part* of the problem for some people was not the
transparency itself, as much as the fact that we did bad things with
64-bit resources etc.

So what I think mostly happened was that not sizing up transparent
bridges ended up showing up other bugs. We've fixed at least some of
those other bugs in the meantime (things like using "unsigned long"
for physical addresses in ioremap etc, which broke when 64-bit
resources were used on 32-bit architectures).

But it's entirely possible that it will still trigger similar issues.
For example, even if a bridge is transparent, maybe it is still
limited to 32-bit addresses? If we look at the actual IO windows, we'd
get that 32-bit limit right automatically. If we just say "it's
transparent", we might allocate child devices with 64-bit resources
above the 4GB area, and be screwed. That seems to have been one
problem above - even if we now get it right on a software level, there
may actually be hardware issues in the same area.

(It's not clear whether the 64-bit resource issue back in 2008 was due
to hardware or due to our resource bugs).

Adding Ivan to the cc due to historical issues - although I haven't
seen him in email for a year, so he may be gone.

                           Linus
