Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082Ab1CYKLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:11:45 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:51751 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470Ab1CYKLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:11:44 -0400
X-ASG-Debug-ID: 1301047903-03d6a577be015f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8C6A5C.3090904@fusionio.com>
Date: Fri, 25 Mar 2011 11:11:40 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
References: <20110324193441.GA1723@gentoo.trippels.de> <4D8B9D2F.4010504@fusionio.com> <20110324194546.GA1741@gentoo.trippels.de> <4D8BA235.7060904@fusionio.com> <20110324200613.GA1724@gentoo.trippels.de> <4D8BB114.2070002@fusionio.com> <20110324214150.GA1739@gentoo.trippels.de> <4D8C4304.3050101@fusionio.com> <20110325083757.GA1754@gentoo.trippels.de> <4D8C55D9.1060903@fusionio.com> <20110325095704.GA1694@gentoo.trippels.de>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-Reply-To: <20110325095704.GA1694@gentoo.trippels.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301047903
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58915
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-25 10:57, Markus Trippelsdorf wrote:
> On 2011.03.25 at 09:44 +0100, Jens Axboe wrote:
>> On 2011-03-25 09:37, Markus Trippelsdorf wrote:
>>> On 2011.03.25 at 08:23 +0100, Jens Axboe wrote:
>>>> On 2011-03-24 22:41, Markus Trippelsdorf wrote:
>>>>> On 2011.03.24 at 22:01 +0100, Jens Axboe wrote:
>>>>>> On 2011-03-24 21:06, Markus Trippelsdorf wrote:
>>>>>>> On 2011.03.24 at 20:57 +0100, Jens Axboe wrote:
>>>>>>>>
>>>>>>>> OK, still a data point. What was the last -git kernel you used?
>>>>>>>
>>>>>>> This one was the last and gave me no problems:
>>>>>>>
>>>>>>> commit b81a618dcd3ea99de292dbe624f41ca68f464376
>>>>>>> Merge: 2f284c8 a9712bc
>>>>>>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>>>>>>> Date:   Wed Mar 23 20:51:42 2011 -0700
>>>>>>>
>>>>>>>     Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6
>>>>>>
>>>>>> Puzzling... Poking at straws here so far. Does this make any difference
>>>>>> whatsoever?
>>>>>
>>>>> I will test your patch later.
>>>>>
>>>>> Git-bisect gave me this result thus far:
>>>>>
>>>>> 9026e521c0da0731eb31f9f9022dd00cc3cd8885 is bad
>>>>> 82f04ab47e1d94d78503591a7460b2cad9601ede is good
>>>>>
>>>>> When I continue the bisection with 4345caba340f051e10847924fc078ae18ed6695c
>>>>> the system will start normally, but it then silently corrupts my xfs
>>>>> partitions. And on next (re)boot I get this (only fixable with
>>>>> xfs_repair):
>>>>>
>>>> How confident are you in those bisection results? Not trying to put you
>>>> on the spot, just wondering whether you tested and it's completely
>>>> consistent, or whether it was a one-off.
>>>
>>> Just double checked and 82f04ab47e1d94d78503591a7460b2cad9601ede is also
>>> bad. It just silently corrupts the file system (without a BUG) and I
>>> didn't notice.
>>> So back to square one. 
>>>
>>> How can I tell git-bisect just to try the commits in the block merge and
>>> not to take wild swings in history?
>>
>> Something like:
>>
>> $ git bisect start
>> $ git bisect good 3dab04e6978e358ad2307bca563fabd6c5d2c58b
>> $ git bisect bad 6c5103890057b1bb781b26b7aae38d33e4c517d8
> 
> Ok this time I've found the commit:
> 
> 9b6096a65f99a89dfd8328c4e469e7b53b3ae04a is the first bad commit
> commit 9b6096a65f99a89dfd8328c4e469e7b53b3ae04a
> Author: Shaohua Li <shaohua.li@intel.com>
> Date:   Thu Mar 17 10:47:06 2011 +0100
> 
>     mm: make generic_writepages() use plugging
>     
>     This recovers a performance regression caused by the removal
>     of the per-device plugging.
>     
>     Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> 
> Reverting it solves all problems here.

Great! I'll see if I can find out why. The patch itself should not cause
problems. I'm suspecting some interaction with nested plugging and the
auto-flush.

-- 
Jens Axboe

