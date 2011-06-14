Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1FNRNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:13:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:14561 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab1FNRNE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:13:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,365,1304319600"; 
   d="scan'208";a="16138089"
From: "Luck, Tony" <tony.luck@intel.com>
To: Avi Kivity <avi@redhat.com>, Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Tue, 14 Jun 2011 10:13:02 -0700
Subject: RE: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
Thread-Topic: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
Thread-Index: AcwqmR3KlRiZ19hVRVWsuUlwzctK3gAHF+lw
Message-ID: <987664A83D2D224EAE907B061CE93D5301E7280DF7@orsmsx505.amr.corp.intel.com>
References: <BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>
 <4DF5C36A.1040707@redhat.com> <20110613095521.GA26316@aftab>
 <4DF5F729.4060609@redhat.com> <20110613124003.GA27918@aftab>
 <4DF606C9.90308@redhat.com> <20110613151208.GA29045@aftab>
 <4DF63B7A.1030805@redhat.com>
 <BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com>
 <4DF748C2.10009@redhat.com> <20110614133323.GB2830@aftab>
 <4DF76586.1090308@redhat.com>
In-Reply-To: <4DF76586.1090308@redhat.com>
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

>Since we can't have nested #MC (due to the IST mechanism resetting %rsp 
>and clobbering the previous invocation's stack), we have to clear MCIP 
>outside the #MC handler.  And that means irq_work_queue()
>
>(note that this changes the behaviour from memory corruption to shutdown 
>state; both suck, but one more than the other).

Hmm. We currently clear MCIP inside the handler (at the very end, but
still inside).  Deferring clearing would make sense - but we'd have to
be sure to do so a.s.a.p on all processors.  It also would change how
we look at the possibility of a process being able to run and re-execute
an instruction that causes a machine check. If we defer clearing MCIP
this won't just be annoying, it will be fatal (if any cpu hasn't yet
got to the work queue to clear MCIP).

-Tony
