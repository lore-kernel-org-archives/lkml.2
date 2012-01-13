Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab2AMCUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 21:20:40 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63096 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab2AMCUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 21:20:37 -0500
Date: Thu, 12 Jan 2012 19:20:34 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, sfr@canb.auug.org.au,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 13/14] irq_domain: Remove 'new' irq_domain in favour of the
 ppc one
Message-ID: <20120113022034.GA25999@ponder.secretlab.ca>
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
 <1326313337-24603-14-git-send-email-grant.likely@secretlab.ca>
 <4F0DFC0F.2090005@gmail.com>
 <CACxGe6vVSO0cTgPurr6jFoo9QF_W02UaABOFYadCTQGU9dcwmg@mail.gmail.com>
 <4F0F7B60.5040701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0F7B60.5040701@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 06:31:28PM -0600, Rob Herring wrote:
> Adding lakml...
> 
> On 01/11/2012 03:27 PM, Grant Likely wrote:
> > On Wed, Jan 11, 2012 at 2:15 PM, Rob Herring <robherring2@gmail.com> wrote:
> >> Grant,
> >>
> >> On 01/11/2012 02:22 PM, Grant Likely wrote:
> >>> This patch removes the simplistic implementation of irq_domains and enables
> >>> the powerpc infrastructure for all irq_domain users.  The powerpc
> >>> infrastructure includes support for complex mappings between Linux and
> >>> hardware irq numbers, and can manage allocation of irq_descs.
> >>>
> >>> This patch also converts the few users of irq_domain_add()/irq_domain_del()
> >>> to call irq_domain_add_legacy() instead.
> >>
> >> So what is the non-legacy way? Legacy implies we don't want to do it
> >> that way. I guess until we remove all non-DT platforms with GIC we are
> >> stuck with legacy. That seems like it could be a ways out until we get
> >> there.
> > 
> > Non-legacy is letting the irq_domain manage the irq_desc allocations.
> > Some of the controllers will be easy to convert, some will be more
> > difficult.  The primary thing that really blocks getting away from the
> > legacy method is anything that expects hardcoded #defined irq numbers.
> >  The goal is to convert all users over to the linear revmap method.
> > 
> 
> So I gave this a spin on highbank. I ran into a couple problems.
> 
> I had to revert "irqdesc: Consolidate irq reservation logic" which is in
> your branch, but not this series. irq_alloc_desc_from was returning -EEXIST.

Gah, I flubbed that patch too.  Try this on top of it:

---

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 8a9e2ec..11feb2f 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -375,6 +375,9 @@ __irq_reserve_irqs(int irq, unsigned int from, unsigned int cnt)
 	}
 
 	bitmap_set(allocated_irqs, start, cnt);
+	mutex_unlock(&sparse_irq_lock);
+	return start;
+
 err:
 	mutex_unlock(&sparse_irq_lock);
 	return ret;
@@ -408,7 +411,8 @@ EXPORT_SYMBOL_GPL(__irq_alloc_descs);
  */
 int irq_reserve_irqs(unsigned int from, unsigned int cnt)
 {
-	return __irq_reserve_irqs(from, from, cnt);
+	int start = __irq_reserve_irqs(from, from, cnt);
+	return start < 0 ? start : 0;
 }
 
 /**
