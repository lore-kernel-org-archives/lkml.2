Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1LSWDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:03:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab1LSWDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:03:40 -0500
Date: Mon, 19 Dec 2011 14:03:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Eric Dumazet <eric.dumazet@gmail.com>,
        Jesper Juhl <jj@chaosbits.net>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Put braces around potentially empty 'if' body in
 handle_pte_fault()
Message-Id: <20111219140338.a05bd83d.akpm@linux-foundation.org>
In-Reply-To: <20111218011828.GA4445@p183.telecom.by>
References: <alpine.LNX.2.00.1112180059080.21784@swampdragon.chaosbits.net>
	<1324167535.3323.63.camel@edumazet-laptop>
	<20111218003419.GE2203@ZenIV.linux.org.uk>
	<20111218011828.GA4445@p183.telecom.by>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Dec 2011 04:18:28 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sun, Dec 18, 2011 at 12:34:19AM +0000, Al Viro wrote:
> > On Sun, Dec 18, 2011 at 01:18:55AM +0100, Eric Dumazet wrote:
> > > Thats should be fixed in the reverse way :
> > > 
> > > #define flush_tlb_fix_spurious_fault(vma, address) do { } while (0)
> > 
> > There's a better way to do that -
> > #define f(a) do { } while(0)
> > does not work as a function returning void -
> > 	f(1), g();
> > won't work.  OTOH
> > #define f(a) ((void)0)
> > works just fine.
> 
> Two words: static inline.

Amen.  How often must we teach ourselves this lesson?


It gets a bit messy because of:

#ifndef flush_tlb_fix_spurious_fault
#define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
#endif

But that can be handled with

static inline void flush_tlb_fix_spurious_fault(...)
{
	...
}
#define flush_tlb_fix_spurious_fault flush_tlb_fix_spurious_fault

and

#ifndef flush_tlb_fix_spurious_fault
static inline void flush_tlb_fix_spurious_fault(...)
{
}
#define flush_tlb_fix_spurious_fault flush_tlb_fix_spurious_fault
#endif
