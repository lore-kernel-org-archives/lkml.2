Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab0CaVlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:41:00 -0400
Received: from mail-pz0-f179.google.com ([209.85.222.179]:32933 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab0CaVk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:40:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U6s+GMTyCIL52p5kR9pgVm99MqFZ4lWWw4pThmCNpsm1SG9WE9RXJno76LlmHYbUjx
         iv0K658ux2sIMhv/eh3NMfakcEBj4IWYog2AsrzHJwhf/1yhD7q8BNO3YVJAnRYkNJPO
         VhR1Ruuv1ku3qZnqZL9V2k0In3KGlacdhE7wU=
Date: Wed, 31 Mar 2010 23:41:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Message-ID: <20100331214058.GE5163@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <201003301233.40461.arnd@arndb.de> <20100331172208.GB5163@nowhere> <201003312221.23953.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003312221.23953.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 10:21:23PM +0200, Arnd Bergmann wrote:
> On Wednesday 31 March 2010 19:22:11 Frederic Weisbecker wrote:
> > On Tue, Mar 30, 2010 at 11:33:40AM +0100, Arnd Bergmann wrote:
> > > I believe we can actually remove ioctl from file_operations. The patch I did
> > > to convert all users to ".unlocked_ioctl = default_ioctl," should really catch
> > > all cases, and I think we can enforce this by renaming fops->ioctl to locked_ioctl
> > > or old_ioctl to make sure we didn't miss any, and then mandate that this one
> > > is only used when unlocked_ioctl is set to default_ioctl.
> > 
> > I just looked at the patch in question and noted that the changelog
> > is pretty high, but how could it be else.
> > Actually it's not that large, but highly spread:
> <snip>
> >  157 files changed, 372 insertions(+), 80 deletions(-)
> > 
> > 
> > I wonder if we should actually just turn all these into unlocked_ioctl
> > directly. And then bring a warn on ioctl, and finally schedule the removal
> > of this callback.
> > 
> > What do you think?
> 
> I don't think the warning helps all that much, at least not across an
> entire release. We could leave it in for the merge window and fix all
> users for -rc1, then submit a patch that kills everything that came
> in during the merge window and remove it completely in -rc2.
> 
> Getting rid of ioctl completely is a lot of work though, covering the
> entire lot of ~150 device drivers. I think the patch as is (or the
> variant renaming .ioctl to .locked_ioctl) is far less work and has
> less potential of introducing regressions.
> 
> > You plan looks good but I fear this actually carries the problem forward
> > in that we won't be able to remove .ioctl after that.
> > 
> > I can handle that if you agree.
> 
> I don't think we really need to get rid of it this soon in the obsolete
> drivers, pushing down the BKL into an unlocked_ioctl function only slightly
> shifts the problem around, since the driver still depends on the BKL then
> and gets disabled if you build with CONFIG_BKL=n.


Hmm, yeah you're right actually. Since we have this CONFIG_BKL thing
plus a future check to prevent from people implementing new ioctl
(checking ioctl without default_ioctl), it's actually better than
a big pushdown as it's less invasive.



> In the meantime, we can move the declaration of the .locked_ioctl callback
> into an #ifdef CONFIG_BKL, to make sure nobody builds a driver with an
> ioctl function that does not get called.


Ok, now how to get this all merged? A single monolithic patch is probably
not appropriate.

The simplest is to have a single branch with the default_ioctl implemented,
and then attributed to drivers in a set cut by subsystems/drivers. And
push the whole for the next -rc1.

The other solution is to push default_ioctl for this release and get
the driver changes to each concerned tree. That said, I suspect a good
part of them are unmaintained, hence the other solution looks better
to me.


Hmm?

