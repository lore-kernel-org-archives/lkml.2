Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2ATR4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:56:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:36381 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab2ATR4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:56:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="109155561"
From: "Luck, Tony" <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>, Don Zickus <dzickus@redhat.com>,
        Chen Gong <gong.chen@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Thread-Topic: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC)
 below smp_send_stop()
Thread-Index: AQHMy9CqWb3Eal+luUidUg+JrwynPJX+IWHAgAAOOECAAJk+gIAGFpuAgACYuICAASNngIAAuA6AgACm9AD//5HLQIADWlqQgAlb+CWAAVZ7cA==
Date: Fri, 20 Jan 2012 17:56:15 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F0275EE@ORSMSX104.amr.corp.intel.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF7F@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF81@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28FBB21@ORSMSX104.amr.corp.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827B01D@USINDEVS01.corp.hds.com>
 <20120105210123.GI5650@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827BBD8@USINDEVS01.corp.hds.com>
 <4F0BAB33.2090201@linux.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C583163B0@USINDEVS01.corp.hds.com>
 <4F0D3A0B.4090709@linux.intel.com> <20120111172544.GS5650@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28FD61F@ORSMSX104.amr.corp.intel.com>,<32727E9A83EE9A42A1F0906295A3A77B2C78F49973@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2DA7B65F2A@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2DA7B65F2A@USINDEVS01.corp.hds.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you have any comments?

I'm stuck in because I don't know how assign probabilities to
the failure cases with kmsg_dump() before and after the smp_send_stop().

There's a well documented tendency in humans to stick with the status
quo in such situations.  I'm definitely finding it hard to provide
a positive recommendation (ACK).

So I'll just talk out loud here for a bit in case someone sees
something obviously flawed in my understanding.

Problem statement: We'd like to maximize our chances of saving the
tail of the kernel log when the system goes down. With the current
ordering there is a concern that other cpus will interfere with the
one that is saving the log.

Problems in current code flow:
*) Other cpus might hold locks that we need. Our options are to fail,
   or to "bust" the locks (but busting the locks may lead to other
   problems in the code path - those locks were there for a reason).
   There are only a couple of ways that this could be an issue.
   1) The lock is held because someone is doing some other pstore
   filesystem operation (reading and erasing records). This has a
   very low probability. Normal code flow will have some process harvest
   records from pstore in some /etc/rc.d/* script - this process should
   take much less than a second.
   2) The lock is held because some other kmsg_dump() store is in progress.
   This one seems more worrying - think of an OOPS (or several) right
   before we panic

Problems in proposed code flow:
*) smp_send_stop() fails:
   1) doesn't actually stop other cpus (we are no worse off than before we
   made this change)
   2) doesn't return - so we don't even try to dump to pstore back end. x86
   code has recently been hardened (though I can still imagine a pathological
   case where in a crash the cpu calling this is uncertain of its own
   identity, and somehow manages to stop itself - perhaps we are so screwed up
   in this case that we have no hope anyway)
*) Even if it succeeds - we may still run into problems busting locks because
   even though the cpu that held them isn't executing, the data structures
   or device registers protected by the lock may be in an inconsistent state.
*) If we had just let this other cpus keep running, they'd have finished their
   operation and freed up the problem lock anyway

-Tony
