Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab1ALD7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 22:59:47 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53548 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932798Ab1ALD7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 22:59:43 -0500
X-Sasl-enc: uYaayNz0y/5+30iLagf8k8Yb0kxs2ae2XnircJ0yl4Wh 1294804782
Subject: Re: [announce] vfs-scale git tree update
From: Ian Kent <raven@themaw.net>
To: aelder@sgi.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1294768668.2435.177.camel@doink>
References: <20110107075831.GA14915@amd> <1294763679.2435.72.camel@doink>
	 <AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	 <1294768668.2435.177.camel@doink>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 11:59:36 +0800
Message-ID: <1294804776.2821.4.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 11:57 -0600, Alex Elder wrote:
> On Tue, 2011-01-11 at 08:51 -0800, Linus Torvalds wrote:
> > On Tue, Jan 11, 2011 at 8:34 AM, Alex Elder <aelder@sgi.com> wrote:
> > >
> > > FYI, when using this code, as merged by Linus, I hit the
> > > BUG_ON() at the beginning of d_set_d_op() when it's called
> > > by autofs4_dir_mkdir().  I managed to work around it by
> > > just commenting out those BUG_ON() calls but it's something
> > > that ought to get addressed properly.
> > 
> > Yeah, removing the BUG_ON() isn't the right thing to do - it means
> > that autofs4 is obviously setting the dentry ops twice for the same
> > dentry.
> > 
> > Possibly the thing could be relaxed to allow setting the _same_ d_op
> > pointer, ie do something like
> > 
> >    if (dentry->d_op == op)
> >       return;
> > 
> > at the top of that function. But looking at it, I don't think that
> > fixes the autofs4 issue.
> 
> That's easy enough, but it seems everybody else ensures
> this gets done just once per dentry, and it would be nice
> to preserve that "tightness" if possible.
> 
> > The fact that autofs4 does "d_add()" before it sets the d_ops (or
> > other dentry state, for that matter) looks a bit scary. To me that
> > smells like it might get a  dentry lookup hit before it's actually
> > fully done.
> 
> Agreed.

Isn't the parent i_mutex held during mkdir()?
Still the order can be changed, of course.

> 
> > Does it make any difference if you move the various d_add() calls down
> > to the end of the functions to when the "dentry" has really been
> > instantiated?
> 
> Looking at it quickly, I don't think that would matter for
> the case at hand.  I.e., that might be safer but it doesn't
> address the fact that these fields are getting initialized
> multiple times.

Yeah, a hangover from changes done over time.
Not setting the dentry op in ->lookup() should fix this.

> 
> 					-Alex
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


