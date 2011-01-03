Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1ACOze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:55:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61460 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab1ACOzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:55:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SjpHFBIRkbGcwIzKIEuheLbALYpBO7vnGVTwtzAb4SykmJAH5UwGLDtTN3fCXCSuR8
         FiY+XgGeyI/yc94TshqEjerAvF6+e8OBOvmV+B0/lLsl7vj0SZpLUymz+6qZeGFIhtPk
         l7S/8WIFdStwp1dSEA2h/QFJkBzbumSyh2J4M=
Date: Mon, 3 Jan 2011 15:44:10 +0100
From: Tejun Heo <tj@kernel.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH 24/32] dlm: dlm workqueues aren't used in memory
 reclaim path
Message-ID: <20110103144410.GT18831@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-25-git-send-email-tj@kernel.org>
 <1294063107.2429.34.camel@dolmen>
 <20110103140107.GP18831@htj.dyndns.org>
 <1294064489.2429.58.camel@dolmen>
 <20110103142734.GR18831@htj.dyndns.org>
 <1294065559.2429.84.camel@dolmen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294065559.2429.84.camel@dolmen>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 03, 2011 at 02:39:19PM +0000, Steven Whitehouse wrote:
> No, the issue arises in case an inode is being ejected from cache with a
> 0 link count (and this need deallocation). At this point the dlm is
> required in order to coordinate which node will perform the
> deallocation, but if it blocks on memory reclaim (via the fs, so
> GFP_NOFS is ok, but GFP_KERNEL is not) then it can land up calling back
> into the fs via a shrink of the dcache which can potentially then also
> call back into the dlm.

I see.  Thanks for the explanation.

> Since there is no workqueue option to indicate that GFP_NOFS is ok, but
> GFP_KERNEL is not, I think in the workqueue case we must mark it as
> WQ_MEM_RECLAIM. So far as I can tell thats a limitation of task creation
> which was the reason for the pre-allocated rescuer thread. I'd rather be
> safe than sorry in this case,

Yeap, in such case, WQ_MEM_RECLAIM seems like the right choice.  It
may call into GFP_KERNEL path again, but the dependency chain isn't
hard.  It will be broken pretty soon and rescuer will kick in.

As the case is rather special, it might be a good idea to explain why
WQ_MEM_RECLAIM is necessary for future references?

Thank you.

-- 
tejun
