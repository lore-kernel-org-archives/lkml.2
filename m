Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2GWWvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 18:51:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab2GWWvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 18:51:01 -0400
Message-ID: <1343083857.2229.323.camel@bling.home>
Subject: Re: [PATCH v6 0/2] kvm: level irqfd and new eoifd
From: Alex Williamson <alex.williamson@redhat.com>
To: avi@redhat.com
Cc: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Mon, 23 Jul 2012 16:50:57 -0600
In-Reply-To: <20120720161841.15119.29653.stgit@bling.home>
References: <20120720161841.15119.29653.stgit@bling.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 10:33 -0600, Alex Williamson wrote:
> v6:
> 
> So we're back to just the first two patches, unfortunately the
> diffstat got bigger though.  The reason for that is that I discovered
> we don't do anything on release of an eoifd.  We cleanup if the kvm
> vm is released, but we're dealing with a constrained resource of irq
> source IDs, so I think it's best that we cleanup to make sure those
> are returned.  To do that we need nearly the same infrastructure as
> irqfd, we just only watch for POLLHUP.  So while there's more code
> here, the structure and function names line up identically to irqfd.
> 
> The other big change here is that KVM_IRQFD returns a token when
> setting up a level irqfd.  We use this token to associate the eoifd
> with the right source.  This means we have to put the struct
> _source_ids on a list so we can find them.  This removes the weird
> interaction we were headed to where the eoifd is associated with
> the eventfd of the irqfd.  There's potentially more flexibility for
> the future here too as we might come up with other interfaces that
> can return a source ID "key".  Perhaps some future KVM_IRQFD will
> allow specifying a key for re-attaching.  Anyway, the sequence
> Michael pointed out where an irqfd is de-assigned then re-assigned
> now results in a new key instead of leaving the user wondering if
> it re-associates back to the eoifd.
> 
> Also added workqueue flushes on assign since releasing either
> object now results in a lazy release via workqueue.  This ensures
> we re-claim any source IDs we can.  Thanks,

FYI, I seem to have found a new locking issue in this version.  I'll
send an update when I find it.  Thanks,

Alex

> ---
> 
> Alex Williamson (2):
>       kvm: KVM_EOIFD, an eventfd for EOIs
>       kvm: Extend irqfd to support level interrupts
> 
> 
>  Documentation/virtual/kvm/api.txt |   32 ++-
>  arch/x86/kvm/x86.c                |    3 
>  include/linux/kvm.h               |   18 +
>  include/linux/kvm_host.h          |   17 +
>  virt/kvm/eventfd.c                |  463 ++++++++++++++++++++++++++++++++++++-
>  virt/kvm/kvm_main.c               |   11 +
>  6 files changed, 536 insertions(+), 8 deletions(-)



