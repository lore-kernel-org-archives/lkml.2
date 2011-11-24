Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1KXHKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 02:10:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab1KXHKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 02:10:09 -0500
Date: Thu, 24 Nov 2011 09:11:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCHv3 RFC] virtio-pci: flexible configuration layout
Message-ID: <20111124070728.GH29994@redhat.com>
References: <20111122183621.GA5235@redhat.com>
 <87hb1v1scp.fsf@rustcorp.com.au>
 <20111123084640.GE22734@redhat.com>
 <87ty5uxso3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ty5uxso3.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 11:06:44AM +1030, Rusty Russell wrote:
> Because I suspect we'll be different enough anyway, once we change the
> way we allocate the ring, and write the alignment.

Well, it'd be easy to just add pa_high.

> It'll be *clearer* to have two completely separate paths than to fill
> with if() statements.

Well, look at my patches. See how each new feature basically adds *one*
if statement.

Yes, we could declare all existing features to be required,
this is what you are advocating. But in a couple of years
more if statements have accumulated and we still don't have
a flying car. Meanwhile the driver has a huge legacy section
which is a huge pain to maintain.

> And a rewrite won't hurt the driver.

Wow. Is everyone going for the rewrite these days?
After a lot of work we will be back at the point where we left,
with a minor tweak to enable a huge number of slow devices.
Meanwhile we have no time to work on real problems,
such as ring fragmentation that Avi pointed out,
support for very large requests.


And yes it will hurt, it will hurt bisectability and testability.
What you propose is a huge patch that just changes all of it.
If there's a breakage, bisect just points at a rewrite.
What I would like to see is incremental patches. So I would like to
1. Split driver config from common config
2. Split isr/notifications out too
3. Copy config in MMIO
4. Add a new config
5. Add length checks
6. Add 64 bit features
7. Add alignment programming

At each point we can bisect.  It worked well for event index, qemu had a
flag to turn it off, each time someone came in and went 'maybe it's
event index' we just tested without.

> But to be honest I don't really care about the Linux driver: we're
> steeped in this stuff and we'll get it right.

Maybe. What about windows drivers?

> But I'm *terrified* of making the spec more complex;

All you do is move stuff around. Why do you think it simplifies the spec
so much?

> implementations will get it wrong.

Just to clarify: you assume that if virtio pci spec is changed, then
there will be many more new implementations than existing ones, so it is
worth it to make life (temporarily, for several short years) harder for
all the existing ones?

Look at the qemu side for example. The way I proposed - with optional
capabilities, each one with a separate fallback - the change can be
implemented very gradually.  Each step will be bisectable, and testable.

> I *really* want to banish the legacy stuff to an appendix where noone will
> ever know it's there :)

This does not make life easy for implementations as they
need to implement it anyway. What makes life easy is
making new features optional, so you pick just what you like.

For example, we might want to backport some new feature into
rhel6.X at some point. I would like the diff to be small,
and easily understandable in its impact.


-- 
MST
