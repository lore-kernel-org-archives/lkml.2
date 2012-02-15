Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061Ab2BONcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:32:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758330Ab2BONcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:32:12 -0500
Message-ID: <4F3BB3D3.7060401@redhat.com>
Date: Wed, 15 Feb 2012 15:32:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Alexander Graf <agraf@suse.de>, Anthony Liguori <anthony@codemonkey.ws>,
        KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F313354.4080401@redhat.com> <20120212161034.9d8f68df72f6c28298cdcd33@gmail.com>
In-Reply-To: <20120212161034.9d8f68df72f6c28298cdcd33@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2012 09:10 AM, Takuya Yoshikawa wrote:
> Avi Kivity <avi@redhat.com> wrote:
>
> > > >  Slot searching is quite fast since there's a small number of slots, and we sort the larger ones to be in the front, so positive lookups are fast.  We cache negative lookups in the shadow page tables (an spte can be either "not mapped", "mapped to RAM", or "not mapped and known to be mmio") so we rarely need to walk the entire list.
> > >
> > > Well, we don't always have shadow page tables. Having hints for unmapped guest memory like this is pretty tricky.
> > > We're currently running into issues with device assignment though, where we get a lot of small slots mapped to real hardware. I'm sure that will hit us on x86 sooner or later too.
> > 
> > For x86 that's not a problem, since once you map a page, it stays mapped 
> > (on modern hardware).
> > 
>
> I was once thinking about how to search a slot reasonably fast for every case,
> even when we do not have mmio-spte cache.
>
> One possible way I thought up was to sort slots according to their base_gfn.
> Then the problem would become:  "find the first slot whose base_gfn + npages
> is greater than this gfn."
>
> Since we can do binary search, the search cost is O(log(# of slots)).
>
> But I guess that most of the time was wasted on reading many memslots just to
> know their base_gfn and npages.
>
> So the most practically effective thing is to make a separate array which holds
> just their base_gfn.  This will make the task a simple, and cache friendly,
> search on an integer array:  probably faster than using *-tree data structure.

This assumes that there is equal probability for matching any slot.  But
that's not true, even if you have hundreds of slots, the probability is
much greater for the two main memory slots, or if you're playing with
the framebuffer, the framebuffer slot.  Everything else is loaded
quickly into shadow and forgotten.

> If needed, we should make cmp_memslot() architecture specific in the end?

We could, but why is it needed?  This logic holds for all architectures.

-- 
error compiling committee.c: too many arguments to function

