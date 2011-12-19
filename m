Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1LSVBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 16:01:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab1LSVBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 16:01:17 -0500
Date: Mon, 19 Dec 2011 16:00:46 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
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
Subject: Re: [RFC][PATCH v3 2/3] Skip spin_locks in panic case and add
 WARN_ON()
Message-ID: <20111219210046.GG5650@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57DC0D10@USINDEVS01.corp.hds.com>
 <20111212155827.GR1669@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57EE46F2@USINDEVS01.corp.hds.com>
 <0207C53569FE594381A4F2EB66570B2A018EFB83C4@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0207C53569FE594381A4F2EB66570B2A018EFB83C4@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:48:52AM -0800, Luck, Tony wrote:
> > if (reason == KMSG_DUMP_PANIC) {
> > 	if(is_spin_locked(&psinfo->buf_lock))
> > 		pr_err("lock is taken.\n");
> > else {
> > 	spin_lock_irqsave(&psinfo->buf_lock, flags);
> > }
> >
> > However, this won't work for this reason.
> >  - printk() must not be called in serialized path because deadlock of logbuf_lock may cause.
> 
> There is also the issue that kmsg has already computed the addresses
> of useful pieces in __log_buf at this point - so any printk() we
> add here is not going to be saved into pstore.  So a user relying
> on pstore to see what happened, won't see any messages we add here.

Ah.  Good point.

Now we have a scenario (though rare), where kmsg_dump can fail to save a
dump because some one already has the lock.  Hitachi's whole goal behind
kmsg_dump is to record every possible reason for rebooting the machine for
inspection on reboot, I think if I understood Seiji privately.

Seiji, has does this failure impact kmsg_dump's goal?

Cheers,
Don
