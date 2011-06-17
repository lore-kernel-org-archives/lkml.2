Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab1FQQnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 12:43:13 -0400
Received: from ext190.halfdog.net ([88.116.147.190]:53706 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab1FQQnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 12:43:09 -0400
X-Greylist: delayed 1461 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jun 2011 12:43:08 EDT
Message-ID: <4DFB7E1C.3010509@halfdog.net>
Date: Fri, 17 Jun 2011 16:17:32 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:2.0pre) Gecko/20110408 Firefox/4.0pre SeaMonkey/2.1b3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Possible ext2/3/4 filesysystem iov_length integer overflow and strange
 behavior on large writes
X-Enigmail-Version: 1.2a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

If I understand it correctly, there might be multiple iov_length
interger overflows on 32bit arch in ext2, ext3, ext4, e.g.

fs/ext4/file.c:

static ssize_t
ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
                unsigned long nr_segs, loff_t pos)
{
...
        /*
         * If we have encountered a bitmap-format file, the size limit
         * is smaller than s_maxbytes, which is for extent-mapped files.
         */
        if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
                struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
                size_t length = iov_length(iov, nr_segs);  << length
might be any value with more than 4GB data

                if ((pos > sbi->s_bitmap_maxbytes ||
                    (pos == sbi->s_bitmap_maxbytes && length > 0)))
                        return -EFBIG;

                if (pos + length > sbi->s_bitmap_maxbytes) {
                        nr_segs = iov_shorten((struct iovec *)iov, nr_segs,
                                              sbi->s_bitmap_maxbytes - pos);
                }
...


Can someone confirm or refute that? I wrote a small test program, but
failed to inflict damage on the kernel or filesystem, so I might have
missed something. From source grep, also other filesystems might have
the same problem.


Apart from that, large iov writes seem to be uninteruptible. Sending a
kill signal to the process in writev terminates it after finishing the
syscall.

./LargeWritevTest --File x --IovecNum 257 --BufferSize 16777216
- --LastSize 10
pkill -KILL LargeWritevTest

[24306.588390] INFO: task LargeWritevTest:1390 blocked for more than 120
seconds.
[24306.589984] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[24306.590512] WritevTest      D 00000086     0  1390   1380 0x00000004
[24306.590571]  c8a91db0 00000082 c1040b73 00000086 00000000 c86a1940
c86a1bcc c183a8c0
[24309.657798]  8dcb7199 000014fc c86a1bc8 c183a8c0 c183a8c0 cac068c0
c86a1940 c87e0ca0
[24309.657871]  cac03640 c8605ae8 000581ca 00000380 00000000 00000001
c8a91d90 c103351c
[24309.657908] Call Trace:
[24309.658226]  [<c1040b73>] ? entity_tick+0x73/0x130
[24309.658284]  [<c103351c>] ? kmap_atomic_prot+0x4c/0x100
[24309.658331]  [<c10e7dc0>] ? prep_new_page+0x110/0x1a0
[24309.658439]  [<c15087e6>] __mutex_lock_slowpath+0xd6/0x140
[24309.658526]  [<c1508355>] mutex_lock+0x25/0x40
[24309.658547]  [<c10e3c1b>] generic_file_aio_write+0x4b/0xd0
[24309.658587]  [<c11a9a84>] ext4_file_write+0x54/0x2a0
[24309.658608]  [<c10e8809>] ? __alloc_pages_nodemask+0xf9/0x710
[24309.658627]  [<c10e8809>] ? __alloc_pages_nodemask+0xf9/0x710
[24309.658805]  [<c11a9a30>] ? ext4_file_write+0x0/0x2a0
[24309.660607]  [<c1127676>] do_sync_readv_writev+0xa6/0xe0


Since writev would allow 1024 segments a 1GB, one might be able to
consume 1TB (all) disk space on a machine and the process cannot be
stopped. On 32 bit architecture, the write stops after 2GB, but I'm not
sure why. Would terrabyte writes be possible on 64-bit systems?

On 32-bit, forking and calling write on different files has to be used
instead. Since processes cannot be terminated, reboot does not unmount
cleanly, so that might increase likelihood of disk corruption.

For testing I used
http://www.halfdog.net/Security/2011/ExtFilesystemIovecHandling/LargeWritevTest.c
on an ext4 filesystem, but failed to understand the various outcomes.
Especially un-comprehensible was the oscillation between disk-full and
disk-free when writing with O_DIRECT to a disk with not enough free
space. The behavior change also unexpected, when aligning the memory
buffers to page-size or ext blocksize, or doing unaligned IO.


7G free:
./LargeWritevTest --File x --IovecNum 256 --BufferSize 16777216
./LargeWritevTest --File x --IovecNum 257 --BufferSize 16777216
- --LastSize 10tou
./LargeWritevTest --File y --IovecNum 512 --BufferSize 16777216
- --LastSize 16777215
Write result 2147479552 (is 2^31-4096)

./LargeWritevTest --File x --IovecNum 257 --BufferSize 16777216
- --LastSize 10 --Align 65536
Write result 16740352 (fast)

3.9G free:
./LargeWritevTest --File x --IovecNum 257 --BufferSize 16777216
- --LastSize 10 --Align 65536 --Direct
./LargeWritevTest --File x --IovecNum 256 --BufferSize 16777216 --Align
65536 --Direct
Write result -14 (immediate)

./LargeWritevTest --File x --IovecNum 257 --BufferSize 16777216
- --LastSize 10 --Direct
./LargeWritevTest --File x --IovecNum 256 --BufferSize 16777216 --Direct
Write result -22 (immediate)

Less than 2GB:
./LargeWritevTest --File z --IovecNum 257 --BufferSize 16777216
- --LastSize 10 --Align 4096 --Direct
Oscillates between disk empty/full?


- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFN+34jxFmThv7tq+4RAh5gAJ45kycXTOk4zD9R+J9jkEXQbeoJvACeI3oT
KmEeBGVbF4ZDh3zaUN88mfg=
=WFDh
-----END PGP SIGNATURE-----
