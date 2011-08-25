Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1HYKDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 06:03:39 -0400
Received: from mail1.vodafone.ie ([213.233.128.43]:51027 "EHLO
	mail1.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1HYKDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 06:03:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AowCAAEdVk5tTnqs/2dsb2JhbAAMNpwWjiIBAQQBMgFGBQsLDQEKCRYPCQMCAQIBDzYGDQEFAgEBh24EuySGTASYRIRMhwU
Message-ID: <4E561DF7.4020203@draigBrady.com>
Date: Thu, 25 Aug 2011 11:03:35 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Jovi Zhang <bookjovi@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        dhowells@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
References: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com> <4E527684.3020206@draigBrady.com> <20110822161914.GA9399@redhat.com> <CACV3sbJjDhzKq8YQEnrTQPVVw7YsZjLe45G5sWaMRBk3+Vxkcg@mail.gmail.com> <20110824110134.GA17362@hmsreliant.think-freely.org>
In-Reply-To: <20110824110134.GA17362@hmsreliant.think-freely.org>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 12:01 PM, Neil Horman wrote:
> On Wed, Aug 24, 2011 at 06:14:24PM +0800, Jovi Zhang wrote:
>> 2011/8/23 Oleg Nesterov <oleg@redhat.com>:
>>> On 08/22, Pádraig Brady wrote:
>>>>
>>>> On 08/21/2011 11:36 PM, Neil Horman wrote:
>>>>> Concur.  The comment should be changed
>>>>> Neil
>>>>>
>>>>> Oleg Nesterov <oleg@redhat.com> wrote:
>>>>>
>>>>>> On 08/21, Oleg Nesterov wrote:
>>>>>>>
>>>>>>> On 08/21, bookjovi@gmail.com wrote:
>>>>>>>>
>>>>>>>> For non-pipe case, limit 0 also means drop the coredump, so just put
>>>>>>>> the zero limit check at do_coredump function begining.
>>>>>>>
>>>>>>> Neil, what do you think? Should we change the code or the comment?
>>>>>>
>>>>>> Personally I think we should fix the comment. I think RLIMIT_CORE
>>>>>> doesn't apply in this case, limit == 1 check is very special. And
>>>>>> this is what linux always did, except between 725eae32 and 898b374a.
>>>>
>>>> Sorry for jumping in late here.
>>>> I would really like `ulimit -c 0` to completely disable core dumps,
>>>> including not running core_pattern, as I also mentioned here:
>>>> https://bugs.launchpad.net/ubuntu/+source/apport/+bug/62511
>>>> I noticed this in a script where ctrl-\ was taking a long
>>>> time to be registered as the core_pattern was run unconditionally.
>>>
>>> May be. As I said, I do not really know and personally I agree with
>>> everything. My only point was, this is not the bug, this is what we
>>> always did.
>>>
>>> This is up to Neil, I think.
>>>
>>> Oleg.
>>>
>>>
>> Well, so here have two questions.
>> 1) That comments "but a limit of 0 skips the dump" definitely is wrong
>> right now, it don't match with reality.
> Agreed, I think your patch fixes this correctly.
> 
>> 2) In ispipe case, core limit 0 should skip the dump or not? this need
>> more discussion.
>>    from pipe coredump point of view, core limit is irrelevant, it
>> doesn't write to file system.
>>    from user point of view, there will be a lot of core files if we
>> let core limit 0 create core file, user might be boring.
>>
> The case (ispipe==true && cprm.lmit==0) has to result in us dumping a core. I
> use to be convinced otherwise, but several user space developers changed my
> mind, particularly the guys writing the abrt daemon.  The reason being, the
> default process limit for RLIMIT_CORE is zero.  If you're writing a daemon like
> abrt that wants to catch program crashes, even during boot, there are tons of
> hoops you have to jump through to get core pipes enabled properly if you need to
> change RLIMIT_CORE.  Specifically you have to modify all existing processes
> RLIMIT_CORE values to be non-zero (a racy proposition) as well as modify the
> init processes RLIMIT_CORE value (so that it gets inherited by future
> processes).  Thats a pretty rickety thing to set up, and they really didn't want
> to have that much fiddling to do to get it all working, and I don't blame them.

I'm not convinced by that, but thanks for the info.

> The fact that you're setting up a core pipe in the first place, implies to user
> space that you want an executed notification of cores, and in that execution you
> have the ability to filter which cores you actually care about.  If you're
> worried about too many processes spawning or getting the cpu bogged with crash
> handling, we have the core_limit sysctl to keep us throttled.

For the archive, I think you're referring to core_pipe_limit which sets
the limit of the number of processes to wait for in parallel.

> The long and the short of it is, making RLIMIT_CORE == 0 for the ispipe case
> skip the core dump, breaks lots of user space expectations (which I know, is
> counter-intuitive), but changing it will open up a large can of worms, it works
> properly as it is.

OK. Retesting on my new laptop and latest abrt implementation,
shows that the response to SIGQUIT is much better (on the order of 20ms).
Still there is lots of redundant logic triggered by default
on most systems where abrt et. al. are used.

Drats I just noticed another problem with not being able to disable core dumps
for a process. The `timeout` command from coreutils now tries to propagate
the signal from the process it's monitoring up. But since core dumps
can't be disabled, abrt will attribute any crashes to `timeout` rather
than what it's monitoring. I'll guess we'll have to revert:
http://git.sv.gnu.org/gitweb/?p=coreutils.git;a=commitdiff;h=5a647a0

cheers,
Pádraig.
