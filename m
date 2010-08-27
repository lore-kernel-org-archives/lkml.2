Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab0H0QII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:08:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:53624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab0H0QIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:08:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,279,1280732400"; 
   d="scan'208";a="832513473"
From: "Luck, Tony" <tony.luck@intel.com>
To: Petr Tesarik <ptesarik@suse.cz>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hedi Berriche <hedi@sgi.com>
Date: Fri, 27 Aug 2010 09:08:03 -0700
Subject: RE: Serious problem with ticket spinlocks on ia64
Thread-Topic: Serious problem with ticket spinlocks on ia64
Thread-Index: ActF7PEv2I9vz36oSbC8JQLkGmsl5wAEsetA
Message-ID: <987664A83D2D224EAE907B061CE93D53015D91D029@orsmsx505.amr.corp.intel.com>
References: <201008271537.35709.ptesarik@suse.cz>
In-Reply-To: <201008271537.35709.ptesarik@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hedi Berriche sent me a simple test case that can
> trigger the failure on the siglock.

Can you post the test case please. How long does it typically take
to reproduce the problem?


> Next, CPU 5 releases the spinlock with st2.rel, changing the lock
> value to 0x0 (correct).
>
> SO FAR SO GOOD.
>
> Now, CPU 4, CPU 5 and CPU 7 all want to acquire the lock again.
> Interestingly, CPU 5 and CPU 7 are both granted the same ticket,

What is the duplicate ticket number that CPUs 5 & 7 get at this point?
Presumably 0x0, yes? Or do they see a stale 0x7fff?

> and the spinlock value (as seen from the debug fault handler) is
> 0x0 after single-stepping over the fetchadd4.acq, in both cases.
> CPU 4 correctly sets the spinlock value to 0x1.

Is the fault handler using "ld.acq" to look at the spinlock value?
If not, then this might be a red herring. [Though clearly something
bad is going on here].

> Any ideas?

What cpu model are you running on?
What is the topological connection between CPU 4, 5 and 7 - are any of
them hyper-threaded siblings? Cores on same socket? N.B. topology may
change from boot to boot, so you may need to capture /proc/cpuinfo from
the same boot where this problem is detected. But the variation is
usually limited to which socket gets to own logical cpu 0.

If this is a memory ordering problem (and that seems quite plausible)
then a liberal sprinkling of "ia64_mf()" calls throughout the spinlock
routines would probably make it go away.

-Tony
