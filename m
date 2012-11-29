Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab2K2BdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:33:23 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61180 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab2K2BdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:33:22 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-d1-50b6bb601c07
Date: Thu, 29 Nov 2012 10:33:20 +0900
From: Minchan Kim <minchan@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>, Tomas M <tomas@slax.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] zram: Prevent use of unmapped buffer
Message-ID: <20121129013320.GA24077@blaptop>
References: <1354001167-24878-1-git-send-email-ngupta@vflare.org>
 <20121128051505.GD23136@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121128051505.GD23136@blaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 02:15:05PM +0900, Minchan Kim wrote:
> Hi Nitin,
> 
> On Mon, Nov 26, 2012 at 11:26:07PM -0800, Nitin Gupta wrote:
> > The commit c8f2f0db1 ("zram: Fix handling of incompressible pages")
> > introduced a bug which caused a kunmap()'ed buffer to be used in case
> 
> I got confused by the descripton. :(
> The descripton is not right.
> The problem is to access freed memory, not accessing to kunmaped buffer.
> 
> partial I/O write.
> 
> 1. uncmem = kmalloc
> 2. zram_decompress_page(uncmem)
> 3. memcpy(uncmem, user_mem)
> 4. lzo1x_1_compress(uncmem)
> 5. kfree(uncmem)
> 6. src = uncmem
> 7. memcpy(cmem, src, clen) <----- HIT
> 
> > of partial writes where the data was found to be incompressible.
> > 

I got it. You shouldn't mention partial write for proper description
because it was usecase for swap-over-zram so it can't make partial write.
Without partial write mention, your description is right but the problem
I mentioned above is another problem for partial write so we need a another
patch. I will cook.

Thanks.


> > This fixes bug 50081:
> > https://bugzilla.kernel.org/show_bug.cgi?id=50081
> > 
> > Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> > Reported-by: Mihail Kasadjikov <hamer.mk@gmail.com>
> > Reported-by: Tomas M <tomas@slax.org>
> 
> Good catch! Shame on me. I should have reivewed more carefully. :(
> Please resend it with revised descrption and title.
> I will rebase mh patchset just sent on top of this bug fix patch.
> 
> P.S) Sigh, Now code isn't clean due to partial read/write path handling.
>      IMHO, sooner or later, we need refactoring.
> 
> -- 
> Kind regards,
> Minchan Kim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
