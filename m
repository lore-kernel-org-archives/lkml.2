Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101Ab1ALFBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:01:15 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42023 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754Ab1ALFBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:01:13 -0500
X-Sasl-enc: oj9KxgwK6iOf2l/feb5Jz11smVEHd+CCQxFQAnNALBaj 1294808471
Subject: Re: [announce] vfs-scale git tree update
From: Ian Kent <raven@themaw.net>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: aelder@sgi.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <87aaj6u3oi.fsf@linux.vnet.ibm.com>
References: <20110107075831.GA14915@amd> <1294763679.2435.72.camel@doink>
	 <AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	 <1294768668.2435.177.camel@doink> <1294804776.2821.4.camel@perseus>
	 <87aaj6u3oi.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 13:01:04 +0800
Message-ID: <1294808464.2821.15.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 10:19 +0530, Aneesh Kumar K. V wrote:
> On Wed, 12 Jan 2011 11:59:36 +0800, Ian Kent <raven@themaw.net> wrote:
> > On Tue, 2011-01-11 at 11:57 -0600, Alex Elder wrote:
> > > On Tue, 2011-01-11 at 08:51 -0800, Linus Torvalds wrote:
> > > > On Tue, Jan 11, 2011 at 8:34 AM, Alex Elder <aelder@sgi.com> wrote:
> > > > >
> > > > > FYI, when using this code, as merged by Linus, I hit the
> > > > > BUG_ON() at the beginning of d_set_d_op() when it's called
> > > > > by autofs4_dir_mkdir().  I managed to work around it by
> > > > > just commenting out those BUG_ON() calls but it's something
> > > > > that ought to get addressed properly.
> > > > 
> > > > Yeah, removing the BUG_ON() isn't the right thing to do - it means
> > > > that autofs4 is obviously setting the dentry ops twice for the same
> > > > dentry.
> > > > 
> > > > Possibly the thing could be relaxed to allow setting the _same_ d_op
> > > > pointer, ie do something like
> > > > 
> > > >    if (dentry->d_op == op)
> > > >       return;
> > > > 
> > > > at the top of that function. But looking at it, I don't think that
> > > > fixes the autofs4 issue.
> > > 
> > > That's easy enough, but it seems everybody else ensures
> > > this gets done just once per dentry, and it would be nice
> > > to preserve that "tightness" if possible.
> > > 
> > > > The fact that autofs4 does "d_add()" before it sets the d_ops (or
> > > > other dentry state, for that matter) looks a bit scary. To me that
> > > > smells like it might get a  dentry lookup hit before it's actually
> > > > fully done.
> > > 
> > > Agreed.
> > 
> > Isn't the parent i_mutex held during mkdir()?
> > Still the order can be changed, of course.
> > 
> > > 
> > > > Does it make any difference if you move the various d_add() calls down
> > > > to the end of the functions to when the "dentry" has really been
> > > > instantiated?
> > > 
> > > Looking at it quickly, I don't think that would matter for
> > > the case at hand.  I.e., that might be safer but it doesn't
> > > address the fact that these fields are getting initialized
> > > multiple times.
> > 
> > Yeah, a hangover from changes done over time.
> > Not setting the dentry op in ->lookup() should fix this.
> > 
> 
> for 9p I did the other way round. lookup now set the dentry op for both
> negative and positive dentries and rest of the place we dropped
> d_set_d_op (b8b80cf37c7f0e32729262f805bc0fa81c3e9d12 have the details)

Sadly I can't do that.

For now I need to avoid calls to ->d_revalidate() as much as possible to
reduce a potential deadlock and have access to the flags of the negative
dentry (during create) for the purpose of blocking concurrent walks.

But, if all goes well, later changes will see the autofs
->d_revalidate() gone and consequently the potential deadlock gone as
well.

Ian


