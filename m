Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1ISSFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:05:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19981 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab1ISSFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:05:16 -0400
Message-ID: <4E778434.6040905@oracle.com>
Date: Mon, 19 Sep 2011 11:04:36 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b3pre Thunderbird/3.1.13
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: Josef Bacik <josef@redhat.com>, linux-man@vger.kernel.org,
        Eric Blake <eblake@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Man page doc for SEEK_DATA/SEEK_HOLE
References: <CAKgNAkhZSb0UfZz7N+gKRQD0r7gnC_3-VCB_ORio8ojczbCDvQ@mail.gmail.com>
In-Reply-To: <CAKgNAkhZSb0UfZz7N+gKRQD0r7gnC_3-VCB_ORio8ojczbCDvQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4E778456.002A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2011 12:07 AM, Michael Kerrisk wrote:
> Hello Josef,
>
> For Linux 3.1, you've added SEEK_HOLE + SEEK_DATA. I've attempted to
> document these as below for the lseek.2 man page. Could you please
> review?
>
> Thanks,
>
> Michael
>
>
> diff --git a/man2/lseek.2 b/man2/lseek.2
> index 26943e2..941ea08 100644
> --- a/man2/lseek.2
> +++ b/man2/lseek.2
> @@ -85,6 +85,69 @@ of the file (but this does not change the size of the file).
>   If data is later written at this point, subsequent reads of the data
>   in the gap (a "hole") return null bytes (\(aq\\0\(aq) until
>   data is actually written into the gap.
> +.SS Seeking file data and holes
> +Since version 3.1, Linux supports the following additional values for
> +.IR whence :
> +.TP
> +.B SEEK_DATA
> +Adjust the file offset to the next region
> +in the file greater than or equal to
> +.I offset

I would recommend dropping the word next as it is confusing considering the
offset returned could be the offset passed in.

> +containing data.
> +If
> +.I offset
> +points to data,
> +then the file offset is set to
> +.IR offset .
> +.TP
> +.B SEEK_HOLE
> +Adjust the file offset to the next hole in the file
> +greater than or equal to
> +.IR offset .

Same here.

> +If
> +.I offset
> +points into the middle of a hole,
> +then the file offset is set to
> +.IR offset .
> +If there is no hole past
> +.IR offset ,
> +then the file offset is adjusted to the end of the file
> +(i.e., there is an implicit hole at the end of any file).
> +.PP
> +In both of the above cases,
> +.BR lseek ()
> +fails if
> +.I offset
> +points past the end of the file.
> +
> +These operations allow applications to map holes in a sparsely
> +allocated file.
> +This can be useful for applications such as file backup tools,
> +which can save space when creating backups and preserve holes,
> +if they have a mechanism for discovering holes.
> +
> +For the purposes of these operations, a hole is a sequence of zeroes that
> +(normally) has not been allocated in the underlying file storage.
> +However, a file system is not obliged to report holes,
> +so these operations are not a guaranteed mechanism for
> +mapping the storage space actually allocated to a file.
> +(Furthermore, a sequence of zeroes that actually has been written
> +to the underlying storage normally won't be reported as a hole.)

Instead of "won't be", make it "may not be". The interface should not limit
the file system/block device.

> +In the simplest implementation,
> +a file system can support the operations by making
> +.BR SEEK_HOLE
> +always return the offset of the end of the file,
> +and making
> +.BR SEEK_DATA
> +always return
> +return
> +.IR offset
> +(i.e., even if the location referred to by
> +.I offset
> +is a hole,
> +it can be considered to consist of data that is a sequence of zeroes).
> +.\" https://lkml.org/lkml/2011/4/22/79
> +.\" http://lwn.net/Articles/440255/
> +.\" http://blogs.oracle.com/bonwick/entry/seek_hole_and_seek_data
>
>   .SH "RETURN VALUE"
>   Upon successful completion,
>   .BR lseek ()
> @@ -101,11 +164,14 @@ is not an open file descriptor.
>   .TP
>   .B EINVAL
>   .I whence
> -is not one of
> -.BR SEEK_SET ,
> -.BR SEEK_CUR ,
> -.BR SEEK_END ;
> -or the resulting file offset would be negative,
> +is not valid (this error may be returned if
> +.I whence
> +is
> +.BR SEEK_DATA
> +or
> +.BR SEEK_HOLE
> +and the underlying file system does not support the operation).
> +Or: the resulting file offset would be negative,
>   or beyond the end of a seekable device.
>   .\" Some systems may allow negative offsets for character devices
>   .\" and/or for remote file systems.
> @@ -118,8 +184,21 @@ The resulting file offset cannot be represented in an
>   .B ESPIPE
>   .I fd
>   is associated with a pipe, socket, or FIFO.
> +.TP
> +.B ENXIO
> +.I whence
> +is
> +.B SEEK_DATA
> +or
> +.BR SEEK_HOLE ,
> +and the current file offset is beyond the end of the file.
>   .SH "CONFORMING TO"
>   SVr4, 4.3BSD, POSIX.1-2001.
> +
> +.BR SEEK_DATA
> +and
> +.BR SEEK_HOLE
> +are nonstandard extensions also present in Solaris.
>   .SH NOTES
>   Some devices are incapable of seeking and POSIX does not specify which
>   devices must support
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

