Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab0ICVgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:36:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41544 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab0ICVgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:36:06 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C816A00.9030507@s5r6.in-berlin.de>
Date: Fri, 03 Sep 2010 23:34:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: bugzilla-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 17752] 2.6.36-rc3: inconsistent lock state (iprune_sem,
 shrink_icache_memory)
References: <bug-17752-4803@https.bugzilla.kernel.org/> <201009031907.o83J7tdw011454@demeter1.kernel.org>
In-Reply-To: <201009031907.o83J7tdw011454@demeter1.kernel.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=17752
> 
> 
> Maciej Rutecki <maciej.rutecki@gmail.com> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>              Blocks|                            |16444

This is probably not a regression.  See this earlier discussion:
http://lkml.org/lkml/2010/1/15/76

And another report, coincidentally at the same time:
http://lkml.org/lkml/2010/1/18/108

As I understand Christoph's post on January 19, several code paths are
independently affected:
http://lkml.org/lkml/2010/1/19/267
(Maybe some of those have been fixed in the meantime.)

I don't see in my trace from September 1 which filesystem caused the
particular lockdep report.  I may have unmounted ext4, vfat, or fuse prior to
that.

Dave wrote on September 2:
>> Any memory allocation that enters reclaim in the unmount path will
>> generate this warning. The problem is that the normal memory reclaim
>> path is:
>> 
>> 	alloc -> reclaim -> shrink_slab -> shrink_icache_memory -> iprune_sem -> s_umount
>> 
>> while unmmount does:
>> 
>> 	unmount -> s_umount -> alloc -> lockdep goes boom!
>> or
>> 	unmount -> iprune_sem -> alloc -> lockdep goes boom!
>> 
>> I never got a straight answer on this, but it the warnings are
>> indicating that you must use GFP_NOFS allocations for every
>> allocation in the unmount path, which is kind of hard to know
>> about given the code is not unomunt path specific....

Is it feasible to add a gfp_flag argument to all call chains that could lead
to allocations in unmount?
-- 
Stefan Richter
-=====-==-=- =--= ---==
http://arcgraph.de/sr/
