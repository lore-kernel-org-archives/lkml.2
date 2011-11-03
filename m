Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393Ab1KCSfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 14:35:34 -0400
Received: from mx2.parallels.com ([64.131.90.16]:58878 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933865Ab1KCSfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 14:35:32 -0400
Message-ID: <4EB2DED1.3060602@parallels.com>
Date: Thu, 3 Nov 2011 16:34:57 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Max Kellermann <mk@cm4all.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Tim Hockin <thockin@hockin.org>,
        <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] new cgroup controller "fork"
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag> <20111103164302.GE8198@somewhere.redhat.com> <20111103171645.GA27887@rabbit.intern.cm-ag> <4EB2CEB2.7050800@parallels.com> <20111103174809.GA28108@rabbit.intern.cm-ag> <4EB2D451.4010607@parallels.com> <20111103183018.GA28318@rabbit.intern.cm-ag>
In-Reply-To: <20111103183018.GA28318@rabbit.intern.cm-ag>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2011 04:30 PM, Max Kellermann wrote:
> On 2011/11/03 18:50, Glauber Costa<glommer@parallels.com>  wrote:
>> That still seems to be up to admin. If no processes are removed from
>> the cgroup or included in the cgroup, the only action/verb the
>> counter
>> is concerned about is to fork. Under this circumstance, both seem
>> equivalent from my PoV.
>
> I'm confused.  One of us misunderstands the whole thing.
>
> Examples of both controllers:
>
> task_counter: task.limit=2.  Let's say the only process in that group
> forks, then you have two processes.  Forking is disallowed from now
> on.  The child process exits, and there's only one left - which is
> allowed to fork!  The group may bounce between 0 and 2 processes
> forever.

Ah, I see. I assumed you were decrementing the counter when a process 
exited.

> cgroup_fork: fork.remaining=2.  Now let's say we have one thousand
> processes in that group!  One of those forks (allowed).  And it forks
> again (allowed).  And tries again - blocked because "fork.remaining"
> has reached zero.  We have 1002 processes; when 1001 of those
> processes exit, one remains, but it is still disallowed to fork,
> because "fork.remaining" is still zero.  It will remaing zero until
> somebody with write permissions raises it again.
>
> Did I get it wrong?  To me, that is not look equivalent at all.
No, I was not careful enough when reading the patch, and as already 
stated, I made an assumption that seemed reasonable.

Which raises the question: If you don't decrement on exit, and only 
count how many forks happened in the past, what is your use case for this?

Please note that both of you seem to target the same goal: prevent fork 
bombs. If a child exits, I see no reason to not open up room for a new 
process inside the group.
