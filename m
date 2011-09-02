Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1IBRJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:09:09 -0400
Received: from ixia-3.edge2.lax012.pnap.net ([74.217.148.5]:4459 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753628Ab1IBRJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:09:05 -0400
Message-ID: <4E610DAE.4080607@ixiacom.com>
Date: Fri, 2 Sep 2011 10:09:02 -0700
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.1) Gecko/20110830 Thunderbird/6.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH 1/1 v2]: coredump: use current->group_leader->comm instead
 of current->comm
References: <4E5FBA73.2050108@ixiacom.com> <20110901195554.667c5e58@lxorguk.ukuu.org.uk> <4E5FD937.7050307@ixiacom.com> <20110902163037.GA4808@redhat.com>
In-Reply-To: <20110902163037.GA4808@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg,

>> The patterns %n or %N are the same as %e and %E except that they
>> use current->group_leader->comm instead of current->comm.
> 
> I simply do not know what is better. Alan has a point imho, "might
> break stuff" is true.
> 
> OTOH, %p always reports tgid, not tid...

Which speaks partly to my notion of "consistency".

> But in fact I do not understand the "Using current->group_leader->comm
> makes the name of the core file more consistent" part. Why ?

Internals aside, "%e" is advertised, rightly or wrongly as:

http://lxr.linux.no/#linux+v3.0.4/Documentation/sysctl/kernel.txt

        %e      executable filename (may be shortened)

Using current->comm has the following issues with respect to
the documentation :

Issue 1. The executable filename has the attribute that it is
         the same for all threads in one process, while current->comm
         does not.

Issue 2. Even for the group leader current->comm is not guaranteed to
         be the executable filename at all (the new %E yields that).

I viewed my original change as more "consistent" because it
yielded the attribute alluded to in the documentation --- the
same value for all threads in the one process:

	- Consistent with the documentation
	- Consistent with respect to process name (as opposed to thread name)

>> A core dump can be triggered from any task in a group,
> 
> Indeed. The important case is the private/synchronous signals like
> SIGSEGV, you can see the name of the thread which triggered the crash.

While that is true, it doesn't seem to have been the original intent as
per the %e documentation.

> Imho, this is overkill. This is only used if get_mm_exe_file() fails,
> I don't think this deserves another option. And may be we can use
> group_leader->comm, this is per-process thing anyway.
> 
> But I won't insist, I agree either way.



Fundamentally, which do you consider "broken" ?

	o fs/exec.c using current->comm for %e
		or
	o Documentation/sysctl/kernel.txt


I suspect we'll fall on the side of keeping "broken behaviour" since
it affects existing code, and instead fix the documentation.


Should get_mm_exe_file() just use current->group_leader->comm since it's
meant to be process specific anyway, and there isn't an existing code base
for %E ?


Evidently I need to patch Documentation/sysctl/kernel.txt too.


Earl
