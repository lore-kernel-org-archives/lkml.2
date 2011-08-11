Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1HKTEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:04:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab1HKTET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:04:19 -0400
Date: Thu, 11 Aug 2011 15:04:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alex Neronskiy <zakmagnus@chromium.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.com>
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
Message-ID: <20110811190402.GC17530@redhat.com>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
 <1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
 <m2bovvn5s5.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2bovvn5s5.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 11:48:26AM -0700, Andi Kleen wrote:
> Alex Neronskiy <zakmagnus@chromium.org> writes:
> 
> > From: Alex Neronskiy <zakmagnus@chromium.com>
> >
> > Instead of using the log, use debugfs for output of both stall
> > lengths and stack traces. Printing to the log can result in
> > watchdog touches, 
> 
> Why? Because of printk being slow or something else?

No because the serial console driver does a touch_nmi_watchdog().  So if
we are trying to output debug info _before_ the lockup detector goes off,
we effectively shoot ourselves in the foot by reseting the lockup detector
everytime we print something.  Hence we are trying to capture the data and
output using another interface.

> 
> The first could be probably workarounded, especially if you
> already have "two buffers"
> 
> > distorting the very events being measured.
> > Additionally, the information will not distract from lockups
> > when users view the log.
> >
> > A two-buffer system is used to ensure that the trace information
> > can always be recorded without contention.
> 
> This implies that kernel bug reports will often not contain the 
> back trace, right? Seems like a bad thing to me because it will
> make bug reports worse.

These are debug traces.  The real lockup traces will still print to the
console as they do today.  Nothing will change from that perspective.

What these patches do is give you insight into what part of your system is
coming close but not causing lockups.  If we have the hardlockup detector
set to warn or panic after 5 seconds of no interrupts, then these patches
can give you backtraces after 3 or 4 seconds (these traces might enable
interrupts after 4 seconds so no lock up occurs, but maybe something worth
noting).  It's just way to gather hueristics on system behaviour
regarding lockups.

Cheers,
Don

> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only
