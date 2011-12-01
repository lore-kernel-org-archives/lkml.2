Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1LAIaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:30:18 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:52941 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751793Ab1LAIaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:30:16 -0500
Message-ID: <4ED73B13.7030600@tao.ma>
Date: Thu, 01 Dec 2011 16:30:11 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Set the initial TRIM information as TRIMMED
References: <20111201070052.GA29708@july>	<4ED72F1D.7070207@tao.ma> <CAH9JG2UADvsPX0s8TYTZ29j92AwDkVAGOhCwM-VFXQOP5yF7rA@mail.gmail.com>
In-Reply-To: <CAH9JG2UADvsPX0s8TYTZ29j92AwDkVAGOhCwM-VFXQOP5yF7rA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 04:19 PM, Kyungmin Park wrote:
> On 12/1/11, Tao Ma <tm@tao.ma> wrote:
>> Hi Kyungmin,
>> On 12/01/2011 03:00 PM, Kyungmin Park wrote:
>>> From: Kyungmin Park <kyungmin.park@samsung.com>
>>>
>>> Now trim information doesn't stored at disk so every boot time. it's
>>> cleared.
>>> and do the trim all disk groups.
>>> But assume that it's already trimmed at previous time so don't need to
>>> trim it again. So set the intial state as trimmed.
>> sorry, I don't get your meaning here.
>> Why can we assume that the group is already trimmed since it isn't
>> stored in the disk?
> To avoid the first time trim operation.
> Every boot time. run the fitrim then it trims all block groups again.
> but it's already done at previous time. so don't need to trim it
> again.
> Doesn't make sense? I think it's not designed behavior.
You make the assumption that we run the fitrim every time at boot time.
But what if the user don't run it at all? I guess "run fitrim during
boot" is your firmware's behaviour and it isn't an assumption for all
the other users.

Having said that, this flag will be cleared whenever some
blocks/clusters are freed. So maybe it doesn't matter for setting this
flag during the group initialization.

Thanks
Tao
> 
> In your patch at http://patchwork.ozlabs.org/patch/102918/
> 
> with the patch:
> [root@boyu-tm linux-2.6]# time ./ftrim /mnt/ext4/a
> real	0m5.625s
> user	0m0.000s
> sys	0m1.269s
> [root@boyu-tm linux-2.6]# time ./ftrim /mnt/ext4/a
> real	0m0.002s
> user	0m0.000s
> sys	0m0.001s
> [root@boyu-tm linux-2.6]# time ./ftrim /mnt/ext4/a
> real	0m0.002s
> user	0m0.000s
> sys	0m0.001s
> 
> After reboot. it maybe become below
> 
> [root@boyu-tm linux-2.6]# time ./ftrim /mnt/ext4/a
> real	0m0.002s
> user	0m0.000s
> sys	0m0.001s
> [root@boyu-tm linux-2.6]# time ./ftrim /mnt/ext4/a
> real	0m0.002s
> user	0m0.000s
> sys	0m0.001s
> [root@boyu-tm linux-2.6]# time ./ftrim /mnt/ext4/a
> real	0m0.002s
> user	0m0.000s
> sys	0m0.001s
> 
> Thank you,
> Kyungmin Park
>>
>> Thanks
>> Tao
>>>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>>> index e2d8be8..97ef342 100644
>>> --- a/fs/ext4/mballoc.c
>>> +++ b/fs/ext4/mballoc.c
>>> @@ -1098,6 +1098,12 @@ int ext4_mb_init_group(struct super_block *sb,
>>> ext4_group_t group)
>>>  		goto err;
>>>  	}
>>>  	mark_page_accessed(page);
>>> +
>>> +	/*
>>> +	 * TRIM information is not stored at disk so set the initial
>>> +	 * state as trimmed. Since previous time it's already trimmed all
>>> +	 */
>>> +	EXT4_MB_GRP_SET_TRIMMED(this_grp);
>>>  err:
>>>  	ext4_mb_put_buddy_page_lock(&e4b);
>>>  	return ret;
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

