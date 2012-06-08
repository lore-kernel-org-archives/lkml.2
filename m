Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab2FHHAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:00:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42134 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2FHHAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:00:09 -0400
Date: Thu, 7 Jun 2012 23:58:28 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        Pekka Enberg <penberg@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 2/5] vmevent: Convert from deferred timer to deferred work
Message-ID: <20120608065828.GA1515@lizard>
References: <20120601122118.GA6128@lizard>
 <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
 <4FD170AA.10705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FD170AA.10705@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 11:25:30PM -0400, KOSAKI Motohiro wrote:
[...]
> As I already told you, vmevent shouldn't deal a timer at all. It is
> NOT familiar to embedded world. Because of, time subsystem is one of
> most complex one on linux. Our 'time' is not simple concept. time.h
> says we have 5 possibilities user want, at least.
> 
> include/linux/time.h
> ------------------------------------------
> #define CLOCK_REALTIME			0
> #define CLOCK_MONOTONIC			1
> #define CLOCK_MONOTONIC_RAW		4
> #define CLOCK_REALTIME_COARSE		5
> #define CLOCK_MONOTONIC_COARSE		6
> 
> And, some people want to change timer slack for optimize power 
> consumption.
> 
> So, Don't reinventing the wheel. Just use posix tiemr apis.

I'm puzzled, why you mention posix timers in the context of the
in-kernel user? And none of the posix timers are deferrable.

The whole point of vmevent is to be lightweight and save power.
Vmevent is doing all the work in the kernel, and it uses
deferrable timers/workqueues to save power, and it is a proper
in-kernel API to do so.

If you're saying that we should set up a timer in the userland and
constantly read /proc/vmstat, then we will cause CPU wake up
every 100ms, which is not acceptable. Well, we can try to introduce
deferrable timers for the userspace. But then it would still add
a lot more overhead for our task, as this solution adds other two
context switches to read and parse /proc/vmstat. I guess this is
not a show-stopper though, so we can discuss this.

Leonid, Pekka, what do you think about the idea?

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
