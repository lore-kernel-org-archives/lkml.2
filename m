Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab1J1SeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 14:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab1J1SeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 14:34:12 -0400
Date: Fri, 28 Oct 2011 14:33:47 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Chen, Gong" <gong.chen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v2 -next 2/2] Adding lock operations to
 kmsg_dump()/pstore_dump()
Message-ID: <20111028183347.GE3452@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C576122A9@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C576122A9@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 05:21:35PM -0400, Seiji Aguchi wrote:
> pstore_dump()/kmsg_dump() may be called everywhere in kernel.
> So we have to care about following cases.
> 
>   - Panic path
>     In this case, Logging message process is serialized via smp_send_stop().
>     So, we can bust spin_locks.
> 
>     Currently, kmsg_dump() may be called twice (KMSG_DUMP_PANIC and KMSG_DUMP_EMERGY)
>     So, for avoiding deadlock, I suggest to bust locks rather than skipping them.
> 
>   - NMI context 
>      While a cpu is in NMI handler, other cpus may be running.
>      So, trylock should be called so that lockdep cheking works.
>  
>   - Process context
>     In this case, we can simply take locks.

It ain't pretty but it moves things towards a more reliable message dump.
The odds of us needing to bust the spinlocks are really small.  Most of
the time no one reads the pstore filesystem.

I would love to figure out a prettier solution for this locking mess, but
I can't think of anything.  We have customers who want to utilize this
technology, so I am trying to make sure it is stable and robust for now.
A little selfish I suppose.  But we are open to ideas?

Acked-by: Don Zickus <dzickus@redhat.com>
