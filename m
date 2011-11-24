Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1KXXwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 18:52:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52871 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab1KXXwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 18:52:51 -0500
MIME-Version: 1.0
In-Reply-To: <20111124231848.GC5167@thunk.org>
References: <20111124194626.GA5260@google.com>
	<20111124231848.GC5167@thunk.org>
Date: Thu, 24 Nov 2011 15:52:50 -0800
Message-ID: <CAH+dOx+pfCXJ-zCb-CzfHevD_J8K5DHNEuvK0_KvQtk=xVLfdA@mail.gmail.com>
Subject: Re: [PATCH] ext4: fix racy use-after-free in ext4_end_io_dio()
From: Kent Overstreet <koverstreet@google.com>
To: "Ted Ts'o" <tytso@mit.edu>, Tejun Heo <tj@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kent Overstreet <koverstreet@google.com>,
        rickyb@google.com, aberkan@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heh. It took me about 2 seconds to trigger it in vm :)

One reason it triggered so fast is that my VM test setup runs
everything out of ram (the disks on the host are files in a tmpfs),
but the main reason we were hitting it is that bcache usually runs the
bio->bi_endio function out of a workqueue, not irq context.

It also seems to only trigger when a dio write is extending a file;
the same test setup run against an existing file doesn't ever cause
(visible) slab corruption.

Do you think this would also explain the corruption D is seeing in vd?
I haven't yet figured out a mechanism but the bug seems to fit.

On Thu, Nov 24, 2011 at 3:18 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Nov 24, 2011 at 11:46:26AM -0800, Tejun Heo wrote:
>> ext4_end_io_dio() queues io_end->work and then clears iocb->private;
>> however, io_end->work completes the iocb by calling aio_complete(),
>> which may happen before io_end->work clearing thus leading to
>> use-after-free.
>>
>> Detected and tested with slab poisoning.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Reported-by: Kent Overstreet <koverstreet@google.com>
>> Tested-by: Kent Overstreet <koverstreet@google.com>
>> Cc: stable@kernel.org
>
> Thanks!!  I've been trying to track down this bug for a while.  The
> repro case I had ran the 12 fio's against 12 different file systems
> with the following configuration:
>
> [global]
> direct=1
> ioengine=libaio
> iodepth=1
> bs=4k
> ba=4k
> size=128m
>
> [create]
> filename=${TESTDIR}
> rw=write
>
> ... and would leave a few inodes with elevated i_ioend_counts, which
> means any attempt to delete those inodes or to unmount the file system
> owning those inodes would hang forever.
>
> With your patch this problem goes away.
>
>>I *think* this is the correct fix but am not too familiar with code
>>path, so please proceed with caution.
>
> Looks good to me.  Thanks, applied.
>
>>Thank you.
>
> No, thank *you*!  :-)
>
>                                        - Ted
>
> P.S.  It would be nice to get this into xfstests, but it requires at
> least 10-12 (12 to repro it reliably) HDD's, and a fairly high core
> count machine in order to reproduce it.  I played around with trying
> to create a reproducer that worked on a smaller number of disks and/or
> fio's/CPU's, but I was never able to manage it.
>
