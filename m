Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab0CaUVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 16:21:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57676 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab0CaUVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 16:21:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Date: Wed, 31 Mar 2010 22:21:23 +0200
User-Agent: KMail/1.13.1 (Linux/2.6.33-00063-g0795fff; KDE/4.4.1; x86_64; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <201003301233.40461.arnd@arndb.de> <20100331172208.GB5163@nowhere>
In-Reply-To: <20100331172208.GB5163@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003312221.23953.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1//D4fmJtO2rZrgSVPnzQ95gyoaQ0hW2gjeY4T
 6qwEfCCNoabuTuOtbrSzHbHti1flACAL1jcuzN03UQ5Z79ZpxC
 emLibNAENt+g1TIMGRGZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 March 2010 19:22:11 Frederic Weisbecker wrote:
> On Tue, Mar 30, 2010 at 11:33:40AM +0100, Arnd Bergmann wrote:
> > I believe we can actually remove ioctl from file_operations. The patch I did
> > to convert all users to ".unlocked_ioctl = default_ioctl," should really catch
> > all cases, and I think we can enforce this by renaming fops->ioctl to locked_ioctl
> > or old_ioctl to make sure we didn't miss any, and then mandate that this one
> > is only used when unlocked_ioctl is set to default_ioctl.
> 
> I just looked at the patch in question and noted that the changelog
> is pretty high, but how could it be else.
> Actually it's not that large, but highly spread:
<snip>
>  157 files changed, 372 insertions(+), 80 deletions(-)
> 
> 
> I wonder if we should actually just turn all these into unlocked_ioctl
> directly. And then bring a warn on ioctl, and finally schedule the removal
> of this callback.
> 
> What do you think?

I don't think the warning helps all that much, at least not across an
entire release. We could leave it in for the merge window and fix all
users for -rc1, then submit a patch that kills everything that came
in during the merge window and remove it completely in -rc2.

Getting rid of ioctl completely is a lot of work though, covering the
entire lot of ~150 device drivers. I think the patch as is (or the
variant renaming .ioctl to .locked_ioctl) is far less work and has
less potential of introducing regressions.

> You plan looks good but I fear this actually carries the problem forward
> in that we won't be able to remove .ioctl after that.
> 
> I can handle that if you agree.

I don't think we really need to get rid of it this soon in the obsolete
drivers, pushing down the BKL into an unlocked_ioctl function only slightly
shifts the problem around, since the driver still depends on the BKL then
and gets disabled if you build with CONFIG_BKL=n.

IMHO, a better use of your time would be to completely remove the BKL
along with the ioctl function from any of the drivers in this lists that
looks like it could be relevant to real users.

In the meantime, we can move the declaration of the .locked_ioctl callback
into an #ifdef CONFIG_BKL, to make sure nobody builds a driver with an
ioctl function that does not get called.

Another crazy idea I had was to simply turn the BKL into a regular mutex
as soon as we can show that all remaining users are of the non-recursive
kind and don't rely on the autorelease-on-sleep. Doing that would be
much easier without the pushdown into .unlocked_ioctl than it would be
with it.

	Arnd
