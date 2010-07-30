Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab0G3AGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 20:06:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40145 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab0G3AGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 20:06:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 30 Jul 2010 09:01:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
Message-Id: <20100730090146.7e65d1c1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
References: <201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<20100729142245.4AA5.A69D9226@jp.fujitsu.com>
	<20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 11:44:31 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:
 
> So, in between snapshotting the image and actually hibernating, we have
> two parallel universes, one frozen in the image, the other writing that
> out to swap: with the danger that the latter (which is about to die)
> will introduce fatal inconsistencies in the former by placing pages in
> swap locations innocently reallocated from it.  (Excuse me while I go
> write the movie script.)
> 
> I'd never got to think about that before.
> 
> Your fix is neat though hacky (it's somewhat of a coincidence that the
> usage arg happens to distinguish the hibernation case), and should be
> enough to fix "your" regression, but is it really enough?
> 
yes, it's hacky and this just hides a problem caused by the patch.

> I'm worrying about the try_to_free_swap() calls in shrink_page_list():
> can't those get called from direct reclaim (even if GFP_NOIO), and can't
> direct reclaim get invoked from somewhere in the I/O path below
> swap_writepage(), used for writing out the hibernation image?
> 
IIUC, before hibernation, shirnk_memory() is called and hibernation codes
expect there are enough memory. But you're right, there are no guarantee.

I think the best way is kexec(). But maybe rollback from hibernation failure
will be difficult. Considering how crash-dump works well and under maintainance
by many enterprise guys, hibernation-by-kexec is a choice. I think. It can make
reuse of kdump code, ...or, hibernation-resume code can eat kdump image
directly. Maybe the problem will be the speed of dump.

Otherwise, we need to take care of status changes in already-saved-memory.
Maybe anyone don't like to add COW method...

Thanks,
-Kame

