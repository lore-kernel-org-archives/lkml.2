Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0C2HBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 03:01:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:39492 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab0C2HBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 03:01:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,327,1267430400"; 
   d="scan'208";a="784740517"
Date: Mon, 29 Mar 2010 15:06:42 +0800
From: Feng Tang <feng.tang@intel.com>
To: christian pellegrin <chripell@fsfe.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "david-b@pacbell.net" <david-b@pacbell.net>,
       "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 3/4] max3100: adds console support for MAX3100
Message-ID: <20100329150642.4a94e78a@feng-i7>
In-Reply-To: <cabda6421003282311x78051e1eq38ada68f2553609e@mail.gmail.com>
References: <1269340105-6503-1-git-send-email-chripell@fsfe.org>
	<1269340170-6558-1-git-send-email-chripell@fsfe.org>
	<20100329104838.49c18075@feng-i7>
	<cabda6421003282311x78051e1eq38ada68f2553609e@mail.gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 14:11:15 +0800
christian pellegrin <chripell@fsfe.org> wrote:

> > I modified the code a little and run it on our HW platform, it
> > really show some sigh of life: it can boots to console (the print
> > format is not so good), I can input command and it execute
> > correctly, but very slow, I type 3 characters and it takes about 2
> > seconds to echo back on screen and start the execution, and after
> > about 1 minute, the console hang there and input stopped to work.
> 
> never seen such a behavior. Which platform are you using? Which SPI
> driver? Do you have a low level printk (printascii) that puts output
> somewhere else so I can send you a patch with some debugging output?
> Can you log in some other way (like via network) and see if the CPU
> load is at 100% for some reason?

Hi,

Our platform is Intel Moorestown platform, and use a spi controller core
from Designware (drivers/spi/dw_*.c). I know the problem may probably be
caused by my setting, but the dw_spi driver works fine with our own
3110 driver.

For debug method, sadly I don't get another output port yet, but if you
have some debug patch, that's great, it will help when I find another debug
output than max3110.

> 
> >> +             max3100_sr(s, tx, &rx);
> >
> > It doesn't handle received characters here? If the console is
> > printing out a bulk of message while user input some command, the
> > command may be ignored. Myself have met the same problem in our
> > driver.
> >
> 
> yes but I think it's quite difficult to solve this problem in every
> case. Console output is massively used only on boot when the user is
> not supposed to type a lot.

It's difficult but not impossible, actually our driver checks every word
read back and handle it if it contains a valid data

> 
> >> +     if (next != s->console_tail) {
> >> +             s->console_buf[next] = ch;
> >> +             s->console_head = next;
> >> +     }
> >
> > Also I saw max3100_sr() uses cpu_to_be16() and be16_to_cpu(), is it
> > really necessary, our platform is little-endian(x86), and I have to
> > disable them to make the code work. Is your test platform
> > big-endian?
> >
> 
> Have you configured your SPI controller as LSB first somehow, haven't
> you? BTW my platform is a quite usual ARM9 S3C2440 which is little
> endian.
>
yeah, you hit the point that our spi controller is LSB naturally (not
configured to), here may need a check for whether to do a swap

