Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1GLSBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:01:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab1GLSBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:01:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock frequency
Date: Tue, 12 Jul 2011 20:00:50 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org, matsumur@nts.ricoh.co.jp,
        linux-pci@vger.kernel.org, linux-mmc@vger.kernel.org
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com> <alpine.DEB.2.02.1107121123140.1767@lazy> <m2ei1v76f1.fsf@bob.laptop.org>
In-Reply-To: <m2ei1v76f1.fsf@bob.laptop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107122000.50309.arnd@arndb.de>
X-Provags-ID: V02:K0:RvFEoz1/h/88mrNbcgvb90gqJFkFXj9+l97tJuHqGbh
 ni1U4/AmoFJj4d5IxAaerCctw/oMIK5eegd/upHa20+IkE1oax
 U8CAoLoju/DElGAoedhpBn133mqnm/JIzlrsG3tDiYUK902moN
 9uOYWpHUbPxLWQrin0rjaCZkmDcXSz9zetpKiRitlnJ6+Od2Xl
 pVVrnQL7zXgvnXeLTu1Zw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 July 2011 19:30:42 Chris Ball wrote:
> On Tue, Jul 12 2011, Manoj Iyer wrote:
> > btw only the 1st write was slower, subsequent writes looks ok.
> > [..]
> > I have attached the output of flashbench and the time test to
> >
> > http://launchpad.net/bugs/773524
> > [..]
> > == Finding the number of open erase blocks ==
> > u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 *
> > 1024] --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
> > 4MiB    6.36M/s
> > 2MiB    6.24M/s
> > 1MiB    6.17M/s
> > 512KiB  6.19M/s
> > 256KiB  6.22M/s
> > u@u:~/flash/flashbench$
> > [..]
> > ====== AFTER PATCH ========
> > [..]
> > == Finding the number of open erase blocks ==
> > u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 *
> > 1024]         --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
> > [sudo] password for u:
> > 4MiB    5.49M/s
> > 2MiB    6.22M/s
> > 1MiB    6.22M/s
> > 512KiB  6.21M/s
> > 256KiB  6.21M/s
> > u@u:~/flash/flashbench$
> 
> That's interesting.  Arnd, any idea why only the first test of the
> flashbench run would be slower after the patch?

I would very much expect that to be nonreproducible. The first row
in each test is the result of a single write() system call and does
not get averaged out. More importantly the time for each write
depends a lot of the state of the card before the write.

For instance when you do a lot of random writes to a card, optionally
take it out and put it into a different machine, and then do a large
linear write, that linear write will be very slow because the
card has to garbage collect all the random writes that were done
earlier. After a few writes (usually one is enough), it gets back
to the full performance.

	Arnd
