Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1A3N50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 08:57:26 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:44063 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752287Ab1A3N5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 08:57:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=0Lxqd4HjiDsb0BsytPldiWLDslDyhh8leI9+UUuGdLu8+Ux9nsBLz8AyQuG5cG11kDAV76GzyFcaT4Je+YhlfgWoc9JezxlW4JVwc2BxTFBCtsZ0UfgTantR1xfjOTix;
Message-ID: <4D456E3E.1020800@tao.ma>
Date: Sun, 30 Jan 2011 21:57:18 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mlock: revert the optimization for dirtying pages and
 triggering writeback.
References: <1296371720-4176-1-git-send-email-tm@tao.ma> <AANLkTik1dt1Q9TA+JmdvkuOqmt5LB2iZ1X2B5GbBFx1+@mail.gmail.com>
In-Reply-To: <AANLkTik1dt1Q9TA+JmdvkuOqmt5LB2iZ1X2B5GbBFx1+@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.245.231.188 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2011 06:26 PM, Michel Lespinasse wrote:
> On Sat, Jan 29, 2011 at 11:15 PM, Tao Ma<tm@tao.ma>  wrote:
>>         buf = mmap(NULL, file_len, PROT_WRITE, MAP_SHARED, fd, 0);
>>         if (buf == MAP_FAILED) {
>>                 perror("mmap");
>>                 goto out;
>>         }
>>
>>         if (mlock(buf, file_len)<  0) {
>>                 perror("mlock");
>>                 goto out;
>>         }
> Thanks Tao for tracing this to an individual change. I can reproduce
> this on my system. The issue is that the file is mapped without the
> PROT_READ permission, so mlock can't fault in the pages. Up to 2.6.37
> this worked because mlock was using a write.
>
> The test case does show there was a behavior change; however it's not
> clear to me that the tested behavior is valid.
>
> I can see two possible resolutions:
>
> 1- do nothing, if we can agree that the test case is invalid
The test case does exist in the real world and used widespread. ;)
It is blktrace. 
git://git.kernel.org/pub/scm/linux/kernel/git/axboe/blktrace.git
I can paste codes here also.
In blktrace.c setup_mmap:
mip->fs_buf = my_mmap(NULL, mip->fs_buf_len, PROT_WRITE,
                                       MAP_SHARED, fd,
                                       mip->fs_size - mip->fs_off);
> 2- restore the previous behavior for writable, non-readable, shared
> mappings while preserving the optimization for read/write shared
> mappings. The test would then look like:
>          if ((vma->vm_flags&  VM_WRITE)&&  (vma->vm_flags&  (VM_READ |
> VM_SHARED)) != VM_SHARED)
>                  gup_flags |= FOLL_WRITE;
I am not sure whether it is proper or not. I guess a fat comment is 
needed here
to explain the corner case. So do you have some statistics that your change
improve the performance a lot? If yes, I agree with you. Otherwise, I would
prefer to revert it back to the original design.

Regards,
Tao
