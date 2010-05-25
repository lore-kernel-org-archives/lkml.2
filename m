Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab0EYSrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:47:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:40460 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294Ab0EYSrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:47:14 -0400
Date: Wed, 26 May 2010 04:47:00 +1000
From: Nick Piggin <npiggin@suse.de>
To: Albert Herranz <albert_herranz@yahoo.es>
Cc: aya Kumar <jayakumar.lkml@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev@vger.kernel.org
Subject: Re: page_mkwrite vs pte dirty race in fb_defio
Message-ID: <20100525184700.GJ20853@laptop>
References: <20100525160149.GE20853@laptop>
 <4BFC1657.5000707@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFC1657.5000707@yahoo.es>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 08:26:31PM +0200, Albert Herranz wrote:
> Hi,
> 
> On 05/25/2010 06:01 PM, Nick Piggin wrote:
> > Hi,
> > 
> > I couldn't find where this patch (49bbd815fd8) was discussed, so I'll
> > make my own thread. Adding a few lists to cc because it might be of
> > interest to driver and filesystem writers.
> > 
> 
> The original thread can be found here:
> http://marc.info/?l=linux-fbdev&m=127369791432181

Thanks.

 
> > The old ->page_mkwrite calling convention was causing problems exactly
> > because of this race, and we solved it by allowing page_mkwrite to
> > return with the page locked, and the lock will be held until the
> > pte is marked dirty. See commit b827e496c893de0c0f142abfaeb8730a2fd6b37f.
> > 
> 
> Ah, didn't know about that. Thanks for the pointer.
> 
> > I hope that should provide a more elegant solution to your problem. I
> > would really like you to take a look at that, because we already have
> > filesystem code (NFS) relying on it, and more code we have relying on
> > this synchronization, the more chance we would find a subtle problem
> > with it (also it should be just nicer).
> > 
> 
> So if I undestand it correctly, using the "new" calling convention I should just lock the page on fb_deferred_io_mkwrite() and return VM_FAULT_LOCKED to fix the described race for fb_defio.

As far as I can see from quick reading of the fb_defio code, yes
that should solve it (provided you lock the page inside the mutex,
of course).

