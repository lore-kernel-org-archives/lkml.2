Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2A0MTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 07:19:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2A0MTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 07:19:54 -0500
Message-ID: <4F229660.4000708@redhat.com>
Date: Fri, 27 Jan 2012 07:19:44 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Niels de Vos <ndevos@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>, "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH v3] fs: Invalidate the cache for a parent block-device
 if fsync() is called for a partition
References: <4F213E1A.4060808@redhat.com> <1327584802-14298-1-git-send-email-ndevos@redhat.com> <20120126134051.6add3cd2.akpm@linux-foundation.org> <20120126214534.GA9319@infradead.org> <Pine.LNX.4.64.1201261646570.28710@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1201261646570.28710@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 04:50 PM, Mikulas Patocka wrote:
>
> On Thu, 26 Jan 2012, Christoph Hellwig wrote:
>
>> On Thu, Jan 26, 2012 at 01:40:51PM -0800, Andrew Morton wrote:
>>> The Right Thing To Do here is to make the kernel behave logically and
>>> predictably, then modify the userspace tools.  But if we're modifying
>>> the userspace tools then we would just change userspace to issue a
>>> BLKFLSBUF to /dev/sda and leave the kernel alone.
>> The right fix is to make partition and whole disk access coherent,
>> which is fairly simply:
>>
>>   - create the block device inode/mapping per gendisk, and only reference
>>     count it per block_device
>>   - make sure blkdev_get_block(s) applies the correct offset if used on
>>     partitions
> ... and what if you use 4kB blocksize and the partition start is not
> aligned on 4kB? (quite common case, because partitions are often aligned
> on 63 sectors) Then, you can't translate partition block numbers into disk
> block numbers.
>
> Mikulas
>

In your specific example, you cannot start a partition on a non-full block 
address since you cannot address it. Either the device uses 512 byte sectors, 
emulates 512 byte sectors or supports only 4096 byte sectors. In the first two 
case, not an issue.

In the last case, still not an issue. If you send an unaligned IO down to a 4096 
byte device, you get an IO error.

Also note that all (most?) user space tools have been fixed upstream (and in 
distros) to align properly when the device exports its block size. The new 
default alignment is 1MB from the start of disk, this should not be a concern.

Thanks!

Ric


