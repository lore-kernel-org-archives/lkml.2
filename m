Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab1AEHLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 02:11:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57497 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab1AEHLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 02:11:37 -0500
Message-ID: <4D2419C0.9010102@cn.fujitsu.com>
Date: Wed, 05 Jan 2011 15:12:00 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][RT][PATCH 4/4] rtmutex: Ensure only the top waiter or higher
 priority task can take the lock
References: <20101223224755.078983538@goodmis.org>	 <20101223225117.180036615@goodmis.org> <1294113773.3948.203.camel@gandalf.stny.rr.com>
In-Reply-To: <1294113773.3948.203.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 15:11:17,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 15:11:17,
	Serialize complete at 2011-01-05 15:11:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 12:02 PM, Steven Rostedt wrote:
> On Thu, 2010-12-23 at 17:47 -0500, Steven Rostedt wrote:
>> plain text document attachment
>> (0004-rtmutex-Ensure-only-the-top-waiter-or-higher-priorit.patch)
>> From: Lai Jiangshan <laijs@cn.fujitsu.com>
>>
>> In current rtmutex, the pending owner may be boosted by the tasks
>> in the rtmutex's waitlist when the pending owner is deboosted
>> or a task in the waitlist is boosted. This boosting is unrelated,
>> because the pending owner does not really take the rtmutex.
>> It is not reasonable.
>>
> 
> I'm still hitting some bugs with the port to -rt, but I also noticed
> something that doesn't look too good.
> 
> There's several places in the kernel where a task may release and
> acquire the same lock multiple times in a row.
> 
> The old way of removing the pending owner from the lists and waking it
> up once, would have the high prio task wake it up once, and then it can
> grab the locks multiple times without modifying the list, since the
> pending owner is already awake and not in the pi list anymore.
> 
> The new way has the owner remove the woken task from its pi list and
> wakes it up, but when it steals the lock again, it adds this owner back
> to its pi list. When it releases the lock, it wakes it up again and
> removes it from its pi list again. This happens over and over again.

It is a expected behavior.  With this behavior: we can assume that
if a lock has waiter(s), the top waiter is always on the owner's pi list
and the owner gets/(will get) boosted from it.

This simplifies the code and the logic. But performance is more important,
I will send 2 patches for it in this weekend.

Thanks,
Lai.
