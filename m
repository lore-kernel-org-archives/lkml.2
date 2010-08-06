Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab0HFEu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 00:50:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50471 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab0HFEu1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 00:50:27 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimVOkAi1_G9B290fHRR3PbV4H9003VarAv_zbGn@mail.gmail.com>
References: <23662.1281056463@redhat.com> <20100806011706.GA21657@gondor.apana.org.au> 
	<20100806014057.GA22395@gondor.apana.org.au> <AANLkTi=+-Y2GOZYAZHeaX+op3XB9AY5S85rfJD3jSDvz@mail.gmail.com> 
	<20100806023539.GA22774@gondor.apana.org.au> <AANLkTimVOkAi1_G9B290fHRR3PbV4H9003VarAv_zbGn@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 6 Aug 2010 00:50:04 -0400
Message-ID: <AANLkTinVO0prEfkuOUFWA12q8HwrXS6do_hjw1EqygZu@mail.gmail.com>
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and cryptomgr 
	problem
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        David Howells <dhowells@redhat.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 00:20, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Aug 5, 2010 at 7:35 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:
>> Because it can save data.  Each cryptographic algorithm (such as
>> AES) may have multiple impelmentations, some of which are hardware-
>> based.
>
> Umm. The _developer_ had better test the thing. That is absolutely
> _zero_ excuse for then forcing every boot for every poor user to re-do
> the test over and over again.
>
> Guys, this comes up every single time: you as a developer may think
> that your code is really important, but get over yourself already.
> It's not so important that everybody must be forced to do it.

Speaking as a user whose been bitten several times by bad crypto
implementations, I'd personally rather have this testing on by default
(if the crypto API it depends on is on).  It's pretty damn inexpensive
to do a few brief crypto operations during initialization as a quick
smoke test.  We already do something somewhat similar when loading the
RAID5/RAID6 driver, although admittedly that's a speed-test for
picking an optimized algorithm.

You should also realize that crypto drivers are very much *NOT* in the
same situation as most other drivers.  Without this test, adding a new
crypto hardware driver to the kernel is a completely unsafe operation,
because it could completely break users setups.  You have previously
said you're fine accepting new drivers even after the initial merge
window because they can't break anything, but in crypto that's not
true.

I've actually had it trigger in exactly the described situation.  I
had a box with an encrypted filesystem that I downloaded a new distro
kernel on with new drivers.  The new kernel included a bunch of new
"EXPERIMENTAL" drivers for hardware, none of which I thought I cared
about until I noticed in "dmesg" that one of them was getting enabled
and then failing tests.

So there are unique and compelling reasons for default-enabled basic
smoke tests of cryptographic support during boot.  To be honest, the
test and integration engineer in me would like it if there were more
intensive in-kernel POST tests that could be enabled by a kernel
parameter or something for high-reliability embedded devices.

Cheers,
Kyle Moffett
