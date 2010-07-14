Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab0GNOGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:06:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680Ab0GNOGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:06:53 -0400
Date: Wed, 14 Jul 2010 11:06:26 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: MMU: track dirty page in speculative path
 properly
Message-ID: <20100714140626.GA28485@amt.cnet>
References: <4C3C3518.7080505@cn.fujitsu.com>
 <4C3C35B7.50101@cn.fujitsu.com>
 <20100713220551.GB6370@amt.cnet>
 <4C3D11C6.4000101@cn.fujitsu.com>
 <20100714110926.GA26033@amt.cnet>
 <4C3DB942.3010709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3DB942.3010709@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 09:18:58PM +0800, Xiao Guangrong wrote:
> 
> 
> Marcelo Tosatti wrote:
> > On Wed, Jul 14, 2010 at 09:24:22AM +0800, Xiao Guangrong wrote:
> >>
> >> Marcelo Tosatti wrote:
> >>> On Tue, Jul 13, 2010 at 05:45:27PM +0800, Xiao Guangrong wrote:
> >>>> In speculative path, the page is not real write-access, no need mark it
> >>>> dirty, so clear dirty bit in this path and later examine this bit when
> >>>> we release the page
> >>>>
> >>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> >>>> ---
> >>>>  arch/x86/kvm/mmu.c |   24 +++++++++++-------------
> >>>>  1 files changed, 11 insertions(+), 13 deletions(-)
> >>> Unfortunately all pages that kvm creates translations for are marked
> >>> dirty due to get_user_pages(w=1), except KSM which makes them read-only
> >>> later.
> >> Marcelo, i have looked into get_user_pages() function, but not catch where
> >> to make page dirty, could you point it out for me? :-)
> > 
> > See set_page_dirty call in mm/memory.c::follow_page.
> 
> Yeah, you are right, and i want to use another way to do it since track dirty bit
> is too heavy, also it's dangerous if we miss to set page dirty.
> 
> How about just track access bit for speculative path, we set page both accessed and
> dirty(if it's writable) only if the access bit is set?

A useful thing to do would be to allow read-only mappings, in the fault
path (Lai sent a few patches in that direction sometime ago but there
was no follow up).

So in the case of a read-only fault from the guest, you'd inform
get_user_pages() that read-only access is acceptable (so swapcache pages
can be mapped, or qemu can mprotect(PROT_READ) guest memory).

