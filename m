Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1EKPmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:42:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58536 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1EKPmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:42:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NyWXtXDAfwFGeSy8eG6/sJ9yPiHCXBdU1rq8bn+8iAmaPgKeJpLCczBg40zG/Svffq
         tVNfV9ewun1EU4Lllu7zvnxky76Ob3SE/BMs+LRIoIgVJH/Z8kG+8eAYGvb65VJQOcey
         8zLoC4QwLN352o32t9D2wptEpFLHfbmpkgBLo=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=kkFrvVms7a0vC-pRK96aPr-MDBQ@mail.gmail.com>
References: <BANLkTinr34qmAE8RWVY0Wq_XMfOc0jTUzg@mail.gmail.com>
	<BANLkTi=4DNyWaqqjK5sG5O9cNdfpuAqHWA@mail.gmail.com>
	<BANLkTi=jZ-GA30_54kay3ouoNJvkwbVQ4w@mail.gmail.com>
	<Pine.LNX.4.64.1105100900170.4299@cobra.newdream.net>
	<BANLkTi=kkFrvVms7a0vC-pRK96aPr-MDBQ@mail.gmail.com>
Date: Wed, 11 May 2011 08:58:53 +0200
Message-ID: <BANLkTi=x+BEeGtpBe2reG4erNxyeZweAQA@mail.gmail.com>
Subject: Re: Kernel 2.6.38.6 page allocation failure (ixgbe)
From: Stefan Majer <stefan.majer@gmail.com>
To: Sage Weil <sage@newdream.net>
Cc: Yehuda Sadeh Weinraub <yehudasa@gmail.com>, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sage,

we were running rados bench like this:
# rados -p data bench 60 write -t 128
Maintaining 128 concurrent writes of 4194304 bytes for at least 60 seconds.
  sec Cur ops   started  finished  avg MB/s  cur MB/s  last lat   avg lat
    0       0         0         0         0         0         -         0
    1     128       296       168   671.847       672  0.051857  0.131839
    2     127       537       410   819.838       968  0.052679  0.115476
    3     128       772       644   858.516       936  0.043241  0.114372
    4     128       943       815   814.865       684  0.799326  0.121142
    5     128      1114       986   788.673       684  0.082748   0.13059
    6     128      1428      1300   866.526      1256  0.065376  0.119083
    7     127      1716      1589   907.859      1156  0.037958   0.11151
    8     127      1986      1859    929.36      1080  0.063171   0.11077
    9     128      2130      2002   889.645       572  0.048705  0.109477
   10     127      2333      2206   882.269       816  0.062555  0.115842
   11     127      2466      2339   850.419       532  0.051618  0.117356
   12     128      2602      2474   824.545       540   0.06113  0.124453
   13     128      2807      2679   824.187       820  0.075126  0.125108
   14     127      2897      2770   791.312       364  0.077479  0.125009
   15     127      2955      2828   754.023       232  0.084222  0.123814
   16     127      2973      2846   711.393        72  0.078568  0.123562
   17     127      2975      2848   670.011         8  0.923208  0.124123

as you can see, the transferrate drops suddenly down to 8 and even to 0.

Memory consumption during this is low:

top - 08:52:24 up 18:12,  1 user,  load average: 0.64, 3.35, 4.17
Tasks: 203 total,   1 running, 202 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  0.3%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:  24731008k total, 24550172k used,   180836k free,    79136k buffers
Swap:        0k total,        0k used,        0k free, 22574812k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
22203 root      20   0  581m 284m 2232 S  0.0  1.2   0:44.34 cosd
21922 root      20   0  577m 281m 2148 S  0.0  1.2   0:39.91 cosd
22788 root      20   0  576m 213m 2084 S  0.0  0.9   0:44.10 cosd
22476 root      20   0  509m 204m 2156 S  0.0  0.8   0:33.92 cosd

And after we hit this, ceph -w still reports clean state, all cosd are
still running.

We have no clue :-(

Greetings
Stefan Majer


On Tue, May 10, 2011 at 6:06 PM, Stefan Majer <stefan.majer@gmail.com> wrote:
> Hi Sage,
>
>
> On Tue, May 10, 2011 at 6:02 PM, Sage Weil <sage@newdream.net> wrote:
>> Hi Stefan,
>>
>> On Tue, 10 May 2011, Stefan Majer wrote:
>>> Hi,
>>>
>>> On Tue, May 10, 2011 at 4:20 PM, Yehuda Sadeh Weinraub
>>> <yehudasa@gmail.com> wrote:
>>> > On Tue, May 10, 2011 at 7:04 AM, Stefan Majer <stefan.majer@gmail.com> wrote:
>>> >> Hi,
>>> >>
>>> >> im running 4 nodes with ceph on top of btrfs with a dualport Intel
>>> >> X520 10Gb Ethernet Card with the latest 3.3.9 ixgbe driver.
>>> >> during benchmarks i get the following stack.
>>> >> I can easily reproduce this by simply running rados bench from a fast
>>> >> machine using this 4 nodes as ceph cluster.
>>> >> We saw this with stock ixgbe driver from 2.6.38.6 and with the latest
>>> >> 3.3.9 ixgbe.
>>> >> This kernel is tainted because we use fusion-io iodrives as journal
>>> >> devices for btrfs.
>>> >>
>>> >> Any hints to nail this down are welcome.
>>> >>
>>> >> Greetings Stefan Majer
>>> >>
>>> >> May 10 15:26:40 os02 kernel: [ 3652.485219] cosd: page allocation
>>> >> failure. order:2, mode:0x4020
>>> >
>>> > It looks like the machine running the cosd is crashing, is that the case?
>>>
>>> No the machine is still running. Even the cosd is still there.
>>
>> How much memory is (was?) cosd using?  Is it possible for you to watch RSS
>> under load when the errors trigger?
>
> I will look on this tomorrow
> just for the record:
> each machine has 24GB of RAM and 4 cosd with 1 btrfs formated disks
> each, which is a raid5 over 3 2TB spindles.
>
> The rados bench reaches a constant rate of about 1000Mb/sec !
>
> Greetings
>
> Stefan
>> The osd throttles incoming client bandwidth, but it doesn't throttle
>> inter-osd traffic yet because it's not obvious how to avoid deadlock.
>> It's possible that one node is getting significantly behind the
>> others on the replicated writes and that is blowing up its memory
>> footprint.  There are a few ways we can address that, but I'd like to make
>> sure we understand the problem first.
>>
>> Thanks!
>> sage
>>
>>
>>
>>> > Are you running both ceph kernel module on the same machine by any
>>> > chance? If not, it can be some other fs bug (e.g., the underlying
>>> > btrfs). Also, the stack here is quite deep, there's a chance for a
>>> > stack overflow.
>>>
>>> There is only the cosd running on these machines. We have 3 seperate
>>> mons and clients which uses qemu-rbd.
>>>
>>>
>>> > Thanks,
>>> > Yehuda
>>> >
>>>
>>>
>>> Greetings
>>> --
>>> Stefan Majer
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>
>
>
>
> --
> Stefan Majer
>



-- 
Stefan Majer
