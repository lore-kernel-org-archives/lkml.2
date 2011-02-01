Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab1BAPUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:20:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab1BAPUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:20:53 -0500
Subject: Re: [PATCH] flex_array: Change behaviour on zero size allocations
From: Eric Paris <eparis@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Date: Tue, 01 Feb 2011 10:20:22 -0500
In-Reply-To: <1296572145.27022.2837.camel@nimitz>
References: <20110131085213.GK3070@secunet.com>
	 <1296491497.7797.3792.camel@nimitz> <20110201102417.GL3070@secunet.com>
	 <20110201110311.GM3070@secunet.com> <1296572145.27022.2837.camel@nimitz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1296573623.3145.6.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 06:55 -0800, Dave Hansen wrote:
> On Tue, 2011-02-01 at 12:03 +0100, Steffen Klassert wrote:
> > rc = flex_array_prealloc(p->type_val_to_struct_array, 0,
> >                          p->p_types.nprim - 1, GFP_KERNEL | __GFP_ZERO);
> > if (rc)
> >         goto out;
> > 
> > If p->p_types.nprim is zero, we allocare with total_nr_elements equal
> > to zerro and then we try to prealloc with p->p_types.nprim - 1.
> > flex_array_prealloc interprets this as an unsigned int and fails,
> > because this is bigger than total_nr_elements, which is correct I
> > think.
> > 
> > Thoughts?
> 
> The most we ever hold in a flex_array is ~2 million entries.  So we have
> plenty of room to use a normal int if you want.
> 
> On the other hand, there's only one user of flex_array_prealloc(), and
> making the "end" argument inclusive doesn't seem to be what that user
> wants.  We might want to either make flex_array_prealloc() take start
> and length, or instead make "end" be exclusive of the "end" index.
>
> I thought that flex_array_prealloc would say, effectively: "all put()'s
> would work up until 'end'".  But, looking at it now, that's probably not
> how people will use it.  

I'm fine with any solution.  It's obviously broken for SELinux to be
passing -1 even if the library supported it.  I guess I don't really
have strong feelings on how to fix it.

1) make end exclusive
2) change 'end' to 'len'
3) just make selinux not prealloc() when the #elements == 0

All seem perfectly reasonable to me, but I'd probably do them in that
order.

-Eric

