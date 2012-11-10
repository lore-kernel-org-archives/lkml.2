Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2KJVuB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 16:50:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50884 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab2KJVt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 16:49:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [PATCH 00/16 v3] f2fs: introduce flash-friendly file system
Date: Sat, 10 Nov 2012 21:49:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Kim Jaegeuk <jaegeuk.kim@gmail.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com> <CAOtxgye-sqJFe17EyfJQ0RrMwQqsPbDv5m+4cJT0BjnRnGv56w@mail.gmail.com> <201211101933.38434.Martin@lichtvoll.de>
In-Reply-To: <201211101933.38434.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201211102149.48946.arnd@arndb.de>
X-Provags-ID: V02:K0:5znzF5OM00hfRMzUV2ZOR1oZKkn+5zUkFXRnSd7KGpJ
 naHi6Z/n7Cx5/7L4odZH1cSiZNAjvZf7IbsNOw2L+YpKP2V5vq
 tlFUzc4mJpu+mH5ojEbazsLsJxmNEFtwTDxKqF+287LncFVNHU
 QzfL1d6jKFxXHvrj3rX7WeZiFDbmzm7jPUjZG3xjVI2AoUjqCr
 U4YQ3LgAmpTkA59HdAF8MKtS7aW1wOXAsRWmKeJVpblqPMM+gx
 09IlhW/gpOEmJEKXVtvgO5g29qq57enSBBka1Z0n++AKWbs4YI
 Uca7fC0Fzpqlgt4GqH1hxacp3lT3TZt5v7eVaCzDeZCsGBTmca
 BktFchRqcP2aEQKoFlF8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 November 2012, Martin Steigerwald wrote:
> Command (m for help): n
> Partition type:
>    p   primary (0 primary, 0 extended, 4 free)
>    e   extended
> Select (default p): p
> Partition number (1-4, default 1): 1
> First sector (2048-4095998, default 2048): 
> Using default value 2048
> Last sector, +sectors or +size{K,M,G} (2048-4095998, default 4095998): 
> Using default value 4095998

This is almost certainly not the right setting for f2fs, which only works
at its design point if the segments are aligned to erase blocks. All modern
flash devices have erase blocks larger than 1 MB, so starting the partition
at a 1 MB offset will cause it to be misaligned. Also, some USB sticks
have an area optimized for random writes in the beginning of the drive
where both FAT32 and f2fs store their metadata. It may be worth testing
again without a partition table, using just the raw device.

I would also recommend using flashbench to find out the optimum parameters
for your device. You can download it from
git://git.linaro.org/people/arnd/flashbench.git
In the long run, we should automate those tests and make them part of
mkfs.f2fs, but for now, try to find out the erase block size and the number
of concurrently used erase blocks on your device using a timing attack
in flashbench. The README file in there explains how to interpret the
results from "./flashbench -a /dev/sdb  --blocksize=1024" to guess
the erase block size, although that sometimes doesn't work.

With the correct guess, compare the performance you get using

$ ERASESIZE=$[2*1024*1024] # replace with guess from flashbench -a
$ ./flashbench /dev/sdb --open-au --open-au-nr=1 --blocksize=4096 --erasesize=${ERASESIZE}
$ ./flashbench /dev/sdb --open-au --open-au-nr=3 --blocksize=4096 --erasesize=${ERASESIZE}
$ ./flashbench /dev/sdb --open-au --open-au-nr=5 --blocksize=4096 --erasesize=${ERASESIZE}
$ ./flashbench /dev/sdb --open-au --open-au-nr=7 --blocksize=4096 --erasesize=${ERASESIZE}
$ ./flashbench /dev/sdb --open-au --open-au-nr=13 --blocksize=4096 --erasesize=${ERASESIZE}

The first one of those should always be the fastest, hopefully followed by
some that are equally fast and then some much slower ones (especially for the
smaller block sizes). The "active_logs=N" mount option should be one less
than the highest number above that is still "fast", and only "2", "4" and "6"
are valid at the moment. If you are lucky, your device is still fast with
"--open-au-nr=7" and slow only for higher numbers, then the default of "6"
is ok.

If the erase size is larger than 2 MB, then you have to "-s" option in
mkfs.f2fs to configure how many 2 MB segments there are in one erase block.
For a 2 GB USB stick, I would guess that the erase block size is 1, 2 or
4 MB. Newer (larger) sticks will have larger erase blocks that may also
be a multiple of 3 MB (3, 6, 12, or 24).

	Arnd
