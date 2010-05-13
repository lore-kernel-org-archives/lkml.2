Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab0EMPmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:42:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758951Ab0EMPmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:42:45 -0400
Date: Thu, 13 May 2010 08:41:00 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <josef@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/4] Btrfs: add basic DIO read/write support V3
Message-Id: <20100513084100.d06b266b.akpm@linux-foundation.org>
In-Reply-To: <20100513153145.GE27011@dhcp231-156.rdu.redhat.com>
References: <20100512204052.GD3597@localhost.localdomain>
	<20100513151429.GA16916@infradead.org>
	<20100513153145.GE27011@dhcp231-156.rdu.redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 11:31:45 -0400 Josef Bacik <josef@redhat.com> wrote:

> On Thu, May 13, 2010 at 11:14:30AM -0400, Christoph Hellwig wrote:
> > On Wed, May 12, 2010 at 04:40:53PM -0400, Josef Bacik wrote:
> > > V1->V2
> > > -Use __blockdev_direct_IO instead of helper
> > > -Use KM_IRQ0 for kmap instead of KM_USER0
> > 
> > I still don't think this is correct.  The completion can come from
> > softirq and hardirq context, and possibly even normal process context.
> > You either need to check for all these, or you need to use the generic
> > complete in user context helper btrfs has available for other types
> > of I/O.
> > 
> 
> AIO's aio_complete does kmap with KM_IRQ0/1 and it gets called in the same
> context as the btrfs completion handler, so if it's ok for aio_complete it
> should be ok for btrfs right?  Thanks,
> 

Using KM_USERx from irq context is a horrid, horrid bug.

Using KM_IRQx with local interrupts enabled is a ditto.

It's OK to use KM_IRQx from process context as long as local interrupts
are disabled.

kmap slots are just per-cpu variables.  Each one has a particular usage
convention: process-context-only, must-be-irq-safe, etc.

