Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1HAA3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 20:29:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58314 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1HAA3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 20:29:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 1 Aug 2011 09:22:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, cl@linux-foundation.org,
        akpm@linux-foundation.org, rientjes@google.com, hughd@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kosaki.motohiro@jp.fujitsu.com, yinghan@google.com
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
Message-Id: <20110801092205.14881df1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <m2livez6vl.fsf@firstfloor.org>
References: <alpine.DEB.2.00.1107290145080.3279@tiger>
	<CA+55aFzut1tF6CLAPJUUh2H_7M4wcDpp2+Zb85Lqvofe+3v_jQ@mail.gmail.com>
	<CA+55aFw9V-VM5TBwqdKiP0E_g8urth+08nX-_inZ8N1_gFQF4w@mail.gmail.com>
	<m2livez6vl.fsf@firstfloor.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Jul 2011 10:39:58 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Sat, Jul 30, 2011 at 8:27 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >> Do we allocate the page map array sufficiently aligned that we
> >> actually don't ever have the case of straddling a cacheline? I didn't
> >> check.
> >
> > Oh, and another thing worth checking: did somebody actually check the
> > timings for:
> 
> I would like to see a followon patch that moves the mem_cgroup
> pointer back into struct page. Copying some mem_cgroup people.
> 

A very big change itself is in a future plan. It will do memory usage of
page_cgroup from 32bytes to 8bytes.

A small change, moving page_cgroup->mem_cgroup to struct page, may make
sense. But...IIUC, there is an another user of a field as blkio cgroup.
(They planned to add page_cgroup->blkio_cgroup)

So, my idea is adding

	page->owner

field and encode it in some way. For example, if we can encode it as

	|owner_flags | blkio_id | | memcg_id|

this will work. (I'm not sure how performance will be..)
And we can reduce size of page_cgroup from 32->24(or 16).

In this usage, page->owner will be just required when CGROUP is used.
So, a small machine will not need to increase size of struct page.

If you increase size of 'struct page', memcg will try to make use of
the field.

But we have now some pending big patches (dirty_ratio etc...), moving
pointer may take longer than expected. 

Thanks,
-Kame

