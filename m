Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab0JSSQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:16:49 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56180 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0JSSQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:16:46 -0400
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20101019172805.GU19804@ZenIV.linux.org.uk>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
	 <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
	 <1287506215.2530.187.camel@localhost.localdomain>
	 <20101019165530.GT19804@ZenIV.linux.org.uk>
	 <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
	 <20101019172805.GU19804@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 14:16:22 -0400
Message-ID: <1287512182.3167.130.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 18:28 +0100, Al Viro wrote:
> On Tue, Oct 19, 2010 at 10:03:48AM -0700, Linus Torvalds wrote:
> > On Tue, Oct 19, 2010 at 9:55 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > a) i_writecount is about VM_DENYWRITE, basically. ?Reusing it for ima could
> > > get unpleasant; when it's positive, we are fine, but it can get negative as
> > > well. ?IMA will have interesting time dealing with that.
> > >
> > > b) i_count is simply a refcount for struct inode. ?Not exactly the number
> > > of dentries, but that's the main contributor. ?Basically, that's "how many
> > > pointers outside of inode hash chains point that that struct inode at the
> > > moment".
> > 
> > My question was deeper. More along the lines of "why would IMA care?"
> > 
> > How/why could IMA ever care about the pointless and trivial
> > differences between its current private open/read/write counts and the
> > counts that we already maintain?
> > 
> > Yes, yes, I realize that they have technical differences in what they
> > count. That's not the question. The question is "Why would IMA care?"

The filesystem prevents files being executed from being opened for
write.  The same guarantees that the file won't change, obviously,
doesn't exist for files being opened for read. Thus measuring a file
opened for read that has already been open for write, has no meaning.
Unfortunately, since the inode counters don't provide this information,
IMA maintains a separate set of counters.

> I'd rather not say what I think about IMA sanity (and usefulness); as for what
> it tries to do...  They want to whine if you open a file that is already opened
> for write and they want to whine if you open a file for write when it's already
> opened for read.  Unless they decide to leave the file alone, that is.

You left out one minor detail, invalidate the PCR as well.

Mimi

