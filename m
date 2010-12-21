Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab0LUHnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 02:43:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34283 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726Ab0LUHnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 02:43:04 -0500
Date: Tue, 21 Dec 2010 08:42:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [concept & "good taste" review] persistent store
Message-ID: <20101221074259.GB32278@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>, Huang Ying <ying.huang@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	David Miller <davem@davemloft.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jim Keniston <jkenisto@linux.vnet.ibm.com>,
	Kyungmin Park <kmpark@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
References: <4D0BEE1F.7020008@zytor.com>
 <AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
 <AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com>
 <AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com>
 <20101219091752.GA16150@liondog.tnic>
 <AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com>
 <1292813234.8743.66.camel@yhuang-dev>
 <AANLkTikULE_Jncjs=PkARjZyxb=f+t=4J8g8LQL+L=BZ@mail.gmail.com>
 <1292892494.8743.76.camel@yhuang-dev>
 <AANLkTinBN7QN_c_oyFdpC3vaj9nLEfWCWeeqRCgiEdBW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTinBN7QN_c_oyFdpC3vaj9nLEfWCWeeqRCgiEdBW@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 09:13:33PM -0800, Tony Luck wrote:
> On Mon, Dec 20, 2010 at 4:48 PM, Huang Ying <ying.huang@intel.com> wrote:
> > If persistent storage driver (such as ERST) implements kmsg_dumper by
> > themselves, that should be easier to use multiple records for one
> > message dumping request.
> 
> Or I can build it into the fs/pstore layer. If the record size looks too
> small[*], loop writing multiple records (starting with the tail of the buffer,
> so that if the persistent store fills up, we are sure to have the stack
> back trace and register dump).

Wait a second, isn't this loop writing actually what we want?!

I mean, if the pstore is big enough to contain, say the last ca. 50 or
so oops messages (this size should suffice even for OOMkill oopses),
we do make sure that we always have the last set of oopses belonging
together and thus if we panic, we have also the relevant ones.

 [ IIRC, each ERST record can contain roughly 8K, and we want 50 of
 those so having a 1M flash on the platform isn't science fiction
 anymore, no? ]

By loop writing it, we also make sure we overwrite the oldest oopses
which, if the pstore is big enough, shouldn't have anything to do with
the next set to be written.

So, basically designing the pstore as a big enough circular buffer
should suffice, no?

This would even alleviate the need for the notification heuristics and
writeout to userspace.

Hmm...

-- 
Regards/Gruss,
    Boris.
