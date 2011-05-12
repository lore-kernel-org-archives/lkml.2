Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab1ELPUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:20:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754518Ab1ELPUX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:20:23 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTin6Ujea+qdkvwkH_9o5F8WKPyFdyA@mail.gmail.com>
References: <87fwokarjj.fsf@tucsk.pomaz.szeredi.hu> <BANLkTin6Ujea+qdkvwkH_9o5F8WKPyFdyA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 May 2011 08:19:30 -0700
Message-ID: <BANLkTi=4rdtB5dQH=tycT1sybe7iJmTVcA@mail.gmail.com>
Subject: Re: [GIT PULL] fuse fix for 2.6.39
To: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ooh.

It's "lookup_one_len()", isn't it?

So any filesystem that uses that helper will need to be protected from
a NULL 'nd'.

And then you have nfsd, ecryptfs and cachefiles that will do it on
_other_ filesystems.

Gaah. Ugly. So either we really should fix the filesystems that don't
have protection from a NULL nd, or we should fix lookup_one_len() (are
there perhaps other cases I missed?)

Al? Christoph? Comments?

                            Linus

On Thu, May 12, 2011 at 8:12 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Hmm.
>
> Do we really ever have a NULL 'nd' these days? Can you send me the
> backtrace for whatever oops that was reported?
>
> The reason I ask is because at least NFS also does just
>
>        if (nd->flags & LOOKUP_RCU)
>                return -ECHILD;
>
> in its nfs_lookup/open_revalidate() functions. As does cifs, ncpfs, p9
> and coda from a quick grep.
>
>                        Linus
>
> On Thu, May 12, 2011 at 8:04 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> Please pull from
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus
>>
>> Miklos Szeredi (1):
>>      fuse: fix oops in revalidate when called with NULL nameidata
>>
>> ---
>>  fs/fuse/dir.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>
