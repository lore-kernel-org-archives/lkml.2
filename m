Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0IOFUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 01:20:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42151 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab0IOFUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 01:20:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH v2] After swapout/swapin private dirty mappings are reported clean in smaps
Cc: kosaki.motohiro@jp.fujitsu.com, Richard Guenther <rguenther@suse.de>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        balbir@linux.vnet.ibm.com, Michael Matz <matz@novell.com>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
In-Reply-To: <201009151034.22497.knikanth@suse.de>
References: <20100915134724.C9EE.A69D9226@jp.fujitsu.com> <201009151034.22497.knikanth@suse.de>
Message-Id: <20100915141710.C9F7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 15 Sep 2010 14:20:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday 15 September 2010 10:18:11 KOSAKI Motohiro wrote:
> > > On Wednesday 15 September 2010 05:56:36 KOSAKI Motohiro wrote:
> > > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > > index 439fc1f..06fc468 100644
> > > > > --- a/fs/proc/task_mmu.c
> > > > > +++ b/fs/proc/task_mmu.c
> > > > > @@ -368,7 +368,11 @@ static int smaps_pte_range(pmd_t *pmd, unsigned
> > > > > long addr, unsigned long end, mss->shared_clean += PAGE_SIZE;
> > > > >  			mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
> > > > >  		} else {
> > > > > -			if (pte_dirty(ptent))
> > > > > +			/*
> > > > > +			 * File-backed pages, now anonymous are dirty
> > > > > +			 * with respect to the file.
> > > > > +			 */
> > > > > +			if (pte_dirty(ptent) || (vma->vm_file && PageAnon(page)))
> > > > >  				mss->private_dirty += PAGE_SIZE;
> > > > >  			else
> > > > >  				mss->private_clean += PAGE_SIZE;
> > > >
> > > > This is risky than v1. number of dirties are used a lot of application.
> > >
> > > This is exactly to help those applications, as currently after swap-out
> > > and swap-in, the same pages are accounted as "Private_Clean:" instead of
> > > "Private_Dirty:".
> > 
> > I don't think so.
> 
> Actually this behaviour is observed. With a simple memhog, you can see pages 
> which are "Private_Dirty:", become "Swap:" and then to "Private_Clean:". And 
> that confused GDB.

As I said, incorrect information is always no good solustion. We should concern
how to provide good and enough information, but not how to lie.
If currect gdb is crappy, it should fix. 


> > incorrect infomation bring a lot of confusion rather than
> >  its worth.


