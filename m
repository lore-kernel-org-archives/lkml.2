Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1CQD5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 23:57:15 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48087 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243Ab1CQD5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 23:57:12 -0400
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, akpm@linux-foundation.org,
        maximlevitsky@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <722844.29100.qm@web37604.mail.mud.yahoo.com>
References: <722844.29100.qm@web37604.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 23:57:06 -0400
Message-ID: <1300334226.2620.26.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 20:46 -0700, Alex Dubov wrote:
> > 
> > Why?
> > 
> > Why can't the block layer split a request in the way the
> > driver wants
> > to do?
> > 
> > That is, why can't the driver tell the block layer how to
> > split a
> > request?
> 
> What is needed is the ability to get fixed sized (in bytes) blocks from 
> the block layer.
> 
> Last time I checked (it was a long time ago, admittedly) one could only
> ask for a fixed number of sg entries, without any control on how many
> bytes each sg entry references.
> 
> Is there a way to get data from the block layer in a fashion of:
> "Give me 16k/32k/whatever in one sg entry if request is equal or larger
> than this"?

Yes; we've always had it: it's blk_max_queue_hw_sectors().  No request
will go over that number times the sector size (of course, they may go
under).

> If my knowledge is correct, MTD currently addresses this issue by
> maintaining its own cache, which it uses to aggregate write requests until
> it can write a whole erase block. While this is ok with old media
> (legacy memory stick being an example of such), new flash chips can
> have multi-megabyte sized erase blocks and can benefit from operations
> (like copy and compare) directly on scatter list .

So this is where you want a minimum too.  What you likely want is to set
the logical block size to your erase block
(blk_queue_logical_block_size) and the physical block size to the actual
block size.  Then we'll try as hard as we can to send down blocks on an
erase boundary.  Of course, there are some that just won't fit (like fs
metadata) and you'll have to do a RMW for them.

James


