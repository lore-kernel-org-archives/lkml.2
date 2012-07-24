Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab2GXNEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:04:35 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50745 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2GXNEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:04:34 -0400
MIME-Version: 1.0
In-Reply-To: <1342922751.65328.YahooMailNeo@web120106.mail.ne1.yahoo.com>
References: <1342922751.65328.YahooMailNeo@web120106.mail.ne1.yahoo.com>
Date: Tue, 24 Jul 2012 21:04:32 +0800
Message-ID: <CAJd=RBC24UXztNoKews5sE06DRvk_cBEYunHT7Zc-rdvAFF0ew@mail.gmail.com>
Subject: Re: Direct I/O bug in kernel
From: Hillf Danton <dhillf@gmail.com>
To: Victor Meyerson <calculuspenguin@yahoo.com>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 10:05 AM, Victor Meyerson
<calculuspenguin@yahoo.com> wrote:
> Hi,
>
> I recently found a bug related to direct io in post 3.3 linux kernels.  Fortunately, my hardware (a Cobalt Qube2) is supported by the vanilla kernel so I did not need additional patch sets to get the machine to boot.  I ran git bisect on the main tree[1] and tested the various bisect results until git reported the first bad commit.  After several bisects and many reboots, git reported that [2] was the first bad commit.
>
> In testing this I came up with a repeatable process.  Unfortunately, I do not have any other MIPS hardware to test this on and I believe that based on the commit in question that it is MIPS related.  My procedure is as follows:
>
> 1) Create a random file to be used on the two kernels (one before the commit, and one that includes the commit)
> $ dd if=/dev/urandom of=random-file bs=512 count=30720
> 30720+0 records in
> 30720+0 records out
> 15728640 bytes (16 MB) copied, 60.7035 s, 259 kB/s
> $ chmod -w random-file
>
> 2) Reboot to the kernel before the commit and run dd with direct io.  Repeat.
> $ uname -a
> Linux horadric 3.2.0-dirty #2 Fri Jul 13 06:20:22 PDT 2012 mips64 Nevada V10.0 FPU V10.0 Cobalt Qube2 GNU/Linux
> $ dd if=random-file of=portion-of-random-3.2.0 bs=512 count=20480 iflag=direct
> 20480+0 records in
> 20480+0 records out
> 10485760 bytes (10 MB) copied, 42.3636 s, 248 kB/s
> $ reboot
> $ dd if=random-file of=portion-of-random-3.2.0-2 bs=512 count=20480 iflag=direct
> 20480+0 records in
> 20480+0 records out
> 10485760 bytes (10 MB) copied, 42.5252 s, 247 kB/s
>
> 3) Reboot to the kernel with the commit and run dd with direct io.  Repeat.
> $ uname -a
> Linux horadric 3.2.0-rc4-00003-gb1c10be-dirty #15 Fri Jul 20 15:05:13 PDT 2012 mips64 Nevada V10.0 FPU V10.0 Cobalt Qube2 GNU/Linux
> $ dd if=random-file of=portion-of-random-3.2.0-rc4 bs=512 count=20480 iflag=direct
> 20480+0 records in
> 20480+0 records out
> 10485760 bytes (10 MB) copied, 40.6226 s, 258 kB/s
> $ reboot
> $ dd if=random-file of=portion-of-random-3.2.0-rc4-2 bs=512 count=20480 iflag=direct
> 20480+0 records in
> 20480+0 records out
> 10485760 bytes (10 MB) copied, 40.8856 s, 256 kB/s
>
Hi Victor,

Create files with

    dd if=random-file of=portion-of-random-3.2.0-rc4    bs=8k
count=1280 iflag=direct
    dd if=random-file of=portion-of-random-3.2.0-rc4-2 bs=8k
count=1280 iflag=direct

without reboot(why reboot needed?), then see the changes in checksums.

Thanks
Hillf

> 4) Compare checksums of the resulting files.
> $ sha256sum portion-of-random-3.2.0*
> c98a6e949b36448842a21f68e7c6a5daff1f161e1eb3e3529176cf56bf5af89e  portion-of-random-3.2.0
> c98a6e949b36448842a21f68e7c6a5daff1f161e1eb3e3529176cf56bf5af89e  portion-of-random-3.2.0-2
> dca27da87a78580b8a34bbff2790ae80d3aa880d5d00fc2126f109d6fff9e056  portion-of-random-3.2.0-rc4
> 703cf02d4fa90679d4a75900e7e5a3b8c3000a65bfc475610b10f17bb88bedbc  portion-of-random-3.2.0-rc4-2
>
> Notice how the last two files have different checksums between themselves and even different from the first two files.  This lead me to believe that there is a problem with direct io.  All the files are the same size and should include the same portion of the random file created in step 1).
>
> My configuration is the Cobalt Qube2 with a 64-bit kernel and an n32 userspace.  Hopefully someone with a much more deeper understanding of the kernel can confirm and provide a fix for this (assuming one has not been created yet).
>
> Thanks.  Let me know if there is any additional information that may help with the investigation.
>
> Victor
>
>
> [1] http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> [2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=b1c10bea620f79109b5cc9935267bea4f6f29ac6
