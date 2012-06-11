Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2FKLEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:04:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58629 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab2FKLEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:04:00 -0400
Date: Mon, 11 Jun 2012 13:04:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>, Rus <rus@sfinxsoft.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Steven Rostedt <rostedt@goodmis.org>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [WARNING] lockdep and kmemcheck_alloc_shadow
Message-ID: <20120611110359.GA17022@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	David Rientjes <rientjes@google.com>, Rus <rus@sfinxsoft.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Steven Rostedt <rostedt@goodmis.org>,
	Christoph Lameter <cl@linux.com>,
	LKML <linux-kernel@vger.kernel.org>,
	stable <stable@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>
References: <1337449661.32434.4.camel@gandalf.stny.rr.com>
 <1337485947.4107.295.camel@deadeye>
 <alpine.DEB.2.00.1205201405110.10189@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1206110255380.12414@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206110255380.12414@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Jun 11, 2012 at 02:56:03AM -0700, David Rientjes wrote:
> On Sun, 20 May 2012, David Rientjes wrote:
> 
> > Agreed, slab handles this correctly and it looks like slub ends up 
> > disabling irqs too early.
> > 
> > Does this fix it?  If so, we'll need to annotate it for stable as Ben 
> > noted.
> > 
> 
> Steven, did you have a chance to see if this fixes the issue for you?  Can 
> I add your Tested-by?

Hehe,

this got triggered through a different path too:
http://marc.info/?l=linux-kernel&m=133909780907766

@Rus: Can you pls test David's patch? I'm re-attaching it here.

Thanks.

-- 
Regards/Gruss,
Boris.

--EeQfGwPcQSOJBaQU
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="mm-slub-irq-disable-fix.diff"

From: David Rientjes <rientjes@google.com>
mm, slub: ensure irqs are not disabled for kmemcheck allocation

kmemcheck_alloc_shadow() cannot be called with irqs disabled, which is
possible with __GFP_WAIT.  Ensure we always have them enabled at
allocation time like slab does.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David Rientjes <rientjes@google.com>
---
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1314,13 +1314,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 			stat(s, ORDER_FALLBACK);
 	}
 
-	if (flags & __GFP_WAIT)
-		local_irq_disable();
-
-	if (!page)
-		return NULL;
-
-	if (kmemcheck_enabled
+	if (page && kmemcheck_enabled
 		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
 		int pages = 1 << oo_order(oo);
 
@@ -1336,6 +1330,11 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 			kmemcheck_mark_unallocated_pages(page, pages);
 	}
 
+	if (flags & __GFP_WAIT)
+		local_irq_disable();
+	if (!page)
+		return NULL;
+
 	page->objects = oo_objects(oo);
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?

--EeQfGwPcQSOJBaQU--
