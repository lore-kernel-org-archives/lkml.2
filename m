Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab1JIJKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 05:10:21 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53078 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1JIJKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 05:10:20 -0400
MIME-Version: 1.0
In-Reply-To: <1318146066.2168.10.camel@handai-OptiPlex-780>
References: <1318146066.2168.10.camel@handai-OptiPlex-780>
Date: Sun, 9 Oct 2011 17:10:20 +0800
Message-ID: <CAFj3OHVh391k5p2aXKP4R6YGEfCmm5GMOTnAMSpvbnyYzrNUDg@mail.gmail.com>
Subject: Re: [Fwd: Re: cgroup umount bug]
From: handai handai <handai.szj@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: "Serge E. Hallyn" <serge@hallyn.com>
> To: º¬÷ì <handai.szj@taobao.com>
> Date: Sat, 8 Oct 2011 18:18:13 +0000
> Subject: Re: cgroup umount bug
> Quoting º¬÷ì (handai.szj@taobao.com):
>> Hi,
>>
>>     I found a mount/umount problem while using cgroup: I mount a cpu
>> cgroup (or other subsystems) and create some subgroups under it, but
>> later I try to umount it without rmdir those subgroups. I find that I
>> can umount it without any errors but actually the super block still
>> exist. This is because the sb->s_active count is greater than 1 which
>> was added by cgroup_create. But later if I want to mount both cpu and
>> memory subsystems, it will be unsuccessful indicating that the
>> device(cpu subsystem) is busy. This situation will not happen if I rmdir
>> the subgroups manually before umount it. So my question is:
>>     Should the umount return success when there are still some subgroups
>
> Yes.  The fs was unmounted from that directory.
>
>> exist ? If this is okay, then it may lead to some *strange* errors using
>> cgroup later. If it can not be umount, then it should inform that the
>> mount point is still busy.
>
>> Following is an example of this problem:
>>
>> mount -t cgroup -o cpu cgroup /mnt
>> mkdir /mnt/test
>>
>> .....// do some tests
>>
>> umount /mnt      /* return successfully */
>>
>> /* do other subsystems test */
>> mount -cgroup -o cpu,cpuset cgroup /mnt
>> mount: cgroup already mounted or /mnt busy  /*??? which is strange */
>
> I'm not sure from what you write whether you're aware of this, but
> to work around this, you can then
>
>  mount -t cgroup -o cpu /mnt
>  for i in `cat /mnt/test/tasks`; do
>  echo $i > /mnt/tasks
>  done
>  rmdir /mnt/test
>  umount /mnt
>
> and now you can
>
>  mount -cgroup -o cpu,cpuset cgroup /mnt
>

I know that I can bypass this problem by deleting subgroups before
unmount. But there is no document mentioning that I should do this to
avoid it. But even if there is, users may still directly umount it
accidentally, then he should try to remember what he has done and back
to the scene to make it up, or he may need to reboot his server to do
another test : ( .
So, since there is nothing good to permit incompletely unmount, why
not prevent the potential problem by prohibiting this behavior at
first ?

Best regards,
sha


> Being unable to umount /mnt while child cgroups exist or having all
> child cgroups cleared and removed automatically would both be less
> useful behaviors.
>
> thanks,
> -serge
>
>
