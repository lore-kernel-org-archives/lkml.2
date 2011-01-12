Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107Ab1ALFRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:17:16 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54623 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754Ab1ALFRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:17:14 -0500
X-Sasl-enc: 4YIe6G3scrQ3teZlkLY5znIljaIqCC1zwtO+EDDQ+CUu 1294809432
Subject: Re: [announce] vfs-scale git tree update
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: aelder@sgi.com, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1294807279.2821.9.camel@perseus>
References: <20110107075831.GA14915@amd> <1294763679.2435.72.camel@doink>
	 <AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	 <1294768668.2435.177.camel@doink> <1294804776.2821.4.camel@perseus>
	 <AANLkTim8rQb3mDFHg7DmbTZa20FxRGk3wJCjOkz=JG9S@mail.gmail.com>
	 <1294807279.2821.9.camel@perseus>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 13:17:06 +0800
Message-ID: <1294809426.2821.20.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 12:41 +0800, Ian Kent wrote:
> On Tue, 2011-01-11 at 20:06 -0800, Linus Torvalds wrote:
> > On Tue, Jan 11, 2011 at 7:59 PM, Ian Kent <raven@themaw.net> wrote:
> > >
> > > Isn't the parent i_mutex held during mkdir()?
> > 
> > Yes, but a lookup that hits in the dentry cache won't actually take
> > the parent mutex.
> > 
> > So as far as I can tell, doing the "d_add()" before setting d_op can
> > result in another CPU coming in and seeing the newly added dentry
> > before d_op has actually been initialized. Exactly because it will do
> > the dentry lookup without holding any mutex.
> > 
> > Of course, it's a very small window, so it probably doesn't matter in practice.
> > 
> > >> Looking at it quickly, I don't think that would matter for
> > >> the case at hand.  I.e., that might be safer but it doesn't
> > >> address the fact that these fields are getting initialized
> > >> multiple times.
> > >
> > > Yeah, a hangover from changes done over time.
> > > Not setting the dentry op in ->lookup() should fix this.
> > 
> > Alex, care to test just removing the d_set_d_op() call from autofs4_lookup()?
> > 
> > (That code is a bit scary, though - it explicitly makes it a negative
> > dentry with a d_instantiate(dentry, NULL), and then hides the inode
> > information away separately. Scary scary)
> 
> Yeah, but the expire to mount races with autofs are difficult to handle
> and this approach has worked well under heavy stress testing. It's true
> that this would almost certainly be bad for a file system that supported
> a full range of functionality but that's not so for autofs.

I think I have to partly take this back.
With Nick's recent vfs-scale patches this may not be OK any more since
the dcache_lock has gone away and, at first glance, it looks like the
added autofs4_lock spin lock doesn't provide the needed protection.

Ian


