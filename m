Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0JTO1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:27:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab0JTO1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:27:48 -0400
Date: Wed, 20 Oct 2010 10:27:34 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Robert Richter <robert.richter@amd.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH 4/5] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
Message-ID: <20101020142734.GD19090@redhat.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
 <1287195738-3136-5-git-send-email-dzickus@redhat.com>
 <20101019150701.GR5969@erda.amd.com>
 <20101019162507.GU5969@erda.amd.com>
 <20101019183720.GN4140@redhat.com>
 <1287534192.3026.9.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287534192.3026.9.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 08:23:12AM +0800, Huang Ying wrote:
> > > > What about using raw_spin_trylock() instead? We don't have to wait
> > > > here since we are already processing it by another cpu.
> > > 
> > > This would avoid a global lock and also deadlocking in case of a
> > > potential #gp in the nmi handler.
> > 
> > I would feel more comfortable with it too.  I can't find a reason where
> > trylock would do harm.
> 
> One possible issue can be as follow:
> 
> - PCI SERR NMI raised on CPU 0
> - IOCHK NMI raised on CPU 1
> 
> If we use try lock, we may get unknown NMI on one CPU. Do you guys think
> so?

I thought both PCI SERR and IOCK NMI's were external and routed through
the IOAPIC, which means only one cpu could receive those (unless the
IOAPIC was updated to route them elsewhere).  This would make the issue
moot.  Unless I am misunderstanding where those NMIs come from?

Also as Robert said, we used to handle them on the bsp cpu only before
without any issues.  I believed that was because everything in the IOAPIC
was routed that way.

I thought the point of this patch was to remove that restriction in the
nmi handler, which would allow future patches to re-route these NMIs to
another cpu, thus finally allowing people to hot-remove the bsp cpu, no?

Cheers,
Don
