Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1A0XHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:07:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157Ab1A0XH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:07:29 -0500
Date: Thu, 27 Jan 2011 15:07:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Dean Nelson <dnelson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/2] mm, Make __get_user_pages return -EHWPOISON for
 HWPOISON page optionally
Message-Id: <20110127150705.f2cfe235.akpm@linux-foundation.org>
In-Reply-To: <1296113345.15213.87.camel@yhuang-dev>
References: <1294908168.4596.58.camel@yhuang-dev>
	<4D2ED737.6050802@redhat.com>
	<1294969036.4596.67.camel@yhuang-dev>
	<4D331054.4030206@redhat.com>
	<1295225259.10748.3.camel@yhuang-dev>
	<20110120155021.GA5996@amt.cnet>
	<1296113345.15213.87.camel@yhuang-dev>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 15:29:05 +0800
Huang Ying <ying.huang@intel.com> wrote:

> Hi, Andrew,
> 
> On Thu, 2011-01-20 at 23:50 +0800, Marcelo Tosatti wrote:
> > On Mon, Jan 17, 2011 at 08:47:39AM +0800, Huang Ying wrote:
> > > Hi, Andrew,
> > > 
> > > On Sun, 2011-01-16 at 23:35 +0800, Avi Kivity wrote:
> > > > On 01/14/2011 03:37 AM, Huang Ying wrote:
> > > > > On Thu, 2011-01-13 at 18:43 +0800, Avi Kivity wrote:
> > > > > >  On 01/13/2011 10:42 AM, Huang Ying wrote:
> > > > > >  >  Make __get_user_pages return -EHWPOISON for HWPOISON page only if
> > > > > >  >  FOLL_HWPOISON is specified.  With this patch, the interested callers
> > > > > >  >  can distinguish HWPOISON page from general FAULT page, while other
> > > > > >  >  callers will still get -EFAULT for pages, so the user space interface
> > > > > >  >  need not to be changed.
> > > > > >  >
> > > > > >  >  get_user_pages_hwpoison is added as a variant of get_user_pages that
> > > > > >  >  can return -EHWPOISON for HWPOISON page.
> > > > > >  >
> > > > > >  >  This feature is needed by KVM, where UCR MCE should be relayed to
> > > > > >  >  guest for HWPOISON page, while instruction emulation and MMIO will be
> > > > > >  >  tried for general FAULT page.
> > > > > >  >
> > > > > >  >  The idea comes from Andrew Morton.
> > > > > >  >
> > > > > >  >  Signed-off-by: Huang Ying<ying.huang@intel.com>
> > > > > >  >  Cc: Andrew Morton<akpm@linux-foundation.org>
> > > > > >  >
> > > > > >  >  +#ifdef CONFIG_MEMORY_FAILURE
> > > > > >  >  +int get_user_pages_hwpoison(struct task_struct *tsk, struct mm_struct *mm,
> > > > > >  >  +			    unsigned long start, int nr_pages, int write,
> > > > > >  >  +			    int force, struct page **pages,
> > > > > >  >  +			    struct vm_area_struct **vmas);
> > > > > >  >  +#else
> > > > > >
> > > > > >  Since we'd also like to add get_user_pages_noio(), perhaps adding a
> > > > > >  flags field to get_user_pages() is better.
> > > > >
> > > > > Or export __get_user_pages()?
> > > > 
> > > > That's better, yes.
> > > 
> > > Do you think it is a good idea to export __get_user_pages() instead of
> > > adding get_user_pages_noio() and get_user_pages_hwpoison()?
> > 
> > Better Andrew and/or Linus should decide it.
> 
> We really need your comments about this.
> 

Export __get_user_pages(), I guess.  We don't need hwpoison/kvm-specific
stuff in mm/memory.c and
get_user_pages_hwpoison()/get_user_pages_noio() are very thin
wrappers.

The number of args to these functions is getting nutty - you'll
probably find that it is beneficial to inline these wrapepr functions, if
the number of callsites is small.

