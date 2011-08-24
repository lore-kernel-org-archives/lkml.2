Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab1HXJcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:32:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:50200 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab1HXJcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:32:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,274,1312182000"; 
   d="scan'208";a="41839535"
Date: Wed, 24 Aug 2011 17:32:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Jens Axboe <jaxboe@fusionio.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: slow performance on disk/network i/o full speed after
 drop_caches
Message-ID: <20110824093205.GA5214@localhost>
References: <4E5494D4.1050605@profihost.ag>
 <CAOJsxLEFYW0eDbXQ0Uixf-FjsxHZ_1nmnovNx1CWj=m-c-_vJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJsxLEFYW0eDbXQ0Uixf-FjsxHZ_1nmnovNx1CWj=m-c-_vJw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 02:20:07PM +0800, Pekka Enberg wrote:
> On Wed, Aug 24, 2011 at 9:06 AM, Stefan Priebe - Profihost AG
> <s.priebe@profihost.ag> wrote:
> > i hope this is the correct list to write to if it would be nice to give me a
> > hint where i can ask.
> >
> > Kernel: 2.6.38
> >
> > I'm seeing some strange problems on some of our servers after upgrading to
> > 2.6.38.
> >
> > I'm copying a 1GB file via scp from Machine A to Machine B. When B is
> > freshly booted the file transfer is done with about 80 to 85 Mb/s. I can
> > repeat that various times to performance degrease.
> >
> > Then after some days copying is only done with about 900kb/s up to 3Mb/s
> > going up and down while transfering the file.
> >
> > When i then do drop_caches it works again on 80Mb/s.
> >
> > sync && echo 3 >/proc/sys/vm/drop_caches && sleep 2 && echo 0
> >>/proc/sys/vm/drop_caches
> >
> > Attached is also an output of meminfo before and after drop_caches.
> >
> > What's going on here? MemFree is pretty high.
> >
> > Please CC me i'm not on list.
> 
> Interesting. I can imagine one or more of the following to be
> involved: networking, vmscan, block, and writeback. Lets CC all of
> them!
> 
> > # before drop_caches
> >
> > # cat /proc/meminfo
> > MemTotal:        8185544 kB
> > MemFree:         6670292 kB
> > Buffers:          105164 kB
> > Cached:           166672 kB
> > SwapCached:            0 kB
> > Active:           728308 kB
> > Inactive:         567428 kB
> > Active(anon):     639204 kB
> > Inactive(anon):   394932 kB
> > Active(file):      89104 kB
> > Inactive(file):   172496 kB
> > Unevictable:        2976 kB
> > Mlocked:            2992 kB
> > SwapTotal:       1464316 kB
> > SwapFree:        1464316 kB
> > Dirty:                52 kB
> > Writeback:             0 kB

Since dirty/writeback pages are low, it seems not being throttled by
balance_dirty_pages().

Stefan, would you please run this several times on the server?

ps -eo user,pid,tid,class,rtprio,ni,pri,psr,pcpu,vsz,rss,pmem,stat,wchan:28,cmd | grep scp

It will show where the scp task is blocked (the wchan field). Hope it helps.

Thanks,
Fengguang
