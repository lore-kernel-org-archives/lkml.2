Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1DDQF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:05:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49452 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab1DDQFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:05:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :thread-index:in-reply-to:mime-version:content-type
         :content-transfer-encoding;
        b=syZX8768NQcMssPb5v9HFJCQxV6uV3z6ApRGeWVdIS3gZLdIU+p7jALX69ZHiXAIdr
         qGS+cN+xpVi9lIyEqBl/1ZmBqQZo4H1IQXuk1HF1NWExPRCt8TSvh2Er/hWFLywsSWn8
         eyFLra2jsDNLNVxr5rKjqByLuaxNIm74pOPWo=
User-Agent: Microsoft-Entourage/12.28.0.101117
Date: Mon, 04 Apr 2011 09:05:16 -0700
Subject: Re: [PATCH] MTD: Retry Read/Write Transfer Buffer Allocations
From: Grant Erickson <marathon96@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
CC: <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>
Message-ID: <C9BF3A4C.27686%marathon96@gmail.com>
Thread-Topic: [PATCH] MTD: Retry Read/Write Transfer Buffer Allocations
Thread-Index: Acvy4hY/GJ7zM1eF0U2UIoLJExZr1w==
In-Reply-To: <1301902050.2760.23.camel@localhost>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/11 12:27 AM, Artem Bityutskiy wrote:
> [CCing LKML in a hope to get good suggestions]
> [The patch: 
> http://lists.infradead.org/pipermail/linux-mtd/2011-April/034645.html]
> 
> Hi Grant,
> 
> Just in case, Jarkko was trying to address the same issue recently:
> 
> http://lists.infradead.org/pipermail/linux-mtd/2011-March/034416.html
> 
> This should be a bit more complex I think. First of all, I think it is
> better to make this a separate function. Second, you should make sure
> the system does not print scary warnings when the allocation fails - use
> __GFP_NOWARN flag, just like Jarkko did.
> 
> An third, as I wrote in my answer to Jarkko, allocating large contiguous
> buffers is bad for performance: if the system memory is fragmented and
> there is no such large contiguous areas, the kernel will start writing
> back dirty FS data, killing FS caches, shrinking caches and buggers,
> probably even swapping out applications. We do not want MTD to cause
> this at all.
> 
> Probably we can mitigate this with kmalloc flags. Now, I'm not sure what
> flags are the optimal, but I'd do:
> 
> __GFP_NOWARN | __GFP_WAIT | __GFP_NORETRY
> 
> May be even __GFP_WAIT flag could be kicked out.

Artem:

Thanks for the feedback and the link to Jarkko's very similar patch. Your
suggestions will be incorporated into a subsequent patch.

For reference, I pursued a second uses-less-memory-but-is-more-complex
approach that does get_user_pages, builds up a series of iovecs for the page
extents. This worked well for all read cases I could test; however, for the
write case, the approach required yet more refinement and overhead since the
head and tail of the transfer need to be deblocked with read-modify-write
due to the NOTALIGNED checks in nand_base.c:nand_do_write_ops. I am happy to
share the work-in-progress with the list if anyone is interested.

I propose a two-stage approach. This issue has been in the kernel for about
six years. 

Can we take a modified version of Jarkko's or my simpler fixes for the first
pass and then iterate toward the get_user_pages scatter/gather approach
later?

Best,

Grant


