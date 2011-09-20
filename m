Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab1ITFsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 01:48:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64422 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1ITFrr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 01:47:47 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <4E778D77.4070207@redhat.com>
References: <CAKgNAkhZSb0UfZz7N+gKRQD0r7gnC_3-VCB_ORio8ojczbCDvQ@mail.gmail.com>
 <4E77827C.3030202@redhat.com> <4E7789A1.4080501@oracle.com> <4E778D77.4070207@redhat.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Tue, 20 Sep 2011 07:47:26 +0200
Message-ID: <CAKgNAkjcQDkcnineAAeCk-V5B8YD5HiNmNRpHuScbJUyXNhvkw@mail.gmail.com>
Subject: Re: Man page doc for SEEK_DATA/SEEK_HOLE
To: Eric Blake <eblake@redhat.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>, Josef Bacik <josef@redhat.com>,
        linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric, Sunil,

On Mon, Sep 19, 2011 at 8:44 PM, Eric Blake <eblake@redhat.com> wrote:
> On 09/19/2011 12:27 PM, Sunil Mushran wrote:
>>
>> On 09/19/2011 10:57 AM, Eric Blake wrote:
>>>
>>> Also, it seems a shame that the kernel can fail with EINVAL instead of
>>> properly emulating SEEK_HOLE and SEEK_DATA even on file systems with
>>> no underlying support for reporting holes.
>>>
>>
>> Why do you say that? If I am reading generic_file_llseek_unlocked()
>> correctly, the default behavior is treat offset < i_size as data.
>
> The proposed wording states:
>
>>  .B EINVAL
>>  .I whence
>> -is not one of
>> -.BR SEEK_SET ,
>> -.BR SEEK_CUR ,
>> -.BR SEEK_END ;
>> -or the resulting file offset would be negative,
>> +is not valid (this error may be returned if
>> +.I whence
>> +is
>> +.BR SEEK_DATA
>> +or
>> +.BR SEEK_HOLE
>> +and the underlying file system does not support the operation).
>
> I guess it should instead read:
>
> EINVAL whence is not valid (this error may be returned if whence is
> SEEK_DATA or SEEK_HOLE but the kernel does not support the operation).
>
> Given your argument that new enough kernels understand SEEK_DATA and
> SEEK_HOLE for all file systems.

I think I added this because of the following, which is current (or at
least was 3 days ago when I last pulled and wrote the page). From
fs/hpfs/dir.c:

====
static loff_t hpfs_dir_lseek(struct file *filp, loff_t off, int whence)
{
        loff_t new_off = off + (whence == 1 ? filp->f_pos : 0);
        loff_t pos;
        struct quad_buffer_head qbh;
        struct inode *i = filp->f_path.dentry->d_inode;
        struct hpfs_inode_info *hpfs_inode = hpfs_i(i);
        struct super_block *s = i->i_sb;

        /* Somebody else will have to figure out what to do here */
        if (whence == SEEK_DATA || whence == SEEK_HOLE)
                return -EINVAL;
====

In other words, there's at least one file system that does produce
EINVAL. Perhaps that file system needs to be fixed so that it falls
back to the generic implementation?

That said, I take the point that this probably doesn't need to be
documented in the man page, and I removed that text.

> I agree that EINVAL will occur if you compile against new enough glibc that
> exposes the constants, but then run against an older kernel that does not
> yet understand them.  But I want the text to be clarified to be bullet-proof
> that if I am running against kernel 3.1 or newer, the only way I will ever
> get EINVAL for these two constants is if I do something else invalid, like a
> negative offset.

Revised patch below.

Cheers,

Michael


diff --git a/man2/lseek.2 b/man2/lseek.2
index 26943e2..9e62bc6 100644
--- a/man2/lseek.2
+++ b/man2/lseek.2
@@ -85,6 +85,70 @@ of the file (but this does not change the size of the file).
 If data is later written at this point, subsequent reads of the data
 in the gap (a "hole") return null bytes (\(aq\\0\(aq) until
 data is actually written into the gap.
+.SS Seeking file data and holes
+Since version 3.1, Linux supports the following additional values for
+.IR whence :
+.TP
+.B SEEK_DATA
+Adjust the file offset to the next location
+in the file greater than or equal to
+.I offset
+containing data.
+If
+.I offset
+points to data,
+then the file offset is set to
+.IR offset .
+.TP
+.B SEEK_HOLE
+Adjust the file offset to the next hole in the file
+greater than or equal to
+.IR offset .
+If
+.I offset
+points into the middle of a hole,
+then the file offset is set to
+.IR offset .
+If there is no hole past
+.IR offset ,
+then the file offset is adjusted to the end of the file
+(i.e., there is an implicit hole at the end of any file).
+.PP
+In both of the above cases,
+.BR lseek ()
+fails if
+.I offset
+points past the end of the file.
+
+These operations allow applications to map holes in a sparsely
+allocated file.
+This can be useful for applications such as file backup tools,
+which can save space when creating backups and preserve holes,
+if they have a mechanism for discovering holes.
+
+For the purposes of these operations, a hole is a sequence of zeroes that
+(normally) has not been allocated in the underlying file storage.
+However, a file system is not obliged to report holes,
+so these operations are not a guaranteed mechanism for
+mapping the storage space actually allocated to a file.
+(Furthermore, a sequence of zeroes that actually has been written
+to the underlying storage may not be reported as a hole.)
+In the simplest implementation,
+a file system can support the operations by making
+.BR SEEK_HOLE
+always return the offset of the end of the file,
+and making
+.BR SEEK_DATA
+always return
+return
+.IR offset
+(i.e., even if the location referred to by
+.I offset
+is a hole,
+it can be considered to consist of data that is a sequence of zeroes).
+.\" https://lkml.org/lkml/2011/4/22/79
+.\" http://lwn.net/Articles/440255/
+.\" http://blogs.oracle.com/bonwick/entry/seek_hole_and_seek_data
 .SH "RETURN VALUE"
 Upon successful completion,
 .BR lseek ()
@@ -101,11 +165,8 @@ is not an open file descriptor.
 .TP
 .B EINVAL
 .I whence
-is not one of
-.BR SEEK_SET ,
-.BR SEEK_CUR ,
-.BR SEEK_END ;
-or the resulting file offset would be negative,
+is not valid.
+Or: the resulting file offset would be negative,
 or beyond the end of a seekable device.
 .\" Some systems may allow negative offsets for character devices
 .\" and/or for remote file systems.
@@ -118,8 +179,23 @@ The resulting file offset cannot be represented in an
 .B ESPIPE
 .I fd
 is associated with a pipe, socket, or FIFO.
+.TP
+.B ENXIO
+.I whence
+is
+.B SEEK_DATA
+or
+.BR SEEK_HOLE ,
+and the current file offset is beyond the end of the file.
 .SH "CONFORMING TO"
 SVr4, 4.3BSD, POSIX.1-2001.
+
+.BR SEEK_DATA
+and
+.BR SEEK_HOLE
+are nonstandard extensions also present in Solaris;
+they are proposed for inclusion in the next POSIX revision (Issue 8).
+.\" FIXME . Review http://austingroupbugs.net/view.php?id=415 in the future
 .SH NOTES
 Some devices are incapable of seeking and POSIX does not specify which
 devices must support


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
