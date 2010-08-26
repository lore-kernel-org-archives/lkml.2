Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0HZRSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:18:13 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:42763 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab0HZRSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:18:10 -0400
Date: Thu, 26 Aug 2010 13:17:39 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Andy Grover <andy.grover@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: acpi_os_stall() and touch_nmi_watchdog() (was Re: [PATCH] fix BUG
 using smp_processor_id() in touch_nmi_watchdog and touch_softlockup_watchdog)
In-reply-to: <20100819204256.3380bf6f.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.1008261210420.4686@localhost.localdomain>
References: <20100817025954.GA12366@nowhere>
 <AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
 <20100817083945.GA12022@swordfish.minsk.epam.com>
 <AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
 <20100817092407.GB12022@swordfish.minsk.epam.com>
 <AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com>
 <20100817103948.GA5352@swordfish.minsk.epam.com>
 <20100817131320.GX4879@redhat.com> <20100818024802.GA24748@nowhere>
 <20100818130156.43a183d9.akpm@linux-foundation.org>
 <20100820025749.GB4879@redhat.com>
 <20100819204256.3380bf6f.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_os_stall() is used in two ways.

The typical way is what triggered this e-mail thread.
It implements the AML "Stall()" operator, and is called
with interrupts enabled with durations <= 100 usec.
So one would expect it to be identical to udelay().

The exception case is when ACPICA calls it with interrupts off
and huge durations when we wrote the poweroff or sleep
register, yet we find outselves still running...

Apparently akpm added touch_nmi_watchdog() to keep the
watchdog from firing in this exception case.

Is it useful to have the watchdog running when
we are waiting for firmware to poweroff the machine?
If no, maybe we should turn it off as part of the shutdown
process rather than using yet another invocation
of touch_nmi_watchdog()?

Is calling delay() with IRQs disabled the best thing
we can do after we ask the firmware to cut power
and it takes a long time?

thanks,
Len Brown, Intel Open Source Technology Center
