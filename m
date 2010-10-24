Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab0JXGwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 02:52:54 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44850 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab0JXGwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 02:52:53 -0400
Subject: Re: [PATCH 1/6] IMA: move read/write counters into struct inode
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu,
        viro@zeniv.linux.org.uk
In-Reply-To: <1287802914.2734.44.camel@localhost.localdomain>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
	 <AANLkTikgHG+COx7Bps4NhbiLywUvPcwoQWhN1CWU6yUc@mail.gmail.com>
	 <1287802914.2734.44.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Oct 2010 02:52:47 -0400
Message-ID: <1287903168.4017.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 23:01 -0400, Eric Paris wrote:
> On Tue, 2010-10-19 at 17:25 -0700, Linus Torvalds wrote:
> > On Tue, Oct 19, 2010 at 3:58 PM, Eric Paris <eparis@redhat.com> wrote:
> > >
> > > This patch does the minimum needed to move the location of the data.  Further
> > > cleanups, especially the location of counter updates, may still be possible.
> > 
> > Hmm. The end result looks fine (adding four bytes to struct inode in
> > order to avoid all the complexity seems reasonable), but I do get the
> > feeling that this should likely be the last in the series, so that the
> > VFS level files would get minimal changes. IOW, do the cleanups inside
> > the IMA code first, and then do the switch-over to using counters in
> > the inode last.
> > 
> > Well, not last, since I think you need to do this before you can do
> > the "only allocate iint when needed" only after you've moved the
> > counters. But I think the logical order would be
> >  - switch to rbtree
> >  - drop opencount
> >  - switch counts to 'unsigned int'
> >  - drop iint->writecount and use i_writecount instead
> >  - move the remaining readcount to i_readcount
> >  - only allocate iint when necessary
> > 
> > That way you'd only have _one_ patch that touches <linux/fs.h>, rather
> > than four, and the remaining patches would all be to security/ima.
> > 
> > But maybe I missed some reason for this particular ordering.
> > 
> > Oh, and btw, due to alignment reasons it looks like the 4-byte
> > i_readcount would take 8 bytes due to bad structure packing. I don't
> > know if that is avoidable, but I do think it would make more sense to
> > put it next to i_writecount instead of in between two pointers. That
> > still doesn't help (we've got 3 32-bit values next to each other), but
> > it's at least -closer- to working out.
> 
> Believe me, this series has not been forgotten over the week.  I know
> that IBM research tested my series from yesterday and found that it
> didn't break any of their test suite but they haven't reviewed them well
> enough to give an ACK.
> 
> I probably should spend another couple of hours myself looking over my
> series before I ask for a pull from anyone but I'm willing to show my
> latest work.
> 
> http://git.infradead.org/users/eparis/ima.git
> (these patches are still being changed so don't trust this tree)
> 
> Main changes from last series:
> 1) did away with rcu altogether
> 2) added a new inode->i_flags, S_IMA which gets set when an ima
> integrity structure is allocated so common case on inode free is
> lockless.
> 3) shrunk the integrity structure more.  Now even with all of lock
> debugging turned on it's 232 bytes (most of that is a struct mutex i'm
> going to look at doing away with down the line)
> 
> -Eric

In [PATCH 08/11] IMA: only allocate iint when needed

+               if (unlikely(inode->i_readcount == 0) &&
+                   !ima_limit_imbalance(file)) {
+                       printk(KERN_INFO "%s: open/free imbalance (r:%
u)\n",
+                              __func__, inode->i_readcount);
+                       dump_stack();
+               } else {
+                       inode->i_readcount--;
+               }

Please separate the i_readcount test from the !ima_limit_imbalance()
test.

Other than this, and a couple of typos in the patch descriptions, the
patches look really nice!

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

thanks,

Mimi

