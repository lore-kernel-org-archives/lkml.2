Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240Ab1IWEuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 00:50:35 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:48660 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750802Ab1IWEud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 00:50:33 -0400
Message-ID: <4E7C0FF6.3090502@tao.ma>
Date: Fri, 23 Sep 2011 12:49:58 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@google.com>
CC: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/direct-io.c: Calcuate fs_count correctly in get_more_blocks.
References: <1316420739-4734-1-git-send-email-tm@tao.ma> <20110919153149.be4ab3ca.akpm@google.com>
In-Reply-To: <20110919153149.be4ab3ca.akpm@google.com>
Content-Type: multipart/mixed;
 boundary="------------050505030106010605060804"
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050505030106010605060804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Andrew,
On 09/20/2011 06:31 AM, Andrew Morton wrote:
> On Mon, 19 Sep 2011 16:25:39 +0800
> Tao Ma <tm@tao.ma> wrote:
> 
>> In get_more_blocks, we use dio_count to calcuate fs_count and do some
>> tricky things to increase fs_count if dio_count isn't aligned. But
>> actually it still has some cornor case that can't be coverd. See the
>> following example:
>> ./dio_write foo -s 1024 -w 4096(direct write 4096 bytes at offset 1024).
>> The same goes if the offset isn't aligned to fs_blocksize.
>>
>> In this case, the old calculation counts fs_count to be 1, but actually
>> we will write into 2 different blocks(if fs_blocksize=4096). The old code
>> just works, since it will call get_block twice(and may have to allocate
>> and create extent twice for file systems like ext4). So we'd better call
>> get_block just once with the proper fs_count.
> 
> Has this been carefully tested with more than just ext4?  If so, which?
I have done some more tests on both raw devices and file systems of
ext4, btrfs and xfs.
I have attached the fio test cases and ffsb test cases I used.
Besides this, I also run ffsb -I -s 2G against all these 3 file systems.
By now, no kernel error.

Thanks
Tao

--------------050505030106010605060804
Content-Type: text/plain;
 name="rndrw-bs-16k-filesize-64G"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rndrw-bs-16k-filesize-64G"

[global]
direct=1
ioengine=psync
bs=16k
filename=/mnt/ext4/testfile
size=64G
runtime=600
group_reporting
loops=50

[read]
rw=randread
numjobs=8

[write]
rw=randwrite
numjobs=8

--------------050505030106010605060804
Content-Type: text/plain;
 name="dio_profile"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dio_profile"

directio	= 1
time		= 1800

[filesystem]
	location	= FFSB_DIR

	num_dirs	= 100

	size_weight	4k	33
	size_weight	8k	21
	size_weight	16k	13
	size_weight	32k	10
	size_weight	64k	8
	size_weight	128k	5
	size_weight	256k	4
	size_weight	512k	3
	size_weight	8m	2
	size_weight	32m	1
	size_weight	1g	1

#	min_filesize	= 4k
#	max_filesize	= 10m

	num_files	= 1000
	init_size	= 100m
#	init_size	= 6GB
#	init_size	= 1gb
#	init_util	= 0.002

[end]

[threadgroup0]
	num_threads	= 16

	append_weight		= 1
	append_fsync_weight	= 1
	stat_weight		= 1
	write_weight		= 1
	write_fsync_weight	= 1
	read_weight		= 1
	create_weight		= 1
	create_fsync_weight	= 1
	delete_weight		= 1
	readall_weight		= 1
	writeall_weight		= 1
	writeall_fsync_weight	= 1
	open_close_weight	= 1

	read_random	= 1
	write_random	= 1

	write_size	= 4k
	write_blocksize	= 4k
	read_size	= 4k
	read_blocksize	= 4k

	op_delay	= 0

	[stats]
		enable_stats	= 1
		enable_range	= 0

#		ignore		= close
#		ignore		= open
#		ignore		= lseek
#		ignore		= write
#		ignore		= read

		msec_range	0.00 0.01
		msec_range	0.01 0.02
		msec_range	0.02 0.03
		msec_range	0.03 0.04
		msec_range	0.04 0.05
		msec_range	0.05 0.1
		msec_range	0.1 0.2
		msec_range	0.2 0.5
		msec_range	0.5 1.0
		msec_range	1.0 2.0
		msec_range	2.0 3.0
		msec_range	3.0 4.0
		msec_range	4.0 5.0
		msec_range	5.0 10.0
		msec_range	10.0 10000.0
	[end]
[end]

[threadgroup1]
	num_threads	= 16

	append_weight		= 1
	append_fsync_weight	= 1
	stat_weight		= 1
	write_weight		= 1
	write_fsync_weight	= 1
	read_weight		= 1
	create_weight		= 1
	create_fsync_weight	= 1
	delete_weight		= 1
	readall_weight		= 1
	writeall_weight		= 1
	writeall_fsync_weight	= 1
	open_close_weight	= 1

	read_random	= 0
	write_random	= 0

	write_size	= 4k
	write_blocksize	= 4k
	read_size	= 4k
	read_blocksize	= 4k

	op_delay	= 0

	[stats]
		enable_stats	= 1
		enable_range	= 0

#		ignore		= close
#		ignore		= open
#		ignore		= lseek
#		ignore		= write
#		ignore		= read

		msec_range	0.00 0.01
		msec_range	0.01 0.02
		msec_range	0.02 0.03
		msec_range	0.03 0.04
		msec_range	0.04 0.05
		msec_range	0.05 0.1
		msec_range	0.1 0.2
		msec_range	0.2 0.5
		msec_range	0.5 1.0
		msec_range	1.0 2.0
		msec_range	2.0 3.0
		msec_range	3.0 4.0
		msec_range	4.0 5.0
		msec_range	5.0 10.0
		msec_range	10.0 10000.0
	[end]
[end]

--------------050505030106010605060804--
