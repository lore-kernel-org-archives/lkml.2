Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1BMQpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 11:45:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab1BMQpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 11:45:06 -0500
Message-ID: <4D580A8B.5050508@redhat.com>
Date: Sun, 13 Feb 2011 17:44:59 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] loop: clear read-only flag in loop_clr_fd.
References: <4D573BBB.6090200@redhat.com> <1297594735-5593-1-git-send-email-tm@tao.ma> <4D57E67E.1030707@redhat.com> <4D57F357.6060708@tao.ma>
In-Reply-To: <4D57F357.6060708@tao.ma>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2011 04:05 PM, Tao Ma wrote:
> On 02/13/2011 10:11 PM, Milan Broz wrote:
>> On 02/13/2011 11:58 AM, Tao Ma wrote:
>>    
>>> From: Tao Ma<boyu.mt@taobao.com>
>>>
>>> In 75f1dc0, we check bdev_read_only() from blkdev_get().
>>> But the loop_clr_fd doesn't clear the read only flag.
>>> What cause a error if we changing a loop device from
>>> read only to writable.
>>>      
>> No, sorry, this is not proper/complete fix. It fixes it for loop
>> (and even not completely - you are missing some error
>> paths and ignoring autoclear mode where you have bdev NULL.)
>> (And yes, I tried the same as workaround.)
>>    
> aha, sorry, I don't know you are more familiar with loop than me. ;)
> I just did a quick test and sent the patch. So could you please tell me
> a little more about how we use autoclear mode?

When the autoclear flag is set, the loop device is deallocated with
the last close. So you can mount device over loop and after umount
the loop is automatically cleared (no need for losetup -d).
(I think this flag was not exported to losetup yet, so you need to use
ioctl flag yourself.)

> I will try to update my patch with a V2 when I get familiar with the whole stuff.

I would like Tejun tell us what the intention was here.
There are some paths which are not so clear (this one in loop device is easy),
so that code need to be audited.

> Actually I don't think it is Tejun's patch that causes the bug.

It is quite possible. But it worked before and this patch did not
fix these problems, so it is regression.

> Say loop, it sets ro when it get read  only flags, but doesn't clear it when it is detached.

You can very easily create another bug here if you set device read-write
too early (while udev is still processing change/remove events).

Milan
