Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab0HSC2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 22:28:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab0HSC2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 22:28:11 -0400
Date: Wed, 18 Aug 2010 22:27:42 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Len Brown <len.brown@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Andy Grover <andy.grover@oracle.com>
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
Message-ID: <20100819022742.GI4879@redhat.com>
References: <20100817025954.GA12366@nowhere>
 <AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
 <20100817083945.GA12022@swordfish.minsk.epam.com>
 <AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
 <20100817092407.GB12022@swordfish.minsk.epam.com>
 <AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com>
 <20100817103948.GA5352@swordfish.minsk.epam.com>
 <20100817131320.GX4879@redhat.com>
 <20100818024802.GA24748@nowhere>
 <20100818130156.43a183d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818130156.43a183d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 01:01:56PM -0700, Andrew Morton wrote:
> The surprise new requirement that touch_nmi_watchdog() be called from
> non-preemptible code does seem to make sense IMO.  It's hard to see why
> anyone would be touching the watchdog unless he's spinning in irqs-off
> code.  Except, of course, when we have a utility function which can be
> called from wither irqs-on or irqs-off: acpi_os_stall().
> 
> That being said, it's not good to introduce new API requirements by
> accident!  An audit of all callers should first be performed, at least.
> 
> 
> The surprise new requirement that touch_softlockup_watchdog() be called
> from non-preemptible code doesn't make sense IMO.  If I have a piece of
> code in the kernel which I expect to sit in TASK_UNINTERRUPTIBLE state
> for three minutes waiting for my egg to boil, I should be able to do
> that and I should be able to touch the softlockup detector without
> needing to go non-preemptible.

Wow.  So after re-reading what the original touch_*_watchdog code did and what I
copied to kernel/watchdog.c, I'm a little embarrassed on how I managed to
mangle the internals of both those functions.

While the idea is the same, the semantics are clearly different.

touch_nmi_watchdog had a for_each_cpu_present loop, which means it didn't
have to deal with the preempt issue.

touch_softlockup_watchdog used __raw_get_cpu_var to excuse itself from
dealing with the preempt issue.

I'll put together a patch that brings those functions back in line with
what they used to be.  Sorry for the trouble.

Cheers,
Don

