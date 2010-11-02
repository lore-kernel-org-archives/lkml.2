Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab0KBUFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 16:05:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14908 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab0KBUFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 16:05:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hD4PKWda/UNOQBx4HdEe+KL2K6AcrtJMVynijTfbWLQPmFbaYBbIPcztrbON/17vma
         IVZzE9cxMAYfH1crBfgA==
Date: Tue, 2 Nov 2010 13:05:18 -0700
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/3] Retry page fault when blocking on disk transfer.
Message-ID: <20101102200518.GA9229@google.com>
References: <1286265215-9025-1-git-send-email-walken@google.com>
 <1286265215-9025-3-git-send-email-walken@google.com>
 <4CAB628D.3030205@redhat.com>
 <AANLkTimdACZ9Xm01DM2+E64+T5XfLffrkFBhf7CJ286p@mail.gmail.com>
 <20101008043956.GA25662@google.com>
 <4CAF1B90.3080703@redhat.com>
 <AANLkTinWxTT=+m_fAudc080OUMwacSefnMbSMBFZgPMH@mail.gmail.com>
 <20101009012204.GA17458@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101009012204.GA17458@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 06:22:04PM -0700, Michel Lespinasse wrote:
> Second try on adding the VM_FAULT_RETRY functionality to the swap in path.
> 
> This proposal would replace [patch 2/3] of this series (the initial
> version of it, which was approved by linus / rik / hpa).

Oh my. I've been evidently sloppy while merging the filemap and swap
versions of lock_page_or_retry(), and this issue slipped in...

Please apply attached change. Sorry for not catching this earlier :(

----------------------------- 8< --------------------------------

Release page reference during page fault retry

This slipped by when unifying the filemap and swap versions of
lock_page_or_retry()...

Signed-off-by: Michel Lespinasse <walken@google.com>
    
diff --git a/mm/filemap.c b/mm/filemap.c
index 33f8125..c479d9c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1563,8 +1563,10 @@ retry_find:
 			goto no_cached_page;
 	}
 
-	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags))
+	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags)) {
+		page_cache_release(page);
 		return ret | VM_FAULT_RETRY;
+	}
 
 	/* Did it get truncated? */
 	if (unlikely(page->mapping != mapping)) {

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
