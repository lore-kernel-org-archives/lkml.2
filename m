Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1HXCUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 22:20:00 -0400
Received: from mx2.parallels.com ([64.131.90.16]:38067 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707Ab1HXCTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 22:19:53 -0400
Message-ID: <4E545FAE.5040008@parallels.com>
Date: Tue, 23 Aug 2011 23:19:26 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v3 4/4] parse options in the vfs level
References: <1313334832-1150-1-git-send-email-glommer@parallels.com> <1313334832-1150-5-git-send-email-glommer@parallels.com> <20110815070932.GF26978@dastard>
In-Reply-To: <20110815070932.GF26978@dastard>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.54.7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 04:09 AM, Dave Chinner wrote:
> On Sun, Aug 14, 2011 at 07:13:52PM +0400, Glauber Costa wrote:
>> This patch introduces a simple generic vfs option parser.
>> Right now, the only option we have is to limit the size of the dcache.
>>
>> So any user that wants to have a dcache entries limit, can specify:
>>
>>    mount -o whatever_options,vfs_dcache_size=XXX<dev>  <mntpoint>
>>
>> It is supposed to work well with remounts, allowing it to change
>> multiple over the course of the filesystem's lifecycle.
>>
>> I find mount a natural interface for handling filesystem options,
>> so that's what I've choosen. Feel free to yell at it at will if
>> you disagree.
>
> It's already been noted by both myself and Al that there is not a
> 1:1 mapping between mount point and superblocks....

I had skipped that one in my pending patches.

Well, it's already been noted by me as well. And by anybody.
The problem, however, is not new. Filesystems exports fs-specific
options that operate on the superblock as well. And we've been living 
alright with them.

>> @@ -2350,6 +2449,12 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
>>   	else
>>   		retval = do_new_mount(&path, type_page, flags, mnt_flags,
>>   				      dev_name, data_page);
>> +
>> +	/* bind mounts get to respect their parents decision */
>> +	if (!retval&&  !(flags&  MS_BIND))
>> +		vfs_set_dcache_size(path.mnt->mnt_sb,
>> +				    vfs_options.vfs_dcache_size);
>> +			
>
> And I'm not sure that silently ignoring it in certain cases
> is the best way around that problem.

It is not "in certain cases". It is : 1) When bind mounting, and 2) When 
an error occurs. Pretty well-defined.
