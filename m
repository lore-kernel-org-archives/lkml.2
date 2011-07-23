Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1GWJuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 05:50:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57909 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1GWJuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 05:50:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v2
Date: Sat, 23 Jul 2011 11:50:30 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Shawn Guo <shawn.guo@freescale.com>,
        ashishj3 <ashish.jangam@kpitcummins.com>,
        Dajun <dajun.chen@diasemi.com>, sameo@openedhand.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
References: <1309876620.960.169.camel@L-0532.kpit.com> <11313494.PB6mQOoBLX@wuerfel> <20110722085939.GF23192@opensource.wolfsonmicro.com>
In-Reply-To: <20110722085939.GF23192@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107231150.31055.arnd@arndb.de>
X-Provags-ID: V02:K0:VZr90IGAAHOhR9eB509nePJNw6pdbN8XapFpzOeCX24
 bYJUyMITfHU9zJBi43p5Z0Y4EUlDhhSyhJuM16WJXYnoq+rUCk
 DIknQpYfilvbMwwfr12xCXxIeGsIKb7S8e4KiH36r/OoFjfMfp
 JL09O1WY8Lr/82QfvnS8ktpzUGxwQEMxIaQ3TI1Yd9q9d3SOnq
 I1wq7H4Dja8u3me7yimPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 July 2011, Mark Brown wrote:
> We went round this analysis already with the underlying I2C drivers
> (which also end up needing to take mutexes and so on) - it really does
> work out better to just make the I/O noninterruptible, the I/O is fast
> enough to not really be worth interrupting and the handling for actual
> I/O errors should normally be sufficiently different to that for user
> initiated aborts that it just adds complication.
> 
> For example, if the user interrupts while we're in the middle of some
> lengthy series of operations or wait what we really want to do is to
> tear down the high level thing we're doing in an orderly fashion.  If
> we allow the interrupt to be noticed as part of an I/O operation then
> what we often end up doing is failing that and we then have to work out
> why the I/O failed, if actually happened on a physical level and how we
> deal with that.  Usually none of these paths will be well tested.
> 
> The overall result is that the system generally becomes more complicated
> and less robust.

Yes, that makes sense. There are also cases where a mutex should really
be a spinlock (which is by definition not interruptible), or vice
versa. I don't know if this is one of them.

I agree that the safest solution here is to just make the mutex
uninterruptible.

	Arnd
