Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab1GMPmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:42:43 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33294 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab1GMPml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:42:41 -0400
Date: Wed, 13 Jul 2011 10:42:32 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Chris Ball <cjb@laptop.org>
cc: Arnd Bergmann <arnd@arndb.de>, Manoj Iyer <manoj.iyer@canonical.com>,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        matsumur@nts.ricoh.co.jp, linux-pci@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock
 frequency
In-Reply-To: <m2sjqa2q93.fsf@bob.laptop.org>
Message-ID: <alpine.DEB.2.02.1107131031360.3174@lazy>
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com> <alpine.DEB.2.02.1107121123140.1767@lazy> <m2ei1v76f1.fsf@bob.laptop.org> <201107122000.50309.arnd@arndb.de> <m2sjqa2q93.fsf@bob.laptop.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Chris/Arnd,

Here is a series of test I did with the patched kernel.


== cold boot insert SD card ==
u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 * 
1024] --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
4MiB    4.96M/s
2MiB    6.3M/s
1MiB    6.23M/s
512KiB  6.23M/s
256KiB  6.26M/s

== rerun the same test 2nd time ===
u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 * 
1024] --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
4MiB    6.28M/s
2MiB    6.29M/s
1MiB    6.29M/s
512KiB  6.29M/s
256KiB  6.26M/s

== remove and reinsert the SD card ==
u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 * 
1024] --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
4MiB    6.42M/s
2MiB    6.28M/s
1MiB    6.22M/s
512KiB  6.23M/s
256KiB  6.26M/s

== remove and reinsert the SD card ==
u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 * 
1024] --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
4MiB    6.42M/s
2MiB    6.3M/s
1MiB    6.22M/s
512KiB  6.25M/s
256KiB  6.24M/s

== reboot, reinsert the SD card ==
u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 * 
1024] --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
[sudo] password for u:
4MiB    6.45M/s
2MiB    6.33M/s
1MiB    6.25M/s
512KiB  6.29M/s
256KiB  6.3M/s
u@u:~/flash/flashbench$

== rerun the test again ==
u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 * 
1024] --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
4MiB    6.27M/s
2MiB    6.27M/s
1MiB    6.28M/s
512KiB  6.27M/s
256KiB  6.24M/s
u@u:~/flash/flashbench$

== poweroff, Poweron, insert SD card ==
u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 * 
1024] --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
[sudo] password for u:
4MiB    6.45M/s
2MiB    6.33M/s
1MiB    6.24M/s
512KiB  6.29M/s
256KiB  6.32M/s
u@u:~/flash/flashbench$

== rerun the test again ==
u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 * 
1024] --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
4MiB    6.29M/s
2MiB    6.28M/s
1MiB    6.29M/s
512KiB  6.28M/s
256KiB  6.25M/s
u@u:~/flash/flashbench$

On Wed, 13 Jul 2011, Chris Ball wrote:

> Hi Arnd,
>
> On Tue, Jul 12 2011, Arnd Bergmann wrote:
>> I would very much expect that to be nonreproducible. The first row
>> in each test is the result of a single write() system call and does
>> not get averaged out. More importantly the time for each write
>> depends a lot of the state of the card before the write.
>>
>> For instance when you do a lot of random writes to a card, optionally
>> take it out and put it into a different machine, and then do a large
>> linear write, that linear write will be very slow because the
>> card has to garbage collect all the random writes that were done
>> earlier. After a few writes (usually one is enough), it gets back
>> to the full performance.
>
> That makes sense.  Do you think this explains Manoj getting a slower
> first file copy speed (757ms vs. 480ms) after applying his patch?
> (Manoj, perhaps you could retry your test without GC being needed?)
>
> What would we expect lowering the SD base clock frequency from 200MHz
> to 50MHz to do to performance theoretically?
>
> Thanks,
>
> - Chris.
> -- 
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
