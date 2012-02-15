Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab2BOOjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:39:41 -0500
Received: from gw.danplanet.com ([50.43.125.66]:41552 "EHLO mail.danplanet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754257Ab2BOOjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:39:40 -0500
From: Dan Smith <danms@us.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ensure that walk_page_range()'s start and end are page-aligned
References: <1328902796-30389-1-git-send-email-danms@us.ibm.com>
	<alpine.DEB.2.00.1202130211400.4324@chino.kir.corp.google.com>
	<87zkcm23az.fsf@caffeine.danplanet.com>
	<alpine.DEB.2.00.1202131350500.17296@chino.kir.corp.google.com>
	<87pqdh1mvs.fsf@caffeine.danplanet.com>
	<alpine.DEB.2.00.1202141259420.28450@chino.kir.corp.google.com>
Date: Wed, 15 Feb 2012 06:39:37 -0800
In-Reply-To: <alpine.DEB.2.00.1202141259420.28450@chino.kir.corp.google.com>
	(David Rientjes's message of "Tue, 14 Feb 2012 13:04:45 -0800 (PST)")
Message-ID: <87lio417py.fsf@caffeine.danplanet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DR> And do what if they're not?  What behavior are you trying to fix
DR> from the pagewalk code with respect to page-aligned addresses?  Any
DR> specific examples?

Sorry, I thought I detailed this in the patch header.

In walk_pte_entry(), the exit condition is when the end address is equal
to the start address + n*PAGE_SIZE. If they're not both page aligned,
then we'll never exit the loop and we'll start handing bad pte entries
to the handler function.

As was pointed out earlier in the thread, we could "solve" this by
making the exit condition be > instead of ==. However, that changes the
entirety of walk_page_range() from requiring page-aligned attributes to
silently tolerating them. IMHO, it's better to just
declare/check/enforce that they are.

I hit this recently because I was working with a prototype syscall that
took an address range from userspace and walked the pages. I ended up
passing non-page-aligned addresses, not knowing that walk_page_range()
needed it, and it took me a few days to figure out why my pte_entry
handler got a few good entries and then garbage until I crashed. I
turned on DEBUG_VM and got zero additional help. With the proposed
patch, I would have received a helpful smack in the head.

Does that make sense?

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com
