Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2EAShm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:37:42 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:56235 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab2EAShl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:37:41 -0400
X-ASG-Debug-ID: 1335897460-03d6a52572cb550002-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FA02D71.3060001@fusionio.com>
Date: Tue, 1 May 2012 20:37:37 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be initialized
 to one
References: <1335873936.16988.148.camel@lappy> <20120501161729.GV26595@google.com> <4FA0253F.4000302@fusionio.com> <20120501180906.GX26595@google.com> <4FA028EE.7020208@fusionio.com> <x49wr4vlpn8.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be initialized
 to one
In-Reply-To: <x49wr4vlpn8.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1335897460
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0042 1.0000 -1.9933
X-Barracuda-Spam-Score: -1.99
X-Barracuda-Spam-Status: No, SCORE=-1.99 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.95710
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-01 20:31, Jeff Moyer wrote:
> Jens Axboe <jaxboe@fusionio.com> writes:
> 
>> On 2012-05-01 20:09, Tejun Heo wrote:
>>> On Tue, May 01, 2012 at 08:02:39PM +0200, Jens Axboe wrote:
>>>> On 2012-05-01 18:17, Tejun Heo wrote:
>>>>> create_task_io_context() left ioc->nr_tasks at zero; however, a newly
>>>>> created ioc should have its nr_tasks initialized to one as it begins
>>>>> attached to the task creating it.
>>>>>
>>>>> This affects only CLONE_IO which currently doesn't seem to have any
>>>>> actual user.  Sasha triggered WARN_ON_ONCE() in ioc_task_link() using
>>>>> syscall fuzzer.  Even when it happens, the failure mode isn't critical
>>>>> (blk-cgroup may allow attaching a CLONE_IO'd task to a cgroup when it
>>>>> shouldn't and blkcg limits may behave weirdly).
>>>>
>>>> CLONE_IO is an exported interface, it can be set from clone(2).
>>>> Otherwise Sasha would not have hit this :-)
>>>
>>> Yeah, but with pthread not exposing it, I'm very skeptical how much,
>>> if any, use it's getting.  With its incompatibility with blk-cgroup
>>> and cfq being able to merge coop request streams, I'm not sure how
>>> much we need it.  Maybe we can just make it noop?
>>
>> It's a lot more robust and specific than hoping to get coop merging. For
>> cfq, it also implies that multiple threads sharing an io context should
>> be accounted as one.
>>
>> But as to actual users, I really don't know. I agree it's probably not
>> that widely used. If google still had that code search, we could get a
>> better idea :-)
> 
> I know of one project: the venerable dump/restore utility uses CLONE_IO.

Thanks Jeff, now I remember the specifics of what we tested. IIRC, we
also did numbers back then comparing the coop merging vs specifically
using CLONE_IO.

-- 
Jens Axboe

