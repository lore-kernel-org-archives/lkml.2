Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab0CQJvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:51:05 -0400
Received: from mga06.intel.com ([134.134.136.21]:13150 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753979Ab0CQJvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:51:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,656,1262592000"; 
   d="scan'208";a="501314233"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from host side
Date: Wed, 17 Mar 2010 17:51:01 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; x86_64; ; )
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       "Huang, Zhiteng" <zhiteng.huang@intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>
References: <1268717232.2813.36.camel@localhost> <201003171728.43739.sheng@linux.intel.com> <4BA0A3E6.4040100@redhat.com>
In-Reply-To: <4BA0A3E6.4040100@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003171751.01777.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 March 2010 17:41:58 Avi Kivity wrote:
> On 03/17/2010 11:28 AM, Sheng Yang wrote:
> >> I'm not sure if vmexit does break NMI context or not. Hardware NMI
> >> context isn't reentrant till a IRET. YangSheng would like to double
> >> check it.
> >
> > After more check, I think VMX won't remained NMI block state for host.
> > That's means, if NMI happened and processor is in VMX non-root mode, it
> > would only result in VMExit, with a reason indicate that it's due to NMI
> > happened, but no more state change in the host.
> >
> > So in that meaning, there _is_ a window between VMExit and KVM handle the
> > NMI. Moreover, I think we _can't_ stop the re-entrance of NMI handling
> > code because "int $2" don't have effect to block following NMI.
> 
> That's pretty bad, as NMI runs on a separate stack (via IST).  So if
> another NMI happens while our int $2 is running, the stack will be
> corrupted.

Though hardware didn't provide this kind of block, software at least would 
warn about it... nmi_enter() still would be executed by "int $2", and result 
in BUG() if we are already in NMI context(OK, it is a little better than 
mysterious crash due to corrupted stack).
> 
> > And if the NMI sequence is not important(I think so), then we need to
> > generate a real NMI in current vmexit-after code. Seems let APIC send a
> > NMI IPI to itself is a good idea.
> >
> > I am debugging a patch based on apic->send_IPI_self(NMI_VECTOR) to
> > replace "int $2". Something unexpected is happening...
> 
> I think you need DM_NMI for that to work correctly.
> 
> An alternative is to call the NMI handler directly.

apic_send_IPI_self() already took care of APIC_DM_NMI.

And NMI handler would block the following NMI?

-- 
regards
Yang, Sheng
