Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2CDKZO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 05:25:14 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63065 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2CDKZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 05:25:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of difrost.kernel@gmail.com designates 10.14.182.2 as permitted sender) smtp.mail=difrost.kernel@gmail.com; dkim=pass header.i=difrost.kernel@gmail.com
MIME-Version: 1.0
In-Reply-To: <CADDYkjRyQruZgFHDsyAgAV7J3yvunU5YuwmmbxK=1WXJLHw98Q@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
	<20120301143859.GX5054@shiny>
	<CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
	<20120302140038.GD5054@shiny>
	<CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
	<20120302142651.GH5054@shiny>
	<CADDYkjRyQruZgFHDsyAgAV7J3yvunU5YuwmmbxK=1WXJLHw98Q@mail.gmail.com>
Date: Sun, 4 Mar 2012 11:25:08 +0100
Message-ID: <CADDYkjSWpWAW0dxmMEWjHaRV=jS+U5obeau_GPEgwnJuPBLe3w@mail.gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
From: Jacek Luczak <difrost.kernel@gmail.com>
To: Chris Mason <chris.mason@oracle.com>,
        Jacek Luczak <difrost.kernel@gmail.com>, Theodore Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/3 Jacek Luczak <difrost.kernel@gmail.com>:
> 2012/3/2 Chris Mason <chris.mason@oracle.com>:
>> On Fri, Mar 02, 2012 at 03:16:12PM +0100, Jacek Luczak wrote:
>>> 2012/3/2 Chris Mason <chris.mason@oracle.com>:
>>> > On Fri, Mar 02, 2012 at 11:05:56AM +0100, Jacek Luczak wrote:
>>> >>
>>> >> I've took both on tests. The subject is acp and spd_readdir used with
>>> >> tar, all on ext4:
>>> >> 1) acp: http://91.234.146.107/~difrost/seekwatcher/acp_ext4.png
>>> >> 2) spd_readdir: http://91.234.146.107/~difrost/seekwatcher/tar_ext4_readir.png
>>> >> 3) both: http://91.234.146.107/~difrost/seekwatcher/acp_vs_spd_ext4.png
>>> >>
>>> >> The acp looks much better than spd_readdir but directory copy with
>>> >> spd_readdir decreased to 52m 39sec (30 min less).
>>> >
>>> > Do you have stats on how big these files are, and how fragmented they
>>> > are?  For acp and spd to give us this, I think something has gone wrong
>>> > at writeback time (creating individual fragmented files).
>>>
>>> How big? Which files?
>>
>> All the files you're reading ;)
>>
>> filefrag will tell you how many extents each file has, any file with
>> more than one extent is interesting.  (The ext4 crowd may have better
>> suggestions on measuring fragmentation).
>>
>> Since you mention this is a compile farm, I'm guessing there are a bunch
>> of .o files created by parallel builds.  There are a lot of chances for
>> delalloc and the kernel writeback code to do the wrong thing here.
>>
>
[Most of files are B and K size]
>
> All files scanned: 1978149
> Files fragmented: 313 (0.015%) where 11 have 3+ extents
> Total size of fragmented files: 7GB (~13% of dir size)

BTRFS: Non of files according to filefrag are fragmented - all fit
into one extent.

> tar cf on fragmented files:
> 1) time: 7sec
> 2) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_fragmented.png
> 3) sw graph with spd_readdir:
> http://91.234.146.107/~difrost/seekwatcher/tar_fragmented_spd.png
> 4) both on one:
> http://91.234.146.107/~difrost/seekwatcher/tar_fragmented_pure_spd.png

BTRFS: tar on ext4 fragmented files
1) time: 6sec
2) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_fragmented_btrfs.png

> tar cf of fragmented files disturbed with [40,50) K files (in total
> 4373 files). K files before fragmented M files:
> 1) size: 7.2GB
> 2) time: 1m 14sec
> 3) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_disturbed.png
> 4) sw graph with spd_readdir:
> http://91.234.146.107/~difrost/seekwatcher/tar_disturbed_spd.png
> 5) both on one:
> http://91.234.146.107/~difrost/seekwatcher/tar_disturbed_pure_spd.png

BTRFS: tar on [40,50) K and ext4 fragmented
1) time: 56sec
2) sw graph: http://91.234.146.107/~difrost/seekwatcher/tar_disturbed_btrfs.png

New test I've included - randomly selected files:
- size 240MB
1) ext4 (time: 34sec) sw graph:
http://91.234.146.107/~difrost/seekwatcher/tar_random_ext4.png
2) btrfs (time: 55sec) sw graph:
http://91.234.146.107/~difrost/seekwatcher/tar_random_btrfs.png

-Jacek
