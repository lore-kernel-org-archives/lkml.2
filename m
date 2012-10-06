Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2JFVsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 17:48:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59685 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2JFVsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 17:48:53 -0400
Date: Sat, 6 Oct 2012 14:48:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Kamran Amini <kamran.amini.eng@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: PROBLEM: It seems that /usr/bin/time program reports a wrong
 value for MaxRSS.
In-Reply-To: <CAKMH-Yhdxfq50fKR3TF8gc6i7JeAowD+Oc+dqpXOYvqiNiw=Vw@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1210061344180.28972@eggly.anvils>
References: <CAKMH-Yhdxfq50fKR3TF8gc6i7JeAowD+Oc+dqpXOYvqiNiw=Vw@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2012, Kamran Amini wrote:
> 
> It seems that /usr/bin/time program reports a wrong value for MaxRSS.
> The report shows MaxRSS, about 4 times the
> actual allocated memory by a process and its children. MaxRSS (Maximum
> Resident Set Size) is assumed to be maximum
> allocated memory by a process and its children. This bug report talks
> about this problem. More descriptions are provided in
> time-problem.tar.gz file attached to this mail.

You are right.

Well, time-problem.tar.gz goes into more detail than I had time
to read, so I cannot promise that everything you say is right.

But you're right that /usr/bin/time is reporting MaxRSS 4 times too much
on x86, and many other architectures.  It expects rusage.ru_maxrss to be
a count of pages, so mistakenly uses to ptok() upon it; whereas the Linux
kernel supplies that number already in kilobytes (as "man 2 getrusage"
makes clear).

I see this was mentioned when 2.6.32's commit 1f10206cf8e9 "getrusage:
fill ru_maxrss value" started putting the number there instead of zero: 
    
    Make ->ru_maxrss value in struct rusage filled accordingly to rss hiwater
    mark.  This struct is filled as a parameter to getrusage syscall.
    ->ru_maxrss value is set to KBs which is the way it is done in BSD
    systems.  /usr/bin/time (gnu time) application converts ->ru_maxrss to KBs
    which seems to be incorrect behavior.  Maintainer of this util was
    notified by me with the patch which corrects it and cc'ed.

It looks as if we were naive to expect a change in /usr/bin/time then:
so far as I can see, time has stood still at time-1.7 ever since 1996.
Its README does say:

    Mail suggestions and bug reports for GNU time to
    bug-gnu-utils@prep.ai.mit.edu.  Please include the version of
    `time', which you can get by running `time --version', and the
    operating system and C compiler you used.

Please do so, if you have a chance, or let me know if you cannot and
I'll do so: though I suspect the mail address is out-of-date by now,
and that it should say bug-gnu-utils@gnu.org.

You might also like to raise a bug with the distros you care about:
maybe some already apply their own fix, or will do before time-1.8.

But it does look as if you're the first in three years to notice and
care!  So don't be surprised if it's not a high priority for anyone.

And I don't think you need attach a .tar.gz: just explain in a few
lines that Linux 2.6.32 and later fill ru_maxrss, but in kilobytes
not pages: so /usr/bin/time displays 4 times the right number when
it multiplies that up with ptok().  (I don't have a BSD system to
confirm whether it's indeed wrong for BSD too.)

Thanks,
Hugh
