Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1FMPM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 11:12:29 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36347 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1FMPM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 11:12:28 -0400
Date: Mon, 13 Jun 2011 17:12:08 +0200
From: Borislav Petkov <bp@amd64.org>
To: Avi Kivity <avi@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
Message-ID: <20110613151208.GA29045@aftab>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
 <4df13cea27302b7ccf@agluck-desktop.sc.intel.com>
 <20110612223840.GA23218@aftab>
 <BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>
 <4DF5C36A.1040707@redhat.com>
 <20110613095521.GA26316@aftab>
 <4DF5F729.4060609@redhat.com>
 <20110613124003.GA27918@aftab>
 <4DF606C9.90308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF606C9.90308@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 08:47:05AM -0400, Avi Kivity wrote:
> > HOWEVER, AFAICT, if the page is mapped multiple times,
> > killing/recovering the current task doesn't help from another core
> > touching it and causing a follow-up MCE. So holding off all the cores
> > from scheduling userspace in some manner might be the superior solution.
> > Especially if you don't execute the #MC handler on all CPUs as is the
> > case on AMD.
> >
> 
> That's basically impossible, since the other cores may be in fact 
> executing userspace, with the next instruction accessing the bad page.  
> In fact the access may have been started simultaneously with the one 
> that triggered the #MC.

True.

> The best you can do is IPI everyone as soon as you've caught the #MC,
> but you have to be prepared for multiple #MC for the same page. Once
> you have that, global synchronization is not so important anymore.

Yeah, in the multiple #MC case the memory_failure() thing should
probably be made reentrant-safe (if it is not yet). And in that case,
we'll be starting a worker thread on each CPU that caused an MCE from
accessing that page. The thread that manages to clear all the mappings
of our page simply does so while the others should be able to 'see' that
there's no work to be done anymore (PFN is not mapped in the pagetables
anymore) and exit without doing anything. Yeah, sounds doable with the
irq_work_queue -> user_return_notifier flow.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
