Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab3AEJfy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 04:35:54 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:35609 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3AEJfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 04:35:51 -0500
MIME-Version: 1.0
In-Reply-To: <87wqvtl0we.fsf@devron.myhome.or.jp>
References: <2597526.usDRg4h3X1@mars> <201301011406.19983.Martin@lichtvoll.de>
 <1492866.3ugQ2fqrP0@mars> <201301011537.08466.Martin@lichtvoll.de>
 <alpine.LFD.2.03.1301021144280.10305@gmail.com> <87wqvtl0we.fsf@devron.myhome.or.jp>
From: Shentino <shentino@gmail.com>
Date: Sat, 5 Jan 2013 01:35:10 -0800
Message-ID: <CAGDaZ_p5F9S0kRkikOi4kG0SYLfRrSEN=hK0cFaje_s+Or=Ahg@mail.gmail.com>
Subject: Re: Tux3 report: New news for the new year
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Tero Roponen <tero.roponen@gmail.com>,
        Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Daniel Phillips <lkml@phunq.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Great to see you guys wroking on this.

I can almost taste tux3 on my desktop.

On Fri, Jan 4, 2013 at 2:04 AM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> Tero Roponen <tero.roponen@gmail.com> writes:
>
>>> martin@merkaba:~[…]> sudo ./tux3fuse tux3.img /mnt/zeit
>>> [sudo] password for martin:
>>>
>>> martin@merkaba:~[…]> mount | grep fuse
>>> fusectl on /sys/fs/fuse/connections type fusectl (rw,relatime)
>>> tux3.img on /mnt/zeit type fuse.tux3.img (rw,nosuid,nodev,relatime,user_id=0,group_id=0)
>>>
>>>
>>>
>>> But I am stuck with accessing it:
>>>
>>> martin@merkaba:~[…]> LANG=C ls -l /mnt/zeit
>>> ls: cannot access /mnt/zeit: Permission denied
>>>
>>> martin@merkaba:~[…]> LANG=C sudo chown martin:martin /mnt/zeit
>>> chown: cannot access '/mnt/zeit': Transport endpoint is not connected
>>> martin@merkaba:~[…]> LANG=C sudo ls -l /mnt/zeit
>>> ls: cannot access /mnt/zeit: Transport endpoint is not connected
>>> martin@merkaba:~[…]>
>>
>> Hi,
>>
>> I have not looked at Tux3 for a long time, but there seems to be
>> a simple fix for at least this problem, and two workarounds:
>>
>> 1) Run the program in foreground (-f):
>>
>>    sudo ./tux3fuse tux3.img /mnt/zeit -f
>>
>> 2) Use absolute path for image file:
>>
>>    sudo ./tux3fuse $(pwd)/tux3.img /mnt/zeit
>>
>> The following patch should hopefully fix this for good.
>
> Thanks for report, Martin. Thanks for fixing, Tero.
>
> Applied with free() for make valgrind happy to temp-atomic-commit branch
> (will be merged to master soon).
>
> Thanks!
>
>> commit efc0cf49f6dd00dfbb84e88336d2c5d147a09ed0
>> Author: Tero Roponen <tero.roponen@gmail.com>
>> Date:   Wed Jan 2 11:20:46 2013 +0200
>>
>>     Use absolute path for volume name
>>
>>     If fuse_daemonize() puts us into background it also switches our
>>     working directory to '/', breaking the use of relative paths.
>>
>>     This patch fixes the problem by converting the relative path to
>>     an absolute one.
>>
>>     Signed-off-by: Tero Roponen <tero.roponen@gmail.com>
>>
>> diff --git a/user/tux3fuse.c b/user/tux3fuse.c
>> index 6401204..5047cab 100644
>> --- a/user/tux3fuse.c
>> +++ b/user/tux3fuse.c
>> @@ -993,7 +993,7 @@ int main(int argc, char *argv[])
>>               goto error;
>>
>>       struct tux3fuse tux3fuse = {
>> -             .volname = argv[1],
>> +             .volname = canonicalize_file_name(argv[1]),
>>       };
>>       fs = fuse_lowlevel_new(&args, &tux3_ops, sizeof(tux3_ops), &tux3fuse);
>>       if (fs) {
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
