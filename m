Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab2K2Gz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:55:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:20561 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab2K2GzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:55:25 -0500
X-IronPort-AV: E=Sophos;i="4.83,339,1352044800"; 
   d="scan'208";a="6298653"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, hughd@google.com,
        cl@linux.com
Cc: mgorman@suse.de, minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, tangchen@cn.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lin Feng <linfeng@cn.fujitsu.com>
Subject: [BUG REPORT] [mm-hotplug, aio] aio ring_pages can't be offlined
Date: Thu, 29 Nov 2012 14:54:58 +0800
Message-Id: <1354172098-5691-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 14:54:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 14:54:46,
	Serialize complete at 2012/11/29 14:54:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We encounter a "Resource temporarily unavailable" fail while trying
to offline a memory section in a movable zone. We found that there are 
some pages can't be migrated. The offline operation fails in function 
migrate_page_move_mapping() returning -EAGAIN till timeout because 
the if assertion 'page_count(page) != 1' fails.
I wonder in the case 'page_count(page) != 1', should we always wait
(return -EAGAING)? Or in other words, can we do something here for 
migration if we know where the pages from?

And finally found that such pages are used by /sbin/multipathd in the form
of aio ring_pages. Besides once increment introduced by the offline calling
chain, another increment is added by aio_setup_ring() via callling
get_userpages(), it won't decrease until we call aio_free_ring().

The dump_page info in the offline context is showed as following:
page:ffffea0011e69140 count:2 mapcount:0 mapping:ffff8801d6949881 index:0x7fc4b6d1d
page flags: 0x30000000018081d(locked|referenced|uptodate|dirty|swapbacked|unevictable)
page:ffffea0011fb0480 count:2 mapcount:0 mapping:ffff8801d6949881 index:0x7fc4b6d1c
page flags: 0x30000000018081d(locked|referenced|uptodate|dirty|swapbacked|unevictable)
page:ffffea0011fbaa80 count:2 mapcount:0 mapping:ffff8801d6949881 index:0x7fc4b6d1a
page flags: 0x30000000018081d(locked|referenced|uptodate|dirty|swapbacked|unevictable)
page:ffffea0011ff21c0 count:2 mapcount:0 mapping:ffff8801d6949881 index:0x7fc4b6d1b
page flags: 0x30000000018081d(locked|referenced|uptodate|dirty|swapbacked|unevictable)

The multipathd seems never going to release the ring_pages until we reboot the box.
Furthermore, if some guy makes app which only calls io_setup() but never calls 
io_destroy() for the reason that he has to keep the io_setup() for a long time 
or just forgets to or even on purpose that we can't expect.
So I think the mm-hotplug framwork should get the capability to deal with such
situation. And should we consider adding migration support for such pages?

However I don't know if there are any other kinds of such particular pages in 
current kernel/Linux system. If unluckily there are many apparently it's hard to 
handle them all, just adding migrate support for aio ring_pages is insufficient. 

But if luckily can we use the private field of page struct to track the
ring_pages[] pointer so that we can retrieve the user when migrate? 
Doing so another problem occurs, how to distinguish such special pages?
Use pageflag may cause an impact on current pageflag layout, add new pageflag
item also seems to be impossible.

I'm not sure what way is the right approach, seeking for help.
Any comments are extremely needed, thanks :)

Thanks,
linfeng
