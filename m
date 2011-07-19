Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1GSDKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 23:10:06 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40403
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230Ab1GSDKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 23:10:04 -0400
Date: Mon, 18 Jul 2011 23:10:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 0/2] splice: i_mutex vs splice write deadlock
Message-ID: <20110719031003.GA18166@infradead.org>
References: <1310961884-11634-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310961884-11634-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't really like this very much.  Not taking the i_mutex at all
makes the splice_write method in XFS use different locking than
everyone else, and different from the normal XFS write path.

For example ocfs2 which has the same locking issues just has an
own implementation of the splice_write method, which isn't
too nice but at least marginally better.  I think the right
fix for both xfs and ocfs2 would be to have a generic_file_splice_write
variant that takes an "actor" function pointer, which defaults to
a smaller wrapper around file_remove_suid, file_update_time and
splice_from_pipe_feed, and then XFS and ocfs2 can provide their
own actors that add the additional locking.

