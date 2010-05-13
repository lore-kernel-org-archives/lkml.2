Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab0EMSMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:12:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759003Ab0EMSMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:12:22 -0400
Date: Thu, 13 May 2010 11:11:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <josef@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/4] Btrfs: add basic DIO read/write support V3
Message-Id: <20100513111136.6986e8cc.akpm@linux-foundation.org>
In-Reply-To: <20100513180137.GH27011@dhcp231-156.rdu.redhat.com>
References: <20100512204052.GD3597@localhost.localdomain>
	<20100513151429.GA16916@infradead.org>
	<20100513153145.GE27011@dhcp231-156.rdu.redhat.com>
	<20100513152639.GA30954@infradead.org>
	<20100513180137.GH27011@dhcp231-156.rdu.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 14:01:37 -0400
Josef Bacik <josef@redhat.com> wrote:

> On Thu, May 13, 2010 at 11:26:39AM -0400, Christoph Hellwig wrote:
> > On Thu, May 13, 2010 at 11:31:45AM -0400, Josef Bacik wrote:
> > > AIO's aio_complete does kmap with KM_IRQ0/1 and it gets called in the same
> > > context as the btrfs completion handler, so if it's ok for aio_complete it
> > > should be ok for btrfs right?  Thanks,
> > 
> > aio_complete does a spin_lock_irqsave before that, which disables
> > interrupts on the local CPU.
> > 
> 
> Ok how about I just do
> 
> local_irq_disable()
> kmap(KM_IRQ0)
> local_irq_enable()
> 
> would that be acceptable?  Thanks,

yup.

local_irq_disable() (or local_irq_save())
kmap_atomic(KM_IRQx);
<stuff>
kunmap_atomic(KM_IRQx);
local_irq_enable() (or local_irq_restore()).

then perhaps flush_dcache_page().
