Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547Ab0HMLya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 07:54:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48022 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761519Ab0HMLy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 07:54:28 -0400
Date: Fri, 13 Aug 2010 07:54:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>, Mark Lord <kernel@teksavvy.com>,
        LKML <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.35 Regression: Ages spent discarding blocks that weren't
 used!
Message-ID: <20100813115424.GA24737@infradead.org>
References: <4C58C528.4000606@tuxonice.net>
 <4C5960B0.7020003@teksavvy.com>
 <4C59DA16.4020500@tuxonice.net>
 <AANLkTik_PH-7T7OFtzaCtPbAHE6pqnYMUsjP25KtsRnR@mail.gmail.com>
 <4C5A59FC.1030304@tuxonice.net>
 <AANLkTi=NMHkKduZzsLiiYt3=w8++8epb5aGrqv7V3-vB@mail.gmail.com>
 <4C5B925A.5000409@tuxonice.net>
 <AANLkTinU24v6Mty54YL3gv3M5S+4jdN5vHD54KknchAG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinU24v6Mty54YL3gv3M5S+4jdN5vHD54KknchAG@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 03:07:25PM -0700, Hugh Dickins wrote:
> If REQ_SOFTBARRIER means that the device is still free to reorder a
> write, which was issued after discard completion was reported, before
> the discard (so later discarding the data written), then certainly I
> agree with Christoph (now Cc'ed) that the REQ_HARDBARRIER is
> unavoidable there; but if not, then it's not needed for the swap case.
>  I hope to gain a little more enlightenment on such barriers shortly.

REQ_SOFTBARRIER is indeed purely a reordering barrier inside the block
elevator.

> What does seem over the top to me, is for mm/swapfile.c's
> blkdev_issue_discard()s to be asking for both BLKDEV_IFL_WAIT and
> BLKDEV_IFL_BARRIER: those swap discards were originally written just
> to use barriers, without needing to wait for completion in there.  I'd
> be interested to hear if cutting out the BLKDEV_IFL_WAITs makes the
> swap discards behave acceptably again for you - but understand that
> you won't have a chance to try that until later next week.

That does indeed look incorrect to me.  Any kind of explicit waits
usually mean the caller provides ordering.  Getting rid of
BLKDEV_IFL_BARRIER in the swap code ASAP would indeed be beneficial
given that we are trying to get rid of hard barriers completely soon.
Auditing the existing blkdev_issue_discard callers in filesystems
is high on the todo list for me.
