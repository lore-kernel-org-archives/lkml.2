Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0LWAyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 19:54:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096Ab0LWAyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 19:54:24 -0500
Date: Wed, 22 Dec 2010 16:54:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Dean Nelson <dnelson@redhat.com>
Subject: Re: [RFC 1/3] mm, Make __get_user_pages return -EHWPOISON for
 HWPOISON page optionally
Message-Id: <20101222165406.6e3f8fb0.akpm@linux-foundation.org>
In-Reply-To: <1293064800.8743.128.camel@yhuang-dev>
References: <1292986317-2805-1-git-send-email-ying.huang@intel.com>
	<1292986317-2805-2-git-send-email-ying.huang@intel.com>
	<20101222150735.c266c149.akpm@linux-foundation.org>
	<1293064800.8743.128.camel@yhuang-dev>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010 08:39:59 +0800
Huang Ying <ying.huang@intel.com> wrote:

> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -1449,9 +1449,16 @@ int __get_user_pages(struct task_struct
> > >  				if (ret & VM_FAULT_ERROR) {
> > >  					if (ret & VM_FAULT_OOM)
> > >  						return i ? i : -ENOMEM;
> > > -					if (ret &
> > > -					    (VM_FAULT_HWPOISON|VM_FAULT_HWPOISON_LARGE|
> > > -					     VM_FAULT_SIGBUS))
> > > +					if (ret & (VM_FAULT_HWPOISON |
> > > +						   VM_FAULT_HWPOISON_LARGE)) {
> > > +						if (i)
> > > +							return i;
> > > +						else if (gup_flags & FOLL_HWPOISON)
> > > +							return -EHWPOISON;
> > > +						else
> > > +							return -EFAULT;
> > > +					}
> > > +					if (ret & VM_FAULT_SIGBUS)
> > 
> > hm, that function is getting a bit unweildy.
> 
> Yes. Do you think the following code is better?
> 
> return i ? i : (gup_flags & FOLL_HWPOISON) ? -EHWPOISON : -EFAULT;

nope ;)

The function just needs to be ripped up and redone somehow.  That's not
an appropriate activity in the context of this patch though.

