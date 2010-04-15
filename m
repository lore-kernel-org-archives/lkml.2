Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0DOOIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 10:08:22 -0400
Received: from mga10.intel.com ([192.55.52.92]:61244 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753091Ab0DOOIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 10:08:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,212,1270450800"; 
   d="scan'208";a="789562160"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest 
 =?iso-8859-1?q?os=09statistics_from_host?= side
Date: Thu, 15 Apr 2010 22:08:08 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; x86_64; ; )
Cc: Joerg Roedel <joro@8bytes.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <20100415104051.GC12697@8bytes.org> <4BC6EDFF.3000702@redhat.com>
In-Reply-To: <4BC6EDFF.3000702@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004152208.08409.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 April 2010 18:44:15 Avi Kivity wrote:
> On 04/15/2010 01:40 PM, Joerg Roedel wrote:
> >> That means an NMI that happens outside guest code (for example, in the
> >> mmu, or during the exit itself) would be counted as if in guest code.
> >
> > Hmm, true. The same is true for an NMI that happens between VMSAVE and
> > STGI but that window is smaller. Anyway, I think we don't need the
> > busy-wait loop. The NMI should be executed at a well defined point and
> > we set the cpu_var back to NULL after that point.
> 
> The point is not well defined.  Considering there are already at least
> two implementations svm, I don't want to rely on implementation details.

After more investigating, I realized that I had interpreted the SDM wrong. 
Sorry.

There is *no* risk with the original method of calling "int $2". 

According to the SDM 24.1:

> The following bullets detail when architectural state is and is not updated 
in response to VM exits:
[...]
> - An NMI causes subsequent NMIs to be blocked, but only after the VM exit 
completes.

So the truth is, after NMI directly caused VMExit, the following NMIs would be 
blocked, until encountered next "iret". So execute "int $2" is safe in 
vmx_complete_interrupts(), no risk in causing nested NMI. And it would unblock 
the following NMIs as well due to "iret" it executed.

So there is unnecessary to make change to avoid "potential nested NMI".

Sorry for the mistake and caused confusing.

-- 
regards
Yang, Sheng

> 
> We could tune the position of the loop so that zero iterations are
> executed on the implementations we know about.
> 
