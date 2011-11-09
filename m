Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab1KIKeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:34:18 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59231
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700Ab1KIKeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:34:16 -0500
Date: Wed, 9 Nov 2011 05:34:15 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>, Arne Jansen <sensille@gmx.net>,
        Andrea Gelmini <andrea.gelmini@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs pull request
Message-ID: <20111109103415.GA11064@infradead.org>
References: <20111106183851.GA4339@shiny>
 <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
 <4EB7A6CC.5030502@gmx.net>
 <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com>
 <4EB7D2D8.2060505@gmx.net>
 <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com>
 <4EB8DEAC.7000906@gmx.net>
 <20111109010701.GI4149@shiny>
 <20111109074847.GA16742@infradead.org>
 <4EBA560B.1070509@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBA560B.1070509@jan-o-sch.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 11:29:31AM +0100, Jan Schmidt wrote:
> Am 09.11.2011 08:48, schrieb Christoph Hellwig:
> >On Tue, Nov 08, 2011 at 08:07:01PM -0500, Chris Mason wrote:
> >>Looks like bio_add_page() is failing and we're getting the enomem from
> >>there.  LVM is only letting us put one page in each bio.
> >
> >Yes, at the moment all bio based DM targets only allow single page I/O.
> 
> Wait. If I got that correctly, each bio_add_page needs special
> ENOMEM treatment (assuming the target could always be a device
> mapper target), right?

Each bio_add_page caller needs to expect it can't add more than a
page worth of data.  If you look at callers what write large amounts
of data (XFS, mpage code) you'll always see a pattern of:

	bio = bio_alloc();

	while (bytes_left) {
		len = min(bytes_left, PAGE_SIZE);
		bytes = bio_add_page(io, ..., len);
		if (bytes < len) {
			submit_bio(bio);
			bio = bio_alloc();
		}
		update_indices();
	}
	submit_bio(bio);

