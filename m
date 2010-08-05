Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134Ab0HEK2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:28:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48148 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758642Ab0HEK2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:28:34 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-reply-to: <20100804194749.GA2134@shell> (message from Valerie Aurora on
	Wed, 4 Aug 2010 15:47:50 -0400)
Subject: Re: [PATCH 19/38] union-mount: Introduce union_dir structure and basic operations
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-20-git-send-email-vaurora@redhat.com> <E1OgfJb-0000n9-KZ@pomaz-ex.szeredi.hu> <20100804194749.GA2134@shell>
Message-Id: <E1OgxgQ-0002vU-BK@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Aug 2010 12:28:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Valerie Aurora wrote:
> > Why was the hash table concept dropped?  The header comment still
> > talks about that?
> 
> Simply, Al Viro didn't like it.  But note that the current
> implementation still uses part of the hash table solution.  You still
> have union_dir structures external to dentries for the read-only
> layers of the stack.  The change is from Al's observation that the
> topmost dentry could only be part of one stack.  Why do a lookup on
> the topmost dentry when you could keep an pointer to the stack in the
> dentry itself and skip the lookup?  Once you have the head of the
> stack, you don't need lookup for the rest of it.  This eliminates all
> the lookup machinery and the union hash table lock, which seems like a
> big win to me.

That dentry field will be unused most of the time and we lose space
for d_iname for *all* filesystems.  On 64bit this results in max
inline name going from 32 down to 24 bytes.  On my root fs 7% of names
are 24-31 in length.  That's more than triple that of names which are
more than 32 in length.

Yeah, union mounts can be configured out, but that's not much
consolation for distros which want to enable this feature.

> The biggest drawback of the hash table in my mind was that it
> introduced a new global synchronization point in lookup.  Making it go
> fast would be dcache lookup optimization all over again.

I already asked this, but I'll ask again, what about doing this with a
union filesystem?  That solves this problem in one simple go, as well
as a host of others.

I'll do some experimenting because I feel it should be possible to do
all this in a union fs with most of the advantages of union mounts.
That doesn't mean it won't need any VFS support, but I think the
amount of VFS burden can be considerably reduced with that approach at
a small price (just dentry tree duplication).

Miklos
