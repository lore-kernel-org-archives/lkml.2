Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab0JWDCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 23:02:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab0JWDCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 23:02:53 -0400
Subject: Re: [PATCH 1/6] IMA: move read/write counters into struct inode
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, david@fromorbit.com, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk
In-Reply-To: <AANLkTikgHG+COx7Bps4NhbiLywUvPcwoQWhN1CWU6yUc@mail.gmail.com>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
	 <AANLkTikgHG+COx7Bps4NhbiLywUvPcwoQWhN1CWU6yUc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 23:01:54 -0400
Message-ID: <1287802914.2734.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 17:25 -0700, Linus Torvalds wrote:
> On Tue, Oct 19, 2010 at 3:58 PM, Eric Paris <eparis@redhat.com> wrote:
> >
> > This patch does the minimum needed to move the location of the data.  Further
> > cleanups, especially the location of counter updates, may still be possible.
> 
> Hmm. The end result looks fine (adding four bytes to struct inode in
> order to avoid all the complexity seems reasonable), but I do get the
> feeling that this should likely be the last in the series, so that the
> VFS level files would get minimal changes. IOW, do the cleanups inside
> the IMA code first, and then do the switch-over to using counters in
> the inode last.
> 
> Well, not last, since I think you need to do this before you can do
> the "only allocate iint when needed" only after you've moved the
> counters. But I think the logical order would be
>  - switch to rbtree
>  - drop opencount
>  - switch counts to 'unsigned int'
>  - drop iint->writecount and use i_writecount instead
>  - move the remaining readcount to i_readcount
>  - only allocate iint when necessary
> 
> That way you'd only have _one_ patch that touches <linux/fs.h>, rather
> than four, and the remaining patches would all be to security/ima.
> 
> But maybe I missed some reason for this particular ordering.
> 
> Oh, and btw, due to alignment reasons it looks like the 4-byte
> i_readcount would take 8 bytes due to bad structure packing. I don't
> know if that is avoidable, but I do think it would make more sense to
> put it next to i_writecount instead of in between two pointers. That
> still doesn't help (we've got 3 32-bit values next to each other), but
> it's at least -closer- to working out.

Believe me, this series has not been forgotten over the week.  I know
that IBM research tested my series from yesterday and found that it
didn't break any of their test suite but they haven't reviewed them well
enough to give an ACK.

I probably should spend another couple of hours myself looking over my
series before I ask for a pull from anyone but I'm willing to show my
latest work.

http://git.infradead.org/users/eparis/ima.git
(these patches are still being changed so don't trust this tree)

Main changes from last series:
1) did away with rcu altogether
2) added a new inode->i_flags, S_IMA which gets set when an ima
integrity structure is allocated so common case on inode free is
lockless.
3) shrunk the integrity structure more.  Now even with all of lock
debugging turned on it's 232 bytes (most of that is a struct mutex i'm
going to look at doing away with down the line)

-Eric

