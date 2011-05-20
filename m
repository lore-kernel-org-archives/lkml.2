Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880Ab1ETNeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:34:36 -0400
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:61421 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab1ETNef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:34:35 -0400
X-AuditID: c1b4fb3d-b7c17ae00000262e-36-4dd66dea2c29
From: Bertil Engelholm <bertil.engelholm@ericsson.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 20 May 2011 15:34:33 +0200
Subject: PROBLEM: zone_reclaim is hanging high priority real time user
 pthreads
Thread-Topic: PROBLEM: zone_reclaim is hanging high priority real time user
 pthreads
Thread-Index: AcwW6+x7V9oOyumnStmBILDD2XpyRgAAcezg
Message-ID: <980E20D8E719A84BBF593FDE6AEC23DA0AEB3CFAA7@ESESSCMS0351.eemea.ericsson.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I have been investigating a problem for several weeks now and at last I 
beleave I'm on to something. So now I'm hoping that someone has the time to 
help me answer some questions.
The problem has been seen in kernel 2.6.16 and I now wonder if this is solved
in later kernels. I have looked in the 2.6.39 source code and there was a 
comment in that code indicating that this could still be a problem even though
it's not as serious as in 2.6.16.

The actual problem I have seen in 2.6.16 is that the zone_reclaim function can
execute on several CPU's in parallell in a multi core system. There is a check
for the reclaim_in_progress counter in zone_reclaim but it takes some time
until this counter is increased in shrink_zone so if several CPU's start
executing zone_reclaim at the same time they will continue executing
shrink_zone etc. in parallell. With a test program we have seen up to 4 CPU's
do this in parallell. I have seen two CPU's execute zone_reclaim in parallell 
in a panic dump that I triggered using sysrq-trigger when our pthread was 
"hanging". However, this is not a problem functionally wise, it looks like 
they all do what they are supposed to do. 

The problem is that the execution time goes up quite a lot when several CPU's
execute zone_reclaim. Most likely I guess because they will compete for the
same locks etc. Since this is executed in the "context" of any user
process/pthread it can "hang" this process/pthread for several seconds while
other pthreads etc. continue to execute as normal. 
If you have enough allocated memory e.g. 40GB, we have seen hangings for 16 
seconds. And this is even though the pthread is a high priority real time 
scheduled pthread that is suppose to execute every 10 ms (testprogram). Even 
if you get rid of the parallell execution, I suppose zone_reclaim can still 
hang a user pthread for some time if you have many active pages and this is 
what I wonder if it's still valid.

In later versions of vmscan.c I can see that a lot has changed regarding this
code but in shrink_zone in 2.6.39 this comment can be found :

/*
* On large memory systems, scan >> priority can become
* really large. This is fine for the starting priority;
* we want to put equal scanning pressure on each zone.
* However, if the VM has a harder time of freeing pages,
* with multiple processes reclaiming pages, the total
* freeing target can get unreasonably large.
*/

This indicates to me that the execution time for shrink_zone can still be
relativly long if you have a lot of pages. 

So the question is : Can todays kernel also "hang" high priority user pthreads
due to zone_reclaim if you have a large system with lots of allocated memory ? 
I.e. is this function still executed in a user pthread context risking to
hang it for some time ? 
If this has changed so it's executed in another way (background thread or
some other way), when was this changed (which kernel version) ? 

OK, that's it. I hope I have managed to make myself understandable.
As I started I have spent several weeks on this and I just want to make
shure that if we recommend a new kernel version to our users that the
problem is actually solved in that version. I have searched the internet
for many hours for this problem but not been able to find anything that
looks like this specific problem. The reason we have such a problem is 
because the pthreads that are hanging is important supervision pthreads
(that's why they are high priority real time pthreads) so they must execute
at certain intervals otherwise other pthreads will think something is wrong
and trigger recovery actions. 

Since I'm not subscribing to this mailing list I would appreciate if you 
could CC me any response.

thanx
/Bertil
