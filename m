Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab1KCFEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 01:04:14 -0400
Received: from mfb01-md.ns.itscom.net ([175.177.155.109]:53081 "EHLO
	mfb01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab1KCFEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 01:04:11 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: hooanon05@yahoo.co.jp, viro@zeniv.linux.org.uk, hch@infradead.org,
        jwboyer@gmail.com, wli@holomorphy.com
Subject: [RFC 0/2] locking order of mm->mmap_sem and various FS
Date: Thu,  3 Nov 2011 13:53:53 +0900
Message-Id: <1320296035-8744-1-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There had ever been several posts which report a circular locking
problem around mm->mmap_sem and FS. For instance
"INFO: possible circular locking dependency detected 3.1.0-rc2-00190-g3210d19"
<http://marc.info/?l=linux-kernel&m=131402669412658&w=2>

While the problem in ext4 evict_inode seems to be already solved, here
I'll try fixing hugetlbfs as first step. The problem in hugetlbfs is

- read(2) -- hugetlbfs_read() -- ... --  __copy_to_user()
  hugetlbfs_read() holds i_mutex. So this is i_mutex before mmap_sem
  correctly.

- mmap(2) -- hugetlbfs_file_mmap()
  hugetlbfs_file_mmap() holds i_mutex too. But mmap_sem is already held
  before hugetlbfs_file_mmap(). This is an AB-BA problem.

While I am not sure whether hugetlbfs_read() really needs to acquire
i_mutex, if it really does, then I'd suggest f_op->{pre,post}_mmap().
These two patches are just to show the approach and not intends to be
merged into mainline now. I don't think it is the best solution, but I
simply have no idea other than this.
I'd like to hear comments from LKML people.

Taking a glance at ->mmap() functions in several FSs. I also found
gfs2_mmap()/gfs2_readdir() which acquires gl->gl_spin and may cause a
similar problem. And ocfs2_mmap()/ocfs2_readdir() too, but I don't
understand it enough.

If it is OK and {pre,post}_mmap() is accepted, then I will step forward
and try fixing below too. All of them acquires mmap_sem and calls
->mmap() (indirectly).

- callers of do_mmap()
  arch/x86/ia32/ia32_aout.c:load_aout_binary() and its siblings
  arch/x86/kvm/x86.c:kvm_arch_prepare_memory_region()
  arch/tile/kernel/single_step.c:single_step_once()
  drivers/gpu/drm/drm_bufs.c:drm_mapbufs() and others
  drivers/gpu/drm/i810/i810_dma.c:i810_map_buffer()
  drivers/gpu/drm/i915/i915_gem.c:i915_gem_mmap_ioctl()
  fs/aio.c:aio_setup_ring()
  fs/binfmt_aout.c:load_aout_binary() and its siblings
  fs/binfmt_elf.c:elf_map() and its siblings
  fs/binfmt_elf_fdpic.c:load_elf_fdpic_binary() and its siblings
  fs/binfmt_flat.c:load_flat_file() and its siblings
  fs/binfmt_som.c:map_som_binary() and its siblings
  ipc/shm.c:do_shmat()

- callers of do_mmap_pgoff()
  mm/nommu.c:SYSCALL mmap_pgoff
  mm/mmap.c:SYSCALL mmap_pgoff

- callers of mmap_region()
  arch/tile/mm/elf.c:arch_setup_additional_pages()

Additionally they will need some work too.
- callers of ->mmap()
  fs/coda/file.c:coda_file_mmap()
  fs/proc/inode.c:proc_reg_mmap()

Oh, the base version is v3.0, not latest mainline.


J. R. Okajima (2):
  introduce f_op->{pre,post}_mmap()
  hugetlbfs: implement f_op->{pre,post}_mmap()

 Documentation/filesystems/Locking |    8 ++++++++
 Documentation/filesystems/vfs.txt |    7 +++++++
 fs/hugetlbfs/inode.c              |   20 +++++++++++++++++---
 include/linux/fs.h                |    2 ++
 include/linux/mm.h                |    4 ++++
 mm/mmap.c                         |   27 ++++++++++++++++++++++++---
 6 files changed, 62 insertions(+), 6 deletions(-)

-- 
1.7.2.5
