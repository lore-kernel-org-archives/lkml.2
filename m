Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab1CYMOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:14:43 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:33536 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab1CYMOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:14:41 -0400
X-ASG-Debug-ID: 1301055279-01de284cf8bae90001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8C872C.1030805@fusionio.com>
Date: Fri, 25 Mar 2011 13:14:36 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Theodore Tso <tytso@MIT.EDU>
CC: Dave Chinner <david@fromorbit.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
References: <4D8B4A89.80608@fusionio.com> <20110324183019.GA1676@gentoo.trippels.de> <4D8B8F34.5000203@fusionio.com> <4D8B92AE.8090308@fusionio.com> <20110324185445.GB1696@gentoo.trippels.de> <4D8B9457.2020608@fusionio.com> <20110324193441.GA1723@gentoo.trippels.de> <20110325044128.GJ26611@dastard> <91CCAB14-F9CC-4676-94C3-FBCDD0663FD5@mit.edu>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-Reply-To: <91CCAB14-F9CC-4676-94C3-FBCDD0663FD5@mit.edu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301055279
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58924
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-25 12:59, Theodore Tso wrote:
> 
> On Mar 25, 2011, at 12:41 AM, Dave Chinner wrote:
> 
>>>
>>> It works insofar as the Oops is gone. But my xfs partitions apparently
>>> still get corrupted (I had to run xfs_repair on several of them, because
>>> they would not mount otherwise).
>>
>> So the patchset is causing repeatable filesystem corruption? Sounds
>> to me like this series is not yet ready for mainline merging. Last
>> thing I want to spend the .39 cycle helping people recover busted
>> filesystems as a result of undercooked block layer changes...
> 
> FYI.   I did a trial merge last night of the ext4 changes last night with
> the tip of Linus's tree.   The ext4 changes (based on 2.6.38-rc5) 
> survived xfstests -g auto before I merged in Linus's 2.6.39 master
> branch.  After I merged with 2.6.39-tip, I reran xfstests, and it got 
> past test #13 (fsstress), which normally means that everything is
> OK, so I sent a pull request to Linus.    Much later, (-g auto takes a 
> long time) I got an OOPS inside the virtio driver.   Ext4 was nowhere 
> in the stack trace, but of course the block layer was.   Grumbling
> that someone  had broke virtio during the merge window, I switched
> my KVM setup to use SATA emulation and used the sda devices
> instead.  This time I got an oops in the block I/O layer, again quite
> late in xfstests.  Somewhere around test #224 or so if I remember
> correctly.
> 
> It was too late last night to do any more investigating, which is why
> I hadn't sent a formal report yet, but next up is for me to retry xfstests
> before merging in my changes, and then to start a git bisect.
> 
> So before accusing some patch series which hasn't been merged
> into 2.6.39 yet, you might want to also worry about some change
> that already has been merged.   Of course the symptoms for me are
> quite different.   I'm not seeing an early oops, but only something
> which shows up when the the system is put under a lot of stress
> by xfstests.  So it could be a different problem....
> 
> 								- Ted
> 
> P.S.  And of course there is the chance that there is some
> subtle bug in the ext4 branch, which worked just fine when
> it was just based on 2.6.38-rc5, but which only manifested
> itself when I merged in the tip of Linus's branch.   So I'm not
> __accusing__ the block layer yet, even though the stack traces
> seem to point that way, because I don't have a smoking gun
> yet.   But I do have to admit I'm suspicious....

But this plugging change is merged, so it is a very likely candidate.
With the oddness going on, I suspect that we end up flushing a plug that
resides on a stack that is no longer valid.

Is there a way to check whether a given pointer is valid on the current
stack for this process?

I think we can rule out stack overflows, since the plug context itself
is very small (28 bytes). But if we have something like:

blk_start_plug(&plug1);
        ...
        blk_start_plug(&plug2);
        ...
flush(&plug2);

then that could explain the corruption and lockups.

So I'd really like to have something ala:

        if (is_str_ptr_valid(current, ptr, size))
                ...

to aid the debugging.

-- 
Jens Axboe

