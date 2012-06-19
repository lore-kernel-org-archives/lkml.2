Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2FSIpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:45:39 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54471 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab2FSIpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:45:36 -0400
MIME-Version: 1.0
In-Reply-To: <1339768999.2559.69.camel@twins>
References: <20120614132902.800827488@chello.nl> <20120614133212.810726968@chello.nl>
 <1339708758.2559.42.camel@twins> <1339768999.2559.69.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Tue, 19 Jun 2012 01:45:05 -0700
Message-ID: <CAPM31RLdfWkDrnceBWETracj=WquuZd31_LaxjR0xUQvBim+hw@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/4] sched/fair: Optimize cgroup pick_next_task_fair
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, venki@google.com, efault@gmx.de, rostedt@goodmis.org,
        glommer@parallels.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 7:03 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-06-14 at 23:19 +0200, Peter Zijlstra wrote:
>> On Thu, 2012-06-14 at 15:29 +0200, Peter Zijlstra wrote:
>> > Since commit 2f36825b1 ("sched: Next buddy hint on sleep and preempt
>> > path") it is likely we pick a new task from the same cgroup, doing a put
>> > and then set on all intermediate entities is a waste of time, so try to
>> > avoid this.
>>
>> I just noticed put_prev_entity() also does the bandwidth enforcement
>> stuff, I think I just broke that. Will have a peek at fixing that
>> tomorrow or so.
>
> Damn, that's annoying, that wants to be done bottom-up, while we're now
> doing a top-down selection. pjt any sane ideas?

I'll have a look at this tomorrow, but I think this is fairly
immediately resolvable -- I don't see any immediate reason we need to
do  full enforcement here.  The only interesting thing we really need
to do in the put_path is the voluntary return of quota, which -- if we
need to do it -- we will get to do since that occurs iff the entity is
no longe runnable and actually getting a put().
