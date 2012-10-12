Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab2JLUe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:34:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36432 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2JLUeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:34:25 -0400
Message-ID: <50787ECB.1050803@gmail.com>
Date: Fri, 12 Oct 2012 22:34:19 +0200
From: Milan Broz <gmazyland@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Michael Zugelder <michael@zugelder.org>
CC: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        dm-crypt <dm-crypt@saout.de>
Subject: Re: PROBLEM: [dm-crypt] read starvation during writeback
References: <1350070656.2554.6.camel@vpcz1>
In-Reply-To: <1350070656.2554.6.camel@vpcz1>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 09:37 PM, Michael Zugelder wrote:
> I'm having an issue reading data via dm-crypt when there is heavy
> writeback going on (i.e. copying large files or using dd). A single
> read takes anywhere from a few seconds to multiple minutes.
> 
> Testing setup:
>  * Fedora 17, stock 3.5.4-2.fc17 kernel and a self-compiled 3.6.1 kernel
>  * 320 GiB USB hard drive (sdb)

I guess that USB is the key factor here... I remember to have similar
problem some time ago even without dmcrypt.

Is it reproducible with the same kernel cfg but with internal disk?

You can also test completely fake underlying device,
use device-mapper- zero target:
dmsetup create dev_zero --table "0 <sectors size> zero"
(All writes are dropped and all reads returns zero in this case.)

Is there any starvation with this setup? (It shouldn't.)

>  * dmsetup library version 1.02.74 (2012-03-06), driver version 4.23.0
>  * dm-crypt set up using cipher_null:
>    echo "0 $(blockdev --getsize /dev/sdb) crypt cipher_null - 0 /dev/sdb 0"|dmsetup create test

Btw you can use cryptsetup with cipher "null" to simplify
(I added to cryptsetup to test exactly such scenarios).

So, it means that encryption is not the problem.
The crypto_null will cause that there is no crypto operation
(it is just plain data copy) but the remaining dmcrypt overhead remains
exactly the same.

> * writeback induced by running 'dd if=/dev/zero of=$target bs=1M'

Any change if you use oflag=direct ? (iow using direct io)

> I experimented a bit with the other device mapper targets, namely linear
> and stripe, but both worked completely fine. I also tried putting a
> linear mapping above dm-crypt, with no impact on performance. Comparing
> the content of the /sys/block/$DEV files of the linear mapping and
> dm-crypt, there are no differences beside the name, dev no, stats,
> uevent and inflight files.

There is crucial difference between linear/stripe and dmcrypt:
linear just remaps IO target device, dmcrypt queues operations
(using kernel workqueue) and creates full bio clones.
So comparison here is IMHO not much helpful.

There are two internal dmcrypt queues, but I think that the problem
is triggered by some combination with USB storage backend.

> Any pointers would be appreciated, I haven't found much on the web about
> this issue.

Btw there was a proposed rewrite of internal dmcrypt queues, if you have time,
you can try if it changes anything for your use case.
Patches in dm-devel archive
http://www.redhat.com/archives/dm-devel/2012-August/msg00210.html

Milan
