Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1ACOiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:38:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910Ab1ACOiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:38:20 -0500
Subject: Re: [PATCH 24/32] dlm: dlm workqueues aren't used in memory
 reclaim path
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <20110103142734.GR18831@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	 <1294062595-30097-25-git-send-email-tj@kernel.org>
	 <1294063107.2429.34.camel@dolmen> <20110103140107.GP18831@htj.dyndns.org>
	 <1294064489.2429.58.camel@dolmen>  <20110103142734.GR18831@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 03 Jan 2011 14:39:19 +0000
Message-ID: <1294065559.2429.84.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2011-01-03 at 15:27 +0100, Tejun Heo wrote:
> Hello again,
> 
> On Mon, Jan 03, 2011 at 02:21:29PM +0000, Steven Whitehouse wrote:
> > > Ooh, I see.  Hmmm... maybe I've asked this before but do you really
> > > need WQ_MEM_RECLAIM there?  Is dlm used during memory reclaim?
> > 
> > Yes, it is in case of deallocation of inodes, so we have to be careful
> > about that,
> 
> I see.  I'm still slightly unsure about the WQ_MEM_RECLAIM rules when
> it comes to distributed file systems and stuff related to them, but I
> think it basically comes down to whether the code can be in the swap
> path or not.  e.g. for nfs backed write shared mapped files, nfs
> definitely can be used during memory reclaim _but_ it's not guaranteed
> to make forward progress under memory pressure and thus can't be
> depended upon and shouldn't be used for swap.  IOW, it may free memory
> but it's not in the critical path which should guarantee forward
> progress.  Isn't dlm the same case?
> 
> Thank you.
> 

No, the issue arises in case an inode is being ejected from cache with a
0 link count (and this need deallocation). At this point the dlm is
required in order to coordinate which node will perform the
deallocation, but if it blocks on memory reclaim (via the fs, so
GFP_NOFS is ok, but GFP_KERNEL is not) then it can land up calling back
into the fs via a shrink of the dcache which can potentially then also
call back into the dlm.

Since there is no workqueue option to indicate that GFP_NOFS is ok, but
GFP_KERNEL is not, I think in the workqueue case we must mark it as
WQ_MEM_RECLAIM. So far as I can tell thats a limitation of task creation
which was the reason for the pre-allocated rescuer thread. I'd rather be
safe than sorry in this case,

Steve.


