Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab0FXOgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:36:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511Ab0FXOga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:36:30 -0400
Date: Fri, 25 Jun 2010 00:36:25 +1000
From: Nick Piggin <npiggin@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, drepper@redhat.com,
       torvalds@linux-foundation.org
Subject: Re: [rfc] new stat*fs-like syscall?
Message-ID: <20100624143625.GB10441@laptop>
References: <20100624131455.GA10441@laptop>
 <E1ORn1F-00088t-9N@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ORn1F-00088t-9N@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 04:03:05PM +0200, Miklos Szeredi wrote:
> On Thu, 24 Jun 2010, Nick Piggin wrote:
> > This has come up a few times in the past, and I'd like to try to get
> > an agreement on it. statvfs(2) importantly contains f_flag (mount
> > flags), and is encouraged to use rather than statfs(2). The kernel
> > provides a statfs syscall only.
> > 
> > This means glibc has to provide f_flag support by parsing /proc/mounts
> > and stat(2)ing mount points. This is really slow, and /proc/mounts is
> > hard for the kernel to provide. It's actually the last scalability
> > bottleneck in the core vfs for dbench (samba) after my patches.
> > 
> > Not only that, but it's racy.
> > 
> > Other than types, other differences are:
> > - statvfs(2) has is f_frsize, which seems fairly useless.
> 
> statfs(2) also has f_frsize since 2.6.0, only it hasn't been
> documented (should be fixed now).
> 
> > - statvfs(2) has f_favail.
> > - statfs(2) f_bsize is optimal transfer block, statvfs(2) f_bsize is fs
> >   block size. The latter could be useful for disk space algorithms.
> >   Both can be ill defned.
> 
> They are the same, only the documentation is different.
> 
> > - statvfs(2) lacks f_type.
> > 
> > Is there anything more we should add here? Samba wants a capabilities
> > field, with things like sparse files, quotas, compression, encryption,
> > case preserving/sensitive.
> > 
> > Any thoughts?
> 
> "struct statfs" and "struct statfs64" have spare fields.  We could put
> the f_flag in there including a magic "this is a valid f_flag" flag,
> that distinguishes from the default zero value.

Ah so it does. We have 5 words spare. So we should have a version
number rather than just do a per-word hack each time. We could
probably pack the version number into a few bits of f_flag though.

