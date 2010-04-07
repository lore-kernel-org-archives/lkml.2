Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab0DGIPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 04:15:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53013 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab0DGIPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 04:15:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 7 Apr 2010 17:11:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: RFC [Patch] Remove
 "please try 'cgroup_disable=memory' option if you don't want memory cgroups"
 printk at boot time.
Message-Id: <20100407171113.1029d6d4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100407080014.GB2446@osiris.boeblingen.de.ibm.com>
References: <1270049283.3551.281.camel@dhcp-100-19-198.bos.redhat.com>
	<1270050899.3551.283.camel@dhcp-100-19-198.bos.redhat.com>
	<4BB38D1A.7050204@redhat.com>
	<20100401104859.e0deeca8.kamezawa.hiroyu@jp.fujitsu.com>
	<20100401045310.GB6337@balbir.in.ibm.com>
	<20100407080014.GB2446@osiris.boeblingen.de.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010 10:00:14 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Thu, Apr 01, 2010 at 10:23:10AM +0530, Balbir Singh wrote:
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-04-01 10:48:59]:
> > I've seen this issue come up on multiple machines, I think the printk
> > is useful. However, we might need to change the panic() to a big fat
> > warning and disable the memcg controller if we fail to allocate memory
> > in page_cgroup_init_flatmem(). 
> 
> Probably a stupid question: but isn't it possible to allocate the huge
> amounts of memory only if somebody activates memcg during runtime?

Activation can occur only at boot but page_cgroup allocation happens at
memory hotplug.

> And then allocate everything using vmalloc?
No.

> But that probably doesn't work, since you need to record everything
> from the boot of the system, I would guess?

The story was..

1. at first, page_cgroup was allocated on demand. but we need to have
   page->page_cgroup pointer. Then, we pay 8bytes per page even if we
   disable memory cgroup.
   All page behavior was tracked since boot time.

2. Fedora maintaienr said "we never enable memcg if you contiue to use
   page->page_cgroup pointer, 8bytes per page costs!".
   Then, we decieded to allocate page_cgroup at boot time, and allocate
   all at once at boot time. This makes memcg runtime robust. And we
   got rid of page->page_cgroup pointer.
   cgroup_disable=memory user have no waste of memory now.

> Just wondering because we do everything to not even waste a single bit
> in struct page and all of a sudden on the enterprise distros we allocate
> (by default!) 40 additional bytes per page.

3. Then, I added warning when I wrote a patch to allocate page_cgroup at boot.
   It's easy to avoid extra 40bytes.
   For enterprise, I have no concern. Enterprise admin tend to be careful and
   check all default value when he use a new kernel.
   That message was for desktop guys using desktop distro.

   Disabling memory cgroup at default may be a choice. But no one send such kind
   of patch until now.

Thanks,
-Kame

