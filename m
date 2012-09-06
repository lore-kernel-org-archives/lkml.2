Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab2IFSxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:53:04 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:54861 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382Ab2IFSxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:53:02 -0400
Subject: Re: [RFC PATCH 0/3] target: try satisfying memory requests with
 higher-order allocations
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <50486727.7060509@redhat.com>
References: <1346858025-10459-1-git-send-email-pbonzini@redhat.com>
	 <1346896698.4162.403.camel@haakon2.linux-iscsi.org>
	 <50486727.7060509@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Sep 2012 11:52:59 -0700
Message-ID: <1346957579.4162.504.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 11:04 +0200, Paolo Bonzini wrote:
> Il 06/09/2012 03:58, Nicholas A. Bellinger ha scritto:
> >> This patch series fixes this problem by using higher-order allocations
> >> to build the data scatterlist.  The problem is that iscsi assumes that the
> >> scatterlist consists of single pages, which is not true anymore.  So
> >> patch 2 has to introduce some relatively complicated changes to
> >> iscsi_map_iovec and iscsi_unmap_iovec.
> > 
> > So enabling multi-page per SGL support is a feature that has been
> > dormant within target core for a long time.  It's about time that we
> > start taking advantage of it again.  ;)
> 
> Yeah, I noticed some preparation for it in tcm_fc/tfc_io.c, though too
> late (they look a lot like my iscsi changes, it would have saved me some
> time!).
> 
> While this is obviously not to be taken lightly, I disagree with making
> this a per-fabric choice.  With a properly organized (and bisectable)
> series, it should be relatively easy to review and to get right.

It's a temporary bit that allows us to figure out which fabrics can
(safely) be enabled for multi-page SGLs operation for the short term
within for-next code.

Unless your prepared to commit to fio+writeverify'ing 8x mainline fabric
drivers in many different types of fabric dependent I/O combination for
high order allocations, I'd still prefer to have some way to disable
this optimization in a per fabric basis if we really need too.

That way we can just disable a problematic fabric instead of having to
revert the whole thing if users run into problems with a specific fabric
module late during the cycle.  If the other fabric maintainers are OK
with enabling this in their code and give their Reviewed-By's +
Tested-By's, then I have no problem dropping this extra bit once
everything has been converted.

>  I looked a bit more closely now and there are no changes needed to other
> targets (actually there is a change needed in tcm_qla2xxx, but the code
> is currently disabled).
> 
> There are however changes to transport_kmap_data_sg needed and a few
> other places.
> 
> I definitely agree with your other comments, including making max_order
> a DEF_DEV_ATTRIB.  In addition, the default max_order should be capped
> based on queue_max_sectors(q) if applicable, to avoid hitting this scenario:
> 
>        /*
>         * XXX: if the length the device accepts is shorter than the
>         *      length of the S/G list entry this will cause and
>         *      endless loop.  Better hope no driver uses huge pages.
>         */
> 

Mmmmm, indeed.  Also, I'm not sure that every old SCSI LLD is smart
enough to handle high older allocations -> multi-page SGLs either..

