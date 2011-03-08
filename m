Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1CHHgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 02:36:01 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61670 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1CHHf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 02:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ia7x4Vd4gtP8ANeczWdrs1BZlYx8LhGgl+FY7++4E668VSLPG07d8m4158Se2UlFms
         6Wp/zl9RWLx/KA8yCyBiQkGYtpTxgo+uL33FcqU6+qAUH0PSKr/oM134GZfm1AH3JFKK
         CduL/OClizSG9xTrzTRp/vbH2DxCkFQziGlQ8=
MIME-Version: 1.0
In-Reply-To: <92E5B019-756F-4CBE-829C-724564D4D650@dilger.ca>
References: <4D6221B8.9040303@gmail.com>
	<4D6F5473.2070709@gmail.com>
	<4D720469.1010101@gmail.com>
	<20110308051121.GE1956@dastard>
	<92E5B019-756F-4CBE-829C-724564D4D650@dilger.ca>
Date: Tue, 8 Mar 2011 08:35:56 +0100
Message-ID: <AANLkTim041-4jY1en3Ma3GjSZjhd_2L4nyP=ZYepD01f@mail.gmail.com>
Subject: Re: [PATCH v3] Check for immutable/append flag in fallocate path
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/8 Andreas Dilger <adilger.kernel@dilger.ca>:
> On 2011-03-07, at 10:11 PM, Dave Chinner wrote:
>> On Sat, Mar 05, 2011 at 10:37:45AM +0100, Marco Stornelli wrote:
>>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>>
>>> In the fallocate path the kernel doesn't check for the immutable/append
>>> flag. It's possible to have a race condition in this scenario: an
>>> application open a file in read/write and it does something, meanwhile
>>> root set the immutable flag on the file, the application at that point
>>> can call fallocate with success. In addition, we don't allow to do any
>>> unreserve operation on an append only file but only the reserve one.
>>>
>>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>>> ---
>>> Patch is against 2.6.38-rc7
>>>
>>> ChangeLog:
>>> v3: Modified do_fallocate instead of every single fs
>>> v2: Added the check for append-only file for XFS
>>> v1: First draft
>>>
>>> --- open.c.orig      2011-03-01 22:55:12.000000000 +0100
>>> +++ open.c   2011-03-04 15:28:43.000000000 +0100
>>> @@ -233,6 +233,14 @@ int do_fallocate(struct file *file, int
>>>
>>>      if (!(file->f_mode & FMODE_WRITE))
>>>              return -EBADF;
>>> +
>>> +    /* It's not possible punch hole on append only file */
>>> +    if (mode & FALLOC_FL_PUNCH_HOLE && IS_APPEND(inode))
>>> +            return -EPERM;
>>
>> Seeing as I didn't get an answer in before you reposted, I still
>> think punching an append-only file is a valid thing to want to do.
>>
>> I've seen this done in the past for application-level transaction
>> journal files. The journal file is append only so new transactions
>> can only be written at the end of the file i.e. you cannot overwrite
>> (and therefore corrupt) existing transactions. However, once a
>> transaction is complete and the changes flushed to disk, the
>> transaction is punched out of the file to zero the range so it
>> doesn't get replayed during recovery after a system crash.
>
> To my thinking "append only" means just that - only new data can be written at the end of the file, and existing data cannot be >modified.  Allowing hole punch on such a file (e.g. range 0 .. ~0) would allow erasing all of the data, entirely bypassing the >append-only flag.
>
> Cheers, Andreas
>

I quite agree with Andreas.

Marco
