Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab0C2Mz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:55:58 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:49901 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab0C2Mzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:55:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=G6uNrH+hPnkMj/A0850iaDuq8MMjO4+s64hcG+BHjifH+pBAudbCEKrpdctdaRpWTh
         +MgRbzmrhqFmhz0edILmmrZJaLqmd6vuzy7EyXeP7XDxUpkf9xN8WZQOlBsu7v2HEgmw
         s5uw9XVaMDom6CYBZLrYYaTl4OYl1cDTyiIvU=
MIME-Version: 1.0
In-Reply-To: <20100329150642.4a94e78a@feng-i7>
References: <1269340105-6503-1-git-send-email-chripell@fsfe.org>
	 <1269340170-6558-1-git-send-email-chripell@fsfe.org>
	 <20100329104838.49c18075@feng-i7>
	 <cabda6421003282311x78051e1eq38ada68f2553609e@mail.gmail.com>
	 <20100329150642.4a94e78a@feng-i7>
Date: Mon, 29 Mar 2010 14:55:51 +0200
X-Google-Sender-Auth: 6917ce30108c5a7a
Message-ID: <cabda6421003290555k70d13168y4beba2c3ae6e2ece@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] max3100: adds console support for MAX3100
From: christian pellegrin <chripell@fsfe.org>
To: Feng Tang <feng.tang@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "david-b@pacbell.net" <david-b@pacbell.net>,
       "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 9:06 AM, Feng Tang <feng.tang@intel.com> wrote:

> Our platform is Intel Moorestown platform, and use a spi controller core
> from Designware (drivers/spi/dw_*.c). I know the problem may probably be
> caused by my setting, but the dw_spi driver works fine with our own
> 3110 driver.

I had a look at the dw_spi driver. The spi_transfer path queues some
work to a worqueue that itself schedules a tasklet. I don't think this
is good for latency, I won't bet that such an architecture could
deliver good performance. Now I see why you needed to do only big fat
SPI transfers. Anyway this doesn't justify the 2 seconds delay between
chars coming in and going out through the max31x0 you are seeing. I
will try to analyze what's going on. BTW is only input slow or output
is sluggish too? The initial messages from the console are coming out
fast? If you disable the MAX3110 for console but you use just as a
normal terminal (set console=/dev/null in the kernel command line and
add getty 115200 /dev/ttyMAX0 in iniitab) is the interaction with the
system fine? Thanks for helping sorting out this.

>>
>> yes but I think it's quite difficult to solve this problem in every
>> case. Console output is massively used only on boot when the user is
>> not supposed to type a lot.
>
> It's difficult but not impossible, actually our driver checks every word
> read back and handle it if it contains a valid data
>

Of course it is possible, I just wanted to keep the max3100 a small
clean driver. Unfortunately console and serial drivers are two
different beings in the Linux kernel, but the max3100 implements the
tx-rx in one indivisible instruction (that is slow compared to
registers IO and has to be called in an preemptible contex for added
fun).  To implement what you are saying we need:

1) the console code has to check if the serial port associated to the
same physical max3100 is up (console driver start their life much
before serial ones).

2) if yes send data to the tty associated to the serial driver.
Locking is needed here.

I will implement this ASAP.

>> Have you configured your SPI controller as LSB first somehow, haven't
>> you? BTW my platform is a quite usual ARM9 S3C2440 which is little
>> endian.
>>
> yeah, you hit the point that our spi controller is LSB naturally (not
> configured to), here may need a check for whether to do a swap
>

ok, I think the dw_spi driver has to be fixed.


-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
