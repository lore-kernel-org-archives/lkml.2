Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0C2Q3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:29:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:44497 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab0C2Q3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:29:05 -0400
Subject: Re: KVM bug, git bisected
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4BB0D11A.607@redhat.com>
References: <4BADFD74.8060904@gmail.com>  <4BB0D11A.607@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 18:29:00 +0200
Message-ID: <1269880140.12097.356.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 12:11 -0400, Rik van Riel wrote:
> On 03/27/2010 08:43 AM, Kent Overstreet wrote:
> > commit 5beb49305251e5669852ed541e8e2f2f7696c53e
> > Author: Rik van Riel <riel@redhat.com>
> > Date: Fri Mar 5 13:42:07 2010 -0800
> >
> > mm: change anon_vma linking to fix multi-process server scalability issue
> >
> > I get this when starting kvm. The warning hasn't caused me problems, but
> > I've also been getting a scheduling while atomic panic when I start kvm
> > that I can only reproduce when I don't want to. It's definitely config
> > dependent, I'd guess preempt might have something to do with it.
> 
>  From your trace, it looks like mm_take_all_locks is taking close
> to 256 locks, which is where the preempt_count could overflow into
> the softirq count.
> 
> Since kvm-qemu is exec'd, I am guessing you have a very large
> number of VMAs in your qemu process.  Is that correct?
> 
> Peter, would it be safe to increase PREEMPT_BITS to eg. 10?

Possibly, but who's to say the thing won't bloat to 65k at which it'll
hit the vma limit, but even that can be grown beyond that.

When we started out with this I predicted this would happen, the
following was said:

---
> When we created this the promise was that kvm would only do this on a
> fresh mm with only a few vmas, has that changed?

The number of vmas did increase, but not materially.  We do link with 
more shared libraries though.
---

That was when we broke the 48 barrier (jul'09), apparently we've now
bloated to beyond 256, at this rate 10 will not last 6 months.

Alternative we remove the preempt overflow warning, it shouldn't break,
although it all is very ugly..


