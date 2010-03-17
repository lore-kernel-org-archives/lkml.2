Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0CQJ2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:28:45 -0400
Received: from mga07.intel.com ([143.182.124.22]:11044 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753894Ab0CQJ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:28:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,656,1262592000"; 
   d="scan'208";a="255596903"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from host side
Date: Wed, 17 Mar 2010 17:28:43 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; x86_64; ; )
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       "Huang, Zhiteng" <zhiteng.huang@intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>
References: <1268717232.2813.36.camel@localhost> <4B9F5021.3080206@redhat.com> <1268793273.2813.70.camel@localhost>
In-Reply-To: <1268793273.2813.70.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003171728.43739.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 March 2010 10:34:33 Zhang, Yanmin wrote:
> On Tue, 2010-03-16 at 11:32 +0200, Avi Kivity wrote:
> > On 03/16/2010 09:48 AM, Zhang, Yanmin wrote:
> > > Right, but there is a scope between kvm_guest_enter and really running
> > > in guest os, where a perf event might overflow. Anyway, the scope is
> > > very narrow, I will change it to use flag PF_VCPU.
> >
> > There is also a window between setting the flag and calling 'int $2'
> > where an NMI might happen and be accounted incorrectly.
> >
> > Perhaps separate the 'int $2' into a direct call into perf and another
> > call for the rest of NMI handling.  I don't see how it would work on svm
> > though - AFAICT the NMI is held whereas vmx swallows it.
> >
> >  I guess NMIs
> > will be disabled until the next IRET so it isn't racy, just tricky.
> 
> I'm not sure if vmexit does break NMI context or not. Hardware NMI context
> isn't reentrant till a IRET. YangSheng would like to double check it.

After more check, I think VMX won't remained NMI block state for host. That's 
means, if NMI happened and processor is in VMX non-root mode, it would only 
result in VMExit, with a reason indicate that it's due to NMI happened, but no 
more state change in the host.

So in that meaning, there _is_ a window between VMExit and KVM handle the NMI. 
Moreover, I think we _can't_ stop the re-entrance of NMI handling code because 
"int $2" don't have effect to block following NMI.

And if the NMI sequence is not important(I think so), then we need to generate 
a real NMI in current vmexit-after code. Seems let APIC send a NMI IPI to 
itself is a good idea.

I am debugging a patch based on apic->send_IPI_self(NMI_VECTOR) to replace 
"int $2". Something unexpected is happening...

-- 
regards
Yang, Sheng
