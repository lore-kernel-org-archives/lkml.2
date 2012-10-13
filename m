Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab2JMU40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 16:56:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56179 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2JMU4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 16:56:25 -0400
Message-ID: <1350161777.6495.46.camel@vpcz1>
Subject: Re: [dm-crypt] PROBLEM:  read starvation during writeback
From: Michael Zugelder <michael@zugelder.org>
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-crypt <dm-crypt@saout.de>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Date: Sat, 13 Oct 2012 22:56:17 +0200
In-Reply-To: <1350083207.2673.5.camel@vpcz1>
References: <1350070656.2554.6.camel@vpcz1> <50787ECB.1050803@gmail.com>
	 <1350083207.2673.5.camel@vpcz1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a small update on my previously posted test case. I noticed
'cryptsetup -c null' uses cipher_null in ecb mode, and in that case, I
don't observe any read starvation. I'm not sure what the default cipher
mode is (cryptsetup uses cbc-essiv:sha256), but I can reproduce the
problem using just 'cipher_null-cbc-plain'.

The revised test case is as follows:

Preparation:
  # dmsetup create dev_zero --table "0 $((1024*1024*1024)) zero"
  # dmsetup create cipher_null-cbc-plain --table "0 $((1024*1024*1024)) crypt cipher_null-cbc-plain - 0 /dev/mapper/dev_zero 0"
  # dmsetup create cipher_null-ecb --table "0 $((1024*1024*1024)) crypt cipher_null-ecb - 0 /dev/mapper/dev_zero 0"

Testing cipher_null-cbc-plain:
  # dd if=/dev/zero bs=1M of=/dev/mapper/cipher_null-cbc-plain
  # ioping -R /dev/mapper/cipher_null-cbc-plain
    1 requests completed in 9530.3 ms, 0 iops, 0.0 mb/s

Note that for some reason, dd writes extremely slow (below 100.0 MB/s on
my machine) in this test.

On the other hand, cipher_null-ecb works fine.
  # dd if=/dev/zero bs=1M of=/dev/mapper/cipher_null-ecb
  # ioping -R /dev/mapper/cipher_null-ecb
    32337 requests completed in 3000.0 ms, 54042 iops, 211.1 mb/s
    min/avg/max/mdev = 0.0/0.0/18.8/0.2 ms

dd writes at around 850 MB/s in that case (1.8 GB/s directly to the null
target).

I tried similar benchmarks using aes instead of cipher_null, but found
no bothersome spikes with aes-ecb, aes-cbc-plain, aes-cbc-essiv:sha256.
But aes-xts-plain sometimes drops down to 5 iops (over the course of 3
seconds).

So there is probably something very wrong with cipher_null-cbc-plain
being an order of magnitude slower than aes-cbc-plain, but the cbc mode
itself doesn't seem to cause the problem.

I also ran the benchmarks on an old Athlon 64 X2 3800+ box running
kernel 3.2 and could reproduce it with very first try for every cipher
spec I tried (cipher_null-cbc-plain, cipher_null-ecb, aes-cbc-plain,
aes-ecb, aes-xts-plain). Best I could achieve was 5 iops. But
interestingly, I didn't observe the really huge spikes (upwards of 20
seconds), as I do on my 1nd gen Core i5 Notebook.

On Sat, 2012-10-13 at 01:06 +0200, Michael Zugelder wrote:
> On Fri, 2012-10-12 at 22:34 +0200, Milan Broz wrote:
> > Btw there was a proposed rewrite of internal dmcrypt queues, if you have time,
> > you can try if it changes anything for your use case.
> > Patches in dm-devel archive
> > http://www.redhat.com/archives/dm-devel/2012-August/msg00210.html
> 
> Seems interesting, I'll try it out tomorrow.

I tried the patch set earlier today, but had the same issues when
reading while writing to a 'crypt_null' mapping.

Anything else I could do to diagnose this problem?


Michael

