Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418Ab2K0KGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:06:17 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39799 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215Ab2K0KGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:06:14 -0500
MIME-Version: 1.0
In-Reply-To: <50B46E05.70906@kernel.dk>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
	<20121120180949.GG1408@quack.suse.cz>
	<CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com>
	<CAAJw_ZsAyB0z0TF1mqPz1Z+H+tg7W6LVzNLKf0BkuF3u8TTMuQ@mail.gmail.com>
	<CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com>
	<50AF7901.20401@kernel.dk>
	<CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com>
	<Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com>
	<CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
	<CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
	<50B46E05.70906@kernel.dk>
Date: Tue, 27 Nov 2012 18:06:13 +0800
Message-ID: <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
Subject: Re: Recent kernel "mount" slow
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 3:38 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-11-27 06:57, Jeff Chua wrote:
>> On Sun, Nov 25, 2012 at 7:23 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>>> On Sun, Nov 25, 2012 at 5:09 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>>>> So it's better to slow down mount.
>>>
>>> I am quite proud of the linux boot time pitting against other OS. Even
>>> with 10 partitions. Linux can boot up in just a few seconds, but now
>>> you're saying that we need to do this semaphore check at boot up. By
>>> doing so, it's inducing additional 4 seconds during boot up.
>>
>> By the way, I'm using a pretty fast SSD (Samsung PM830) and fast CPU
>> (2.8GHz). I wonder if those on slower hard disk or slower CPU, what
>> kind of degradation would this cause or just the same?
>
> It'd likely be the same slow down time wise, but as a percentage it
> would appear smaller on a slower disk.
>
> Could you please test Mikulas' suggestion of changing
> synchronize_sched() in include/linux/percpu-rwsem.h to
> synchronize_sched_expedited()?

Tested. It seems as fast as before, but may be a "tick" slower. Just
perception. I was getting pretty much 0.012s with everything reverted.
With synchronize_sched_expedited(), it seems to be 0.012s ~ 0.013s.
So, it's good.


> linux-next also has a re-write of the per-cpu rw sems, out of Andrews
> tree. It would be a good data point it you could test that, too.

Tested. It's slower. 0.350s. But still faster than 0.500s without the patch.

# time mount /dev/sda1 /mnt; sync; sync; umount /mnt


So, here's the comparison ...

0.500s     3.7.0-rc7
0.168s     3.7.0-rc2
0.012s     3.6.0
0.013s     3.7.0-rc7 + synchronize_sched_expedited()
0.350s     3.7.0-rc7 + Oleg's patch.


Thanks,
Jeff.
