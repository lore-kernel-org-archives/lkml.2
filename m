Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab1DVBW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 21:22:58 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58997 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab1DVBW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 21:22:56 -0400
MIME-Version: 1.0
In-Reply-To: <loom.20110422T001650-760@post.gmane.org>
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
	<loom.20110422T001650-760@post.gmane.org>
Date: Thu, 21 Apr 2011 21:22:55 -0400
Message-ID: <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
From: Josef Bacik <josef@toxicpanda.com>
To: Eric Blake <eblake@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 6:28 PM, Eric Blake <eblake@redhat.com> wrote:
> Josef Bacik <josef <at> redhat.com> writes:
>
>> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns
>> out using fiemap in things like cp cause more problems than it solves, so
>> lets try and give userspace an interface that doesn't suck.  So we have
>>
>> -SEEK_HOLE: this moves the file pos to the nearest hole in the file from the
>> given position.  If the given position is a hole then pos won't move.  A "hole"
>> is defined by whatever the fs feels like defining it to be.
>
> You absolutely need to match Solaris semantics, which are documented as follows:
>
>         �  If whence is SEEK_HOLE, the offset of the start of the  next  hole
>            greater than or equal to the supplied offset is returned. The def-
>            inition of a hole is provided near the end of the DESCRIPTION.
>
>         �  If whence is SEEK_DATA, the file pointer is set to  the  start  of
>            the  next  non-hole  file region greater than or equal to the sup-
>            plied offset.
>
>       A  "hole" is defined as a contiguous range of bytes in a file, all hav-
>       ing the value of zero, but not all zeros in a file are guaranteed to be
>       represented  as  holes returned with SEEK_HOLE. Filesystems are allowed
>       to expose ranges of zeros with SEEK_HOLE, but not required to. Applica-
>       tions can use SEEK_HOLE to optimise their behavior for ranges of zeros,
>       but must not depend on it to find all such ranges in a file. The  exis-
>       tence  of  a  hole at the end of every data region allows for easy pro-
>       gramming and implies that a virtual hole exists at the end of the file.
>       Applications   should   use   fpathconf(_PC_MIN_HOLE_SIZE)   or   path-
>       conf(_PC_MIN_HOLE_SIZE)  to  determine   if   a   filesystem   supports
>       SEEK_HOLE. See fpathconf(2).
>
>       For  filesystems  that  do not supply information about holes, the file
>       will be represented as one entire data region.
>
>       ENXIO           For SEEK_DATA, there are no more data regions past  the
>                       supplied offset. For SEEK_HOLE, there are no more holes
>                       past the supplied offset.
>
> Note that in that definition, SEEK_HOLE does _not_ reposition the file offset
> (it returns the offset of the next hole, which might be at the end of the file
> since all files have a virtual hole at the end, but leaves the position
> unchanged).  I'd have to write a test program on Solaris to see whether that
> definition is actually true, or if it is a bug in the Solaris man page.
>

lseek's purpose is to reposition the file position, so I'd imagine
this is just a bug in the man page.

> Making SEEK_HOLE blindly fail is therefore not useful; you could just as
> easily make it succeed and return the offset of the last byte of the file for
> all file systems (if the offset requested is within bounds, or fail with
> ENXIO if it is out of bounds), and have a valid, working, and minimal
> implementation already in place.
>

Except you can have blocks allocated past i_size, so returning i_size
isn't necessarily correct.  Obviously the idea is to have most of the
filesystems doing the correct thing, but for my first go around I just
was going to do one since I expect quite a bit of repainting for this
bikeshed is yet to be done.  But I guess if you have data past i_size
doing this would encourage the various fs people to fix it.

>>
>> -SEEK_DATA: this is obviously a little more self-explanatory.  Again the only
>> ambiguity comes in with preallocated extents.  If you have an fs that can't
>> reliably tell that the preallocated extent is in the process of turning into a
>> real extent, it is correct for SEEK_DATA to park you at a preallocated extent.
>
> In contrast to SEEK_HOLE, SEEK_DATA _does_ reposition the file, or fail with
> ENXIO.  Back to your minimal implementation, it would be valid to always fail
> with ENXIO (treating every file as a single block of data followed by a single
> virtual hole at file end, so there is no next data after any current position).
>
>> +++ b/fs/read_write.c
>> @@ -64,6 +64,9 @@ generic_file_llseek_unlocked(struct file *file, loff_t
> offset, int origin)
>>                       return file->f_pos;
>>               offset += file->f_pos;
>>               break;
>> +     case SEEK_DATA:
>> +     case SEEK_HOLE:
>> +             return -EINVAL;
>
> Whatever you do, returning EINVAL is not nice, especially when it seems pretty
> easy to provide a working alternative that assumes all files are a single data
> block until fine-tuned otherwise on a per-filesystem basis.
>

Agreed, I'll fix it.  Thanks,

Josef
