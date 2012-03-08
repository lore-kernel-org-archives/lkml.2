Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab2CHWpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:45:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab2CHWp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:45:28 -0500
Date: Thu, 8 Mar 2012 14:45:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Tyler Hicks <tyhicks@canonical.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, jboyer@redhat.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] hugetlbfs: lockdep annotate root inode properly
Message-Id: <20120308144526.addeaaf1.akpm@linux-foundation.org>
In-Reply-To: <20120308223333.GA21766@redhat.com>
References: <1331198116-13670-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20120308130256.c7855cbd.akpm@linux-foundation.org>
	<20120308211926.GB6546@boyd>
	<20120308134050.f53a0b2f.akpm@linux-foundation.org>
	<20120308214951.GB23916@ZenIV.linux.org.uk>
	<20120308141938.1d04afb7.akpm@linux-foundation.org>
	<20120308223333.GA21766@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012 17:33:34 -0500
Dave Jones <davej@redhat.com> wrote:

> On Thu, Mar 08, 2012 at 02:19:38PM -0800, Andrew Morton wrote:
>  > On Thu, 8 Mar 2012 21:49:52 +0000
>  > Al Viro <viro@ZenIV.linux.org.uk> wrote:
>  > 
>  > > > So we need to pull the i_mutex out of hugetlbfs_file_mmap().
>  > > 
>  > > IIRC, you have a patch in your tree doing just that...
>  > 
>  > Nope.
>  > 
>  > But it seems that you've recently seen such a patch - can you recall
>  > where?
> 
> this ? https://lkml.org/lkml/2012/2/23/64
> 

Thanks, yes, probably that.  Needs the i_size_read()/write() changes.

I worry a bit about the region handling code in mm/hugetlb.c.  

 * The region data structures are protected by a combination of the mmap_sem
 * and the hugetlb_instantion_mutex.  To access or modify a region the caller
 * must either hold the mmap_sem for write, or the mmap_sem for read and
 * the hugetlb_instantiation mutex:

I hope that's true - it would be nice to have some debug assertions in
the various region_foo() functions to verify that the required locks are
held.

But if that code is all nice and tight, I guess that removing that
i_mutex acquisition will be pretty simple.

