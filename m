Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab1CaQNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:13:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757757Ab1CaQNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:13:44 -0400
Date: Thu, 31 Mar 2011 12:13:26 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
Message-ID: <20110331161325.GA2327@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>
References: <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com>
 <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
 <20110331035511.GA1255@redhat.com>
 <AANLkTikP5edK=YSRx7zuNqyfwez8qEHpFumYun6GOPxu@mail.gmail.com>
 <20110331145850.GA10163@redhat.com>
 <20110331150344.GB10163@redhat.com>
 <AANLkTimAGbzYe7PNG1xhjsA12zErpRasTso711cq8UHq@mail.gmail.com>
 <20110331154941.GA32045@redhat.com>
 <AANLkTik=WBy7CRQSENiiRfi2BFtwL5iT9d3RBK4uZz1d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik=WBy7CRQSENiiRfi2BFtwL5iT9d3RBK4uZz1d@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 08:58:14AM -0700, Linus Torvalds wrote:
 > On Thu, Mar 31, 2011 at 8:49 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > That's a recent change though, and I first saw this back in November.
 > 
 > So your November report said that you could see "thousands" of these a
 > second. But maybe it didn't use up all CPU until recently?

>From memory, I noticed it back then in the same way "hey, why is the laptop getting hot". 

 > Especially if you have a high CONFIG_HZ value, you'd still see a
 > thousand flushes a second even with the old "delay a bit". So it would
 > use a fair amount of CPU, and certainly waste a lot of power. But it
 > wouldn't pin the CPU entirely.

HZ=1000 here, so yeah that makes sense. 

 > With that commit f23eb2b2b285, the buggy case would become basically
 > totally CPU-bound.
 > 
 > I dunno. Right now 'trinity' just ends up printing out a lot of system
 > call errors for me. I assume that's its normal behavior?

yep. it's throwing semi-random junk and seeing what sticks.
99% of the time, it ends up with an -EINVAL or something providing
the syscalls have sufficient checks in place.  We're pretty solid there
these days. (Though I still need to finish adding more annotations of some
of the syscall arguments just to be sure we're passing semi-sane things
to get deeper into the syscalls)

What still seems to throw a curve-ball though is the case where calling
a syscall generates some state. Due to the random nature of the program,
we never have a balanced alloc/free, so lists can grow quite large etc.
I'm wondering if something has created a livelock situation, where some queue
has grown to the point that we're generating new work before we can
process the backlog.

The downside of using randomness of course is with bugs like this, there's
no easy way to figure out wtf happened to get it into this state
other than poring over huge logfiles of all the syscalls that were made.


I'm happily ignorant of most of the inner workings of the tty layer.
I don't see anything useful in procfs/sysfs/debugfs. Is there anything
useful I can do with the trace tools to try and find out things like
the length of queues ?

	Dave

