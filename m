Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab2FTGeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 02:34:01 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42837 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2FTGd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 02:33:59 -0400
Message-ID: <4FE16ED3.2090403@gmail.com>
Date: Wed, 20 Jun 2012 02:33:55 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: gaowanlong@cn.fujitsu.com
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, Eric Wong <normalperson@yhbt.net>
Subject: Re: [PATCH] mm, fadvise: don't return -EINVAL when filesystem has
 no optimization way
References: <1339792575-17637-1-git-send-email-kosaki.motohiro@gmail.com> <4FE16E50.9030304@cn.fujitsu.com>
In-Reply-To: <4FE16E50.9030304@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/20/12 2:31 AM), Wanlong Gao wrote:
> On 06/16/2012 04:36 AM, kosaki.motohiro@gmail.com wrote:
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> Eric Wong reported his test suite was fail when /tmp is tmpfs.
>>
>> https://lkml.org/lkml/2012/2/24/479
>>
>> Current,input check of POSIX_FADV_WILLNEED has two problems.
>>
>> 1) require a_ops->readpage.
>>    But in fact, force_page_cache_readahead() only require
>>    a target filesystem has either ->readpage or ->readpages.
>> 2) return -EINVAL when filesystem don't have ->readpage.
>>    But, posix says, it should be retrieved a hint. Thus fadvise()
>>    should return 0 if filesystem has no optimization way.
>>    Especially, userland application don't know a filesystem type
>>    of TMPDIR directory as Eric pointed out. Then, userland can't
>>    avoid this error. We shouldn't encourage to ignore syscall
>>    return value.
>>
>> Thus, this patch change a return value to 0 when filesytem don't
>> support readahead.
>>
>> Cc: linux-mm@kvack.org
>> Cc: Hugh Dickins <hughd@google.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Hillf Danton <dhillf@gmail.com>
>> Signed-off-by: Eric Wong <normalperson@yhbt.net>
>> Tested-by: Eric Wong <normalperson@yhbt.net>
>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> ---
>>  mm/fadvise.c |   18 +++++++-----------
>>  1 files changed, 7 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/fadvise.c b/mm/fadvise.c
>> index 469491e..33e6baf 100644
>> --- a/mm/fadvise.c
>> +++ b/mm/fadvise.c
>> @@ -93,11 +93,6 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
>>  		spin_unlock(&file->f_lock);
>>  		break;
>>  	case POSIX_FADV_WILLNEED:
>> -		if (!mapping->a_ops->readpage) {
>> -			ret = -EINVAL;
>> -			break;
>> -		}
> 
> Why not check both readpage and readpages, if they are not here,
> just beak and no following force_page_cache_readahead ?

They are checked in force_page_cache_readahead.

