Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1BSPAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 10:00:33 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:36539 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754233Ab1BSPAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 10:00:31 -0500
Date: Sat, 19 Feb 2011 17:00:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <dacohen@gmail.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>, balbi@ti.com,
        Thomas Weber <weber@corscience.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-omap@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Tejun Heo <tj@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] video: omap24xxcam: Fix compilation
Message-ID: <20110219150024.GA4487@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1297068547-10635-1-git-send-email-weber@corscience.de>
 <4D5A6353.7040907@maxwell.research.nokia.com>
 <20110215113717.GN2570@legolas.emea.dhcp.ti.com>
 <4D5A672A.7040000@samsung.com>
 <4D5A6874.1080705@corscience.de>
 <20110215115349.GQ2570@legolas.emea.dhcp.ti.com>
 <4D5A6EEC.5000908@maxwell.research.nokia.com>
 <AANLkTik+6fguqgH8Bpnpqo7Axmquy3caRMELTZVmuN1j@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik+6fguqgH8Bpnpqo7Axmquy3caRMELTZVmuN1j@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 19, 2011 at 01:35:09PM +0200, David Cohen wrote:
> >> aha, now I get it, so shouldn't the real fix be including <linux/sched.h>
> >> on <linux/wait.h>, I mean, it's <linuux/wait.h> who uses a symbol
> >> defined in <linux/sched.h>, right ?
> 
> That's a tricky situation. linux/sched.h includes indirectly
> linux/completion.h which includes linux/wait.h.

Ok, so the real problem is that there is circular dependency between
<linux/sched.h> and <linux/wait.h>

> By including sched.h in wait.h, the side effect is completion.h will
> then include a blank wait.h file and trigger a compilation error every
> time wait.h is included by any file.

true, but the real problem is the circular dependency between those
files.

> > Surprisingly many other files still don't seem to be affected. But this
> > is actually a better solution (to include sched.h in wait.h).
> 
> It does not affect all files include wait.h because TASK_* macros are
> used with #define statements only. So it has no effect unless some
> file tries to use a macro which used TASK_*. It seems the usual on
> kernel is to include both wait.h and sched.h when necessary.
> IMO your patch is fine.

I have to disagree. The fundamental problem is the circular dependency
between those two files:

sched.h uses wait_queue_head_t defined in wait.h
wait.h uses TASK_* defined in sched.h

So, IMO the real fix would be clear out the circular dependency. Maybe
introducing <linux/task.h> to define those TASK_* symbols and include
that on sched.h and wait.h

Just dig a quick and dirty to try it out and works like a charm

-- 
balbi
