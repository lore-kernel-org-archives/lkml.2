Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1GZKnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 06:43:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33742 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab1GZKnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 06:43:41 -0400
Subject: Re: [PATCH] vfs: dont chain pipe/anon/socket on superblock
 s_inodes list
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>, Andi Kleen <andi@firstfloor.org>,
        Matthew Wilcox <matthew@wil.cx>, Anton Blanchard <anton@samba.org>,
        npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <20110726094204.GA12086@infradead.org>
References: <20110721204042.GB31405@ZenIV.linux.org.uk>
	 <1311294452.2576.18.camel@schen9-DESK>
	 <20110723132411.GA22183@infradead.org>
	 <1311633550.2576.33.camel@schen9-DESK>
	 <20110725225154.GD22133@ZenIV.linux.org.uk>
	 <1311636178.2576.34.camel@schen9-DESK>
	 <1311660013.2996.6.camel@edumazet-laptop>
	 <1311668466.2355.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110726090357.GA13013@infradead.org>
	 <1311672994.2355.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110726094204.GA12086@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jul 2011 12:43:33 +0200
Message-ID: <1311677013.2355.25.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 26 juillet 2011 à 05:42 -0400, Christoph Hellwig a écrit :
> On Tue, Jul 26, 2011 at 11:36:34AM +0200, Eric Dumazet wrote:
> > [PATCH v2] vfs: dont chain pipe/anon/socket on superblock s_inodes list
> > 
> > Workloads using pipes and sockets hit inode_sb_list_lock contention.
> > 
> > superblock s_inodes list is needed for quota, dirty, pagecache and
> > fsnotify management. pipe/anon/socket fs are clearly not candidates for
> > these.
> > 
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> Looks good to me,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thanks !

BTW, we have one atomic op that could be avoided in new_inode()

spin_lock(&inode->i_lock);
inode->i_state = 0;
spin_unlock(&inode->i_lock);

can probably be changed to something less expensive...

inode->i_state = 0;
smp_wmb();

Not clear if we really need a memory barrier either....



