Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0HKNqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 09:46:15 -0400
Received: from ozlabs.org ([203.10.76.45]:33536 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab0HKNqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 09:46:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] Module parameter bugfixes and cleanups
Date: Wed, 11 Aug 2010 23:15:58 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Sachin Sant <sachinp@in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008112315.59826.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes some longstanding bugs in the module parameter code: these
patches date from over 6 months ago and have been in linux-next.

We currently leak memory on setting a charp parameter via sysfs, since there
was no way of stopping those writes while accessing parameters.  To fix this
we create an ops structure, add a ->free routine to it, and implement locking
primitives for drivers.  This doesn't effect trivial parameter usage, but I
fix up the more boutique ones rather than write a compat layer.

Many cleanups along the way, including documentation.

The following changes since commit 3d30701b58970425e1d45994d6cb82f828924fdd:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://neil.brown.name/md

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git params

Rusty Russell (19):
      documentation: fix erroneous email address.
      params: don't hand NULL values to param.set callbacks.
      param: move the EXPORT_SYMBOL to after the definitions.
      param: use ops in struct kernel_param, rather than get and set fns directly
      param: silence .init.text references from param ops
      param: add a free hook to kernel_param_ops.
      param: use free hook for charp (fix leak of charp parameters)
      param: make param sections const.
      param: locking for kernel parameters
      param: add kerneldoc to moduleparam.h
      param: remove unnecessary writable charp
      param: simple locking for sysfs-writable charp parameters
      param: lock myri10ge_fw_name against sysfs changes.
      param: lock if_sdio's lbs_helper_name and lbs_fw_name against sysfs changes.
      param: update drivers/char/ipmi/ipmi_watchdog.c to new scheme
      ide: use module_param_named rather than module_param_call
      param: use module_param in drivers/message/fusion/mptbase.c
      param: update drivers/acpi/debug.c to new scheme
      param: don't deref arg in __same_type() checks

Sachin Sant (1):
      Add param ops struct for hvc_iucv driver.

Stephen Rothwell (2):
      AppArmor: update for module_param_named API change
      nfs: update for module_param_named API change

 Documentation/cpu-hotplug.txt             |    2 +-
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
 include/linux/moduleparam.h               |  288 ++++++++++++++++++++++-------
 init/main.c                               |    8 +-
 kernel/params.c                           |  233 ++++++++++++++++-------
 net/mac80211/rate.c                       |    2 +
 net/sunrpc/auth.c                         |    9 +-
 net/sunrpc/xprtsock.c                     |   26 ++-
 scripts/mod/modpost.c                     |   13 ++
 security/apparmor/lsm.c                   |   36 +++--
 30 files changed, 658 insertions(+), 253 deletions(-)

commit d2800800d795350435936b08afb402ed9aab1e66
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:08 2010 -0600

    documentation: fix erroneous email address.
    
    Hey, at least it has both l's.
    
    Reported-by: Marin Mitov <mitov@issp.bas.bg>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 Documentation/cpu-hotplug.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 2e9fb9953df91ef6310da22182ca8f4496907502
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:10 2010 -0600

    params: don't hand NULL values to param.set callbacks.
    
    An audit by Dongdong Deng revealed that most driver-author-written param
    calls don't handle val == NULL (which happens when parameters are specified
    with no =, eg "foo" instead of "foo=1").
    
    The only real case to use this is boolean, so handle it specially for that
    case and remove a source of bugs for everyone else.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Dongdong Deng <dongdong.deng@windriver.com>
    Cc: Américo Wang <xiyou.wangcong@gmail.com>

 kernel/params.c |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

commit a14fe249a8f74269c9e636bcbaa78f5bdb354ce3
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:11 2010 -0600

    param: move the EXPORT_SYMBOL to after the definitions.
    
    This is modern style, and good to do before we start changing things.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Reviewed-by: Takashi Iwai <tiwai@suse.de>
    Tested-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

 kernel/params.c |   39 +++++++++++++--------------------------
 1 files changed, 13 insertions(+), 26 deletions(-)

commit 9bbb9e5a33109b2832e2e63dcc7a132924ab374b
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:12 2010 -0600

    param: use ops in struct kernel_param, rather than get and set fns directly
    
    This is more kernel-ish, saves some space, and also allows us to
    expand the ops without breaking all the callers who are happy for the
    new members to be NULL.
    
    The few places which defined their own param types are changed to the
    new scheme (more which crept in recently fixed in following patches).
    
    Since we're touching them anyway, we change get() and set() to take a
    const struct kernel_param (which they really are).  This causes some
    harmless warnings until we fix them (in following patches).
    
    To reduce churn, module_param_call creates the ops struct so the callers
    don't have to change (and casts the functions to reduce warnings).
    The modern version which takes an ops struct is called module_param_cb.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Reviewed-by: Takashi Iwai <tiwai@suse.de>
    Tested-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
    Cc: "David S. Miller" <davem@davemloft.net>
    Cc: Ville Syrjala <syrjala@sci.fi>
    Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Cc: Alessandro Rubini <rubini@ipvvis.unipv.it>
    Cc: Michal Januszewski <spock@gentoo.org>
    Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
    Cc: "J. Bruce Fields" <bfields@fieldses.org>
    Cc: Neil Brown <neilb@suse.de>
    Cc: linux-kernel@vger.kernel.org
    Cc: linux-input@vger.kernel.org
    Cc: linux-fbdev-devel@lists.sourceforge.net
    Cc: linux-nfs@vger.kernel.org
    Cc: netdev@vger.kernel.org

 drivers/input/misc/ati_remote2.c   |   26 +++++---
 drivers/input/mouse/psmouse-base.c |   14 +++--
 drivers/video/uvesafb.c            |    7 +-
 fs/nfs/callback.c                  |   11 ++--
 include/linux/moduleparam.h        |  123 ++++++++++++++++++++++--------------
 kernel/params.c                    |   90 ++++++++++++++++++--------
 net/sunrpc/xprtsock.c              |   26 +++++---
 7 files changed, 186 insertions(+), 111 deletions(-)

commit 101d6c826fa03266f8538ea4f6a459190e6863e8
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Mon Aug 2 12:00:43 2010 +1000

    AppArmor: update for module_param_named API change
    
    Fixes these build errors:
    security/apparmor/lsm.c:701: error: 'param_ops_aabool' undeclared here (not in a function)
    security/apparmor/lsm.c:721: error: 'param_ops_aalockpolicy' undeclared here (not in a function)
    security/apparmor/lsm.c:729: error: 'param_ops_aauint' undeclared here (not in a function)
    
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: John Johansen <john.johansen@canonical.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 security/apparmor/lsm.c |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

commit 8e4e15d44a817e9f02cb04a6cd6c0ee77ed3fbd8
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Wed Aug 4 12:11:22 2010 +1000

    nfs: update for module_param_named API change
    
    After merging the rr tree, today's linux-next build (powerpc
    ppc64_defconfig) failed like this:
    
    net/sunrpc/auth.c:74: error: 'param_ops_hashtbl_sz' undeclared here (not in a function)
    
    Caused by commit 0685652df0929cec7d78efa85127f6eb34962132
    ("param:param_ops") interacting with commit
    f8f853ab19fcc415b6eadd273373edc424916212 ("SUNRPC: Make the credential
    cache hashtable size configurable") from the nfs tree.
    
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 net/sunrpc/auth.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

commit 549a8a030693912d5ec4106c2f538593c482a1e4
Author: Sachin Sant <sachinp@in.ibm.com>
Date:   Tue Nov 17 18:51:03 2009 +0530

    Add param ops struct for hvc_iucv driver.
    
    Today's next 20091117 build failed on s390 with
    
    drivers/char/hvc_iucv.c:1331: error: 'param_ops_vmidfilter' undeclared here (not in a function)
    make[2]: *** [drivers/char/hvc_iucv.o] Error 1
    
    Most probably caused by commit 684a6d340b8a5767db4670031b0f39455346018a
    (param:param_ops) which introduced a param_ops structure.
    
    The following compile tested patch adds a param_ops structure for hvc_iucv.
    
    Signed-off-by: Sachin Sant <sachinp@in.ibm.com>
    Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Tested-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/char/hvc_iucv.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

commit 6a841528d288ac420052f5c98fd426b0fcdc5b52
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:16 2010 -0600

    param: silence .init.text references from param ops
    
    Ideally, we'd check that it was only the "set" function which was __init,
    and that the permissions were r/o.  But that's a little hard.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Sam Ravnborg <sam@ravnborg.org>
    Tested-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

 scripts/mod/modpost.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

commit e6df34a4429b77fdffb6e05adf263468a3dcda33
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:17 2010 -0600

    param: add a free hook to kernel_param_ops.
    
    This allows us to generalize the KPARAM_KMALLOCED flag, by calling a function
    on every parameter when a module is unloaded.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Reviewed-by: Takashi Iwai <tiwai@suse.de>
    Tested-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

 include/linux/moduleparam.h |    2 ++
 kernel/params.c             |   17 ++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

commit a1054322afc8120ea5a50bc84e5beeda54571862
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:18 2010 -0600

    param: use free hook for charp (fix leak of charp parameters)
    
    Instead of using a "I kmalloced this" flag, we keep track of the kmalloced
    strings and use that list to check if we need to kfree (in practice, the
    list is very short).
    
    This means that kparams can be const again, and plugs a leak.  This
    is important for drivers/usb/gadget/nokia.c which gets modprobe/rmmod'ed
    frequently on the N9000.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Reviewed-by: Takashi Iwai <tiwai@suse.de>
    Cc: Artem Bityutskiy <dedekind1@gmail.com>
    Tested-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

 kernel/params.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 50 insertions(+), 2 deletions(-)

commit 914dcaa84c53f2c3efa6016efcae13fd92a8a17c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:18 2010 -0600

    param: make param sections const.
    
    Since this section can be read-only (they're in .rodata), they should
    always have been const.  Minor flow-through various functions.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Tested-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

 include/linux/moduleparam.h |    2 +-
 init/main.c                 |    8 ++++----
 kernel/params.c             |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

commit 907b29eb41aa604477a655bff7345731da94514d
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:19 2010 -0600

    param: locking for kernel parameters
    
    There may be cases (most obviously, sysfs-writable charp parameters) where
    a module needs to prevent sysfs access to parameters.
    
    Rather than express this in terms of a big lock, the functions are
    expressed in terms of what they protect against.  This is clearer, esp.
    if the implementation changes to a module-level or even param-level lock.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Reviewed-by: Takashi Iwai <tiwai@suse.de>
    Tested-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

 include/linux/moduleparam.h |   56 +++++++++++++++++++++++++++++++++++++++++++
 kernel/params.c             |   33 ++++++++++++++++++++-----
 2 files changed, 82 insertions(+), 7 deletions(-)

commit 546970bc6afc7fb37447fbac09b82c7884662c21
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:20 2010 -0600

    param: add kerneldoc to moduleparam.h
    
    Also reorders the macros with the most common ones at the top.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Reviewed-by: Takashi Iwai <tiwai@suse.de>
    Tested-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

 include/linux/moduleparam.h |  121 +++++++++++++++++++++++++++++++++---------
 1 files changed, 95 insertions(+), 26 deletions(-)

commit dca41306395eab37e222ff9e72765e692fcc7251
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:21 2010 -0600

    param: remove unnecessary writable charp
    
    sysfs-writable charp arguments need to be locked against modification
    (since the old ones may be kfreed underneath us).  String arguments
    are much simpler, so use them for small strings (eg. IFNAMSIZ).
    
    lkdtm only uses the parameters at module initialization time, so there's
    not much point making them writable.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Reviewed-by: Takashi Iwai <tiwai@suse.de>
    Tested-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: M. Mohan Kumar <mohan@in.ibm.com>
    Cc: Greg Kroah-Hartman <gregkh@suse.de>
    Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
    Cc: Jeff Mahoney <jeffm@suse.com>
    Cc: Julia Lawall <julia@diku.dk>
    Cc: devel@driverdev.osuosl.org

 drivers/misc/lkdtm.c                    |    4 ++--
 drivers/staging/rtl8187se/r8180_core.c  |    6 +++---
 drivers/staging/rtl8192e/r8192E_core.c  |    6 +++---
 drivers/staging/rtl8192su/r8192U_core.c |    6 +++---
 4 files changed, 11 insertions(+), 11 deletions(-)

commit d6d1b650ae6acce73d55dd0246de22180303ae73
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:27 2010 -0600

    param: simple locking for sysfs-writable charp parameters
    
    Since the writing to sysfs can free the old one, we need to block that
    when we access the charp variables.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Reviewed-by: Takashi Iwai <tiwai@suse.de>
    Tested-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
    Cc: Jeff Dike <jdike@addtoit.com>
    Cc: Dan Williams <dcbw@redhat.com>
    Cc: John W. Linville <linville@tuxdriver.com>
    Cc: Jing Huang <huangj@brocade.com>
    Cc: James E.J. Bottomley <James.Bottomley@suse.de>
    Cc: Greg Kroah-Hartman <gregkh@suse.de>
    Cc: Johannes Berg <johannes@sipsolutions.net>
    Cc: David S. Miller <davem@davemloft.net>
    Cc: user-mode-linux-devel@lists.sourceforge.net
    Cc: libertas-dev@lists.infradead.org
    Cc: linux-wireless@vger.kernel.org
    Cc: netdev@vger.kernel.org
    Cc: linux-scsi@vger.kernel.org
    Cc: linux-usb@vger.kernel.org

 arch/um/drivers/hostaudio_kern.c          |   10 ++++++++++
 drivers/net/wireless/libertas/if_usb.c    |    3 +++
 drivers/net/wireless/libertas_tf/if_usb.c |    3 +++
 drivers/scsi/bfa/bfad.c                   |    2 ++
 drivers/usb/atm/ueagle-atm.c              |    2 ++
 drivers/video/vt8623fb.c                  |    2 ++
 net/mac80211/rate.c                       |    2 ++
 7 files changed, 24 insertions(+), 0 deletions(-)

commit 7d3510356b066bcfa9898ec3f90c9c7810ba6ed7
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:31 2010 -0600

    param: lock myri10ge_fw_name against sysfs changes.
    
    Since it can be changed via sysfs, we need to make a copy.  This most
    generic way of doing this is to keep a flag so we know when to free it.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Reviewed-by: Takashi Iwai <tiwai@suse.de>
    Cc: Andrew Gallatin <gallatin@myri.com>
    Cc: Brice Goglin <brice@myri.com>
    Cc: netdev@vger.kernel.org

 drivers/net/myri10ge/myri10ge.c |   54 +++++++++++++++++++++++++++++---------
 1 files changed, 41 insertions(+), 13 deletions(-)

commit 886275ce41a9751117367fb387ed171049eb6148
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:33 2010 -0600

    param: lock if_sdio's lbs_helper_name and lbs_fw_name against sysfs changes.
    
    Since it can be changed via sysfs, we need to make a copy.  This most
    generic way of doing this is to keep a flag so we know when to free it.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Reviewed-by: Takashi Iwai <tiwai@suse.de>
    Cc: Dan Williams <dcbw@redhat.com>
    Cc: John W. Linville <linville@tuxdriver.com>
    Cc: libertas-dev@lists.infradead.org
    Cc: linux-wireless@vger.kernel.org
    Cc: netdev@vger.kernel.org

 drivers/net/wireless/libertas/if_sdio.c |   32 +++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 2 deletions(-)

commit c8ba6c52e19c13c2b6fb9ca9e5188799c753914c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:37 2010 -0600

    param: update drivers/char/ipmi/ipmi_watchdog.c to new scheme
    
    This is one of the most interesting users of module parameters in the
    tree, so weaning it off the old-style non-const module_param_call
    scheme is a useful exercise.
    
    I was confused by set_param_int/get_param_int (vs. the normal
    param_set_int and param_get_int), so I renamed set_param_int to
    set_param_timeout, and re-used param_get_int directly instead of
    get_param_int.  I also implemented param_check_wdog_ifnum and
    param_check_timeout, so now the ifnum_to_use and timeout/pretimeout
    parameters can just use plain module_param().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Corey Minyard <minyard@acm.org>
    Cc: openipmi-developer@lists.sourceforge.net

 drivers/char/ipmi/ipmi_watchdog.c |   42 +++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 15 deletions(-)

commit 1a8bff5b404909436fcf03cac167a76ceaaa5547
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:38 2010 -0600

    ide: use module_param_named rather than module_param_call
    
    It has the additional benefit of typechecking (in this case, an unsigned int).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Reviewed-by: Takashi Iwai <tiwai@suse.de>

 drivers/ide/ide.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

commit 57ba4717f2fe3ed441f3225dd9e05f6a0419fb6c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:39 2010 -0600

    param: use module_param in drivers/message/fusion/mptbase.c
    
    No need to open code this!
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Reviewed-by: Takashi Iwai <tiwai@suse.de>

 drivers/message/fusion/mptbase.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

commit 4ef2db016aab27af05a95aeab1c30ad3f2fed7b9
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:39 2010 -0600

    param: update drivers/acpi/debug.c to new scheme
    
    The new module_param_cb() uses an ops struct, and the ops take a
    const struct kernel_param pointer (it's in .rodata).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/acpi/debug.c |   32 ++++++++++++++++++++++++--------
 1 files changed, 24 insertions(+), 8 deletions(-)

commit a6de51b2787012ba3ab62c7d50df1b749b83d5f0
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Aug 11 23:04:40 2010 -0600

    param: don't deref arg in __same_type() checks
    
    gcc allows this when arg is a function, but sparse complains:
    
    drivers/char/ipmi/ipmi_watchdog.c:303:1: error: cannot dereference this type
    drivers/char/ipmi/ipmi_watchdog.c:307:1: error: cannot dereference this type
    drivers/char/ipmi/ipmi_watchdog.c:311:1: error: cannot dereference this type
    
    Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
    Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/moduleparam.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)
