Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab1F3MiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:38:13 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33422
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358Ab1F3MiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:38:06 -0400
Date: Thu, 30 Jun 2011 08:37:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Curt Wohlgemuth <curtw@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110630123759.GA14956@infradead.org>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
 <20110629005422.GQ32466@dastard>
 <BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
 <20110629081155.GA5558@infradead.org>
 <20110629165714.GF17590@quack.suse.cz>
 <20110629175534.GA32236@infradead.org>
 <20110629191518.GA23196@quack.suse.cz>
 <20110629201234.GA31129@infradead.org>
 <20110630121558.GF28475@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110630121558.GF28475@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 02:15:58PM +0200, Jan Kara wrote:
>   Yes. Actually, specifically for filesystems like XFS which update inode
> after IO completion we would need more passes to be efficient and correct:
>   for all inodes
>     fdatawrite
>   for all inodes
>     fdatawait
>   for all inodes
>     write_inode
>   for all inodes
>     wait for inode IO
> 
>   But maybe this could be handled by having new WB_SYNC_ mode indicating
> that writeback_single_inode() should not bother waiting (thus we'd really
> end up waiting in sync_inodes_sb()) and then XFS and other filesystems that
> need it would writeout inodes in their sync_fs() implementation (possibly
> using a generic helper)?

We do very little in write_inode these days.  Basically just log the
inode size and timestamp sized into the in-memory log.  The actual
writeout of the log happens in ->sync_fs already.

