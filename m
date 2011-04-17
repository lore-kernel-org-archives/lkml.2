Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1DQPMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 11:12:39 -0400
Received: from mailservices.uwaterloo.ca ([129.97.128.141]:48000 "EHLO
	mailchk-m03.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752439Ab1DQPMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 11:12:32 -0400
Date: Sun, 17 Apr 2011 11:12:04 -0400
From: Kyle Spaans <kspaans@uwaterloo.ca>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, mjg@redhat.com,
        maciej.rutecki@gmail.com, nouveau@lists.freedesktop.org,
        Nigel Cunningham <lkml@nigelcunningham.com.au>
Subject: Re: 2.6.39-rc1 nouveau regression (bisected)
Message-ID: <20110417151204.GA24519@taurine.csclub.uwaterloo.ca>
References: <20110403181206.GA19291@comet.dominikbrodowski.net>
 <20110407151129.GA24977@comet.dominikbrodowski.net>
 <20110414170559.GA10768@comet.dominikbrodowski.net>
 <20110414190117.GA3493@joi.lan>
 <20110415061136.GA21979@isilmar-3.linta.de>
 <4DAA1453.5000604@nigelcunningham.com.au>
 <20110416235028.GA6096@taurine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110416235028.GA6096@taurine.csclub.uwaterloo.ca>
X-PGP-Key: http://csclub.uwaterloo.ca/~kspaans/kspaans-pubkey.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
X-UUID: 0c1d82e5-560a-4117-b835-97377ef6cb29
X-Miltered: at mailchk-m03 with ID 4DAB0344.003 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (mailchk-m03.uwaterloo.ca [129.97.128.141]); Sun, 17 Apr 2011 11:12:09 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 07:50:28PM -0400, Kyle Spaans wrote:
> On Sun, Apr 17, 2011 at 08:12:35AM +1000, Nigel Cunningham wrote:
> > On 15/04/11 16:11, Dominik Brodowski wrote:
> > > On Thu, Apr 14, 2011 at 09:02:01PM +0200, Marcin Slusarz wrote:
> > >> On Thu, Apr 14, 2011 at 07:05:59PM +0200, Dominik Brodowski wrote:
> > >>> Thought about CCing Linus to show him that 2.6.39-rcX isn't as "calm"
> > >>> to everyone, but then chose to CC Maciej instead: Would you be so kind and
> > >>> add this to your regression list? Thanks!
> > >>>
> > >>> Since commit 38f1cff
> > >>>
> > >>>     From: Dave Airlie <airlied@redhat.com>
> > >>>     Date: Wed, 16 Mar 2011 11:34:41 +1000
> > >>>     Subject: [PATCH] Merge commit '5359533801e3dd3abca5b7d3d985b0b33fd9fe8b' into dr
> > >>>
> > >>>     This commit changed an internal radeon structure, that meant a new driver
> > >>>     in -next had to be fixed up, merge in the commit and fix up the driver.
> > >>>
> > >>>     Also fixes a trivial nouveau merge.
> > >>>
> > >>>     Conflicts:
> > >>>         drivers/gpu/drm/nouveau/nouveau_mem.c
> > >>>
> > >>> booting my atom/NM10/ION2 system crashes hard during boot, right after
> > >>> blanking the screen, and before the initramfs gets loaded. I just
> > >>> re-checked: both parent commits ( 5359533 and 4819d2e ) do indeed work
> > >>> just fine, but the merge commit ( 38f1cff ) fails, same as tip ( 85f2e68 ).
> > >> Can you activate netconsole and check whether kernel spits anything interesting?
> > >> You might try to load nouveau module after boot - maybe something will be saved
> > >> to /var/log or you could even ssh into the box and check dmesg...
> > > Compiling it as a module seems to work fine. When I do so, no regression is
> > > obvious from what gets reported in "dmesg". However, somehow I now do get
> > > some output: The last message I see is
> > >
> > > [drm] nouveau 0000:01:00.0: allocated 1680x1050, fb 0x40.... b0 <some pointer value>
> > >
> > > Then, nothing more. However, it really is quite strange why this error only
> > > appears in the CONFIG_NOUVEAU=y case, not in the =m case...
> > Try disabling CONFIG_BOOT_LOGO. I reported on freedesktop.org that it is
> > causing me an oops at boot, but my bug has been ignored there so far -
> > perhaps I should have posted it here instead.
> 
> I'm getting the exact same symptoms on my Atom + ION hardware. Crashes before it
> can write any logs if it's compiled in and the logo is selected, but boots fine
> if compiled as a module or the logo is removed.
> 
> In my case I bisected and found 8969960 by Nick Piggin (change to mm/vmalloc.c)
> to be the first bad one in 2.6.38+. This makes me think that it's not a bug in
> nouveau, but maybe a bug in the order that things are initialized?

FWIW, reverting commit 89699605fe7cfd8611900346f61cb6cbf179b10a on 2.6.39-rc3+
makes my system boot just fine with the nouveau drivers compiled into the
kernel. I've seen some similar looking bugs on LKML that this regression may or
may not be related to? It works fine on 2.6.38.

https://bugzilla.kernel.org/show_bug.cgi?id=33272
http://lkml.org/lkml/2011/4/15/194

I'm still trying to figure out exactly where the kernel is crashing after
printing
[drm] nouveau 0000:03:00.0: allocated 1280x1024 fb: 0x40000000, b0 f4cf7600

Any thoughts on what else I should look for?
