Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0CQP7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:59:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40978 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab0CQP7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:59:38 -0400
Subject: Re: [PATCH] Timekeeping: Fix dead lock in update_wall_time by
 correct shift convertion.
From: john stultz <johnstul@us.ibm.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4e5ebad51003162214s3430aa39xde29a4ba9c1b7d8c@mail.gmail.com>
References: <1268735629.5075.8.camel@eight.analog.com>
	 <1268763512.1676.7.camel@work-vm>
	 <4e5ebad51003161958n6db293f0y6da99483bf96ada0@mail.gmail.com>
	 <1268797285.3130.90.camel@localhost.localdomain>
	 <4e5ebad51003162214s3430aa39xde29a4ba9c1b7d8c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 08:59:22 -0700
Message-ID: <1268841562.1996.16.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 13:14 +0800, Sonic Zhang wrote:
> With you new workaround, no dead loop. But are you sure this doesn't
> overflow the ntp_error after thousands of loops?
> 
>        timekeeper.ntp_error += tick_length << shift;
>        timekeeper.ntp_error -= timekeeper.xtime_interval <<
>                                (timekeeper.ntp_error_shift + shift);


At some point, yes it could overflow, but for that to happen, we'd have
to have accumulated over 4 seconds of time error between calls to
update_wall_time. At a max error rate of 500ppm, that would mean over
two hours of delay between calls.

The time subsystem can try to accommodate reasonable stalls in the
system, but i think there will always be windows in which KGDB could
cause the system to not recover (ie: i know quite of bit of scsi
hardware have heartbeat requirements, so I could imagine kgdb causing
those watchdogs to trigger and reset the device).

One approach would be to have KGDB suspend the timekeeping core, much as
is done over suspend/resume. This should be able to protect us from any
overflows, but I suspect its unlikely that we'd want to go run other
kernel stuff when breaking into KGDB.

Thanks again for the testing. I'll try to send out an improved version
of the fix for testing later today. If you could confirm it works as
well, I'd appreciate it.

thanks
-john




