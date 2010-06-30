Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab0GBLyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 07:54:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:56418 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab0GBLyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 07:54:39 -0400
Date: Wed, 30 Jun 2010 16:51:34 +0200
From: Michal Marek <mmarek@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Greg Thelen <gthelen@google.com>,
       Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
Subject: Re: [PATCH] kbuild: Clean up and speed up the localversion logic
Message-ID: <20100630145134.GA14739@sepie.suse.cz>
References: <4C1764CD.3080402@suse.cz>
 <1276782038-23441-1-git-send-email-mmarek@suse.cz>
 <20100618055512.GA20186@core.coreip.homeip.net>
 <20100629215421.GA24113@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629215421.GA24113@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 02:54:21PM -0700, Dmitry Torokhov wrote:
> On Thu, Jun 17, 2010 at 10:55:12PM -0700, Dmitry Torokhov wrote:
> > On Thu, Jun 17, 2010 at 03:40:38PM +0200, Michal Marek wrote:
> > > Now that we run scripts/setlocalversion during every build, it makes
> > > sense to move all the localversion logic there. This cleans up the
> > > toplevel Makefile and also makes sure that the script is called only
> > > once in 'make prepare' (previously, it would be called every time due to
> > > a variable expansion in an ifneq statement). No user-visible change is
> > > intended, unless one runs the setlocalversion script directly.
> > > 
> > > Reported-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > Cc: David Rientjes <rientjes@google.com>
> > > Cc: Greg Thelen <gthelen@google.com>
> > > Cc: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
> > > Signed-off-by: Michal Marek <mmarek@suse.cz>
> > > ---
> > > 
> > > I tried to test this in various scenarios, but if anyone of you could give
> > > it a try, that would be great. The patch is against 2.6.35-rc3.
> > > 
> > 
> > Seems to be working for me, I do not need to go and fetch coffee while
> > installig newly compiled kernel anymore.
> > 
> 
> Michal,
> 
> Any chance this could be merged in 2.6.35? Without the patch installing
> over the network is not really an option anymore.

I now found that my patch breaks 'make LOCALVERSION=... '. The following
patch should fix it.

Michal


commit 0a564b2645c8766a669c55bde1f1ef5b0518caec
Author: Michal Marek <mmarek@suse.cz>
Date:   Wed Jun 30 16:41:23 2010 +0200

    kbuild: Propagate LOCALVERSION= down to scripts/setlocalversion
    
    Variables given on the make commandline are not exported to $(shell
    ...) commands, so run the setlocalversion script in the make rule
    directly.
    
    Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/Makefile b/Makefile
index a86ac8c..12ab175 100644
--- a/Makefile
+++ b/Makefile
@@ -884,11 +884,9 @@ $(vmlinux-dirs): prepare scripts
 	$(Q)$(MAKE) $(build)=$@
 
 # Store (new) KERNELRELASE string in include/config/kernel.release
-localversion = $(shell $(CONFIG_SHELL) \
-	       $(srctree)/scripts/setlocalversion $(srctree))
 include/config/kernel.release: include/config/auto.conf FORCE
 	$(Q)rm -f $@
-	$(Q)echo $(KERNELVERSION)$(localversion) > $@
+	$(Q)echo "$(KERNELVERSION)$$($(CONFIG_SHELL) scripts/setlocalversion $(srctree))" > $@
 
 
 # Things we need to do before we recursively start building the kernel
