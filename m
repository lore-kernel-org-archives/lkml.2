Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0FECj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 22:39:59 -0400
Received: from ozlabs.org ([203.10.76.45]:37577 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab0FECj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 22:39:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for June 3
Date: Sat, 5 Jun 2010 12:09:51 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: "Luck, Tony" <tony.luck@intel.com>, Dave Young <hidave.darkstar@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20100603134753.710a64b3.sfr@canb.auug.org.au> <987664A83D2D224EAE907B061CE93D530114C3DE4D@orsmsx505.amr.corp.intel.com> <alpine.LFD.2.00.1006041548480.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006041548480.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006051209.51664.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010 08:27:13 am Linus Torvalds wrote:
> 
> On Fri, 4 Jun 2010, Luck, Tony wrote:
> > 
> > It gets rid of the oops. So that's good.  Something is still
> > hokey in linux-next land though because no modules get loaded.
> > So no ehci/uhci available :-(
> 
> So maybe the error (the one that caused us to exit and caused the oops due 
> to the wrong return value) is the one that now causes it to not load.
> 
> I note that ia64 has a pretty big/complex module_frob_arch_sections(). 
> Many architectures (like x86) has a trivial one ("return 0;"), and there 
> might be some ordering differences in the setup that only matter with 
> architectures that do odd things there..

Hmm, but at a glance nothing else in layout_and_allocate() can fail silently,
and ia64's module_arch_frob_sections() has a printk on fail.

But, the June 3 tree (beware dateline: we are talking next-20100603?)
had the "deref per-cpu ptr before allocating it" issue which was fixed
the following day.

There have been three bugfixes since then, too:
1) I have also thrown out the "clean up percpu" commit, which would fail
   on any relocations in the percpu section.
2) Linus' error path fix (I did it slightly different for consistency)
3) SYSFS=n compile issue.

Since it's a weekend here already, we're not going to get another linux-next
until Monday.

Here's a tree with all current fixes: still no module load?

The following changes since commit ad8456361fa19068cf49b50a4f98e41b73c08e76:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../jgarzik/libata-dev

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6 module

Eric Dumazet (1):
      module: module_unload_init() cleanup

Linus Torvalds (6):
      module: Make the 'usage' lists be two-way
      module: move find_module check to end
      module: refactor load_module
      module: refactor load_module part 2
      module: reduce stack usage for each_symbol()
      module: fix bne2 "gave up waiting for init of module libcrc32c"

Rusty Russell (18):
      module: fix kdb's illicit use of struct module_use.
      module: move sysfs exposure to end of load_module
      module: Make module sysfs functions private.
      module: make locking more fine-grained.
      module: verify_export_symbols under the lock
      module: fix bne2 "gave up waiting for init of module libcrc32c"
      module: refactor load_module part 3
      module: refactor load_module part 4
      module: refactor load_module part 5
      module: refactor out section header rewriting
      module: kallsyms functions take struct load_info
      module: layout_and_allocate
      module: sysfs cleanup
      module: fix sysfs cleanup for !CONFIG_SYSFS
      module: pass load_info into other functions
      module: move module args strndup_user to just before use
      module: group post-relocation functions into post_relocation()
      module: cleanup comments, remove noinline

 include/linux/module.h      |   44 +--
 kernel/debug/kdb/kdb_main.c |   12 +-
 kernel/module.c             | 1362 ++++++++++++++++++++++++-------------------
 3 files changed, 779 insertions(+), 639 deletions(-)
