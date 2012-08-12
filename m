Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2HLD2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 23:28:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51388 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab2HLD2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 23:28:51 -0400
Date: Sun, 12 Aug 2012 05:28:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] HWPOISON: improve handling/reporting of memory error on dirty pagecache
Message-ID: <20120812032844.GE11413@one.firstfloor.org>
References: <m21ujdd6it.fsf@firstfloor.org> <1344719674-7267-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344719674-7267-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That function uses a global lock. fdatawait is quite common. This will
> > likely cause performance problems in IO workloads.
> 
> OK, I should avoid it.

Maybe just RCU the hash table.
 
> > You need to get that lock out of the hot path somehow.
> > 
> > Probably better to try to put the data into a existing data structure,
> > or if you cannot do that you would need some way to localize the lock.
> 
> Yes, I have thought about adding some data like new pagecache tag or
> new members in struct address_space, but it makes the size of heavily
> used data structure larger so I'm not sure it's acceptable.
> And localizing the lock is worth trying, I think.

It's cheaper than a hash table lookup in the hot path.
 
> > Or at least make it conditional of hwpoison errors being around. 
> 
> I'll try to do your suggestions, but I'm not sure your point of the
> last one. Can you explain more about 'make it conditional' option?

The code should check some flag first that is only set when hwpoison
happened on the address space (or global, but that would mean that 
performance can go down globally when any error is around)

-Andi
