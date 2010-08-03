Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab0HCXgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 19:36:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40157 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab0HCXgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 19:36:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Aug 2010 08:31:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH -mm] hibernation: freeze swap at hibernation (Was
 Re: Memory corruption during hibernation since 2.6.31
Message-Id: <20100804083119.8b7cd3f0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201008040109.15818.rjw@sisk.pl>
References: <201007282334.08063.rjw@sisk.pl>
	<20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100802150225.851b48fe.kamezawa.hiroyu@jp.fujitsu.com>
	<201008040109.15818.rjw@sisk.pl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010 01:09:15 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, August 02, 2010, KAMEZAWA Hiroyuki wrote:
> > On Fri, 30 Jul 2010 13:14:32 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Thu, 29 Jul 2010 21:10:10 -0700
> > > Hugh Dickins <hughd@google.com> wrote:
> > > 
> > > > On Thu, Jul 29, 2010 at 5:01 PM, KAMEZAWA Hiroyuki
> > > > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > 
> > > > > I think the best way is kexec(). But maybe rollback from hibernation failure
> > > > > will be difficult. Considering how crash-dump works well and under maintainance
> > > > > by many enterprise guys, hibernation-by-kexec is a choice. I think. It can make
> > > > > reuse of kdump code, ...or, hibernation-resume code can eat kdump image
> > > > > directly. Maybe the problem will be the speed of dump.
> > > > 
> > > > I've no appetite for a total rework of hibernation, and I don't see
> > > > how that would
> > > > address the issue: I'm just looking for some protection against swap
> > > > reuse danger.
> > > > 
> > > Okay ;) (And I forget that kexec has to prepare memory at boot time for 2nd kernel.
> > > It will be harmful for small device guys.)
> > > 
> > > I'll prepare a routine not-quick-fix.
> > 
> > Ok, here. Passed easy tests as
> > # echo disk > /sys/power/state
> > 
> > 
> > Looks like a big hammer ? But I think following kind of patch is required.
> > About swap-reuse, it's only possible when a page is added to swap cache
> > but try_to_unmap() fails and the page remains in memory. IIUC, most of this
> > kind of pages will be backed to swap by shrink_all_memory(). So, reuse-swap
> > happens only when the user unlucky. This patch ignores reuse-swap but freeze
> > swap_map[] for saving swap_map[] to the disk in consistent way.
> > 
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > swap_map[] is a one of objects which can be update while hibernation. I.E,
> > usage counter in swap_map[] is updated while hibernation is making a copy
> > of memory image to the disk.
> > 
> > At resume, hibenation code doesn't call swap_free() against the swaps they
> > used...So, the swap_map[] will turns to be an initial state.
> > 
> > With small consideration, the question is how swap_map[] updated before
> > dumping to the disk is treated. In swap-system view, there are no guarantee
> > that swap_map[] are properly reloaded and there is no leak in swap count.
> > 
> > This patch tries to freeze swap_map[] during hibernation.
> > By this, no updates will be happen to swap_map[] among save_image().
> > At load_image(), the swap_map[] has no record for swap entries used by
> > save_image(), we can simply forget it.
> > 
> > Note: I'm not a specialist of hibernation...so, I'm not sure the hooks
> >       to kernel/power/user.c is appropriate or not.
> >       And this disables swap-out once hibernation starts saving.
> >       Should we afraid of OOM ?
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I have only one comment (below).
> 
> > ---
> ...
> > Index: mmotm-0727/kernel/power/user.c
> > ===================================================================
> > --- mmotm-0727.orig/kernel/power/user.c
> > +++ mmotm-0727/kernel/power/user.c
> > @@ -135,6 +135,7 @@ static int snapshot_release(struct inode
> >  	free_basic_memory_bitmaps();
> >  	data = filp->private_data;
> >  	free_all_swap_pages(data->swap);
> > +	hibernation_thaw_swap();
> 
> free_all_swap_pages() calls hibernation_thaw_swap(), so it doesn't need to be
> called again.
> 

Ah, yes. Thank you for review.

Regards,
-Kame

