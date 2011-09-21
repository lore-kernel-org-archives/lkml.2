Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750926Ab1IUEMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 00:12:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43484 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab1IUEL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 00:11:56 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAKgNAkj-jPR-9hyuxrJ74uu3Kdv9bATrfCUedoty4dJOCh2GcA@mail.gmail.com>
References: <1289840876-3546-1-git-send-email-josef@redhat.com> <CAKgNAkj-jPR-9hyuxrJ74uu3Kdv9bATrfCUedoty4dJOCh2GcA@mail.gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 21 Sep 2011 06:11:36 +0200
Message-ID: <CAKgNAkhCptHn_UxReeZeSNaP0yNr+iWYd3fcxrD_PHohqQVxuQ@mail.gmail.com>
Subject: Re: [PATCH] fallocate.2: add FALLOC_FL_PUNCH_HOLE flag definition
To: Josef Bacik <josef@redhat.com>
Cc: Eric Gouriou <egouriou@google.com>, inux-man@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending with Eric Gouriou on CC]

Hi Josef (Dave C, please also note comments below),

On Mon, Nov 15, 2010 at 6:07 PM, Josef Bacik <josef@redhat.com> wrote:
> This patch adds the relevant documenation for using fallocate with the
> FALLOC_FL_PUNCH_HOLE mode.  This information comes from the implementation of
> FALLOC_FL_PUNCH_HOLE that I've posted along with this man page update to outline
> the definition for hole punching.  Obviously this patch is dependant upon the
> current implementation being accepted.  Thanks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  man2/fallocate.2 |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/man2/fallocate.2 b/man2/fallocate.2
> index 42eefbd..1b28916 100644
> --- a/man2/fallocate.2
> +++ b/man2/fallocate.2
> @@ -31,9 +31,8 @@ bytes.
>
>  The
>  .I mode
> -argument determines the operation to be performed on the given range.
> -Currently only one flag is supported for
> -.IR mode :
> +argument determines the operation to be performed on the given range, the
> +value can be one of the following:
>  .TP
>  .B FALLOC_FL_KEEP_SIZE
>  This flag allocates and initializes to zero the disk space
> @@ -50,6 +49,16 @@ the file size (as reported by
>  .BR stat (2))
>  even if it is less than
>  .IR offset + len .
> +.TP
> +.B FALLOC_FL_PUNCH_HOLE
> +This flag de-allocates the disk space within the range specified by
> +.I offset
> +and
> +.IR len .
> +This call preserves the file size (as reported by
> +.BR stat (2)),
> +the only change will be to the amount of space used by the file.  After a
> +successful call, subsequent reads from this range will return 0's.
>  .\"
>  .\" Note from Amit Arora:
>  .\" There were few more flags which were discussed, but none of
> --
> 1.6.6.1

Thanks for this patch. As noted in another mail, Lucian also sent a
patch for FALLOC_FL_PUNCH_HOLE, and I applied his patch first, and
then added some pieces from yours, as well as some of my own edits.

However, the addition of a second class of operation to the man page
made it clear that some significant restructuring of the page is
required. So I substantially reworked the page, including the
preexisting material on the default "file allocation" operation (Dave
C please note).

Josef, Lucian, could I ask you to check ("man -l <file>") the final
text (below) for FALLOC_FL_PUNCH_HOLE (including the EPERM error under
ERRORS)?

Dave, could I ask you to review my reworked text for the "Allocating
disk space" subsection?

Thanks,

Michael

.\" Copyright (c) 2007 Silicon Graphics, Inc. All Rights Reserved
.\" Written by Dave Chinner <dgc@sgi.com>
.\" May be distributed as per GNU General Public License version 2.
.\"
.\" 2011-09-19: Added FALLOC_FL_PUNCH_HOLE
.\" 2011-09-19: Substantial restructuring of the page
.\"
.TH FALLOCATE 2 2011-09-19 "Linux" "Linux Programmer's Manual"
.SH NAME
fallocate \- manipulate file space
.SH SYNOPSIS
.nf
.BR "#define _GNU_SOURCE" "             /* See feature_test_macros(7) */"
.B #include <fcntl.h>

.BI "int fallocate(int " fd ", int " mode ", off_t " offset \
", off_t " len ");
.fi
.SH DESCRIPTION
This is a nonportable, Linux-specific system call.
For the portable, POSIX.1-specified method of ensuring that space
is allocated for a file, see
.BR posix_fallocate (3).

.BR fallocate ()
allows the caller to directly manipulate the allocated disk space
for the file referred to by
.I fd
for the byte range starting at
.I offset
and continuing for
.I len
bytes.

The
.I mode
argument determines the operation to be performed on the given range.
Details of the supported operations are given in the subsections below.
.SS Allocating disk space
The default operation (i.e.,
.I mode
is zero) of
.BR fallocate ()
allocates and initializes to zero the disk space
within the range specified by
.I offset
and
.IR len .
The file size (as reported by
.BR stat (2))
will be changed if
.I "offset + len"
is greater than the file size.
This default behavior closely resembles the behavior of the
.BR posix_fallocate (3)
library function,
and is intended as a method of optimally implementing that function.

After a successful call, subsequent writes into the range specified by
.IR offset
and
.IR len
are guaranteed not to fail because of lack of disk space.

If the
.B FALLOC_FL_KEEP_SIZE
flag is specified in
.IR mode ,
the behavior of the call is similar,
but the file size will not be changed even if
.I "offset + len"
is greater than the file size.
Preallocating zeroed blocks beyond the end of the file in this manner
is useful for optimizing append workloads.
.PP
Because allocation is done in block size chunks,
.BR fallocate ()
may allocate a larger range of disk space than was specified.
.SS Deallocating file space
Specifying the
.BR FALLOC_FL_PUNCH_HOLE
flag (available since Linux 2.6.38) in
.I mode
deallocates space (i.e., creates a hole)
in the byte range starting at
.I offset
and continuing for
.I len
bytes.
Within the specified range, partial file system blocks are zeroed,
and whole file system blocks are removed from the file.
After a successful call,
subsequent reads from this range will return zeroes.

The
.BR FALLOC_FL_PUNCH_HOLE
flag must be ORed with
.BR FALLOC_FL_KEEP_SIZE
in
.IR mode ;
in other words, even when punching off the end of the file, the file size
(as reported by
.BR stat (2))
does not change.

Not all file systems support
.BR FALLOC_FL_PUNCH_HOLE ;
if a file system doesn't support the operation, an error is returned.
.SH RETURN VALUE
.BR fallocate ()
returns zero on success, and \-1 on failure.
.SH ERRORS
.TP
.B EBADF
.I fd
is not a valid file descriptor, or is not opened for writing.
.TP
.B EFBIG
.IR offset + len
exceeds the maximum file size.
.TP
.B EINTR
A signal was caught during execution.
.TP
.B EINVAL
.I offset
was less than 0, or
.I len
was less than or equal to 0.
.TP
.B EIO
An I/O error occurred while reading from or writing to a file system.
.TP
.B ENODEV
.I fd
does not refer to a regular file or a directory.
(If
.I fd
is a pipe or FIFO, a different error results.)
.TP
.B ENOSPC
There is not enough space left on the device containing the file
referred to by
.IR fd .
.TP
.B ENOSYS
The file system containing the file referred to by
.I fd
does not support this operation.
.TP
.B EOPNOTSUPP
The
.I mode
is not supported by the file system containing the file referred to by
.IR fd .
.TP
.B EPERM
The file referred to by
.I fd
is marked immutable (see
.BR chattr (1)).
Or:
.I mode
specifies
.BR FALLOC_FL_PUNCH_HOLE
and
the file referred to by
.I fd
is marked append-only
(see
.BR chattr (1)).
.TP
.B ESPIPE
.I fd
refers to a pipe of FIFO.
.SH VERSIONS
.BR fallocate ()
is available on Linux since kernel 2.6.23.
Support is provided by glibc since version 2.10.
.SH CONFORMING TO
.BR fallocate ()
is Linux-specific.
.SH SEE ALSO
.BR ftruncate (2),
.BR posix_fadvise (3),
.BR posix_fallocate (3)

--
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
