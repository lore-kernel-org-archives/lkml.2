Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab0K3Tw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:52:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:47242 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab0K3Twz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:52:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,281,1288594800"; 
   d="scan'208";a="862818420"
Subject: Re: [PATCH 0/2] Fix dmar fault interrupt problems
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>
In-Reply-To: <20101130192845.GI10050@sequoia.sous-sol.org>
References: <4CF4B597.4030708@jp.fujitsu.com>
	 <1291140553.2623.10.camel@sbsiddha-MOBL3>
	 <20101130181314.GH10050@sequoia.sous-sol.org>
	 <1291141220.2623.13.camel@sbsiddha-MOBL3>
	 <20101130192845.GI10050@sequoia.sous-sol.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 30 Nov 2010 11:52:41 -0800
Message-Id: <1291146762.2623.34.camel@sbsiddha-MOBL3>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 11:28 -0800, Chris Wright wrote:
> AFAICT, it just becomes a duplicate call in a narrow window.
> 
> native_smp_prepare_cpus() (or APIC_init_uniprocessor()):
>  enable_IR_x2apic()
>   enable_IR()
>    enable_intr_remapping() <-- clears faults
>  default_setup_apic_routing()
>    enable_drhd_fault_handling() <-- added call to clear faults
> 
> That's what I meant by not needed.

I agree that we will call clear faults twice.

With out the second clear fault, any fault in that narrow window of
enabling intr-remapping and enabling fault handling will go unnoticed
and block further faults getting reported.

I am not sure if the first fault is necessary. I can check and remove it
if not needed.

Ideally we want to do something like:

Setup fault handling
Clear any faults
Enable intr-remapping

But fault handling interrupt configuration depends on the apic mode that
gets selected based on whether intr-remapping was enabled successfully
or not. And hence we were enabling fault handling after enabling the
intr-remapping mode.

I can see if I can cleanup any of these flows for 2.6.38. For 2.6.37 and
older kernels I would like to keep the patch simple.

thanks,
suresh

