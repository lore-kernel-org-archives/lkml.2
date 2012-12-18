Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2LRMVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:21:22 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:57615 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2LRMVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:21:21 -0500
References: <50CC9663.4010200@gmail.com> <20121216021508.GG9806@dastard>
In-Reply-To: <20121216021508.GG9806@dastard>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <60E209F1-F797-42C2-9F41-43BF7839B2A3@dilger.ca>
Cc: ys <sickamd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
X-Mailer: iPhone Mail (10A525)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] vfs: update atimes over one day in the past or future
Date: Tue, 18 Dec 2012 05:14:57 -0700
To: Dave Chinner <david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-15, at 19:15, Dave Chinner <david@fromorbit.com> wrote:
> 
> On Sat, Dec 15, 2012 at 11:25:23PM +0800, ys wrote:
>> From 3d56c131b58a21c05bcd677b9d2ba915abcbf195 Mon Sep 17 00:00:00 2001
>> From: yangsheng <sickamd@gmail.com>
>> Date: Sat, 15 Dec 2012 21:46:22 +0800
>> Subject: [PATCH] vfs: update atimes over one day in the past or future
>> 
>> Relatime should update the inode atime if it is more than one day
>> in the future.  The original problem seen was a tarball that had
>> a bad atime in the distant future, but could also happen if someone
>> fat-fingers a "touch".  The future atime will never be fixed.
>> 
>> Without relatime enabled, a future atime is updated to the current
>> kernel time on access.  Relatime is meant to reduce the frequency
>> of atime updates, not decide if whether the system clock or the
>> inode timestamp is correct or not.
>> 
>> Signed-off-by: Yang Sheng <sickamd@gmail.com>
>> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
>> Acked-by: David Chinner <david@fromorbit.com>
> 
> No I didn't. Please don't add tags that someone has not added
> directly in a reply to the original patch.

That's my fault. I thought you'd OK'd the patch with the revised commit comment. 

>> CC: stable@vger.kernel.org
>> ---
>> fs/inode.c | 7 ++++---
>> 1 ??????????????????????????? 4 ???(+)????????? 3 ???(-)
> 
> There's something wrong with the character encoding you are using...

Chinese locale, but probably doesn't matter since text below "---" isn't in the commit anyway?

>> diff --git a/fs/inode.c b/fs/inode.c
>> index 14084b7..8713dc8 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -1488,10 +1488,11 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
>>        return 1;
>> 
>>    /*
>> -     * Is the previous atime value older than a day? If yes,
>> -     * update atime:
>> +     * Update atime if it's older than a day or more than a day
>> +     * in the future, which we assume is corrupt.
>> +     *         
> 
> A time in the future is not a corruption - the comment should
> reflect exactly what you've put in the commit message. i.e. that
> relatime is for reducing updates, not preventing atime from ever
> moving backwards.

Ok. 

> Also, you've added an extra line of whitespace damage that doesn't
> need to be there.....
> 
> FWIW, could you write a test for xfstests for this behaviour
> so we can confirm that we don't break it in future?

Sure, I'll take a crack at that. 

Cheers, Andreas