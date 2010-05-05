Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab0EEFdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 01:33:49 -0400
Received: from ozlabs.org ([203.10.76.45]:33038 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab0EEFds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 01:33:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: dedekind1@gmail.com
Subject: Re: [PULL] param sysfs oops (simple, leaky) fix, bool arrays fix
Date: Wed, 5 May 2010 15:03:41 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>
References: <200910290902.13724.rusty@rustcorp.com.au> <201005041154.24658.rusty@rustcorp.com.au> <1272996439.2458.0.camel@localhost.localdomain>
In-Reply-To: <1272996439.2458.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005051503.42289.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010 03:37:19 am Artem Bityutskiy wrote:
> On Tue, 2010-05-04 at 11:53 +0930, Rusty Russell wrote:
> > On Tue, 27 Apr 2010 08:23:24 pm Artem Bityutskiy wrote:
> > > Rusty, correct me if I'm wrong, but it looks like the above memleak was
> > > introduced by e180a6b7759a99a28cbcce3547c4c80822cb6c2a, where you added
> > > the kstrdup(). So you kinda fixed the sysfs case (it still memleaks
> > > though), but at the cost of additional insmod/rmmod leak, right?
> > 
> > Yep!
> 
> Are you working/planning to work on fixing this regression?

I'm still ambivalent on it; I have patches but it's a lot of churn for not
much gain.

To fix this, we need a way to lock parameters against changing by sysfs, and
we need to use it everywhere.  Past experience has demonstrated that this will
never be maintained.  

On the other hand, the leak is trivial.

Here's a git tree if you want to look further:

The following changes since commit 05ce7bfe547c9fa967d9cab6c37867a9cb6fb3fa:
  Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../jack/linux-fs-2.6

are available in the git repository at:

  git://git.kernel.org/rusty/linux-2.6-param-fixes.git master

Rusty Russell (17):
      param: move the EXPORT_SYMBOL to after the definitions.
      params: don't hand NULL values to param.set callbacks.
      param: use ops in struct kernel_param, rather than get and set fns directly
      param: silence .init.text references from param ops
      param: add a free hook to kernel_param_ops.
      param: use free hook for charp
      param: make param sections const.
      param: locking for kernel parameters
      param: add kerneldoc
      param: remove unnecessary writable charp
      param: simple locking for sysfs-writable charp parameters
      param: lock myri10ge_fw_name against sysfs changes.
      param: lock if_sdio's lbs_helper_name and lbs_fw_name against sysfs changes.
      param: update drivers/char/ipmi/ipmi_watchdog.c to new scheme
      ide: use module_param_named rather than module_param_call
      param: use module_param in drivers/message/fusion/mptbase.c
      param: update drivers/acpi/debug.c to new scheme

Sachin Sant (1):
      Add param ops struct for hvc_iucv driver.

 arch/um/drivers/hostaudio_kern.c          |   10 +
 drivers/acpi/debug.c                      |   32 +++-
 drivers/char/hvc_iucv.c                   |    9 +-
 drivers/char/ipmi/ipmi_watchdog.c         |   42 +++--
 drivers/ide/ide.c                         |   20 ++-
 drivers/input/misc/ati_remote2.c          |   26 ++-
 drivers/input/mouse/psmouse-base.c        |   14 +-
 drivers/message/fusion/mptbase.c          |    3 +-
 drivers/misc/lkdtm.c                      |    4 +-
 drivers/net/myri10ge/myri10ge.c           |   54 ++++--
 drivers/net/wireless/libertas/if_sdio.c   |   32 +++-
 drivers/net/wireless/libertas/if_usb.c    |    3 +
 drivers/net/wireless/libertas_tf/if_usb.c |    3 +
 drivers/scsi/bfa/bfad.c                   |    2 +
 drivers/staging/rtl8187se/r8180_core.c    |    6 +-
 drivers/staging/rtl8192e/r8192E_core.c    |    6 +-
 drivers/staging/rtl8192su/r8192U_core.c   |    6 +-
 drivers/usb/atm/ueagle-atm.c              |    2 +
 drivers/video/uvesafb.c                   |    7 +-
 drivers/video/vt8623fb.c                  |    2 +
 fs/nfs/callback.c                         |   11 +-
 include/linux/moduleparam.h               |  282 ++++++++++++++++++++++-------
 init/main.c                               |    8 +-
 kernel/params.c                           |  233 ++++++++++++++++--------
 net/mac80211/rate.c                       |    2 +
 net/sunrpc/xprtsock.c                     |   26 ++-
 scripts/mod/modpost.c                     |   13 ++
 27 files changed, 623 insertions(+), 235 deletions(-)
