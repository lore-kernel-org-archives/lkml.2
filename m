Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1BVVmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:42:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:28141 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab1BVVmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:42:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=uHX8OCPXCjAXxAgXLLVF9tazw/pwBWDQcCRvRysQxwUpKO5Wm+er2fssos7JZVQ68y
         M7BmrYalIcHxKVl/oqvw==
Date: Tue, 22 Feb 2011 13:42:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        lwoodman@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/8] Add __GFP_OTHER_NODE flag
In-Reply-To: <1298315270-10434-7-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1102221333100.5929@chino.kir.corp.google.com>
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org> <1298315270-10434-7-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a new __GFP_OTHER_NODE flag to tell the low level numa statistics
> in zone_statistics() that an allocation is on behalf of another thread.
> This way the local and remote counters can be still correct, even
> when background daemons like khugepaged are changing memory
> mappings.
> 
> This only affects the accounting, but I think it's worth doing that
> right to avoid confusing users.
> 

This makes the accounting worse, NUMA_LOCAL is defined as "allocation from 
local node," meaning it's local to the allocating cpu, not local to the 
node being targeted.

Further, preferred_zone has taken on a much more significant meaning other 
than just statistics: it impacts the behavior of memory compaction and how 
long congestion timeouts are, if a timeout is taken at all, depending on 
the I/O being done on behalf of the zone.

A better way to address the issue is by making sure preferred_zone is 
actually correct by using the appropriate zonelist to be passed into the 
allocator in the first place.

> I first tried to just pass down the right node, but this required
> a lot of changes to pass down this parameter and at least one
> addition of a 10th argument to a 9 argument function. Using
> the flag is a lot less intrusive.
> 

And adding a branch to every successful page allocation for statistics 
isn't intrusive?
