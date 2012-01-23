Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab2AWQsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:48:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab2AWQsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:48:04 -0500
Message-ID: <4F1D8EDD.6040908@redhat.com>
Date: Mon, 23 Jan 2012 16:46:21 +0000
From: Niels de Vos <ndevos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Bryn M. Reeves" <bmr@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2] fs: Invalidate the cache for a parent block-device
 if fsync() is called for a partition
References: <4F19356E.3020708@redhat.com> <1327315109-7740-1-git-send-email-ndevos@redhat.com> <x49ehuqbd0p.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ehuqbd0p.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2012 04:27 PM, Jeff Moyer wrote:
> Niels de Vos <ndevos@redhat.com> writes:
> 
>> Executing an fsync() on a file-descriptor of a partition flushes the
>> caches for that partition by calling blkdev_issue_flush(). However, it
>> seems that reading data through the parent device will still return the
>> old cached data.
> 
> What problem, exactly, are you trying to fix?  Could you please post a
> reproducer?

The problem that was noticed is the following:
1) create two or more partitions on a device
   - use fdisk to create /dev/sdb1 and /dev/sdb2
2) format and mount one of the partition
   - mkfs -t ext3 /dev/sdb1
3) read through the main device to have something in the cache
   - read /dev/sdb with dd or use something like "parted /dev/sdb print"
4) now write something to /dev/sdb2, format the partition for example
   - mkfs -t ext3 /dev/sdb2
5) read the blocks where sdb2 starts, through /dev/sdb
   - use dd or do again a "parted /dev/sdb print"

Without this patch, calling "blockdev --flushbufs" or dropping the
caches, the result in 5) is the same as in 3). Reading the same area
through /dev/sdb2 shows the inconsistancy between the two caches.

With this patch, or one of the workarounds, the data read through
/dev/sdb and /dev/sdb2 is the same.

I hope this explains is clear enough, if not, please let me know.

Thanks,
Niels
