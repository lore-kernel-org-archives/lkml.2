Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab2AITFC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:05:02 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58131
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932812Ab2AITFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:05:00 -0500
Date: Mon, 9 Jan 2012 14:04:50 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org, david@fromorbit.com
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
Message-ID: <20120109190450.GA26390@infradead.org>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
 <20120109171639.GA9359@infradead.org>
 <20120109173010.GX23916@ZenIV.linux.org.uk>
 <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
 <CA+55aFxRroO0KAz8qbhz_2vDc=bc-C2b0ux0tdFfQhBGMnqRzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxRroO0KAz8qbhz_2vDc=bc-C2b0ux0tdFfQhBGMnqRzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:46:22AM -0800, Linus Torvalds wrote:
> On Mon, Jan 9, 2012 at 10:30 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Here's a TOTALLY UNTESTED rebase of just that single patch from Dave.
> 
> Well, it boots, and the dentry cache shrinks under memory pressure. So
> it's not _totally_ untested now.
> 
> But I don't really see why it would fix Miklos' case. I think
> select_parent() may still end up touching the d_lru list of something
> that is on the 'dispose' list. So the patch looks like a nice cleanup,
> but it seems to be independent of the issue Miklos found.
> 
> What am I missing now?

After Dave's patch select_parent isolates dentries that are going to
be dropped directly to an on-stack list instead of abusing the LRU.

With that scheme the trylock and retry loop in __shrink_dcache_sb
goes away completely for this caller.
