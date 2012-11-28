Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab2K1PlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:41:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab2K1PlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:41:12 -0500
Date: Wed, 28 Nov 2012 10:42:42 -0500
From: Don Zickus <dzickus@redhat.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: akpm@linux-foundation.org, mingo@kernel.org, rjw@sisk.pl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] watchdog: optimizing the hrtimer interval for power
 saving
Message-ID: <20121128154242.GS14805@redhat.com>
References: <1353602906.15558.1695.camel@cliu38-desktop-build>
 <1354101892.15558.1699.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354101892.15558.1699.camel@cliu38-desktop-build>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 07:24:52PM +0800, Chuansheng Liu wrote:
> 
> By default, the watchdog threshold is 10, it means every 4s
> every CPU will receive one hrtimer interrupt, for low power
> device, it will cause 4-5mV power impact when device is deep
> sleep.
> 
> So here want to optimize it as below:
> 4s + 4s + 4s + 4s + 4s
> == >
> 1s + 9s + 9s ...
> Or
> 1s + 1s..+ 9s + 9s ....
> 
> For soft lockup detection, it will have more than 5 chances to
> hit, once one chance is successful, we will start 9s hrtimer
> instead of 1s;
> 
> For hard lockup dection, it will have more than 2 chances to hit,
> As Don said, the min window is 10s just when CPU is always running
> as MAX frequency. In most case, the window is 60s, so we should
> have much more than 2 chances.
> 
> With this patch, in most cases the hrtimer will be 9s instead
> of 4s averagely. It can save the device power indeed.
> 
> Change log:
> Since V1: In V1, Don pointed out, "12 seconds will miss the window
>           repeatedly." So here set the long period < min window 10s.

Hmm.  My only concern is if you are solving this the right way.  The
Chrome folks wanted this threshold to be smaller like 2 seconds, which
would defeat the whole point of this patch.

It seems like a better approach would be to adjust the timer somehow when
you change c-states.  The whole point of the hard and softlockup is to
detect if scheduled code is either deadlock or hogging the cpu for too long.

If the cpu is in a deep sleep, then nothing is running, right?  Which
means nothing can deadlock or hog the cpu.  In those cases you can
probably temporarily disable the lockup detector until the cpu wakes up
from that c-state and starts scheduling code again.

In that case you can really maximize your power savings (and probably get
powerTop to stop telling everyone to disable the nmi_watchdog :-) ).

Ideally in a deep sleep you don't want any soft interrupts running, no?

Just a thought.

Cheers,
Don
