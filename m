Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187Ab2IFB6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 21:58:22 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:41353 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2IFB6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 21:58:20 -0400
Subject: Re: [RFC PATCH 0/3] target: try satisfying memory requests with
 higher-order allocations
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <1346858025-10459-1-git-send-email-pbonzini@redhat.com>
References: <1346858025-10459-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Sep 2012 18:58:18 -0700
Message-ID: <1346896698.4162.403.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 17:13 +0200, Paolo Bonzini wrote:
> Hi all,
> 
> while testing PSCSI I noticed that even requests for a smallish amount
> of data (approximately 700 KB) failed due to an excessive number of
> segments in the request.  In fact, using alloc_page resulted in a
> completely fragmented request, with no merging of consecutive pages
> at all.
> 
> This patch series fixes this problem by using higher-order allocations
> to build the data scatterlist.  The problem is that iscsi assumes that the
> scatterlist consists of single pages, which is not true anymore.  So
> patch 2 has to introduce some relatively complicated changes to
> iscsi_map_iovec and iscsi_unmap_iovec.
> 

So enabling multi-page per SGL support is a feature that has been
dormant within target core for a long time.  It's about time that we
start taking advantage of it again.  ;)

> While doing this, I noticed something strange in iscsit_do_crypto_hash_sg.
> Patch 1 adds a warning about it.
> 

Mmmmm, looks like a separate bug with DataDigest enabled.  

> The approach may be completely wrong and it needs more testing anyway.
> Please review!
> 

Adding my comments inline.

Thanks Paolo!

--nab

> Paolo
> 
> Paolo Bonzini (3):
>   tcm_iscsi: warn on incorrect precondition for iscsit_do_crypto_hash_sg
>   tcm_iscsi: support multiple sizes in the scatterlist
>   target: try satisfying memory requests with contiguous blocks
> 
>  drivers/target/iscsi/iscsi_target.c      |  106 +++++++++++++++++++++++++-----
>  drivers/target/iscsi/iscsi_target_core.h |    2 +-
>  drivers/target/target_core_transport.c   |   58 ++++++++++++++---
>  3 files changed, 138 insertions(+), 28 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


