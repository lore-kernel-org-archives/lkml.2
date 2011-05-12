Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab1ELQKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:10:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51284 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab1ELQKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XAkuMZCI3mkMksiCbtXbz3EqSjCqwN0LoDuuLwESxyL3VDV0negnKzDfGA1iF4p7vM
         Tmx9Jzr117T4CtVW4leSrK/ToIpSqo6iRU1GzBmR3WUp0wx1ays6r4LukkfSOFsxHPo0
         cToioSaO7RcFglZ/QEPGFW9/NiDMNN/a5IuxE=
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1105121050220.26013@router.home>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
	 <1305127773-10570-4-git-send-email-mgorman@suse.de>
	 <alpine.DEB.2.00.1105120942050.24560@router.home>
	 <1305213359.2575.46.camel@mulgrave.site>
	 <alpine.DEB.2.00.1105121024350.26013@router.home>
	 <1305214993.2575.50.camel@mulgrave.site>
	 <alpine.DEB.2.00.1105121050220.26013@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 18:10:38 +0200
Message-ID: <1305216638.3795.36.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 12 mai 2011 à 11:01 -0500, Christoph Lameter a écrit :
> On Thu, 12 May 2011, James Bottomley wrote:
> 
> > > Debian and Ubuntu have been using SLUB for a long time
> >
> > Only from Squeeze, which has been released for ~3 months.  That doesn't
> > qualify as a "long time" in my book.
> 
> I am sorry but I have never used a Debian/Ubuntu system in the last 3
> years that did not use SLUB. And it was that by default. But then we
> usually do not run the "released" Debian version. Typically one runs
> testing. Ubuntu is different there we usually run releases. But those
> have been SLUB for as long as I remember.
> 
> And so far it is rock solid and is widely rolled out throughout our
> infrastructure (mostly 2.6.32 kernels).
> 
> > but a sample of one doeth not great testing make.
> >
> > However, since you admit even you see problems, let's concentrate on
> > fixing them rather than recriminations?
> 
> I do not see problems here with earlier kernels. I only see these on one
> testing system with the latest kernels on Ubuntu 11.04.

More fuel to this discussion with commit 6d4831c2

Something is wrong with high order allocations, on some machines.

Maybe we can find real cause instead of limiting us to use order-0 pages
in the end... ;)

commit 6d4831c283530a5f2c6bd8172c13efa236eb149d
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Wed Apr 27 15:26:41 2011 -0700

    vfs: avoid large kmalloc()s for the fdtable
    
    Azurit reports large increases in system time after 2.6.36 when running
    Apache.  It was bisected down to a892e2d7dcdfa6c76e6 ("vfs: use kmalloc()
    to allocate fdmem if possible").
    
    That patch caused the vfs to use kmalloc() for very large allocations and
    this is causing excessive work (and presumably excessive reclaim) within
    the page allocator.
    
    Fix it by falling back to vmalloc() earlier - when the allocation attempt
    would have been considered "costly" by reclaim.
    
  

