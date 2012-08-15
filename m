Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2HOXHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 19:07:52 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4024 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2HOXHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 19:07:51 -0400
Date: Thu, 16 Aug 2012 01:07:43 +0200
Message-Id: <201208152307.q7FN7hMR008630@xs8.xs4all.nl>
From: "Miquel van Smoorenburg" <mikevs@xs4all.net>
To: stan@hardwarefreak.com
Subject: Re: O_DIRECT to md raid 6 is slow
X-Newsgroups: lists.linux.kernel
In-Reply-To: <502C1C01.1040509@hardwarefreak.com>
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com>
Organization: 
Cc: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <xs4all.502C1C01.1040509@hardwarefreak.com> you write:
>It's time to blow away the array and start over.  You're already
>misaligned, and a 512KB chunk is insanely unsuitable for parity RAID,
>but for a handful of niche all streaming workloads with little/no
>rewrite, such as video surveillance or DVR workloads.
>
>Yes, 512KB is the md 1.2 default.  And yes, it is insane.  Here's why:
>Deleting a single file changes only a few bytes of directory metadata.
>With your 6 drive md/RAID6 with 512KB chunk, you must read 3MB of data,
>modify the directory block in question, calculate parity, then write out
>3MB of data to rust.  So you consume 6MB of bandwidth to write less than
>a dozen bytes.  With a 12 drive RAID6 that's 12MB of bandwidth to modify
>a few bytes of metadata.  Yes, insane.

Ehrm no. If you modify, say, a 4K block on a RAID5 array, you just have
to read that 4K block, and the corresponding 4K block on the
parity drive, recalculate parity, and write back 4K of data and 4K
of parity. (read|read) modify (write|write). You do not have to
do I/O in chunksize, ehm, chunks, and you do not have to rmw all disks.

>Parity RAID sucks in general because of RMW, but it is orders of
>magnitude worse when one chooses to use an insane chunk size to boot,
>and especially so with a large drive count.

If you have a lot of parallel readers (readers >> disks) then
you want chunk sizes of about 2*mean_read_size, so that for each
read you just have 1 seek on 1 disk.

If you have just a few readers (readers <<<< disks) that read
really large blocks then you want a small chunk size to keep
all disks busy.

If you have no readers and just writers and you write large
blocks, then you might want a small chunk size too, so that
you can write data+parity over the stripe in one go, bypassing rmw.

Also, 256K or 512K isn't all that big nowadays, there's not much
latency difference between reading 32K or 512K..

>Recreate your array, partition aligned, and manually specify a sane
>chunk size of something like 32KB.  You'll be much happier with real
>workloads.

Aligning is a good idea, and on modern distributions partitions,
LVM lv's etc are generally created with 1MB alignment. But using
a small chunksize like 32K? That depends on the workload, but
in most cases I'd advise against it.

Mike.
