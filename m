Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0D1B6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:58:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753548Ab0D1B6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:58:53 -0400
Date: Tue, 27 Apr 2010 18:56:53 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 1/2] mm, Make __get_user_pages return -EHWPOISON for
 HWPOISON page
Message-Id: <20100427185653.e05aad55.akpm@linux-foundation.org>
In-Reply-To: <1272419412.24125.124.camel@yhuang-dev.sh.intel.com>
References: <1272351858.24125.14.camel@yhuang-dev.sh.intel.com>
	<20100427144723.a8c3d997.akpm@linux-foundation.org>
	<1272419412.24125.124.camel@yhuang-dev.sh.intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 09:50:12 +0800 Huang Ying <ying.huang@intel.com> wrote:

> On Wed, 2010-04-28 at 05:47 +0800, Andrew Morton wrote:
> > On Tue, 27 Apr 2010 15:04:18 +0800
> > Huang Ying <ying.huang@intel.com> wrote:
> > 
>
> ...
> 
> > >  				if (ret & VM_FAULT_ERROR) {
> > >  					if (ret & VM_FAULT_OOM)
> > >  						return i ? i : -ENOMEM;
> > > -					if (ret &
> > > -					    (VM_FAULT_HWPOISON|VM_FAULT_SIGBUS))
> > > +					if (ret & VM_FAULT_SIGBUS)
> > >  						return i ? i : -EFAULT;
> > > +					if (ret & VM_FAULT_HWPOISON)
> > > +						return i ? i : -EHWPOISON;
> > >  					BUG();
> > >  				}
> > >  				if (ret & VM_FAULT_MAJOR)
> > > 
> > 
> > This will cause various code paths (eg: fs/direct-io.c) to return
> > -EHWPOISON to userspace, will it not?
> 
> Yes. I think it may be returned to userspace. Do we need to keep the
> userspace errno interface like this?

I don't think we should extend the kernel interface in a non-posix
fashion without good reason and some thought.  manpages and glibc will
need to be updated, etc..

> If it is, we can check whether the virtual page is hwpoisoned via going
> through the page table because the hwpoisoned virtual page has a special
> swap entry in page table.

Spose so.  Or you could perhaps extend __get_user_pages() by adding a
new FOLL_HWPOISON and make it return -EHWPOISON only if FOLL_HWPOISON
was set, and require that the __get_user_pages(FOLL_HWPOISON) caller
rewrite -EHWPOISON to something else.  But I didn't think about that
very hard.

