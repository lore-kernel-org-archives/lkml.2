Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0LTCr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 21:47:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:22272 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab0LTCrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 21:47:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,199,1291622400"; 
   d="scan'208";a="363923068"
Subject: Re: [concept & "good taste" review] persistent store
From: Huang Ying <ying.huang@intel.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@gmail.com>,
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
In-Reply-To: <AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com>
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
	 <AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 10:47:14 +0800
Message-ID: <1292813234.8743.66.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 04:17 +0800, Tony Luck wrote:
> On Sun, Dec 19, 2010 at 1:17 AM, Borislav Petkov <bp@alien8.de> wrote:
> > Before we go and delve into priority-sorting the oopses in the pstore,
> > let me ask this: how big an actual persistent storage device are we
> > talking?
> 
> I'm not sure how big the store is on my system ... the ACPI/ERST
> interface on this machine limits each entry to just under 8KB. But
> that isn't inherent to to ERST, both larger and smaller values would
> be an option. 8K seems quite useful for kmsg_dump purposes as
> it grabs a significant number of lines leading up to the oops/panic.

8KB is about 100-200 lines message, sometimes it may be not enough for
all necessary information.  But in fact, we can use multiple ERST
records to save one kernel message dumping. So the real limitation is
just total storage capacity.

For journal (or transaction) semantics, I think the overall picture of
system can be as follow,

kernel ---> persistent storage ---> user space daemon ---> disk

1. kernel dump OOPS and PANIC message into persistent storage.
2. user space daemon poll persistent storage and erase the record after
saving it into disk.

So,

- for OOPS messages will not cause system panic, it will go to disk and
will not use up the persistent storage.
- for PANIC message, it will be saved into persistent storage only and
read out/saved to disk/erased after successfully rebooting. (Maybe need
the heuristic to overwrite the latest OOPS if storage is really tight).

The issues are:

- We need a user space daemon, via extending /sbin/syslogd?
- It is a little hard to implement "poll" support for a file system.

Best Regards,
Huang Ying


