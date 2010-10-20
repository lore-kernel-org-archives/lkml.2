Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab0JTBf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:35:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:55654 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab0JTBf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:35:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,353,1283756400"; 
   d="scan'208";a="565620510"
Date: Wed, 20 Oct 2010 09:35:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        "Figo.zhang" <zhangtianfei@leadcoretech.com>,
        lKOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        figo1802 <figo1802@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: oom_killer crash linux system
Message-ID: <20101020013553.GA7428@localhost>
References: <20101018021126.GB8654@localhost>
 <1287389631.1997.9.camel@myhost>
 <20101018180919.3AF8.A69D9226@jp.fujitsu.com>
 <1287454058.2078.12.camel@myhost>
 <20101019115952.d922763b.kamezawa.hiroyu@jp.fujitsu.com>
 <AANLkTikw6NizBStoXVz8Br_LYvoLoofsOB+d6-FX2=Be@mail.gmail.com>
 <20101019142640.44c87807.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101019142640.44c87807.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 01:26:40PM +0800, KAMEZAWA Hiroyuki wrote:
> On Tue, 19 Oct 2010 14:23:29 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > On Tue, Oct 19, 2010 at 11:59 AM, KAMEZAWA Hiroyuki
> > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > On Tue, 19 Oct 2010 10:07:38 +0800
> > > "Figo.zhang" <zhangtianfei@leadcoretech.com> wrote:
> > >
> > >>
> > >> >
> > >> > very lots of change ;)
> > >> > can you please send us your crash log?
> > >>
> > >> i add some prink in select_bad_process() and oom_badness() to see
> > >> pid/totalpages/points/memoryuseage/and finally process to selet to kill.
> > >>
> > >> i found it the oom-killer select: syslog-ng,mysqld,nautilus,VirtualBox
> > >> to kill, so my question is:
> > >>
> > >> 1. the syslog-ng,mysqld,nautilus is the system foundamental process, so
> > >> if oom-killer kill those process, the system will be damaged, such as
> > >> lose some important data.
> > >>
> > >> 2. the new oom-killer just use percentage of used memory as score to
> > >> select the candidate to kill, but how to know this process to very
> > >> important for system?
> > >>
> > >
> > > The kernel can never know it. Just an admin (a man or management software) knows.
> > > Old kernel tries to guess it, but it tend to be wrong and many many report comes
> > > "why my ....is killed..." All guesswork the kernel does is not enough, I think.
> > >
> > >> oom_score_adj, it is anyone commercial linux distributions to use this
> > >> to protect the critical process.
> > >>
> > > oom_adj may be used in some system. All my customers select panic_at_oom=1
> > > and cause cluster fail over rather than half-broken.
> > >
> > > <Off topic>
> > > Your another choice is memory cgroup, I think.
> > > please see documentation/cgroup/memory.txt or libcgroup.
> > > http://sourceforge.net/projects/libcg/
> > > You can use some fancy controls with it.
> > > </Off topic>
> > >
> > >
> > > BTW, there seems to be some strange things.
> > > (CC'ed to linux-mm)
> > > Brief Summary:
> > >   an oom-killer happens on swapless environment with 2.6.36-rc8.
> > >   It has 2G memory.
> > > a reporter says
> > > ==
> > >> i want to test the oom-killer. My desktop (Dell optiplex 780, i686
> > >> kernel)have 2GB ram, i turn off the swap partition, and open a huge pdf
> > >> files and applications, and let the system eat huge ram.
> > >>
> > >> in 2.6.35, i can use ram up to 1.75GB,
> > >>
> > >> but in 2.6.36-rc8, i just use to 1.53GB ram , the system come very slow
> > >> and crashed after some minutes , the DiskIO is very busy. i see the
> > >> DiskIO read is up to 8MB/s, write just only 400KB/s, (see by conky).
> > > ==
> > >
> > > The trigger of oom-kill is order=0 allocation. (see original mail for full log)
> > >
> > >
> > > Oct 19 09:44:08 myhost kernel: [  618.441470] httpd invoked oom-killer:
> > > gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
> > >
> > > Zone's stat is.
> > >
> > > Oct 19 09:44:08 myhost kernel: [  618.441551]
> > > DMA free:7968kB min:64kB low:80kB high:96kB active_anon:3700kB inactive_anon:3752kB
> > >    active_file:12kB inactive_file:252kB unevictable:0kB isolated(anon):0kB
> > >    isolated(file):0kB present:15788kB mlocked:0kB dirty:0kB writeback:4kB
> > >    mapped:52kB shmem:348kB slab_reclaimable:0kB slab_unreclaimable:16kB
> > >    kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB
> > >    writeback_tmp:0kB pages_scanned:421 all_unreclaimable? yes
> > >    lowmem_reserve[]: 0 865 1980 1980
> > >
> > > Oct 19 09:44:08 myhost kernel: [  618.441560]
> > > Normal free:39348kB min:3728kB low:4660kB high:5592kB active_anon:176740kB
> > >       inactive_anon:25640kB active_file:84kB inactive_file:308kB
> > >       unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB
> > >       mlocked:0kB dirty:0kB writeback:4kB mapped:576992kB shmem:5024kB
> > >       slab_reclaimable:7612kB slab_unreclaimable:15512kB kernel_stack:2792kB
> > >       pagetables:6884kB unstable:0kB bounce:0kB writeback_tmp:0kB
> > >       pages_scanned:741 all_unreclaimable? yes
> > >       lowmem_reserve[]: 0 0 8921 8921
> > >
> > > Oct 19 09:44:08 myhost kernel: [  618.441569]
> > > HighMem free:392kB min:512kB low:1712kB high:2912kB active_anon:492208kB
> > >        inactive_anon:166404kB active_file:180kB inactive_file:840kB
> > >        unevictable:40kB isolated(anon):0kB isolated(file):0kB present:1141984kB
> > >        mlocked:40kB dirty:0kB writeback:12kB mapped:493648kB shmem:72216kB
> > >        slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
> > >        pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
> > >        pages_scanned:1552 all_unreclaimable? yes
> > >
> > > Highmem seems a bit strange.
> > >  present(1141984) - active_anon - inactive_anon - inactive_file - active_file
> > >  = 482352kB but free is 392kB.
> > >
> > >  Highmem is used for some other purpose than usual user's page.(pagetable is 0.)
> > >  And, Hmm, mapped:493648kB seems too large for me.
> > >  (active/inactive-file + shmem is not enough.)
> > >  And "mapped" in NORMAL zone is large, too.
> > >
> > >  Does anyone have idea about file-mapped-but-not-on-LRU pages ?
> > 
> > Isn't it possible some file pages are much sharable?
> > Please see the page_add_file_rmap.
> > 
> 
> page_add_file_rmap() just counts an event where mapcount goes 0->1. 
> Even if thousands process shares  a page,  it's just counted into file_mapped as 1.
> 
> Then, there are 480MB of mapped file caches. Do I miss something ?
> 
> Anyway, sum-of-all-lru-of-highmem is 480MB smaller than present pages.
> and isolated(anon/file) is 0kB.
> (NORMAL has similar problem)

hugetlb files? But it's a desktop box. Figo, what's your meminfo?

The GEM objects may be files not in LRU, however they should be
accounted into shmem.

Figo, would you run "page-types -r" for some clues? It can be compiled
from the kernel tree:

        cd linux
        make Documentation/vm
        sudo Documentation/vm/page-types -r

Thanks,
Fengguang
