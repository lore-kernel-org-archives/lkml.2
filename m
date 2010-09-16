Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab0IPI3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 04:29:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53184 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0IPI3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 04:29:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] Remove BKL from fs/locks.c
Date: Thu, 16 Sep 2010 10:28:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-next-20100910+; KDE/4.5.1; x86_64; ; )
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <201009142206.54130.arnd@arndb.de> <1284501356.10782.139.camel@heimdal.trondhjem.org> <20100915204203.GA27837@fieldses.org>
In-Reply-To: <20100915204203.GA27837@fieldses.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009161028.56837.arnd@arndb.de>
X-Provags-ID: V02:K0:f7GBQqkzPHgeV/03NNYTsH6p70pjrpRJIoe8oZeEolR
 T51hMkfTuVlqvAqaJQSd05OolcL2kaW1Mry6RJjbeuXU2QAUnI
 kvme+O43UI8tf4AMKLlU8gi/9WHHnZtgspQj2KOkqtPj9ILxrw
 8We29c6Wjrn/gaFEAQTYZPhk4u+ahIyLk2nB6BJQgoKocm81G4
 4JlO/SSqoWObilIrOtEtQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 September 2010 22:42:03 J. Bruce Fields wrote:
> Looking over the server code....  The only code I see under the BKL is:
> 
>         - a few lease callbacks in fs/nfsd/nfs4state.c, none of which
>           sleep at this point, so all should be fine under a spinlock or
>           whatever we want.
>         - fs/nfsd/nfs4state.c:check_for_locks(), which explicitly takes
>           the BKL itself.  All it does, though, is walk the lock list
>           for a given file and check whether any of them have a given
>           owner.  It would be trivial to put it under some other lock
>           and/or move it to locks.c.

Ok. In the version of the patch I sent out yesterday, I came to the
same conclusion and put both of these under lock_flocks(), which
is still the BKL but can be converted to a spinlock after we have
sorted out ceph and lockd. If you and others are fine with this patch,
I'll add it to my bkl/config series.

Note that walking the i_flock list needs to use lock_flocks()
(or the BKL), not a private lock. I guess that's what you are saying
anyway, just making sure.

	Arnd
