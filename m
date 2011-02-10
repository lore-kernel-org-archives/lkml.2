Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab1BJSuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:50:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33819 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab1BJSuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:50:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Patch] idle governor: Avoid lock acquisition to read pm_qos before entering idle
Date: Thu, 10 Feb 2011 19:50:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Tim Chen <tim.c.chen@linux.intel.com>, mark gross <markgross@thegnar.org>,
        David Alan Gilbert <linux@treblig.org>, linux-kernel@vger.kernel.org,
        Len <len.brown@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
References: <1297300864.2645.128.camel@schen9-DESK> <1297359914.4933.56.camel@mulgrave.site>
In-Reply-To: <1297359914.4933.56.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102101950.30757.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 10, 2011, James Bottomley wrote:
> On Wed, 2011-02-09 at 17:21 -0800, Tim Chen wrote:
> > I noticed that before entering idle state, the menu idle governor will
> > look up the current pm_qos value according to the list of qos request
> > received.  This look up currently needs the acquisition of a lock to go
> > down a list of qos requests to find the qos value, slowing down the
> > entrance into idle state due to contention by multiple cpus to traverse
> > this list.  The contention is severe when there are a lot of cpus waking
> > and going into idle.  For example, for a simple workload that has 32
> > pair of processes ping ponging messages to each other, where 64 cores
> > cores are active in test system, I see the following profile:
> > 
> > -     37.82%          swapper  [kernel.kallsyms]          [k]
> > _raw_spin_lock_irqsave
> >    - _raw_spin_lock_irqsave
> >       - 95.65% pm_qos_request             
> >            menu_select                                             
> >            cpuidle_idle_call                      
> >          - cpu_idle                                                     
> >               99.98% start_secondary
> > 
> > Perhaps a better approach will be to cache the updated pm_qos value so
> > reading it does not require lock acquisition as in the patch below.   
> > 
> > Tim
> > 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> 
> What you say is true as long as the value is 32 bits ... perhaps a note
> of that should be made somewhere?
> 
> Otherwise, it looks like a good lockless optimisation on the read path,
> so you can add my ack.

Thanks James, I'm going to take the patch.

Rafael
