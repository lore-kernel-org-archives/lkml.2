Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab2BCWct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:32:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:23285 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab2BCWcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:32:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="103752630"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>
CC: Seiji Aguchi <seiji.aguchi@hds.com>, Chen Gong <gong.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Thread-Index: AQHMy9CqWb3Eal+luUidUg+JrwynPJX+IWHAgAAOOECAAJk+gIAGFpuAgACYuICAASNngIAAuA6AgACm9AD//5HLQIADWlqQgAlb+CWAAVZ7cIAWhOmA///PCcA=
Date: Fri, 3 Feb 2012 22:32:31 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F02B380@ORSMSX104.amr.corp.intel.com>
References: <20120105210123.GI5650@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827BBD8@USINDEVS01.corp.hds.com>
 <4F0BAB33.2090201@linux.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C583163B0@USINDEVS01.corp.hds.com>
 <4F0D3A0B.4090709@linux.intel.com> <20120111172544.GS5650@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28FD61F@ORSMSX104.amr.corp.intel.com>
 <32727E9A83EE9A42A1F0906295A3A77B2C78F49973@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2DA7B65F2A@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F0275EE@ORSMSX104.amr.corp.intel.com>
 <20120203171809.GL5650@redhat.com>
In-Reply-To: <20120203171809.GL5650@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What if we send the REBOOT_IPI first and let it block for up to a second.
> Most code paths that are done with spin_locks will use
> spin_lock_irqrestore.  As soon as the interrupts are re-enabled the
> REBOOT_IPI comes in and takes the processor.  If after a second the cpu
> still is blocking interrupts, just use the NMI as a big hammer to shut it
> down.

This looks good - it certainly deals with my "if we just let them run
a bit, they'd release the locks" quibble.  One second sounds very
generous - but I'm not going to bikeshed that (so long as it is a total
of one second - not one second per cpu). So the pseudo-code is:

	send_reboot_ipi_to_everyone_else()

	wait_1_second()

	for_each_cpu_that_didnt_respond_to_reboot_ipi {
		hit_that_cpu_with_NMI()
	}

Perhaps a notification printk() if we had to use the NMI hammer?

-Tony
