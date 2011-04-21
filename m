Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1DUPad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:30:33 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:33690 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab1DUPac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:30:32 -0400
X-ASG-Debug-ID: 1303399827-01de284cf8177d20001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DB04D8F.2000708@fusionio.com>
Date: Thu, 21 Apr 2011 17:30:23 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer   dereference
 at  0000000c IP: cfq_insert_request+0x1d/0x3f5
References: <20110420125824.GA3507@tiehlicka.suse.cz>	<4DAEDBEB.7060904@fusionio.com>	<20110420132903.GA13554@tiehlicka.suse.cz>	<4DAF18DF.9080205@fusionio.com>	<20110421071642.GA3556@tiehlicka.suse.cz>	<5F35AAD2-8277-44BD-86B6-B1D7B816071E@kernel.dk> <x49r58vprw2.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer   dereference
 at  0000000c IP: cfq_insert_request+0x1d/0x3f5
In-Reply-To: <x49r58vprw2.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303399827
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.20
X-Barracuda-Spam-Status: No, SCORE=0.20 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=PR0N_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61512
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.20 PR0N_SUBJECT           Subject has letters around special characters (pr0n)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-21 17:04, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 21/04/2011, at 09.16, Michal Hocko <mhocko@suse.cz> wrote:
>>
>>> On Wed 20-04-11 19:33:19, Jens Axboe wrote:
>>>> On 2011-04-20 15:29, Michal Hocko wrote:
>>>>> On Wed 20-04-11 15:13:15, Jens Axboe wrote:
>>>>>> On 2011-04-20 14:58, Michal Hocko wrote:
>>> [...]
>>>>>>> [   31.207888] Oops: 0000 [#1] PREEMPT [   31.208186] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/queue/scheduler
>>>>>>
>>>>>> Ahh hang on, this may be a good clue. Does your boot scripts change the
>>>>>> IO scheduler?
>>>>>
>>>>> Good one...
>>>>> Yes, I have:
>>>>> echo deadline > /sys/block/sda/queue/scheduler
>>>>> in /etc/rc.local
>>>>>
>>>>> I am able to boot after I remove it. This is the first time I have seen
>>>>> "last sysfs file" being useful.
>>>>> Still want me to test the patch from the other email?
>>>>
>>>> Is this a new addition to your system? IOW, how certain are you that
>>>> this is a regression that occured between rc3 and rc4?
>>>
>>> No, I am setting the scheduler this way for quite some time. If I use it
>>> rc4 explodes while rc3 boots just fine. I am wondering, can this be a
>>> timing issue? I am able to set the scheduler after system settles down
>>> after boot and kde starts.
>>>
>>> I am going to bisect, let's see if I can find anything.
>>
>> Thanks, that would be great!
> 
> OK, this is a long shot, but in a derivative kernel, I saw what may be
> the same issue.  Is this kernel built with CONFIG_BLK_CGROUP=n by
> chance?  The exact problem I saw was a panic on boot in
> cfq_insert_request+0x77, which mapped to this:
> 
> /usr/src/debug/kernel-2.6.32-135.el6/linux-2.6.32-135.el6.x86_64/block/cfq-iosched.c:1997
> ffffffff8125c390:       49 8b 84 24 a8 00 00    mov    0xa8(%r12),%rax
> ffffffff8125c397:       00                          <---------------------
> ffffffff8125c398:       83 80 ec 02 00 00 01    addl   $0x1,0x2ec(%rax)
> 
> cfq-iosched.c:1997 looks like this:
> 
>         (RQ_CFQG(rq))->dispatched++;
> 
> Enabling CONFIG_BLK_CGROUP made the problem go away.  Again, not sure
> it's the same thing, but I figured I'd speak up in case it helps.

I think this is just the canary in this particular case, I bet it does
not work reliably in general after the addition of the SORT_MERGE
insert.

-- 
Jens Axboe

