Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0FUSoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 14:44:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61001 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0FUSoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 14:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NewgGNO+iPntOPOhoxDfCrZ4s+Hmw02NZ+z6dZbF1WcQXBBZ+KjqYNMhEhKtfTnNfq
         8PTZShYmXT8gic8/Sb3jUmLptoc6RV1BUu4h0LpbSxS3Ki8WIDgD8fqQahdN23n7H63c
         /Hk5DlWbbYK3Lg5qJclKmD5NgBRSeKV5Gwgp8=
Date: Mon, 21 Jun 2010 20:41:54 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Peter Zijlstra <peterz@infradead.org>, Xiaotian Feng <dfeng@redhat.com>,
       Dan Carpenter <error27@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H.Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [patch] x86, pat: freeing invalid memtype messages
Message-ID: <20100621184154.GA3380@joi.lan>
References: <4C1B1691.6020809@redhat.com>
 <20100618175726.GA2785@joi.lan>
 <4C1F455E.6050502@redhat.com>
 <1277118155.1875.508.camel@laptop>
 <4C1F47EF.2060509@redhat.com>
 <20100621153303.GA2754@joi.lan>
 <1277134873.1875.520.camel@laptop>
 <1277142860.3017.22.camel@sbs-t61.sc.intel.com>
 <AANLkTilXM-6fIvU8TYADyyxxyg-6eIclkzfeT4vvBVJY@mail.gmail.com>
 <AANLkTimPFZiL7_Z-IIMj6NpuyzsJ4fZYvMD_q5o4E0Mq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimPFZiL7_Z-IIMj6NpuyzsJ4fZYvMD_q5o4E0Mq@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 11:38:27AM -0700, Venkatesh Pallipadi wrote:
> On Mon, Jun 21, 2010 at 11:08 AM, Venkatesh Pallipadi <venki@google.com> wrote:
> > On Mon, Jun 21, 2010 at 10:54 AM, Suresh Siddha
> > <suresh.b.siddha@intel.com> wrote:
> >> On Mon, 2010-06-21 at 08:41 -0700, Peter Zijlstra wrote:
> >>> On Mon, 2010-06-21 at 17:33 +0200, Marcin Slusarz wrote:
> >>> > On Mon, Jun 21, 2010 at 07:07:27PM +0800, Xiaotian Feng wrote:
> >>> > > On 06/21/2010 07:02 PM, Peter Zijlstra wrote:
> >>> > > > On Mon, 2010-06-21 at 18:56 +0800, Xiaotian Feng wrote:
> >>> > > >
> >>> > > >> I guess there might be something wrong between the augmented rbtree insert/remove ..
> >>> > > >
> >>> > > > The easiest thing is to revert that change and try again, the next step
> >>> > > > would be to print the full RB tree on each modification and look where
> >>> > > > it goes wrong.
> >>> > > >
> >>> > > > That said, I did print my fair share of (augmented) RB trees while
> >>> > > > playing with scheduler patches and I can't remember it ever having
> >>> > > > messed up like that.
> >>> > > He's using 2.6.35-rc2+, without your "rbtree: Undo augmented trees
> >>> > > performance damage" patch ;-)
> >>> >
> >>> > I applied it manually (commit 2463eb8b3093995e09a0d41b3d78ee0cf5fb4249 from -tip)
> >>> > to 2.6.35-rc3 and it fixed both acpi's and nouveau's "invalid memtype" messages.
> >>> > Thanks.
> >>>
> >>> Oh neat, so it actually fixes a bug in the previous augmented rb-tree
> >>> implementation?
> >>
> >> When I was reviewing your fix, it looked like that prior to your fix we
> >> were re-augmenting only at points where we do the tree rotations/color
> >> change and at the points of node insertion/removal. I don't think we
> >> were re-augmenting all the parent nodes in the path of the selected-node
> >> that is going to replace the deleted node.
> >>
> >> Perhaps we were hitting this issue here.
> >>
> >
> > rb_erase was calling the augment callback with successor_parent_cb.
> > That should be doing proper re-augmenting on delete.
> >
> > May be we are hitting the problem with not-initializing
> > subtree_max_end on insert? That was fixed in a later patch.
> 
> Here's the patch I was referring to
> http://marc.info/?l=linux-mm-commits&m=127654225011850&w=2
> 
> Marcin: Can you try this patch without Peter's patch and see whether
> there are any issues with that. Just to make sure we don't have issues
> wuth underlying augmented rbtree algorithm that somehow got fixed or
> masked for the time being with Peter's change.

I tested this patch few days ago and it produced even more "invalid memtype" messages...

Marcin

