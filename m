Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0JUAkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:40:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:2944 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab0JUAkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:40:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,214,1286175600"; 
   d="scan'208";a="618764204"
Subject: Re: [PATCH 4/5] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
In-Reply-To: <20101020142734.GD19090@redhat.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
	 <1287195738-3136-5-git-send-email-dzickus@redhat.com>
	 <20101019150701.GR5969@erda.amd.com> <20101019162507.GU5969@erda.amd.com>
	 <20101019183720.GN4140@redhat.com> <1287534192.3026.9.camel@yhuang-dev>
	 <20101020142734.GD19090@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 08:40:07 +0800
Message-ID: <1287621607.19320.7.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 22:27 +0800, Don Zickus wrote:
> On Wed, Oct 20, 2010 at 08:23:12AM +0800, Huang Ying wrote:
> > > > > What about using raw_spin_trylock() instead? We don't have to wait
> > > > > here since we are already processing it by another cpu.
> > > > 
> > > > This would avoid a global lock and also deadlocking in case of a
> > > > potential #gp in the nmi handler.
> > > 
> > > I would feel more comfortable with it too.  I can't find a reason where
> > > trylock would do harm.
> > 
> > One possible issue can be as follow:
> > 
> > - PCI SERR NMI raised on CPU 0
> > - IOCHK NMI raised on CPU 1
> > 
> > If we use try lock, we may get unknown NMI on one CPU. Do you guys think
> > so?
> 
> I thought both PCI SERR and IOCK NMI's were external and routed through
> the IOAPIC, which means only one cpu could receive those (unless the
> IOAPIC was updated to route them elsewhere).  This would make the issue
> moot.  Unless I am misunderstanding where those NMIs come from?
> 
> Also as Robert said, we used to handle them on the bsp cpu only before
> without any issues.  I believed that was because everything in the IOAPIC
> was routed that way.
> 
> I thought the point of this patch was to remove that restriction in the
> nmi handler, which would allow future patches to re-route these NMIs to
> another cpu, thus finally allowing people to hot-remove the bsp cpu, no?

Yes. We just want to make it possible to hot-remove the bsp cpu. Because
IOAPIC is configurable, I think it is possible to configure IOAPIC to
send PCI SERR NMI to one CPU while IOCK NMI to another CPU. Why not
support this situation too? It does not harm anything but performance to
use raw_spin_lock() instead of raw_spin_trylock() here. And for hardware
error processing, performance is not so important in fact.

Best Regards,
Huang Ying


