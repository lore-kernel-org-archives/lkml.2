Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab1HGDTo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 23:19:44 -0400
Received: from natasha.panasas.com ([67.152.220.90]:60612 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab1HGDTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 23:19:41 -0400
Message-ID: <4E3E043D.108@panasas.com>
Date: Sat, 6 Aug 2011 20:19:25 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        open-osd <osd-dev@open-osd.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Welch, Brent" <welch@panasas.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [GIT PULL] exofs: Changes for Linux v3.1 merge window
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please pull the following changes since commit Linux v3.0

They are available in the git repository at:
  git://git.open-osd.org/linux-open-osd.git for-linus

Sorry for the very late request. The last 3.5 patches are new, from this week.
Though they are reincarnation of very old code. The reason I want to push
them so badly is because I have code in the NFS tree, through Trond, for
Linux v3.2 that needs to be based on this code.

The issue is that I want the objects-raid-engine of both exofs and pnfs
objects-layout-driver to use the same library, ORE. Currently raid0/1
support is duplicated in both places. But I want to introduce raid5/6
and it calls for consolidation.

I have tested this code aggressively the last 3 days. And to be honest
it is not that dangerous. It is a mechanical change of renaming and
moving structures and members around. Though in places it goes deep.
I have also tested backward and forward compatibility with old exofs.

But I admit the last 3 patches did not sit in linux-next long enough.

If you feel bad pulling the all thing then please pull:
  git://git.open-osd.org/linux-open-osd.git for-linus-old

Which was in linux-next for a while and includes bug fixes and important
changes, without the move to ORE.

---
Below are the changes summary:
Boaz Harrosh (10):
      nfs_xdr: Move nfs4_string definition out of #ifdef CONFIG_NFS_V4
      exofs: Remove pnfs-osd private definitions
      exofs: BUG: Avoid sbi realloc
      exofs: Small cleanup of exofs_fill_super
      exofs: Fix truncate for the raid-groups case
      exofs: Add offset/length to exofs_get_io_state
      exofs: Move exofs specific osd operations out of ios.c
      exofs: ios: Move to a per inode components & device-table
      exofs: Rename raid engine from exofs/ios.c => ore
      ore: Make ore its own module

 fs/exofs/Kbuild           |    5 +-
 fs/exofs/Kconfig          |    4 +
 fs/exofs/exofs.h          |  159 +++++---------------
 fs/exofs/inode.c          |  152 +++++++++---------
 fs/exofs/{ios.c => ore.c} |  370 ++++++++++++++++++++++++---------------------
 fs/exofs/pnfs.h           |   45 ------
 fs/exofs/super.c          |  251 ++++++++++++++++++++-----------
 include/linux/nfs_xdr.h   |   10 +-
 include/scsi/osd_ore.h    |  125 +++++++++++++++
 9 files changed, 617 insertions(+), 504 deletions(-)
 rename fs/exofs/{ios.c => ore.c} (61%)
 delete mode 100644 fs/exofs/pnfs.h
 create mode 100644 include/scsi/osd_ore.h

---
Here are the commit logs: (rebase order)

commit 655b16128482fd12808f77a6799eea5419c93709
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Sun May 29 10:57:47 2011 +0300

    nfs_xdr: Move nfs4_string definition out of #ifdef CONFIG_NFS_V4
    
    exofs file system wants to use pnfs_osd_xdr.h file instead of
    redefining pnfs-objects types in it's private "pnfs.h" headr.
    
    Before we do the switch we must make sure pnfs_osd_xdr.h is
    compilable also under NFS versions smaller than 4.1. Since now
    it is needed regardless of version, by the exofs code.
    
    nfs4_string is not the only nfs4 type out in the global scope.
    
    Ack-by: Trond Myklebust <Trond.Myklebust@netapp.com>
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

commit 26ae93c2dc7152463d319c28768f242a11a54620
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Tue Feb 2 15:56:53 2010 +0200

    exofs: Remove pnfs-osd private definitions
    
    Now that pnfs-osd has hit mainline we can remove exofs's
    private header. (And the FIXME comment)
    
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

commit 6d4073e88132259485ef1b2c88daa5e50c95789c
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Wed Jul 27 17:51:53 2011 -0700

    exofs: BUG: Avoid sbi realloc
    
    Since the beginning we realloced the sbi structure when a bigger
    then one device table was specified. (I know that was really stupid).
    
    Then much later when "register bdi" was added (By Jens) it was
    registering the pointer to sbi->bdi before the realloc.
    
    We never saw this problem because up till now the realloc did not
    do anything since the device table was small enough to fit in the
    original allocation. But once we starting testing with large device
    tables (Bigger then 28) we noticed the crash of writeback operating
    on a deallocated pointer.
    
    * Avoid the all mess by allocating the device-table as a second array
      and get rid of the variable-sized structure and the rest of this
      mess.
    * Take the chance to clean near by structures and comments.
    * Add a needed dprint on startup to indicate the loaded layout.
    * Also move the bdi registration to the very end because it will
      only fail in a low memory, which will probably fail before hand.
      There are many more likely causes to not load before that. This
      way the error handling is made simpler. (Just doing this would be
      enough to fix the BUG)
    
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

commit 9ce730475e1b950d78a69c1be3410109c103ac98
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Wed Aug 3 20:18:01 2011 -0700

    exofs: Small cleanup of exofs_fill_super
    
    Small cleanup that unifies duplicated code used in both the
    error and success cases
    
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

commit 16f75bb35d54b44356f496272c013f7ace5fa698
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Wed Aug 3 20:44:16 2011 -0700

    exofs: Fix truncate for the raid-groups case
    
    In the general raid-group case the truncate was wrong in that
    it did not also fix the object length of the neighboring groups.
    
    There are two bad cases in the old code:
    1. Space that should be freed was not.
    2. If a file That was big is truncated small, then made bigger
       again, the holes would not contain zeros but could expose old data.
       (If the growing of the file expands to more than a full
        groups cycle + group size (> S + T))
    
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

commit e1042ba0991aab80ced34f7dade6ec25f22b4304
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Tue Nov 16 20:09:58 2010 +0200

    exofs: Add offset/length to exofs_get_io_state
    
    In future raid code we will need to know the IO offset/length
    and if it's a read or write to determine some of the array
    sizes we'll need.
    
    So add a new exofs_get_rw_state() API for use when
    writeing/reading. All other simple cases are left using the
    old way.
    
    The major change to this is that now we need to call
    exofs_get_io_state later at inode.c::read_exec and
    inode.c::write_exec when we actually know these things. So this
    patch is kept separate so I can test things apart from other
    changes.
    
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

commit 85e44df4748670a1a7d8441b2d75843cdebc478a
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Mon May 16 15:26:47 2011 +0300

    exofs: Move exofs specific osd operations out of ios.c
    
    ios.c will be moving to an external library, for use by the
    objects-layout-driver. Remove from it some exofs specific functions.
    
    Also g_attr_logical_length is used both by inode.c and ios.c
    move definition to the later, to keep it independent
    
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

commit 9e9db45649eb5d3ee5622fdad741914ecf1016a0
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Fri Aug 5 15:06:04 2011 -0700

    exofs: ios: Move to a per inode components & device-table
    
    Exofs raid engine was saving on memory space by having a single layout-info,
    single pid, and a single device-table, global to the filesystem. Then passing
    a credential and object_id info at the io_state level, private for each
    inode. It would also devise this contraption of rotating the device table
    view for each inode->ino to spread out the device usage.
    
    This is not compatible with the pnfs-objects standard, demanding that
    each inode can have it's own layout-info, device-table, and each object
    component it's own pid, oid and creds.
    
    So: Bring exofs raid engine to be usable for generic pnfs-objects use by:
    
    * Define an exofs_comp structure that holds obj_id and credential info.
    
    * Break up exofs_layout struct to an exofs_components structure that holds a
      possible array of exofs_comp and the array of devices + the size of the
      arrays.
    
    * Add a "comps" parameter to get_io_state() that specifies the ids creds
      and device array to use for each IO.
    
      This enables to keep the layout global, but the device-table view, creds
      and IDs at the inode level. It only adds two 64bit to each inode, since
      some of these members already existed in another form.
    
    * ios raid engine now access layout-info and comps-info through the passed
      pointers. Everything is pre-prepared by caller for generic access of
      these structures and arrays.
    
    At the exofs Level:
    
    * Super block holds an exofs_components struct that holds the device
      array, previously in layout. The devices there are in device-table
      order. The device-array is twice bigger and repeats the device-table
      twice so now each inode's device array can point to a random device
      and have a round-robin view of the table, making it compatible to
      previous exofs versions.
    
    * Each inode has an exofs_components struct that is initialized at
      load time, with it's own view of the device table IDs and creds.
      When doing IO this gets passed to the io_state together with the
      layout.
    
    While preforming this change. Bugs where found where credentials with the
    wrong IDs where used to access the different SB objects (super.c). As well
    as some dead code. It was never noticed because the target we use does not
    check the credentials.
    
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

commit 8ff660ab85f524bdc7652eb5d38aaef1d66aa9c7
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Sat Aug 6 19:26:31 2011 -0700

    exofs: Rename raid engine from exofs/ios.c => ore
    
    ORE stands for "Objects Raid Engine"
    
    This patch is a mechanical rename of everything that was in ios.c
    and its API declaration to an ore.c and an osd_ore.h header. The ore
    engine will later be used by the pnfs objects layout driver.
    
    * File ios.c => ore.c
    
    * Declaration of types and API are moved from exofs.h to a new
      osd_ore.h
    
    * All used types are prefixed by ore_ from their exofs_ name.
    
    * Shift includes from exofs.h to osd_ore.h so osd_ore.h is
      independent, include it from exofs.h.
    
    Other than a pure rename there are no other changes. Next patch
    will move the ore into it's own module and will export the API
    to be used by exofs and later the layout driver
    
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

commit cf283ade08c454e884394a4720f22421dd33a715
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Sat Aug 6 19:22:06 2011 -0700

    ore: Make ore its own module
    
    Export everything from ore need exporting. Change Kbuild and Kconfig
    to build ore.ko as an independent module. Import ore from exofs
    
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

