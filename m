Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab1DUPFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:05:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab1DUPFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:05:31 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Michal Hocko <mhocko@suse.cz>, Jens Axboe <JAxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer  dereference at  0000000c IP: cfq_insert_request+0x1d/0x3f5
References: <20110420125824.GA3507@tiehlicka.suse.cz>
	<4DAEDBEB.7060904@fusionio.com>
	<20110420132903.GA13554@tiehlicka.suse.cz>
	<4DAF18DF.9080205@fusionio.com>
	<20110421071642.GA3556@tiehlicka.suse.cz>
	<5F35AAD2-8277-44BD-86B6-B1D7B816071E@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 21 Apr 2011 11:04:45 -0400
In-Reply-To: <5F35AAD2-8277-44BD-86B6-B1D7B816071E@kernel.dk> (Jens Axboe's
	message of "Thu, 21 Apr 2011 09:25:57 +0200")
Message-ID: <x49r58vprw2.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 21/04/2011, at 09.16, Michal Hocko <mhocko@suse.cz> wrote:
>
>> On Wed 20-04-11 19:33:19, Jens Axboe wrote:
>>> On 2011-04-20 15:29, Michal Hocko wrote:
>>>> On Wed 20-04-11 15:13:15, Jens Axboe wrote:
>>>>> On 2011-04-20 14:58, Michal Hocko wrote:
>> [...]
>>>>>> [   31.207888] Oops: 0000 [#1] PREEMPT [   31.208186] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/queue/scheduler
>>>>> 
>>>>> Ahh hang on, this may be a good clue. Does your boot scripts change the
>>>>> IO scheduler?
>>>> 
>>>> Good one...
>>>> Yes, I have:
>>>> echo deadline > /sys/block/sda/queue/scheduler
>>>> in /etc/rc.local
>>>> 
>>>> I am able to boot after I remove it. This is the first time I have seen
>>>> "last sysfs file" being useful.
>>>> Still want me to test the patch from the other email?
>>> 
>>> Is this a new addition to your system? IOW, how certain are you that
>>> this is a regression that occured between rc3 and rc4?
>> 
>> No, I am setting the scheduler this way for quite some time. If I use it
>> rc4 explodes while rc3 boots just fine. I am wondering, can this be a
>> timing issue? I am able to set the scheduler after system settles down
>> after boot and kde starts.
>> 
>> I am going to bisect, let's see if I can find anything.
>
> Thanks, that would be great!

OK, this is a long shot, but in a derivative kernel, I saw what may be
the same issue.  Is this kernel built with CONFIG_BLK_CGROUP=n by
chance?  The exact problem I saw was a panic on boot in
cfq_insert_request+0x77, which mapped to this:

/usr/src/debug/kernel-2.6.32-135.el6/linux-2.6.32-135.el6.x86_64/block/cfq-iosched.c:1997
ffffffff8125c390:       49 8b 84 24 a8 00 00    mov    0xa8(%r12),%rax
ffffffff8125c397:       00                          <---------------------
ffffffff8125c398:       83 80 ec 02 00 00 01    addl   $0x1,0x2ec(%rax)

cfq-iosched.c:1997 looks like this:

        (RQ_CFQG(rq))->dispatched++;

Enabling CONFIG_BLK_CGROUP made the problem go away.  Again, not sure
it's the same thing, but I figured I'd speak up in case it helps.

Cheers,
Jeff
