Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab1D1MtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 08:49:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab1D1Ms7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 08:48:59 -0400
Subject: Re: [PATCH] drm/nouveau: Remove interrupt handler around
 suspend/resume
From: Alex Williamson <alex.williamson@redhat.com>
To: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
In-Reply-To: <1303970068.3676.18.camel@clockmaker-el6>
References: <20110428051926.10111.28554.stgit@localhost6.localdomain6>
	 <1303970068.3676.18.camel@clockmaker-el6>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 06:48:56 -0600
Message-ID: <1303994936.9306.20.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 15:54 +1000, Dave Airlie wrote:
> On Wed, 2011-04-27 at 23:20 -0600, Alex Williamson wrote:
> > We're often using a shared interrupt line for nouveau, so we have
> > to be prepared that it could be called at any point in time.  If
> > we've suspended the device via vga switcheroo and get a stray
> > interrupt on the line from another device, we'll read back -1 from
> > the device and head down all sorts of strange paths, most of which
> > eventually lock the system.
> > 
> > On my system (Asus UL30VT) the interrupt line is shared with USB.
> > Attempting to disable the USB bluetooth device seems to trigger
> > a stray interrupt that ends up in nv04_fifo_isr() where we
> > eventually hit the "PFIFO still angry after 100 spins, halt",
> > which kills the system.
> > 
> > Using free_irq/request_irq around the suspend seems to be a
> > reliable fix.  Attempting to flag the device state in
> > nouvea_irq_handler(), similar to the intel_lid_notify() fix
> > is too racy since we can power off the device as an interrupt
> > is being processed.
> 
> The actual solution is to check if we read back all Fs and return from
> the irq handler. Robust irq handlers are generally considered a good
> idea esp around race conditions at suspend/resume time.

The trouble I found in trying to do that is that we can still race,
having the device be disabled while and interrupt is still being
processed.  It seems impractical to check every device read through the
interrupt path for -1 and back out.  Adding a spinlock to the interrupt
handler seemed expensive, while this has no additional runtime interrupt
overhead.  Thanks,

Alex



