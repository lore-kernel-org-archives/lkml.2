Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1FNQ7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:59:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:41554 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab1FNQ7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:59:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,365,1304319600"; 
   d="scan'208";a="16130225"
From: "Luck, Tony" <tony.luck@intel.com>
To: Avi Kivity <avi@redhat.com>
CC: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Tue, 14 Jun 2011 09:59:46 -0700
Subject: RE: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
Thread-Topic: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
Thread-Index: Acwqh/i6aoZ3I0gKSYmUtFKXAd3DdAAKyExA
Message-ID: <987664A83D2D224EAE907B061CE93D5301E7280DBF@orsmsx505.amr.corp.intel.com>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
	<4df13cea27302b7ccf@agluck-desktop.sc.intel.com>
	<20110612223840.GA23218@aftab>
	<BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>
	<4DF5C36A.1040707@redhat.com>	<20110613095521.GA26316@aftab>
	<4DF5F729.4060609@redhat.com>	<20110613124003.GA27918@aftab>
	<4DF606C9.90308@redhat.com>	<20110613151208.GA29045@aftab>
	<4DF63B7A.1030805@redhat.com>
 <BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com>
 <4DF748C2.10009@redhat.com>
In-Reply-To: <4DF748C2.10009@redhat.com>
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

> Aren't these events extraordinarily rare?  I think we can afford a 
> little inefficiency there.

Yes. Very rare. But also very disruptive (On Intel all cpus are signaled
and will be stuck processing the machine check for hundreds of microseconds).
So we'd like to try hard not to take the same fault more than once.

There's also the issue of post-error analysis. Some people like to dig
around in the MCA logs to figure out if the memory is really going bad,
or is just being hit occasionally by stray alpha-particles or neutrons.
Getting two errors close together might cause someone to replace a DIMM
that isn't really bad.  In Linux user space tools we could take account
of this repetition - but the OEM tools are imbedded in their BIOS or
maintenance processors.

>I don't think that doing anything to the task is correct, though, as the 
>problem is with the page, not the task itself.  In fact if the task is 
>executing a vgather instruction, or if another thread munmap()s the 
>page, it may not hit the same page again when re-executed.

True the memory is the source of the problem - but the task is
intimately affected.  Time for a car analogy :-) ...

You are driving along the road when you notice a giant hole. You
hit the brakes and stop on the very edge.  The problem is with the
road, not with your car. But I don't think you want to start driving
again (at least not in the forward direction!)

-Tony
