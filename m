Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab2J2LaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:30:22 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:50956 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745Ab2J2LaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:30:19 -0400
Date: Mon, 29 Oct 2012 12:30:06 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] s390: Add pmd_mknotpresent()
Message-ID: <20121029123006.5eae86ea@mschwide>
In-Reply-To: <20121029110519.GA22569@gmail.com>
References: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
	<20121018182642.2a541275@thinkpad>
	<20121028131014.GA10754@gmail.com>
	<20121029084956.12b512e6@mschwide>
	<20121029110519.GA22569@gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12102911-8372-0000-0000-00000428FCB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012 12:05:19 +0100
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > On Sun, 28 Oct 2012 14:10:14 +0100
> > Ingo Molnar <mingo@kernel.org> wrote:
> > 
> > > 
> > > There's a related problem on s390: other THP implementations 
> > > have pmd_mknotpresent() while s390 not, resulting in:
> > > 
> > >   mm/huge_memory.c:1543:2: error: implicit declaration of function 'pmd_mknotpresent'
> > > 
> > > The (untested!) patch below adds the s390 version of this 
> > > method.
> > > 
> > > Gerald, Martin, did I get the S390 details right?
> > 
> > This won't work I'm afraid. S390 uses invalid bits which need 
> > to be set to make an entry not present. Just setting the 
> > _SEGMENT_ENTRY_INV bit is not good enough either, there is 
> > _HPAGE_TYPE_NONE to consider. The patch to fix this for 
> > pmd_none & pmd_present just got added to the s390 tree on 
> > kernel.org:
> >
> > https://git.kernel.org/?p=linux/kernel/git/s390/linux.git;a=shortlog;h=refs/heads/fixes
> > 
> > Now, if pmd_mknotpresent is supposed to make the entry invalid 
> > so that pmd_present will return false the function needs to do 
> > two things, 1) set the _SEGMENT_ENTRY_INV bit, and 2) clear 
> > the _SEGMENT_ENTRY_RO bit.
> 
> Would be nice if you could send me your suggested 
> pmd_mknotpresent().
> 
> (Writing it into the email would be enough, I can turn it into a 
> patch - but a patch would be welcome as well.)

This would look like the following, the patch should apply to all recent
kernel version.
--
Subject: [PATCH] s390,mm: add pmd_mknotpresent

Fix the following build problem in huge_memory:

mm/huge_memory.c:1543:2: error: implicit declaration of function 'pmd_mknotpresent'

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 335b601..4a84431 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1326,6 +1326,13 @@ static inline pmd_t pmd_mkyoung(pmd_t pmd)
 	return pmd;
 }
 
+static inline pmd_t pmd_mknotpresent(pmd_t pmd)
+{
+	pmd_val(pmd) |= _SEGMENT_ENTRY_INV;
+	pmd_val(pmd) &= ~_SEGMENT_ENTRY_RO;
+	return pmd;
+}
+
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
 static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long address, pmd_t *pmdp)
-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

