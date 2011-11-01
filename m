Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1KADbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 23:31:45 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:33006 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754022Ab1KADbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 23:31:42 -0400
Message-ID: <4EAF6802.2060005@tao.ma>
Date: Tue, 01 Nov 2011 11:31:14 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH for 3.2] fs/direct-io.c: Calculate fs_count correctly
 in get_more_blocks.
References: <20111029105856.GA6479@infradead.org>	<1320045873-3956-1-git-send-email-tm@tao.ma> <x49wrblav46.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49wrblav46.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2011 02:12 AM, Jeff Moyer wrote:
> Tao Ma <tm@tao.ma> writes:
> 
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> In get_more_blocks, we use dio_count to calculate fs_count and do some
>> tricky things to increase fs_count if dio_count isn't aligned. But
>> actually it still has some cornor case that can't be coverd. See the
>> following example:
>> ./dio_write foo -s 1024 -w 4096(direct write 4096 bytes at offset 1024).
>> The same goes if the offset isn't aligned to fs_blocksize.
>>
>> In this case, the old calculation counts fs_count to be 1, but actually
>> we will write into 2 different blocks(if fs_blocksize=4096). The old code
>> just works, since it will call get_block twice(and may have to allocate
>> and create extent twice for file systems like ext4). So we'd better call
>> get_block just once with the proper fs_count.
> 
> This description was *really* hard for me to understand.  It seems to me
> that right now there's an inefficiency in the code.  It's not clear
> whether you're claiming that it was introduced recently, though.  Was
> it, or has this problem been around for a while?
Actually it is there a long time ago. And the good thing is that it
isn't a bug, only some performance overhead.
> 
> How did you notice this?  Was there any evidence of a problem, such as
> performance overhead or less than ideal file layout?
I found it when I dig into some ext4 issues. The ext4 can't create the
whole 8K(in the above case) and ext4 has to create the blocks 2 times
for just one direct i/o write. In some of our test, it costs.

> 
> Anyway, I agree that the code does not correctly calculate the number of
> file system blocks in a request.  I also agree that your patch fixes
> that issue.
> 
> Please ammend the description and then you can add my:
So how about the following commit log(please feel free to modify it if I
still don't describe it correctly).

In get_more_blocks, we use dio_count to calculate fs_count to let the
file system map(maybe also create) blocks. And some tricky things are
done to increase fs_count if dio_count isn't aligned.

But actually it still has some cornor case that can't be coverd. See the
following example:
./dio_write foo -s 1024 -w 4096(direct write 4096 bytes at offset 1024).

In this case, the old calculation counts fs_count to be 1, but actually
we will write into 2 different blocks(if fs_blocksize=4096). So the
underlying file system is called twice and leads to some performance
overhead. So fix it by calculating fs_count correctly and let the file
system knows what we really want to write.

Thanks
Tao

> 
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> 
> Cheers,
> Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

