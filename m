Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1CHFij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 00:38:39 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:52317 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1CHFii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 00:38:38 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=37qdrPIVUooonMxFi2BWZ8DhoCRe+hJcgJuumZcJ4K8= c=1 sm=1
 a=oeVD3z6_cdsA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=pGLkceISAAAA:8 a=1ckM6HE7bukOf_hAgYoA:9
 a=-gj1kuWWMV3xFUEagYLqJ0CjoX8A:4 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH v3] Check for immutable/append flag in fallocate path
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20110308051121.GE1956@dastard>
Date: Mon, 7 Mar 2011 22:38:37 -0700
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <92E5B019-756F-4CBE-829C-724564D4D650@dilger.ca>
References: <4D6221B8.9040303@gmail.com> <4D6F5473.2070709@gmail.com> <4D720469.1010101@gmail.com> <20110308051121.GE1956@dastard>
To: Dave Chinner <david@fromorbit.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-07, at 10:11 PM, Dave Chinner wrote:
> On Sat, Mar 05, 2011 at 10:37:45AM +0100, Marco Stornelli wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>> 
>> In the fallocate path the kernel doesn't check for the immutable/append
>> flag. It's possible to have a race condition in this scenario: an
>> application open a file in read/write and it does something, meanwhile
>> root set the immutable flag on the file, the application at that point
>> can call fallocate with success. In addition, we don't allow to do any
>> unreserve operation on an append only file but only the reserve one.
>> 
>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>> ---
>> Patch is against 2.6.38-rc7
>> 
>> ChangeLog:
>> v3: Modified do_fallocate instead of every single fs
>> v2: Added the check for append-only file for XFS
>> v1: First draft
>> 
>> --- open.c.orig	2011-03-01 22:55:12.000000000 +0100
>> +++ open.c	2011-03-04 15:28:43.000000000 +0100
>> @@ -233,6 +233,14 @@ int do_fallocate(struct file *file, int
>> 
>> 	if (!(file->f_mode & FMODE_WRITE))
>> 		return -EBADF;
>> +
>> +	/* It's not possible punch hole on append only file */
>> +	if (mode & FALLOC_FL_PUNCH_HOLE && IS_APPEND(inode))
>> +		return -EPERM;
> 
> Seeing as I didn't get an answer in before you reposted, I still
> think punching an append-only file is a valid thing to want to do.
> 
> I've seen this done in the past for application-level transaction
> journal files. The journal file is append only so new transactions
> can only be written at the end of the file i.e. you cannot overwrite
> (and therefore corrupt) existing transactions. However, once a
> transaction is complete and the changes flushed to disk, the
> transaction is punched out of the file to zero the range so it
> doesn't get replayed during recovery after a system crash.

To my thinking "append only" means just that - only new data can be written at the end of the file, and existing data cannot be modified.  Allowing hole punch on such a file (e.g. range 0 .. ~0) would allow erasing all of the data, entirely bypassing the append-only flag.

Cheers, Andreas





