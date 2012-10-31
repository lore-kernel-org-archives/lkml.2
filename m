Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab2JaPQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:16:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32009 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab2JaPQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:16:07 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2012 11:16:07 EDT
MIME-Version: 1.0
Message-ID: <45d16955-dd1e-4975-a5b6-31e17322cad3@default>
Date: Wed, 31 Oct 2012 08:15:17 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, minchan@kernel.org, fschmaus@gmail.com,
        Andor Daam <andor.daam@googlemail.com>, ilendir@googlemail.com,
        akpm@linux-foundation.org, mgorman@suse.de
Subject: RE: [PATCH 0/5] enable all tmem backends to be built and loaded as
 modules
References: <<1351696074-29362-1-git-send-email-dan.magenheimer@oracle.com>>
In-Reply-To: <<1351696074-29362-1-git-send-email-dan.magenheimer@oracle.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies... I misspelled the family name of one of the
Erlangen University authors of the first two patches
in this patchset, so any reply-alls to any of the
patch posts will see a bounce.  If you reply-all to any
of these patches, kindly change one of the recipients
to:

andor.daam@googlemail.com (was misspelled andor.damm)

I regret the inconvenience... :-(

> -----Original Message-----
> From: Dan Magenheimer [mailto:dan.magenheimer@oracle.com]
> Sent: Wednesday, October 31, 2012 9:08 AM
> To: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; linux-
> mm@kvack.org; ngupta@vflare.org; konrad.wilk@oracle.com; sjenning@linux.vnet.ibm.com;
> minchan@kernel.org; dan.magenheimer@oracle.com; fschmaus@gmail.com; andor.damm@googlemail.com;
> ilendir@googlemail.com; akpm@linux-foundation.org; mgorman@suse.de
> Subject: [PATCH 0/5] enable all tmem backends to be built and loaded as modules
> 
> Since various parts of transcendent memory ("tmem") [1] were first posted in
> 2009, reviewers have suggested that various tmem features should be built
> as a module and enabled by loading the module, rather than the current clunky
> method of compiling as a built-in and enabling via boot parameter.  Due
> to certain tmem initialization steps, that was not feasible at the time.
> 
> [1] http://lwn.net/Articles/454795/
> 
> This patchset allows each of the three merged transcendent memory
> backends (zcache, ramster, Xen tmem) to be used as modules by first
> enabling transcendent memory frontends (cleancache, frontswap) to deal
> with "lazy initialization" and, second, by adding the necessary code for
> the backends to be built and loaded as modules.
> 
> The original mechanism to enable tmem backends -- namely to hardwire
> them into the kernel and select/enable one with a kernel boot
> parameter --  is retained but should be considered deprecated.  When
> backends are loaded as modules, certain knobs will now be
> properly selected via module_params rather than via undocumented
> kernel boot parameters.  Note that module UNloading is not yet
> supported as it is lower priority and will require significant
> additional work.
> 
> The lazy initialization support is necessary because filesystems
> and swap devices are normally mounted early in boot and these
> activites normally trigger tmem calls to setup certain data structures;
> if the respective cleancache/frontswap ops are not yet registered
> by a back end, the tmem setup would fail for these devices and
> cleancache/frontswap would never be enabled for them which limits
> much of the value of tmem in many system configurations.  Lazy
> initialization records the necessary information in cleancache/frontswap
> data structures and "replays" it after the ops are registered
> to ensure that all filesystems and swap devices can benefit from
> the loaded tmem backend.
> 
> Patches 1 and 2 are the original [2] patches to cleancache and frontswap
> proposed by Erlangen University, but rebased to 3.7-rcN plus a couple
> of bug fixes I found necessary to run properly.  I have not attempted
> any code cleanup.  I have also added defines to ensure at runtime
> that backends are not loaded as modules if the frontend patches are not
> yet merged; this is useful to avoid any build dependency (since the
> frontends may be merged into linux-next through different trees and
> at different times than some backends) and once the entire patchset
> is safely merged, these defines/ifdefs can be removed.
> 
> [2] http://www.spinics.net/lists/linux-mm/msg31490.html
> 
> Patch 3 enables module support for zcache2.  Zsmalloc support
> has not yet been merged into zcache2 but, once merged, could now
> easily be selected via a module_param.
> 
> Patch 4 enables module support for ramster.  Ramster will now be
> enabled with a module_param to zcache2.
> 
> Patch 5 enables module support for the Xen tmem shim.  Xen
> self-ballooning and frontswap-selfshrinking are also "lazily"
> initialized when the Xen tmem shim is loaded as a module, unless
> explicitly disabled by module_params.
> 
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> 
> ---
> Diffstat:
> 
>  drivers/staging/ramster/Kconfig                    |    6 +-
>  drivers/staging/ramster/Makefile                   |   11 +-
>  drivers/staging/ramster/ramster.h                  |    6 +-
>  drivers/staging/ramster/ramster/nodemanager.c      |    9 +-
>  drivers/staging/ramster/ramster/ramster.c          |   29 +++-
>  drivers/staging/ramster/ramster/ramster.h          |    2 +-
>  .../staging/ramster/ramster/ramster_nodemanager.h  |    2 +
>  drivers/staging/ramster/tmem.c                     |    6 +-
>  drivers/staging/ramster/tmem.h                     |    8 +-
>  drivers/staging/ramster/zcache-main.c              |   61 +++++++-
>  drivers/staging/ramster/zcache.h                   |    2 +-
>  drivers/xen/Kconfig                                |    4 +-
>  drivers/xen/tmem.c                                 |   56 ++++++--
>  drivers/xen/xen-selfballoon.c                      |   13 +-
>  include/linux/cleancache.h                         |    1 +
>  include/linux/frontswap.h                          |    1 +
>  include/xen/tmem.h                                 |    8 +
>  mm/cleancache.c                                    |  157 +++++++++++++++++--
>  mm/frontswap.c                                     |   70 ++++++++-
>  19 files changed, 379 insertions(+), 73 deletions(-)
