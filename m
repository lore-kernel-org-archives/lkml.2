Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450Ab1LOTbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:31:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52563 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab1LOTbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:31:38 -0500
Date: Thu, 15 Dec 2011 11:31:33 -0800
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: workqueue_set_max_active(wq, 0)?
Message-ID: <20111215193133.GF32002@google.com>
References: <1323424482.3622.8.camel@jlt3.sipsolutions.net>
 <20111209165702.GD12108@google.com>
 <1323963492.23550.1.camel@jlt3.sipsolutions.net>
 <20111215183537.GA32002@google.com>
 <1323974620.1082.7.camel@jlt3.sipsolutions.net>
 <20111215191212.GD32002@google.com>
 <1323977161.1082.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323977161.1082.12.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 15, 2011 at 08:26:01PM +0100, Johannes Berg wrote:
> Ah. So fundamentally, the freeze code does:
> 
>  * set each gcwq frozen
>  * set max_active=0 for each CWQ in each WQ

Yeap and then iterate over them waiting for all nr_actives to drop to
zero.

> but it interleaves the two loops. I guess this would have to be
> untangled if we want to share it so it sets all gcwq frozen and then
> iterates the workqueues and their CWQs. Locking seems a bit hairy
> though, why does the current code keep the GCWQ lock over CWQ changes? I
> guess that's so nothing can work on the CWQ?

All CWQ's are protected by the corresponding GCWQ lock, so all CWQs on
the same CPU are protected by single gcwq->lock on that CPU.  It's
actually rather simple.  The reason the loop there is interleaved is
to avoid releasing and grabbing different gcwq->lock's for each
iteration.  I don't think that would really matter either way.

Thanks.

-- 
tejun
