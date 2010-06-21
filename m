Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0FUSid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 14:38:33 -0400
Received: from smtp-out.google.com ([74.125.121.35]:22963 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab0FUSib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 14:38:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=YhEVFNyI+nNKoD1pln4nD6RpkL/28z43I22MShXqqp0FUXV8nylY/GQN3/RRMdjX2
	dd8K+1ELf1ZBTTpefMe9A==
MIME-Version: 1.0
In-Reply-To: <AANLkTilXM-6fIvU8TYADyyxxyg-6eIclkzfeT4vvBVJY@mail.gmail.com>
References: <20100617134559.GA29824@bicker>
	<20100617161728.GA2741@joi.lan>
	<4C1B1691.6020809@redhat.com>
	<20100618175726.GA2785@joi.lan>
	<4C1F455E.6050502@redhat.com>
	<1277118155.1875.508.camel@laptop>
	<4C1F47EF.2060509@redhat.com>
	<20100621153303.GA2754@joi.lan>
	<1277134873.1875.520.camel@laptop>
	<1277142860.3017.22.camel@sbs-t61.sc.intel.com>
	<AANLkTilXM-6fIvU8TYADyyxxyg-6eIclkzfeT4vvBVJY@mail.gmail.com>
Date: Mon, 21 Jun 2010 11:38:27 -0700
Message-ID: <AANLkTimPFZiL7_Z-IIMj6NpuyzsJ4fZYvMD_q5o4E0Mq@mail.gmail.com>
Subject: Re: [patch] x86, pat: freeing invalid memtype messages
From: Venkatesh Pallipadi <venki@google.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Xiaotian Feng <dfeng@redhat.com>, Dan Carpenter <error27@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H.Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 11:08 AM, Venkatesh Pallipadi <venki@google.com> wrote:
> On Mon, Jun 21, 2010 at 10:54 AM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
>> On Mon, 2010-06-21 at 08:41 -0700, Peter Zijlstra wrote:
>>> On Mon, 2010-06-21 at 17:33 +0200, Marcin Slusarz wrote:
>>> > On Mon, Jun 21, 2010 at 07:07:27PM +0800, Xiaotian Feng wrote:
>>> > > On 06/21/2010 07:02 PM, Peter Zijlstra wrote:
>>> > > > On Mon, 2010-06-21 at 18:56 +0800, Xiaotian Feng wrote:
>>> > > >
>>> > > >> I guess there might be something wrong between the augmented rbtree insert/remove ..
>>> > > >
>>> > > > The easiest thing is to revert that change and try again, the next step
>>> > > > would be to print the full RB tree on each modification and look where
>>> > > > it goes wrong.
>>> > > >
>>> > > > That said, I did print my fair share of (augmented) RB trees while
>>> > > > playing with scheduler patches and I can't remember it ever having
>>> > > > messed up like that.
>>> > > He's using 2.6.35-rc2+, without your "rbtree: Undo augmented trees
>>> > > performance damage" patch ;-)
>>> >
>>> > I applied it manually (commit 2463eb8b3093995e09a0d41b3d78ee0cf5fb4249 from -tip)
>>> > to 2.6.35-rc3 and it fixed both acpi's and nouveau's "invalid memtype" messages.
>>> > Thanks.
>>>
>>> Oh neat, so it actually fixes a bug in the previous augmented rb-tree
>>> implementation?
>>
>> When I was reviewing your fix, it looked like that prior to your fix we
>> were re-augmenting only at points where we do the tree rotations/color
>> change and at the points of node insertion/removal. I don't think we
>> were re-augmenting all the parent nodes in the path of the selected-node
>> that is going to replace the deleted node.
>>
>> Perhaps we were hitting this issue here.
>>
>
> rb_erase was calling the augment callback with successor_parent_cb.
> That should be doing proper re-augmenting on delete.
>
> May be we are hitting the problem with not-initializing
> subtree_max_end on insert? That was fixed in a later patch.

Here's the patch I was referring to
http://marc.info/?l=linux-mm-commits&m=127654225011850&w=2

Marcin: Can you try this patch without Peter's patch and see whether
there are any issues with that. Just to make sure we don't have issues
wuth underlying augmented rbtree algorithm that somehow got fixed or
masked for the time being with Peter's change.

Thanks,
Venki
