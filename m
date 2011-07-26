Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1GZLtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 07:49:32 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56031
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379Ab1GZLtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 07:49:25 -0400
Date: Tue, 26 Jul 2011 07:49:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, David Miller <davem@davemloft.net>,
        Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
        Anton Blanchard <anton@samba.org>, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] vfs: dont chain pipe/anon/socket on superblock s_inodes
 list
Message-ID: <20110726114906.GA19975@infradead.org>
References: <20110723132411.GA22183@infradead.org>
 <1311633550.2576.33.camel@schen9-DESK>
 <20110725225154.GD22133@ZenIV.linux.org.uk>
 <1311636178.2576.34.camel@schen9-DESK>
 <1311660013.2996.6.camel@edumazet-laptop>
 <1311668466.2355.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110726090357.GA13013@infradead.org>
 <1311672994.2355.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110726094204.GA12086@infradead.org>
 <1311677013.2355.25.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311677013.2355.25.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 12:43:33PM +0200, Eric Dumazet wrote:
> BTW, we have one atomic op that could be avoided in new_inode()
> 
> spin_lock(&inode->i_lock);
> inode->i_state = 0;
> spin_unlock(&inode->i_lock);
> 
> can probably be changed to something less expensive...
> 
> inode->i_state = 0;
> smp_wmb();
> 
> Not clear if we really need a memory barrier either....

I think we already had this in some of the earlier vfs/inode scale
series, but it got lost when Al asked to just put the fundamental
changes in.

For plain new_inode() the barrier shouldn't be needed as we take
the sb list lock just a little later.  I'm not sure about your new
variant, so I'll rather lave that to you.

There's a few other things missing from earlier iterations, most notable
the non-atomic i_count, and the bucket locks for the inode hash, if
you're eager enough to look into that area.

