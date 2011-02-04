Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1BDVSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:18:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab1BDVSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:18:32 -0500
Date: Fri, 4 Feb 2011 22:18:25 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>
Subject: Re: [RFC][PATCH 1/6] count transparent hugepage splits
Message-ID: <20110204211825.GJ30909@random.random>
References: <20110201003357.D6F0BE0D@kernel>
 <20110201003358.98826457@kernel>
 <alpine.DEB.2.00.1102031235100.453@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102031235100.453@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 01:22:14PM -0800, David Rientjes wrote:
> i.e. no global locking, but we've accepted the occassional off-by-one 
> error (even though splitting of hugepages isn't by any means lightning 
> fast and the overhead of atomic ops would be negligible).

Agreed losing an increment is not a problem, but in very large systems
it will become a bottleneck. It's not super urgent, but I think it
needs to become a per-cpu counter sooner than later (not needed
immediately but I would appreciate an incremental patch soon to
address that). split_huge_page is already fully SMP scalable if the
rmap isn't shared (i.e. fully SMP scalable across different execve)
and I'd like it to stay that way because split_huge_page can run at
high frequency at times from different processes, so in very large
systems it may be measurable, with that cacheline bouncing around 1024
cpus. pages_collapsed is not a problem because it's only used by one
kernel thread so it can't be contended. Again not super urgent but
better to optimize it ;).
