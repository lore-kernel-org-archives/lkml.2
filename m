Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab1F2GmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 02:42:22 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42628
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759Ab1F2GmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 02:42:16 -0400
Date: Wed, 29 Jun 2011 02:42:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Curt Wohlgemuth <curtw@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110629064210.GA18469@infradead.org>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
 <20110629005422.GQ32466@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629005422.GQ32466@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 10:54:22AM +1000, Dave Chinner wrote:
> The comment says it does not wait for IO to be -completed-.
> 
> The function as implemented waits for IO to be *submitted*.
> 
> This provides the callers with same blocking semantics (i.e. request
> queue full) as if the caller submitted the IO themselves. The code
> that uses this function rely on this blocking to delay the next set
> of operations they do until after IO has been started, so removing
> the completion will change their behaviour significantly.

The real importance is for locking.  If we don't wait for completion
we may still do writebacks in the flushers thread while we're already
unlocked s_umount.  That will give us back the nasty writeback vs
umount races that this scheme fixed.  The commit logs that added
it should explain it in more detail (at least I usually write detailed
changelogs)

