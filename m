Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab2BOX7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:59:55 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46784 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755743Ab2BOX7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:59:51 -0500
Message-ID: <4F3C467B.1@fb.com>
Date: Wed, 15 Feb 2012 15:57:47 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andrea Righi <andrea@betterlinux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shaohua Li <shaohua.li@intel.com>,
        =?windows-1252?Q?P=E1draig_Brady?= <P@draigBrady.com>,
        John Stultz <john.stultz@linaro.org>,
        Jerry James <jamesjer@betterlinux.com>,
        Julius Plenz <julius@plenz.com>, linux-mm <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] fadvise: implement POSIX_FADV_NOREUSE
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com> <1329006098-5454-4-git-send-email-andrea@betterlinux.com> <20120215233537.GA20724@dev3310.snc6.facebook.com> <20120215234724.GA21685@thinkpad>
In-Reply-To: <20120215234724.GA21685@thinkpad>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.260,0.0.0000
 definitions=2012-02-15_05:2012-02-15,2012-02-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2/15/12 3:47 PM, Andrea Righi wrote:
>> index 74b6a97..b4e45e6 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -9,7 +9,6 @@
>>   #include<linux/limits.h>
>>   #include<linux/ioctl.h>
>>   #include<linux/blk_types.h>
>> -#include<linux/kinterval.h>
>>   #include<linux/types.h>
>>
>>   /*
>> @@ -656,7 +655,7 @@ struct address_space {
>>   	spinlock_t		private_lock;	/* for use by the address_space */
>>   	struct list_head	private_list;	/* ditto */
>>   	struct address_space	*assoc_mapping;	/* ditto */
>> -	struct rb_root		nocache_tree;	/* noreuse cache range tree */
>> +	void			*nocache_tree;	/* noreuse cache range tree */
>>   	rwlock_t		nocache_lock;	/* protect the nocache_tree */
>>   } __attribute__((aligned(sizeof(long))));
>>   	/*
>
> mmh.. a forward declaration of rb_root in fs.h shouldn't be better than
> this?
>

Forward declaration works if the type was struct rb_root *. But the type 
in your patch was a struct and the compiler can't figure out its size.

include/linux/fs.h:659:17: error: field ‘nocache_tree’ has incomplete type

Did you mean forward declaring struct rb_node instead of rb_root?

If we go down this path, a few more places need fixups (I ignored the 
compiler warnings about casting void * to struct rb_root *).

  -Arun

