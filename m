Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab2ENQ2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:28:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:62689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757183Ab2ENQ2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:28:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99903896"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Chen Gong <gong.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: RE: [PATCH 2/2] x86/mce: Add instruction recovery signatures to
 mce-severity table
Thread-Topic: [PATCH 2/2] x86/mce: Add instruction recovery signatures to
 mce-severity table
Thread-Index: AQHNL0lNX6PGPdBkbUOeJPxXhK/15JbE0YwAgAMlFwCAAYSpAA==
Date: Mon, 14 May 2012 16:28:35 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192EED4A@ORSMSX104.amr.corp.intel.com>
References: <cover.1336674796.git.tony.luck@intel.com>
 <0e89440bf6444635bde0b876eedd26e5c51f9ca3.1336674796.git.tony.luck@intel.com>
 <4FACC25B.80305@linux.intel.com>
 <3908561D78D1C84285E8C5FCA982C28F192ED617@ORSMSX104.amr.corp.intel.com>
 <20120513100532.GC28863@aftab.osrc.amd.com>
In-Reply-To: <20120513100532.GC28863@aftab.osrc.amd.com>
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

> > I'm trying to figure out a quirk for processors that do generate
> > EIPV=RIPV=0 signature for IFU errors. There are some case where
> > we can work around the lack of EIPV.
>
> __mcheck_cpu_apply_quirks?

The quirk is a bit more extensive than just setting some flag in there
for "if (c->x86 == 6 && c->x86_model == 45)". Sometime EIPV isn't set
because the regs->ip and regs->cs really aren't valid. So  I'll need
to do something like:

	if (we are on Intel family 6 model 45 AND
          this is a UC=1, PCC=0, AR=1, S=1, ADDRV=1, MCACOD=0x150 error AND
	    (virtophys(regs->ip) >> PAGE_SHIFT) == (MC(bank)_ADDR >> PAGE_SHIFT)) {
		/* ok to trust CS & IP */
		m.mcgstatus |= MCG_STATUS_EIPV;
	}
before running through the mce_severity() table lookup.

x86 doesn't seem to have a "virtophys()" that I can find. Closest is lookup_address(vaddr, level)
which gets a pte (which is almost all the work).

Sigh!

-Tony
