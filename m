Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051Ab2EXSUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:20:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:16130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797Ab2EXSUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:20:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170992353"
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 24 May 2012 11:19:19 -0700
In-Reply-To: <20120524143711.GA24711@sgi.com>
References: <20120521164959.GE16454@sgi.com>
	 <alpine.LFD.2.02.1205212304580.3231@ionos> <20120521211917.GA25567@sgi.com>
	 <alpine.LFD.2.02.1205212324260.3231@ionos> <20120523181636.GA2032@sgi.com>
	 <20120523190414.GA5263@sgi.com>
	 <1337801086.1997.197.camel@sbsiddha-desk.sc.intel.com>
	 <20120523200226.GA6936@sgi.com>
	 <1337816970.1997.207.camel@sbsiddha-desk.sc.intel.com>
	 <20120524143711.GA24711@sgi.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337883560.7938.9.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 09:37 -0500, Dimitri Sivanich wrote:
> And speaking of possible holes in destroy_irq()..
> 
> What happens if we're running __assign_irq_vector() (say we're changing irq
> affinity), and on another cpu we had just run through __clear_irq_vector()
> via destroy_irq().  Now destroy_irq() is going to call
> free_irq_at()->free_irq_cfg, which will clear irq_cfg.  Then
> __assign_irq_vector goes to access irq_cfg (cfg->vector or
> cfg->move_in_progress, for instance), which was already freed.
> 
> I'm not sure if this can happen, but just eyeballing it, it does look that
> that way.
> 

I wanted to say, irq desc is locked when we change the irq affinity,
which calls assign_irq_vector() and friends, so this should be fine.

BUT NO. I don't see any reference counts being maintained when we do
irq_to_desc(). So locking/unlocking that desc pointer is bogus when
destroy_irq() can go ahead and free the desc in parallel.

So, SPARSE_IRQ looks terribly broken! Yinghai, Thomas?

thanks,
suresh

