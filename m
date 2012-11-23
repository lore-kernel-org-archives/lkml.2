Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab2KWXsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 18:48:05 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38888 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab2KWXsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 18:48:02 -0500
MIME-Version: 1.0
In-Reply-To: <CAAJw_ZuYh=ZYLS7O+5rtBd1Qm-qh=dza3D9SD7M5LJ7t4j3hFw@mail.gmail.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
	<20121120180949.GG1408@quack.suse.cz>
	<CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com>
	<CAAJw_ZsAyB0z0TF1mqPz1Z+H+tg7W6LVzNLKf0BkuF3u8TTMuQ@mail.gmail.com>
	<CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com>
	<50AF7901.20401@kernel.dk>
	<CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com>
	<CAAJw_ZuYh=ZYLS7O+5rtBd1Qm-qh=dza3D9SD7M5LJ7t4j3hFw@mail.gmail.com>
Date: Sat, 24 Nov 2012 07:48:01 +0800
Message-ID: <CAAJw_Zucq2xiSpUpcoLyK9umuOu_7vYxP0+CyDj=3RieGF6ESA@mail.gmail.com>
Subject: Re: Recent kernel "mount" slow
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Mikulas Patocka <mpatocka@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 7:31 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Sat, Nov 24, 2012 at 6:21 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>> On Fri, Nov 23, 2012 at 9:24 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 2012-11-22 20:21, Linus Torvalds wrote:
>>>> Doesn't sound like a fsdevel issue since it seems to be independent of
>>>> filesystems. More like some generic block layer thing. Adding Jens
>>>> (and quoting the whole thing)
>>>>
>>>> Jens, any ideas? Most of your stuff came in after -rc2, which would
>>>> fit with the fact that most of the slowdown seems to be after -rc2
>>>> according to Jeff.
>>>
>>> No ideas. Looking at what went in from my side, only the rq plug sorting
>>> is a core change, and that should not cause any change in behaviour for
>>> a single device. That's commit 975927b9.
>>>
>>>> Jeff, more bisecting would be good, though.
>>>
>>> Probably required, yes...
>>
>>
>> This one slows mount from 0.012s to 0.168s.
>>
>> commit 62ac665ff9fc07497ca524bd20d6a96893d11071
>> Author: Mikulas Patocka <mpatocka@redhat.com>
>> Date:   Wed Sep 26 07:46:43 2012 +0200
>>
>>     blockdev: turn a rw semaphore into a percpu rw semaphore
>>
>>
>> There were couple of more changes to percpu-rw-semaphores after
>> 3.7.0-rc2 and those slows mount further from 0.168s to 0.500s. I don't
>> really know, but I'm suspecting these. Still bisecting.
>>
>> commit 5c1eabe68501d1e1b1586c7f4c46cc531828c4ab
>> Author: Mikulas Patocka <mpatocka@redhat.com>
>> Date:   Mon Oct 22 19:37:47 2012 -0400
>>
>>     percpu-rw-semaphores: use light/heavy barriers
>>
>>
>> commit 1bf11c53535ab87e3bf14ecdf6747bf46f601c5d
>> Author: Mikulas Patocka <mpatocka@redhat.com>
>> Date:   Mon Oct 22 19:39:16 2012 -0400
>>
>>     percpu-rw-semaphores: use rcu_read_lock_sched
>
>
> I reverted these 3 patches and mount time is now 0.012s.
>
> # time mount /dev/sda1 /mnt; sync; sync; umount /mnt
>
>
>> commit 1a25b1c4ce189e3926f2981f3302352a930086db
>> Author: Mikulas Patocka <mpatocka@redhat.com>
>> Date:   Mon Oct 15 17:20:17 2012 -0400
>>
>>     Lock splice_read and splice_write functions
>
> Looks like this one is not the problem. But I reverted it anyway
> because it's part of the same chunk.
>
>
> Happy Thanksgiving!

I'm on latest git 3.7.0-rc6 5e351cdc998db82935d1248a053a1be37d1160fd
and with the above patches reverted and mount time is now 0.012s.

Jeff
