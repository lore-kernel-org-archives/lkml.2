Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780Ab1LOXHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:07:08 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62434 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759704Ab1LOXHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:07:07 -0500
Date: Thu, 15 Dec 2011 15:07:02 -0800
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix for binary_sysctl() memory leak
Message-ID: <20111215230702.GA7527@google.com>
References: <1323917052-480-1-git-send-email-walken@google.com>
 <20111215141945.add405d5.akpm@linux-foundation.org>
 <CANN689EViJYxDRr48wK1=_Lpb62wB5tj4-fnN1-MY8y-1L33fw@mail.gmail.com>
 <20111215144411.930dd860.akpm@linux-foundation.org>
 <CANN689HNM+01fXGNijNCgWtoGEGsxBz1Hi4Z+WNYe02EiREuyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689HNM+01fXGNijNCgWtoGEGsxBz1Hi4Z+WNYe02EiREuyA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

binary_sysctl() calls sysctl_getname() which allocates from
names_cache slab usin __getname()

The matching function to free the name is __putname(), and not
putname() which should be used only to match getname() allocations.

This is because when auditing is enabled, putname() calls
audit_putname *instead* (not in addition) to __putname(). Then, if a
syscall is in progress, audit_putname does not release the name -
instead, it expects the name to get released when the syscall
completes, but that will happen only if audit_getname() was called
previously, i.e. if the name was allocated with getname() rather than
the naked __getname(). So, __getname() followed by putname() ends up
leaking memory.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 kernel/sysctl_binary.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index e8bffbe..2ce1b30 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1354,7 +1354,7 @@ static ssize_t binary_sysctl(const int *name, int nlen,
 
 	fput(file);
 out_putname:
-	putname(pathname);
+	__putname(pathname);
 out:
 	return result;
 }
-- 
1.7.3.1

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
