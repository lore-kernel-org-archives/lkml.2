Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184Ab2IESb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:31:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62949 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759168Ab2IESbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:31:53 -0400
Date: Wed, 5 Sep 2012 11:31:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11 V5] workqueue: new day don't need WORKER_REBIND
 for busy rebinding
Message-ID: <20120905183148.GB13737@google.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
 <1346841475-4422-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346841475-4422-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 06:37:40PM +0800, Lai Jiangshan wrote:
> because old busy_worker_rebind_fn() have to wait until all idle worker finish.
> so we have to use two flags WORKER_UNBOUND and WORKER_REBIND to avoid
> prematurely clear all NOT_RUNNING bit when highly frequent offline/online.
> 
> but current code don't need to wait idle workers. so we don't need to
> use two flags, just one is enough. remove WORKER_REBIND from busy rebinding.

ROGUE / REBIND thing existed for busy workers from the beginning when
there was no idle worker rebinding, so this definitely wasn't about
whether idle rebind is synchronous or not.  Trying to remember
what... ah, okay, setting of DISASSOCIATED and setting of WORKER_ROGUE
didn't use to happen together with gcwq->lock held.  CPU_DOWN would
first set ROGUE and then later on set DISASSOCIATED, so if the
rebind_fn kicks in inbetween that, it would break CPU_DOWN.

I think now that both CPU_DOWN and UP are done under single holding of
gcwq->lock, this should be safe.  It would be nice to note what
changed in the patch description and the atomicity requirement as a
comment tho.

Thanks.

-- 
tejun
