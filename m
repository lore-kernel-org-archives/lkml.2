Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0DOUgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 16:36:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56815 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab0DOUgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 16:36:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 2/2] [RFC] Remove BKL from fs/locks.c
Date: Thu, 15 Apr 2010 22:36:19 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1271277384-7627-1-git-send-email-arnd@arndb.de> <1271278334.3159.19.camel@localhost.localdomain> <20100414210403.GA29133@fieldses.org>
In-Reply-To: <20100414210403.GA29133@fieldses.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004152236.19732.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18bc5ATljvLkdSgY5LJNPOl/KhsvYlhx/vqEXs
 xlUgN4ykZ5LgQdjiwdUWltD/DWMT13/k/c2nWfZdCCdCtavV1i
 PiujgM2uiZBrrwD7oSMqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 April 2010 23:04:03 J. Bruce Fields wrote:
> The lockd thread is entirely under the BKL--it takes it at the top of
> fs/lockd/svc.c:lockd(), and drops it at the bottom.  It's possible
> there may be code that lockd runs that assumes mutual exclusion with
> code in locks.c, but I don't know.

That one seems interesting as the lockd thread calls lots of sleeping
functions as well as file lock code that takes the BKL again, both
of which of course is not allowed when converting to a spinlock.

I just attempted to blindly convert lockd to taking lock_flocks()
in place of the BKL and releasing it where necessary, but quickly gave
up because this seems rather pointless. It basically never does
anything interesting between places where it would need to drop the
lock.

	Arnd
