Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0LVHet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 02:34:49 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54716 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0LVHeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 02:34:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=XcwtL1A0PQDL4lTALgQTqH5YLwBtoCCbOQZe6twiDjlc/SEWcGVub1DW86yoHw13LU
         YKAH+WZPR0VgqDK6Sp6yVYdqpC9f7OI2iz86Nb+eNgQRI0MZ/TQuiQMQdZWBfGs1u1pS
         qmIor8fOET//09QIpAwTGDXg72knNVoHvjuyk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1012211651000.27461@asgard.lang.hm>
References: <1292892072.8743.70.camel@yhuang-dev>
	<1292813234.8743.66.camel@yhuang-dev>
	<4d0662e511688484b3@agluck-desktop.sc.intel.com>
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
	<AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com>
	<17027.1292841992@redhat.com>
	<32058.1292926258@redhat.com>
	<1292977616.8743.87.camel@yhuang-dev>
	<alpine.DEB.2.00.1012211651000.27461@asgard.lang.hm>
Date: Tue, 21 Dec 2010 23:34:45 -0800
X-Google-Sender-Auth: _KXj8gOQi0WkxcqwcPBBH8dONq0
Message-ID: <AANLkTi=qhwSM8-849OWwKjSAC17tS1GEk90ixkN9O6AJ@mail.gmail.com>
Subject: Re: [concept & "good taste" review] persistent store
From: Tony Luck <tony.luck@intel.com>
To: david@lang.hm
Cc: Huang Ying <ying.huang@intel.com>, David Howells <dhowells@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 4:53 PM,  <david@lang.hm> wrote:
> almost nobody runs syslog with a fsync after each message anymore. the
> problem is that doing so reduced throughput so much that you ended up
> loosing more messages (and causing processes to block, resulting in
> user-visible problems) because the messages had to queue up for processing.
>
> so if you want to record critical messages and be guaranteed that they are
> on disk, you will be needing a specific application, and not just using
> standard syslog.

Here we are talking about OOPS situations ... when we have an
oops we will log it to persistent store and make sure we keep it
until something else says that the information has been saved
somewhere else.

Not sure how difficult it would be to have syslog parse what it
copies to look for oops signatures and
1) Issue an fsync()
2) Tell the persistent store to drop the record.

Perhaps some other logging mechanism would be better?
I outlined my thoughts for this yesterday:
> 1) Oops happens, gets written to persistent store.
> 2) fs/pstore code makes a file appear in /dev/pstore
> 3) Daemon that's watching /dev/pstore sees new file
> 4) File is read, copied some place safe and fsync'd
> 5) Daemon unlinks file from /dev/pstore
> 6) fs/pstore code tells platform level to erase record

Since this is only for "oops" class events, I don't think that
the fsync should be a performance problem (you really have
much bigger problems if there are that many oopses!)

-Tony
