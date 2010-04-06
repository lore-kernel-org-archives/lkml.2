Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0DFP7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:59:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61448 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab0DFP7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:59:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Rz1ANlGLxWq7/1haMlr3NWX+2FnlIVIfplL8X7PhPK3upZ5RDgsRnThwXKjvND325r
         XAfvu85+WkTJd/F1//sUt67UH8qQUWDQBAq0kflMyJQT1yaYvHLs6H+4e1tyqwkh+Uv6
         JCfYbnchX6yxJGvnw17OL3sF7t1Fr4+C7KEUs=
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <4BBB55DC.8070509@redhat.com>
References: <20100402175937.GA19690@liondog.tnic>
	 <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
	 <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com>
	 <1270568096.1814.145.camel@barrios-desktop> <4BBB55DC.8070509@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 00:58:54 +0900
Message-ID: <1270569534.1814.151.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 11:40 -0400, Rik van Riel wrote:
> On 04/06/2010 11:34 AM, Minchan Kim wrote:
> 
> > Let's see the unlink_anon_vmas.
> >
> > 1. list_for_each_entry_safe(avc,next, vma->anon_vma_chain, same_vma)
> > 2. 	anon_vma_unlink
> > 3. 		spin_lock(anon_vma->lock)<-- HERE LOCK.
> > 4.		list_del(anon_vma_chain->same_anon_vma);
> >
> > What if anon_vma is destroyed and reuse by SLAB_XXX_RCU for another
> > anon_vma object between 2 and 3?
> > I mean how to make sure 3) does lock valid anon_vma?
> >
> > I hope it is culprit.
> 
> How can the anon_vma get destroyed and reused, when this
> anon_vma_chain still has a reference to it (and the

Doesn't anon_vma_chain have a ref counter on anon_vma?

> anon_vma has not been freed yet)?

AFAIK, anon_vma can be reused without free by SLAB_XXX_RCU.
So we always use it carefully by page_lock_anon_vma or manual check
with RCU and page_mapped. 

What am I missing?

> 
> What combination of circumstances is necessary for
> your bug hypothetical to happen?


	CPU A				CPU B

unlink_anon_vmas
list_for_each_entry 
				
					free_pgtable
					anon_vma_unlink
  <crazy stall>				spin_lock(anon_vma);
					list_del(same_anon_vma)
					spin_unlock(anon_vma)
anon_vma_unlink
					anon_vma_free
					reuse for another anon_vma
spin_lock(another anon_vma)
list_del(another anon_vma)

If my assumption is wrong, please correct me. 
Thanks, Rik. 

-- 
Kind regards,
Minchan Kim


