Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab2AKQUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:20:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57945 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2AKQTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:19:48 -0500
Date: Wed, 11 Jan 2012 16:19:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Ted Ts'o" <tytso@mit.edu>, Miklos Szeredi <mszeredi@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [git pull] vfs pile 1
Message-ID: <20120111161934.GH23916@ZenIV.linux.org.uk>
References: <20120105022318.GG23916@ZenIV.linux.org.uk>
 <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
 <20120111115846.GA2646@infradead.org>
 <1326285382.13736.4.camel@tucsk.pomaz.szeredi.hu>
 <20120111124001.GA834@infradead.org>
 <1326287556.13736.12.camel@tucsk.pomaz.szeredi.hu>
 <20120111152337.GA4589@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111152337.GA4589@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 10:23:37AM -0500, Ted Ts'o wrote:
> On Wed, Jan 11, 2012 at 02:12:36PM +0100, Miklos Szeredi wrote:
> > > Yes.  a) really isn't an option - we don't want to spew thousands of
> > > useless messages during a log recovery for an operation that's totally
> > > normal.  b) is okay, too - but it's not just xfs that needs to be
> > > covered, but any fs that support the concept of recovering from open
> > > but unlinked inodes after a crash.  It's just that no one else seems
> > > to have regular QA for that code path.
> > 
> > Since it's a ratelimited printk there won't be thousands of messages.  I
> > think this is just a cosmetic issue and lack of QA isn't a problem.  If
> > the messages are bothersome it can be fixed.
> 
> We're going to spew messages in ext3/4 for orphan inodes as well
> (thanks for Cristoph for pointing that out).  I can put in a similar
> kludge, but maybe there should be a _set_nlink() that skips the check?
> We do our own more sophisticated check in and will do appropriate
> error handling in ext4_iget() anyway, so it's just a waste in that
> particular codepath anyway.

Looking at the callers, I'm not sure we want that warning in set_nlink()
at all, rate-limited or not.  Note that it can trigger on the things
like stale NFS fhandle coming in for something that had been deleted
a while ago - IOW, it's neither a kernel bug nor fs corruption.
inc_nlink - sure, that might catch real bugs, drop_nlink - definitely,
but this...
