Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab1ACQ13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:27:29 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:4799 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1ACQ11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:27:27 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=fp/YrIG6YJuYYWILSlVONgBms0XWtFqTjqHWlNKfnDg= c=1 sm=1
 a=Dn-75YwQAYUA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8
 a=R7VPdpcKr-8wtAoHEkYA:9 a=wLyVq4jye_WCF2s8NgsA:7
 a=fAYNh-uBqPJVepnWytEO2Csnrd0A:4 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10
 a=MSl-tDqOz04A:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
References: <1293631121-12667-1-git-send-email-sickamd@gmail.com> <1294050468.2429.2.camel@dolmen>
In-Reply-To: <1294050468.2429.2.camel@dolmen>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <E8737614-4ED4-4732-9B03-90811029A0F7@dilger.ca>
Cc: yangsheng <sickamd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
X-Mailer: iPhone Mail (8C148a)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Update atime from future.
Date: Mon, 3 Jan 2011 09:27:54 -0700
To: Steven Whitehouse <swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-03, at 3:27, Steven Whitehouse <swhiteho@redhat.com> wrote:
> On Wed, 2010-12-29 at 21:58 +0800, yangsheng wrote:
>> Signed-off-by: sickamd@gmail.com
>> ---
>> fs/inode.c |    8 +++++++-
>> 1 files changed, 7 insertions(+), 1 deletions(-)
>> 
>> diff --git a/fs/inode.c b/fs/inode.c
>> index da85e56..6c8effd 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -1469,7 +1469,13 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
>>        return 1;
>> 
>>    /*
>> -     * Is the previous atime value older than a day? If yes,
>> +     * Is the previous atime value in future? If yes,
>> +     * update atime:
>> +     */
>> +    if ((long)(now.tv_sec - inode->i_atime.tv_sec) < 0)
>> +        return 1;
>> +    /*
>> +     * Is the previous atime value old than a day? If yes,
>>     * update atime:
>>     */
>>    if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
> 
> I don't think this is a good plan for cluster filesystems, since if the
> times on the nodes are not exactly synchronised (we do highly recommend
> people run ntp or similar) then this might lead to excessive atime
> updating. The current behaviour is to ignore atimes which are in the
> future for exactly this reason,

The problem that is seen is if a tarball has stored a bad atime, or someone fat-fingers a "touch" then the future atime will never be fixed. Before the relatime patch, the future atime would be updated back to the current time on the next access. One if our regression tests for Lustre caught this. 

I wouldn't mind changing the relatime check so that it only updates the atime if it is more than one day in the future. That will avoid thrashing atime if the clocks are only slightly out of sync, but still allow fixing completely bogus atimes. 

Cheers, Andreas