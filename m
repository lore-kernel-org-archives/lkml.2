Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab1CBWSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:18:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:46929 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab1CBWSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:18:11 -0500
Date: Wed, 2 Mar 2011 23:18:08 +0100
From: Jan Kara <jack@suse.cz>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] Fix mapping->writeback_index to point to the last
 written page
Message-ID: <20110302221808.GG7496@quack.suse.cz>
References: <4D676067.8050200@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D676067.8050200@ce.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Fri 25-02-11 16:55:19, Jun'ichi Nomura wrote:
> For range-cyclic writeback (e.g. kupdate), the writeback code sets
> a continuation point of the next writeback to mapping->writeback_index.
> 
> Current code sets the page next to the last written page.
> I think it's intended for sequential writer.
  Not exactly. The code is meant so that background writeback gets to
writing the end of a file which gets continuously dirtied (if we always
started at the beginning, nr_to_write could always get to 0 before we reach
end of the file).

> However, in many cases, sequential writer is writing in the middle of the page
> and it just redirties the last written page by continuing from that.
> 
> So the next writeback should try to continue from the last written page,
> not the next one.
> (If it's clean because the writer was on the page boundary,
>  pagevec_lookup_tag just skips it. So no problem.)
> 
> Otherwise, the last written page was left dirty until the writeback
> wraps around.
> 
> I.e. if the sequential dirtier has written on pagecache as '*'s below:
> 
>    |*******|*******|****---|-------|-------|     ( |---| is a page )
> 
> then, writeback happens:
> 
>    |-------|-------|-------|-------|-------|
> 
> and the dirtier continues:
> 
>    |-------|-------|----***|*******|*****--|
>                    A       B
> 
> Next writeback should start from page A, not B.
  Yes, this is downside of our current scheme. Have you actually observed
it in practice or is it mostly a theoretic concern?
 
But as I'm thinking about it, it wouldn't harm our original aim to do
what you propose and it can help this relatively common case. So I think
it's a good idea. Fengguang, what do you think?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
