Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab0D1BuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:50:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:15272 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab0D1BuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:50:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,285,1270450800"; 
   d="scan'208";a="793398352"
Subject: Re: [PATCH 1/2] mm, Make __get_user_pages return -EHWPOISON for
 HWPOISON page
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>
In-Reply-To: <20100427144723.a8c3d997.akpm@linux-foundation.org>
References: <1272351858.24125.14.camel@yhuang-dev.sh.intel.com>
	 <20100427144723.a8c3d997.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 09:50:12 +0800
Message-ID: <1272419412.24125.124.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 05:47 +0800, Andrew Morton wrote:
> On Tue, 27 Apr 2010 15:04:18 +0800
> Huang Ying <ying.huang@intel.com> wrote:
> 
> > With this patch, the caller of __get_user_pages can distinguish
> > HWPOISON page from general FAULT page. This is needed by KVM, where
> > UCR MCE should be relayed to guest for HWPOISON page, while
> > instruction emulation and MMIO will be tried for general FAULT page.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > ---
> >  include/asm-generic/errno.h |    2 ++
> >  mm/memory.c                 |    5 +++--
> >  2 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > --- a/include/asm-generic/errno.h
> > +++ b/include/asm-generic/errno.h
> > @@ -108,4 +108,6 @@
> >  
> >  #define ERFKILL		132	/* Operation not possible due to RF-kill */
> >  
> > +#define EHWPOISON	133	/* Memory page has hardware error */
> > +
> >  #endif
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -1432,9 +1432,10 @@ int __get_user_pages(struct task_struct
> >  				if (ret & VM_FAULT_ERROR) {
> >  					if (ret & VM_FAULT_OOM)
> >  						return i ? i : -ENOMEM;
> > -					if (ret &
> > -					    (VM_FAULT_HWPOISON|VM_FAULT_SIGBUS))
> > +					if (ret & VM_FAULT_SIGBUS)
> >  						return i ? i : -EFAULT;
> > +					if (ret & VM_FAULT_HWPOISON)
> > +						return i ? i : -EHWPOISON;
> >  					BUG();
> >  				}
> >  				if (ret & VM_FAULT_MAJOR)
> > 
> 
> This will cause various code paths (eg: fs/direct-io.c) to return
> -EHWPOISON to userspace, will it not?

Yes. I think it may be returned to userspace. Do we need to keep the
userspace errno interface like this?

If it is, we can check whether the virtual page is hwpoisoned via going
through the page table because the hwpoisoned virtual page has a special
swap entry in page table.

Best Regards,
Huang Ying



