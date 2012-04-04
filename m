Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab2DDMsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 08:48:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59272 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab2DDMsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 08:48:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: swap on eMMC and other flash
Date: Wed, 4 Apr 2012 12:47:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linaro-kernel@lists.linaro.org, linux-mm@kvack.org,
        "Luca Porzio (lporzio)" <lporzio@micron.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>, linux-kernel@vger.kernel.org,
        Saugata Das <saugata.das@linaro.org>,
        Venkatraman S <venkat@linaro.org>, Yejin Moon <yejin.moon@samsung.com>,
        Hyojin Jeong <syr.jeong@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        kernel-team@android.com
References: <201203301744.16762.arnd@arndb.de> <201203301850.22784.arnd@arndb.de> <4F7C3CE2.5070803@intel.com>
In-Reply-To: <4F7C3CE2.5070803@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204041247.53289.arnd@arndb.de>
X-Provags-ID: V02:K0:hgRFNx0NydERscTCboagXkASj0nqTKPhEyhI/9lcVo4
 Rl2C5kafrW8QgHa1CpjFZzLTAD5BGi+JzODWjGXLfUf7weEAm1
 oknDY2g6lhZIeOkPzRhegRcDUMY8v/w8hVZs1MT/QV3w+ZtzPc
 O/+YGJ055vEjS0PGMH36f9c/FfGzQAzKDlcSBjesnSu1OtZLHt
 gFMvwk0XRcqNt/bbfsmAbm0O2N53hzpExDNgbc64nIqmFDiedK
 Jkk/+DSm0Dbe0kX2ZMG2CYlCBzve5y+pLYx1+S8REcgKLk1zZg
 kiKdVqbYpptQHzkXhXPczz15oiBaueI2EPaY3kKPbWBPJVndH4
 TtfTYL9B8/uWUABWBenI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2012, Adrian Hunter wrote:
> On 30/03/12 21:50, Arnd Bergmann wrote:
> > (sorry for the duplicated email, this corrects the address of the android
> > kernel team, please reply here)
> > 
> > On Friday 30 March 2012, Arnd Bergmann wrote:
> > 
> >  We've had a discussion in the Linaro storage team (Saugata, Venkat and me,
> >  with Luca joining in on the discussion) about swapping to flash based media
> >  such as eMMC. This is a summary of what we found and what we think should
> >  be done. If people agree that this is a good idea, we can start working
> >  on it.
> 
> There is mtdswap.

Ah, very interesting. I wasn't aware of that. Obviously we can't directly
use it on block devices that have their own garbage collection and wear
leveling built into them, but it's interesting to see how this was solved
before.

While we could build something similar that remaps blocks between an
eMMC device and the logical swap space that is used by the mm code,
my feeling is that it would be easier to modify the swap code itself
to do the right thing.

> Also the old Nokia N900 had swap to eMMC.
> 
> The last I heard was that swap was considered to be simply too slow on hand
> held devices.

That's the part that we want to solve here. It has nothing to do with
handheld devices, but more with specific incompatibilities of the
block allocation in the swap code vs. what an eMMC device expects
to see for fast operation. If you write data in the wrong order on
flash devices, you get long delays that you don't get when you do
it the right way. The same problem exists for file systems, and is
being addressed there as well.

> As systems adopt more RAM, isn't there a decreasing demand for swap?

No. You would never be able to make hibernate work, no matter how much
RAM you add ;-)

More seriously, the need for swap is not to work around the fact that
we have too little memory, it's one of the fundamental assumptions of
the mm subsystem that swap exists, and it's generally a good idea to
have, so you treat file backed memory in the same way as anonymous
memory.

	Arnd
