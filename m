Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2FMWIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:08:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2FMWIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:08:10 -0400
Date: Wed, 13 Jun 2012 15:08:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/2] msync: support syncing a small part of the file
Message-Id: <20120613150809.44149ef6.akpm@linux-foundation.org>
In-Reply-To: <1339624293.2080.24.camel@knife>
References: <1338497035-13014-1-git-send-email-pbonzini@redhat.com>
	<1338497035-13014-2-git-send-email-pbonzini@redhat.com>
	<20120613142614.6af42ef5.akpm@linux-foundation.org>
	<1339624293.2080.24.camel@knife>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012 15:51:33 -0600
Zan Lynx <zlynx@acm.org> wrote:

> On Wed, 2012-06-13 at 14:26 -0700, Andrew Morton wrote:
> > On Thu, 31 May 2012 22:43:54 +0200
> > Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > > msync does not need to flush changes to the entire file, even with MS_SYNC.
> > > Instead, it can use vfs_fsync_range to only synchronize a part of the file.
> > > 
> > > In addition, not all metadata has to be synced; msync is closer to
> > > fdatasync than it is to msync.  So, pass 1 to vfs_fsync_range.
> > 
> > Would be nice, but if applications were previously assuming that an
> > msync() was syncing the whole file, this patch will secretly and subtly
> > break them.  Convince me that this change won't weaken anyone's data
> > integrity ;)
> 
> As an interested observer and a programmer who uses msync()...
> 
> I never assumed msync() did the whole file.

OK, that's one user accounted for.  3 million to go.

Look, I'm not terribly averse to the change, but it does have this
risk.  And it's a nasty risk because anyone who is hit by it simply
will not know that his applcation has lost some of its data integrity.

> It has an address and length
> argument. I always assumed it only looked for dirty pages within that
> range. That is also what the msync() documentation claims.
> 
> As for weakening data integrity because of assumptions programmers *may*
> have made, I think this is a bad argument which followed to its logical
> conclusion can only lead to requiring an implicit sync() before and
> after every system call. :-)

No, not at all.  The issue is the *removal* of a side-effect upon which
some apps/designers may have been depending.  Perhaps unintentionally!

