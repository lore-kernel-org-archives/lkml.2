Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab2BITYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 14:24:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60335 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138Ab2BITYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:24:36 -0500
Date: Thu, 9 Feb 2012 11:24:31 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [PATCH] block: strip out locking optimization in
 put_io_context()
Message-ID: <20120209192431.GF19392@google.com>
References: <20120207162253.GG21292@google.com>
 <4F315113.5010804@kernel.dk>
 <CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
 <20120207164735.GH21292@google.com>
 <CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
 <CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com>
 <20120208162925.GA19392@google.com>
 <CANejiEVuQRUY4Ovb2a1JNDZjRTeN_nft8LwY8AB144=9dkFq7A@mail.gmail.com>
 <20120209175948.GE19392@google.com>
 <CA+55aFzVmb_DfPPDyeON9X2KAii79g=NszPi+k9jrNLdQS7+4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzVmb_DfPPDyeON9X2KAii79g=NszPi+k9jrNLdQS7+4g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 10:07:35AM -0800, Linus Torvalds wrote:
> On Thu, Feb 9, 2012 at 9:59 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > * What exactly is the test and what do you measure?  What does "12%
> >  regression" mean?  Is it wallclock time or CPU time?  If it's CPU
> >  time, does systime increase dominate the regression?
> 
> Shaohua, it might be interesting to see a profile of the bad case.

Yeap, if CPUs are taking more time to do stuff, it would be helpful to
obtain before and after profiles.

> Now, quite often these kinds of things don't show anything at all -
> it's just due to cache issues and there's no obvious "we hold spinlock
> X for 15 seconds total". But if it's actual lock contention rather
> than just "more scheduling of worker threads", it should show up in
> the profile quite clearly.

Weird thing is that if it were wq, the rwlock patch should have
removed the regression.  It removed the reverse locking and the wq
deferring.  It does replace ioc locking with global readlock but it's
weird that that can show up as >10% regression (whatever the measure
may be).  Even though kernel compiling is pretty fork/exit
intensive....

> That said, I do think the RCU approach is the right one. The whole
> delayed deallocation (and the replacement patch with rwlocks) really
> smells like "badly done RCU-like behavior" to me.

I'll probably post it in several hours and think it's gonna be pretty
well contained.  I probably avoided RCU too hard in that path from the
original scary RCU usage.

Thanks.

-- 
tejun
