Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab1AYCqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 21:46:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:60111 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab1AYCqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 21:46:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,372,1291622400"; 
   d="scan'208";a="379397510"
Date: Tue, 25 Jan 2011 10:46:29 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: more dput lock contentions in 2.6.38-rc?
Message-ID: <20110125024629.GA8931@sli10-conroe.sh.intel.com>
References: <1295915725.1949.967.camel@sli10-conroe>
 <AANLkTikOdiQR+rWXzoU9z5sJv9Q2=ehdhi1NCHXT0a-w@mail.gmail.com>
 <1295917864.1949.970.camel@sli10-conroe>
 <AANLkTimwSNsjR5PnVP8JvzwEBwy3VtDp4DvNecKsTnxJ@mail.gmail.com>
 <1295919258.1949.973.camel@sli10-conroe>
 <AANLkTikfxGF_4ZjJXP7kNChkDBnva5iStTPRLs3B86+c@mail.gmail.com>
 <20110125020123.GA30965@sli10-conroe.sh.intel.com>
 <AANLkTingD-=kXuNReEXeQGX3WVAAam5jVSBrkM2HCc-B@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTingD-=kXuNReEXeQGX3WVAAam5jVSBrkM2HCc-B@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 10:09:48AM +0800, Nick Piggin wrote:
> On Tue, Jan 25, 2011 at 1:01 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> > On Tue, Jan 25, 2011 at 09:44:45AM +0800, Nick Piggin wrote:
> >> On Tue, Jan 25, 2011 at 12:34 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> >> > On Tue, 2011-01-25 at 09:26 +0800, Nick Piggin wrote:
> >> >> On Tue, Jan 25, 2011 at 12:11 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> >> >> > On Tue, 2011-01-25 at 09:04 +0800, Nick Piggin wrote:
> >> >> >> On Tue, Jan 25, 2011 at 11:35 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> >> >> >> > Hi,
> >> >> >> > we are testing dbench benchmark and see big drop of 2.6.38-rc compared
> >> >> >> > to 2.6.37 in several machines with 2 sockets or 4 sockets. We have 12
> >> >> >> > disks mount to /mnt/stp/dbenchdata/sd*/ and dbench runs against data of
> >> >> >> > the disks. According to perf, we saw more lock contentions:
> >> >> >> > In 2.6.37: 13.00%        dbench  [kernel.kallsyms]   [k] _raw_spin_lock
> >> >> >> > In 2.6.38-rc: 69.45%        dbench  [kernel.kallsyms]   [k]_raw_spin_lock
> >> >> >> > -     69.45%        dbench  [kernel.kallsyms]   [k] _raw_spin_lock
> >> >> >> >   - _raw_spin_lock
> >> >> >> >      - 48.41% dput
> >> >> >> >         - 61.17% path_put
> >> >> >> >            - 60.47% do_path_lookup
> >> >> >> >               + 53.18% user_path_at
> >> >> >> >               + 42.13% do_filp_open
> >> >> >> >               + 4.69% user_path_parent
> >> >> >>
> >> >> >> What filesystems are mounted on the path?
> >> >> > ext3 or ext4
> >> >>
> >> >> ext3 or 4 along every step of the path? Are there
> >> >> any acls loaded, or security policy running?
> >> > all disks are formated with the same fs, just some machines use ext3 and
> >> > others ext4. no we don't have acl or security policy.
> >> >> It may be possible that they're all coming from
> >> >> /proc/ access.
> >> > I added trace in dput just after the lock taken. and most files are '/',
> >> > 'mnt', 'stp'. the percentage of 'proc' is small actually.
> >>
> >> Hm, OK well I could send you a patch to gather some statistics for
> >> why rcu-walk gets dropped. It'll have to wait until I get home, though.
> > Sure, I'm still at office tomorrow. I can test before that day, otherwise
> > maybe Tim can help.
> 
> There _are_ a lot of dput contentions coming from d_path. Some of the
> dentries you're seeing in dput could be coming from path_put in
> d_path (mountpoints, eg. 'mnt').
> 
> What does an actual snippet from perf with callgraphs look like?
here is another perf report

# Events: 198K cycles
#
# Overhead       Command       Shared Object                                      Symbol
# ........  ............  ..................  ..........................................
#
    70.20%        dbench  [kernel.kallsyms]   [k] _raw_spin_lock
                  |
                  --- _raw_spin_lock
                     |          
                     |---1.79%-- dput
                     |          |          
                     |          |---45.22%-- path_put
                     |          |          |          
                     |          |          |--58.16%-- do_path_lookup
                     |          |          |          |          
                     |          |          |          |--55.25%-- user_path_at
                     |          |          |          |          |          
                     |          |          |          |          |--96.85%-- vfs_fstatat
                     |          |          |          |          |          vfs_stat
                     |          |          |          |          |          sys_newstat
                     |          |          |          |          |          system_call_fastpath
                     |          |          |          |          |          __GI___xstat64
                     |          |          |          |          |          |          
                     |          |          |          |          |           --100.00%-- 0x1000
                     |          |          |          |          |          
                     |          |          |          |           --3.15%-- sys_statfs
                     |          |          |          |                     system_call_fastpath
                     |          |          |          |                     __GI___statfs
                     |          |          |          |                     |          
                     |          |          |          |                     |--80.01%-- _int_malloc
                     |          |          |          |                     |          
                     |          |          |          |                      --19.99%-- 0x6a
                     |          |          |          |          
                     |          |          |          |--40.19%-- do_filp_open
                     |          |          |          |          do_sys_open
                     |          |          |          |          sys_open
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI_open64
                     |          |          |          |          |          
                     |          |          |          |           --100.00%-- __fopen_internal
                     |          |          |          |                     |          
                     |          |          |          |                     |--80.02%-- 0x200000000
                     |          |          |          |                     |          
                     |          |          |          |                      --19.98%-- 0x34c333c0ef
                     |          |          |          |          
                     |          |          |           --4.56%-- user_path_parent
                     |          |          |                     |          
                     |          |          |                     |--66.67%-- do_unlinkat
                     |          |          |                     |          sys_unlink
                     |          |          |                     |          system_call_fastpath
                     |          |          |                     |          __unlink
                     |          |          |                     |          
                     |          |          |                      --33.33%-- sys_renameat
                     |          |          |                                sys_rename
                     |          |          |                                system_call_fastpath
                     |          |          |                                __GI_rename
                     |          |          |          
                     |          |          |--37.67%-- d_path
                     |          |          |          seq_path
                     |          |          |          show_vfsmnt
                     |          |          |          seq_read
                     |          |          |          vfs_read
                     |          |          |          sys_read
                     |          |          |          system_call_fastpath
                     |          |          |          __GI___libc_read
                     |          |          |          
                     |          |          |--2.15%-- do_filp_open
                     |          |          |          do_sys_open
                     |          |          |          sys_open
                     |          |          |          system_call_fastpath
                     |          |          |          __GI_open64
                     |          |          |          
                     |          |          |--1.89%-- mounts_release
                     |          |          |          fput
                     |          |          |          filp_close
                     |          |          |          sys_close
                     |          |          |          system_call_fastpath
                     |          |          |          __GI_close
                     |          |           --0.13%-- [...]
                     |          |          
                     |          |--41.39%-- link_path_walk
                     |          |          |          
                     |          |          |--96.97%-- do_path_lookup
                     |          |          |          |          
                     |          |          |          |--51.11%-- user_path_at
                     |          |          |          |          |          
                     |          |          |          |          |--94.58%-- vfs_fstatat
                     |          |          |          |          |          vfs_stat
                     |          |          |          |          |          sys_newstat
                     |          |          |          |          |          system_call_fastpath
                     |          |          |          |          |          __GI___xstat64
                     |          |          |          |          |          |          
                     |          |          |          |          |           --100.00%-- 0x1000
                     |          |          |          |          |          
                     |          |          |          |          |--3.62%-- sys_statfs
                     |          |          |          |          |          system_call_fastpath
                     |          |          |          |          |          __GI___statfs
                     |          |          |          |          |          |          
                     |          |          |          |          |          |--50.32%-- _int_malloc
                     |          |          |          |          |          |          
                     |          |          |          |          |          |--24.79%-- 0x1000
                     |          |          |          |          |          |          
                     |          |          |          |          |          |--12.50%-- 0x4
                     |          |          |          |          |          |          0x544345004b4f5f53
                     |          |          |          |          |          |          
                     |          |          |          |          |           --12.39%-- 0x34c3571740
                     |          |          |          |          |          
                     |          |          |          |           --1.80%-- do_utimes
                     |          |          |          |                     sys_utime
                     |          |          |          |                     system_call_fastpath
                     |          |          |          |                     __GI_utime
                     |          |          |          |          
                     |          |          |          |--44.11%-- do_filp_open
                     |          |          |          |          do_sys_open
                     |          |          |          |          sys_open
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI_open64
                     |          |          |          |          
                     |          |          |           --4.78%-- user_path_parent
                     |          |          |                     |          
                     |          |          |                     |--61.54%-- do_unlinkat
                     |          |          |                     |          sys_unlink
                     |          |          |                     |          system_call_fastpath
                     |          |          |                     |          __unlink
                     |          |          |                     |          
                     |          |          |                      --38.46%-- sys_renameat
                     |          |          |                                sys_rename
                     |          |          |                                system_call_fastpath
                     |          |          |                                __GI_rename
                     |          |          |          
                     |          |          |--2.85%-- do_filp_open
                     |          |          |          do_sys_open
                     |          |          |          sys_open
                     |          |          |          system_call_fastpath
                     |          |          |          __GI_open64
                     |          |           --0.18%-- [...]
                     |           --0.22%-- [...]
                     |          
                     |---22.62%-- path_get
                     |          |          
                     |          |--61.51%-- nameidata_drop_rcu
                     |          |          link_path_walk
                     |          |          |          
                     |          |          |--96.48%-- do_path_lookup
                     |          |          |          |          
                     |          |          |          |--54.89%-- user_path_at
                     |          |          |          |          |          
                     |          |          |          |          |--93.35%-- vfs_fstatat
                     |          |          |          |          |          vfs_stat
                     |          |          |          |          |          sys_newstat
                     |          |          |          |          |          system_call_fastpath
                     |          |          |          |          |          __GI___xstat64
                     |          |          |          |          |          |          
                     |          |          |          |          |           --100.00%-- 0x1000
                     |          |          |          |          |          
                     |          |          |          |          |--5.09%-- sys_statfs
                     |          |          |          |          |          system_call_fastpath
                     |          |          |          |          |          __GI___statfs
                     |          |          |          |          |          |          
                     |          |          |          |          |          |--50.01%-- 0x1000
                     |          |          |          |          |          |          
                     |          |          |          |          |           --49.99%-- 0x9
                     |          |          |          |          |          
                     |          |          |          |           --1.57%-- do_utimes
                     |          |          |          |                     sys_utime
                     |          |          |          |                     system_call_fastpath
                     |          |          |          |                     __GI_utime
                     |          |          |          |          
                     |          |          |          |--40.17%-- do_filp_open
                     |          |          |          |          do_sys_open
                     |          |          |          |          sys_open
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI_open64
                     |          |          |          |          |          
                     |          |          |          |           --100.00%-- __fopen_internal
                     |          |          |          |                     |          
                     |          |          |          |                     |--66.67%-- 0x34c333c0ef
                     |          |          |          |                     |          
                     |          |          |          |                      --33.33%-- 0x200000000
                     |          |          |          |          
                     |          |          |           --4.94%-- user_path_parent
                     |          |          |                     |          
                     |          |          |                     |--73.91%-- do_unlinkat
                     |          |          |                     |          sys_unlink
                     |          |          |                     |          system_call_fastpath
                     |          |          |                     |          __unlink
                     |          |          |                     |          
                     |          |          |                      --26.09%-- sys_renameat
                     |          |          |                                sys_rename
                     |          |          |                                system_call_fastpath
                     |          |          |                                __GI_rename
                     |          |          |          
                     |          |           --3.52%-- do_filp_open
                     |          |                     do_sys_open
                     |          |                     sys_open
                     |          |                     system_call_fastpath
                     |          |                     __GI_open64
                     |          |          
                     |          |--37.35%-- d_path
                     |          |          seq_path
                     |          |          show_vfsmnt
                     |          |          seq_read
                     |          |          vfs_read
                     |          |          sys_read
                     |          |          system_call_fastpath
                     |          |          __GI___libc_read
                     |          |          
                     |           --1.15%-- get_task_root
                     |                     mounts_open_common
                     |                     mounts_open
                     |                     __dentry_open
                     |                     nameidata_to_filp
                     |                     finish_open
                     |                     do_filp_open
                     |                     do_sys_open
                     |                     sys_open
                     |                     system_call_fastpath
                     |                     __GI_open64
                     |                     |          
                     |                      --100.00%-- __fopen_internal
                     |                                |          
                     |                                |--50.01%-- 0x34c333c0ef
                     |                                |          
                     |                                 --49.99%-- 0x200000000
                     |          
                     |--19.30%-- nameidata_drop_rcu
                     |          link_path_walk
                     |          |          
                     |          |--96.22%-- do_path_lookup
                     |          |          |          
                     |          |          |--54.40%-- user_path_at
                     |          |          |          |          
                     |          |          |          |--90.61%-- vfs_fstatat
                     |          |          |          |          vfs_stat
                     |          |          |          |          sys_newstat
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI___xstat64
                     |          |          |          |          |          
                     |          |          |          |           --100.00%-- 0x1000
                     |          |          |          |          
                     |          |          |          |--7.22%-- sys_statfs
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI___statfs
                     |          |          |          |          |          
                     |          |          |          |          |--60.00%-- _int_malloc
                     |          |          |          |          |          
                     |          |          |          |          |--20.02%-- 0x1000
                     |          |          |          |          |          
                     |          |          |          |           --19.98%-- 0x34c3571740
                     |          |          |          |          
                     |          |          |           --2.17%-- do_utimes
                     |          |          |                     sys_utime
                     |          |          |                     system_call_fastpath
                     |          |          |                     __GI_utime
                     |          |          |          
                     |          |          |--40.88%-- do_filp_open
                     |          |          |          do_sys_open
                     |          |          |          sys_open
                     |          |          |          system_call_fastpath
                     |          |          |          __GI_open64
                     |          |          |          |          
                     |          |          |           --100.00%-- __fopen_internal
                     |          |          |                     |          
                     |          |          |                     |--64.00%-- 0x200000000
                     |          |          |                     |          
                     |          |          |                      --36.00%-- 0x34c333c0ef
                     |          |          |          
                     |          |           --4.71%-- user_path_parent
                     |          |                     |          
                     |          |                     |--79.16%-- do_unlinkat
                     |          |                     |          sys_unlink
                     |          |                     |          system_call_fastpath
                     |          |                     |          __unlink
                     |          |                     |          
                     |          |                      --20.84%-- sys_renameat
                     |          |                                sys_rename
                     |          |                                system_call_fastpath
                     |          |                                __GI_rename
                     |          |          
                     |           --3.78%-- do_filp_open
                     |                     do_sys_open
                     |                     sys_open
                     |                     system_call_fastpath
                     |                     __GI_open64
                     |          
                     |--0.95%-- __d_lookup
                     |          do_lookup
                     |          link_path_walk
                     |          |          
                     |          |--88.46%-- do_path_lookup
                     |          |          |          
                     |          |          |--52.16%-- user_path_at
                     |          |          |          |          
                     |          |          |          |--91.67%-- vfs_fstatat
                     |          |          |          |          vfs_stat
                     |          |          |          |          sys_newstat
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI___xstat64
                     |          |          |          |          
                     |          |          |           --8.33%-- sys_statfs
                     |          |          |                     system_call_fastpath
                     |          |          |                     __GI___statfs
                     |          |          |          
                     |          |           --47.84%-- do_filp_open
                     |          |                     do_sys_open
                     |          |                     sys_open
                     |          |                     system_call_fastpath
                     |          |                     __GI_open64
                     |          |          
                     |           --11.54%-- do_filp_open
                     |                     do_sys_open
                     |                     sys_open
                     |                     system_call_fastpath
                     |                     __GI_open64
                     |          
                     |--0.51%-- d_path
                     |          seq_path
                     |          show_vfsmnt
                     |          seq_read
                     |          vfs_read
                     |          sys_read
                     |          system_call_fastpath
                     |          __GI___libc_read
                      --1.17%-- [...]

     2.26%        dbench  [kernel.kallsyms]   [k] copy_user_generic_string
                  |
                  --- copy_user_generic_string
                     |          
                     |--67.84%-- generic_file_aio_read
                     |          do_sync_read
                     |          vfs_read
                     |          |          
                     |          |--98.11%-- sys_pread64
                     |          |          system_call_fastpath
                     |          |          __libc_pread
                     |          |          
                     |           --1.89%-- sys_read
                     |                     system_call_fastpath
                     |                     __GI___libc_read
                     |          
                     |--28.32%-- generic_file_buffered_write
                     |          __generic_file_aio_write
                     |          generic_file_aio_write
                     |          do_sync_write
                     |          vfs_write
                     |          sys_pwrite64
                     |          system_call_fastpath
                     |          __GI___pwrite64
                     |          
                     |--2.56%-- call_filldir
                     |          ext3_readdir
                     |          vfs_readdir
                     |          sys_getdents
                     |          system_call_fastpath
                     |          __getdents64
                     |          
                      --1.28%-- vfs_read
                                sys_read
                                system_call_fastpath
                                __GI___libc_read

     1.54%        dbench  [kernel.kallsyms]   [k] read_hpet
                  |
                  --- read_hpet
                      ktime_get
                     |          
                     |--47.29%-- tick_sched_timer
                     |          __run_hrtimer
                     |          hrtimer_interrupt
                     |          smp_apic_timer_interrupt
                     |          apic_timer_interrupt
                     |          |          
                     |          |--34.29%-- dput
                     |          |          |          
                     |          |          |--50.00%-- path_put
                     |          |          |          |          
                     |          |          |          |--50.00%-- do_path_lookup
                     |          |          |          |          do_filp_open
                     |          |          |          |          do_sys_open
                     |          |          |          |          sys_open
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI_open64
                     |          |          |          |          
                     |          |          |          |--33.33%-- d_path
                     |          |          |          |          seq_path
                     |          |          |          |          show_vfsmnt
                     |          |          |          |          seq_read
                     |          |          |          |          vfs_read
                     |          |          |          |          sys_read
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI___libc_read
                     |          |          |          |          
                     |          |          |           --16.67%-- do_filp_open
                     |          |          |                     do_sys_open
                     |          |          |                     sys_open
                     |          |          |                     system_call_fastpath
                     |          |          |                     __GI_open64
                     |          |          |          
                     |          |           --50.00%-- link_path_walk
                     |          |                     do_path_lookup
                     |          |                     |          
                     |          |                     |--50.00%-- user_path_at
                     |          |                     |          vfs_fstatat
                     |          |                     |          vfs_stat
                     |          |                     |          sys_newstat
                     |          |                     |          system_call_fastpath
                     |          |                     |          __GI___xstat64
                     |          |                     |          
                     |          |                     |--33.34%-- do_filp_open
                     |          |                     |          do_sys_open
                     |          |                     |          sys_open
                     |          |                     |          system_call_fastpath
                     |          |                     |          __GI_open64
                     |          |                     |          
                     |          |                      --16.66%-- user_path_parent
                     |          |                                do_unlinkat
                     |          |                                sys_unlink
                     |          |                                system_call_fastpath
                     |          |                                __unlink
                     |          |          
                     |          |--22.86%-- path_get
                     |          |          |          
                     |          |          |--62.49%-- d_path
                     |          |          |          seq_path
                     |          |          |          show_vfsmnt
                     |          |          |          seq_read
                     |          |          |          vfs_read
                     |          |          |          sys_read
                     |          |          |          system_call_fastpath
                     |          |          |          __GI___libc_read
                     |          |          |          
                     |          |           --37.51%-- nameidata_drop_rcu
                     |          |                     link_path_walk
                     |          |                     do_path_lookup
                     |          |                     |          
                     |          |                     |--66.66%-- user_path_at
                     |          |                     |          vfs_fstatat
                     |          |                     |          vfs_stat
                     |          |                     |          sys_newstat
                     |          |                     |          system_call_fastpath
                     |          |                     |          __GI___xstat64
                     |          |                     |          |          
                     |          |                     |           --100.00%-- 0x1000
                     |          |                     |          
                     |          |                      --33.34%-- do_filp_open
                     |          |                                do_sys_open
                     |          |                                sys_open
                     |          |                                system_call_fastpath
                     |          |                                __GI_open64
                     |          |          
                     |          |--11.42%-- nameidata_drop_rcu
                     |          |          link_path_walk
                     |          |          do_path_lookup
                     |          |          |          
                     |          |          |--50.00%-- user_path_at
                     |          |          |          |          
                     |          |          |          |--50.01%-- sys_statfs
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI___statfs
                     |          |          |          |          _int_malloc
                     |          |          |          |          
                     |          |          |           --49.99%-- vfs_fstatat
                     |          |          |                     vfs_stat
                     |          |          |                     sys_newstat
                     |          |          |                     system_call_fastpath
                     |          |          |                     __GI___xstat64
                     |          |          |          
                     |          |          |--25.00%-- do_filp_open
                     |          |          |          do_sys_open
                     |          |          |          sys_open
                     |          |          |          system_call_fastpath
                     |          |          |          __GI_open64
                     |          |          |          
                     |          |           --24.99%-- user_path_parent
                     |          |                     sys_renameat
                     |          |                     sys_rename
                     |          |                     system_call_fastpath
                     |          |                     __GI_rename
                     |          |          
                     |          |--5.72%-- link_path_walk
                     |          |          do_path_lookup
                     |          |          |          
                     |          |          |--50.04%-- user_path_at
                     |          |          |          vfs_fstatat
                     |          |          |          vfs_stat
                     |          |          |          sys_newstat
                     |          |          |          system_call_fastpath
                     |          |          |          __GI___xstat64
                     |          |          |          
                     |          |           --49.96%-- do_filp_open
                     |          |                     do_sys_open
                     |          |                     sys_open
                     |          |                     system_call_fastpath
                     |          |                     __GI_open64
                     |          |          
                     |          |--2.86%-- show_vfsmnt
                     |          |          seq_read
                     |          |          vfs_read
                     |          |          sys_read
                     |          |          system_call_fastpath
                     |          |          __GI___libc_read
                     |          |          
                     |          |--2.86%-- journal_get_write_access
                     |          |          __ext3_journal_get_write_access
                     |          |          ext3_reserve_inode_write
                     |          |          ext3_orphan_del
                     |          |          ext3_evict_inode
                     |          |          evict
                     |          |          iput
                     |          |          do_unlinkat
                     |          |          sys_unlink
                     |          |          system_call_fastpath
                     |          |          __unlink
                     |          |          
                     |          |--2.86%-- follow_managed
                     |          |          do_lookup
                     |          |          link_path_walk
                     |          |          do_path_lookup
                     |          |          do_filp_open
                     |          |          do_sys_open
                     |          |          sys_open
                     |          |          system_call_fastpath
                     |          |          __GI_open64
                     |          |          
                     |          |--2.86%-- m_start
                     |          |          seq_read
                     |          |          vfs_read
                     |          |          sys_read
                     |          |          system_call_fastpath
                     |          |          __GI___libc_read
                     |          |          
                     |          |--2.86%-- malloc_consolidate
                     |          |          
                     |          |--2.86%-- ext3fs_dirhash
                     |          |          htree_dirblock_to_tree
                     |          |          ext3_htree_fill_tree
                     |          |          ext3_readdir
                     |          |          vfs_readdir
                     |          |          sys_getdents
                     |          |          system_call_fastpath
                     |          |          __getdents64
                     |          |          
                     |          |--2.86%-- ext3_write_begin
                     |          |          generic_file_buffered_write
                     |          |          __generic_file_aio_write
                     |          |          generic_file_aio_write
                     |          |          do_sync_write
                     |          |          vfs_write
                     |          |          sys_pwrite64
                     |          |          system_call_fastpath
                     |          |          __GI___pwrite64
                     |          |          
                     |          |--2.86%-- handle_pte_fault
                     |          |          handle_mm_fault
                     |          |          do_page_fault
                     |          |          page_fault
                     |          |          vfs_read
                     |          |          sys_read
                     |          |          system_call_fastpath
                     |          |          __GI___libc_read
                     |          |          
                     |           --2.85%-- __strlen_sse2
                     |          
                     |--32.43%-- sched_clock_tick
                     |          scheduler_tick
                     |          update_process_times
                     |          tick_sched_timer
                     |          __run_hrtimer
                     |          hrtimer_interrupt
                     |          smp_apic_timer_interrupt
                     |          apic_timer_interrupt
                     |          |          
                     |          |--37.51%-- path_get
                     |          |          |          
                     |          |          |--88.89%-- nameidata_drop_rcu
                     |          |          |          link_path_walk
                     |          |          |          do_path_lookup
                     |          |          |          |          
                     |          |          |          |--62.49%-- user_path_at
                     |          |          |          |          vfs_fstatat
                     |          |          |          |          vfs_stat
                     |          |          |          |          sys_newstat
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI___xstat64
                     |          |          |          |          
                     |          |          |           --37.51%-- do_filp_open
                     |          |          |                     do_sys_open
                     |          |          |                     sys_open
                     |          |          |                     system_call_fastpath
                     |          |          |                     __GI_open64
                     |          |          |          
                     |          |           --11.11%-- d_path
                     |          |                     seq_path
                     |          |                     show_vfsmnt
                     |          |                     seq_read
                     |          |                     vfs_read
                     |          |                     sys_read
                     |          |                     system_call_fastpath
                     |          |                     __GI___libc_read
                     |          |          
                     |          |--29.16%-- dput
                     |          |          |          
                     |          |          |--57.16%-- path_put
                     |          |          |          |          
                     |          |          |          |--50.01%-- do_path_lookup
                     |          |          |          |          user_path_at
                     |          |          |          |          vfs_fstatat
                     |          |          |          |          vfs_stat
                     |          |          |          |          sys_newstat
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI___xstat64
                     |          |          |          |          
                     |          |          |           --49.99%-- d_path
                     |          |          |                     seq_path
                     |          |          |                     show_vfsmnt
                     |          |          |                     seq_read
                     |          |          |                     vfs_read
                     |          |          |                     sys_read
                     |          |          |                     system_call_fastpath
                     |          |          |                     __GI___libc_read
                     |          |          |          
                     |          |           --42.84%-- link_path_walk
                     |          |                     do_path_lookup
                     |          |                     |          
                     |          |                     |--66.65%-- user_path_at
                     |          |                     |          vfs_fstatat
                     |          |                     |          vfs_stat
                     |          |                     |          sys_newstat
                     |          |                     |          system_call_fastpath
                     |          |                     |          __GI___xstat64
                     |          |                     |          
                     |          |                      --33.35%-- do_filp_open
                     |          |                                do_sys_open
                     |          |                                sys_open
                     |          |                                system_call_fastpath
                     |          |                                __GI_open64
                     |          |          
                     |          |--12.49%-- nameidata_drop_rcu
                     |          |          link_path_walk
                     |          |          |          
                     |          |          |--66.65%-- do_path_lookup
                     |          |          |          do_filp_open
                     |          |          |          do_sys_open
                     |          |          |          sys_open
                     |          |          |          system_call_fastpath
                     |          |          |          __GI_open64
                     |          |          |          
                     |          |           --33.35%-- do_filp_open
                     |          |                     do_sys_open
                     |          |                     sys_open
                     |          |                     system_call_fastpath
                     |          |                     __GI_open64
                     |          |          
                     |          |--4.17%-- journal_get_write_access
                     |          |          __ext3_journal_get_write_access
                     |          |          ext3_get_blocks_handle
                     |          |          ext3_get_block
                     |          |          __block_write_begin
                     |          |          ext3_write_begin
                     |          |          generic_file_buffered_write
                     |          |          __generic_file_aio_write
                     |          |          generic_file_aio_write
                     |          |          do_sync_write
                     |          |          vfs_write
                     |          |          sys_pwrite64
                     |          |          system_call_fastpath
                     |          |          __GI___pwrite64
                     |          |          
                     |          |--4.17%-- path_put
                     |          |          do_path_lookup
                     |          |          do_filp_open
                     |          |          do_sys_open
                     |          |          sys_open
                     |          |          system_call_fastpath
                     |          |          __GI_open64
                     |          |          
                     |          |--4.17%-- htree_dirblock_to_tree
                     |          |          ext3_htree_fill_tree
                     |          |          ext3_readdir
                     |          |          vfs_readdir
                     |          |          sys_getdents
                     |          |          system_call_fastpath
                     |          |          __getdents64
                     |          |          
                     |          |--4.17%-- link_path_walk
                     |          |          do_path_lookup
                     |          |          do_filp_open
                     |          |          do_sys_open
                     |          |          sys_open
                     |          |          system_call_fastpath
                     |          |          __GI_open64
                     |          |          
                     |           --4.16%-- _int_free
                     |          
                     |--10.81%-- hrtimer_interrupt
                     |          smp_apic_timer_interrupt
                     |          apic_timer_interrupt
                     |          |          
                     |          |--50.00%-- dput
                     |          |          path_put
                     |          |          do_path_lookup
                     |          |          |          
                     |          |          |--75.00%-- user_path_at
                     |          |          |          |          
                     |          |          |          |--66.67%-- vfs_fstatat
                     |          |          |          |          vfs_stat
                     |          |          |          |          sys_newstat
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI___xstat64
                     |          |          |          |          
                     |          |          |           --33.33%-- sys_statfs
                     |          |          |                     system_call_fastpath
                     |          |          |                     __GI___statfs
                     |          |          |          
                     |          |           --25.00%-- do_filp_open
                     |          |                     do_sys_open
                     |          |                     sys_open
                     |          |                     system_call_fastpath
                     |          |                     __GI_open64
                     |          |          
                     |          |--12.51%-- nameidata_drop_rcu
                     |          |          link_path_walk
                     |          |          do_path_lookup
                     |          |          do_filp_open
                     |          |          do_sys_open
                     |          |          sys_open
                     |          |          system_call_fastpath
                     |          |          __GI_open64
                     |          |          
                     |          |--12.50%-- path_get
                     |          |          d_path
                     |          |          seq_path
                     |          |          show_vfsmnt
                     |          |          seq_read
                     |          |          vfs_read
                     |          |          sys_read
                     |          |          system_call_fastpath
                     |          |          __GI___libc_read
                     |          |          
                     |          |--12.50%-- d_path
                     |          |          seq_path
                     |          |          show_vfsmnt
                     |          |          seq_read
                     |          |          vfs_read
                     |          |          sys_read
                     |          |          system_call_fastpath
                     |          |          __GI___libc_read
                     |          |          
                     |           --12.50%-- getmntent_r
                     |          
                      --9.46%-- tick_dev_program_event
                                tick_program_event
                                hrtimer_interrupt
                                smp_apic_timer_interrupt
                                apic_timer_interrupt
                                |          
                                |--71.41%-- dput
                                |          |          
                                |          |--59.99%-- link_path_walk
                                |          |          do_path_lookup
                                |          |          |          
                                |          |          |--66.65%-- do_filp_open
                                |          |          |          do_sys_open
                                |          |          |          sys_open
                                |          |          |          system_call_fastpath
                                |          |          |          __GI_open64
                                |          |          |          
                                |          |           --33.35%-- user_path_at
                                |          |                     vfs_fstatat
                                |          |                     vfs_stat
                                |          |                     sys_newstat
                                |          |                     system_call_fastpath
                                |          |                     __GI___xstat64
                                |          |          
                                |           --40.01%-- path_put
                                |                     |          
                                |                     |--50.02%-- do_path_lookup
                                |                     |          do_filp_open
                                |                     |          do_sys_open
                                |                     |          sys_open
                                |                     |          system_call_fastpath
                                |                     |          __GI_open64
                                |                     |          
                                |                      --49.98%-- d_path
                                |                                seq_path
                                |                                show_vfsmnt
                                |                                seq_read
                                |                                vfs_read
                                |                                sys_read
                                |                                system_call_fastpath
                                |                                __GI___libc_read
                                |          
                                |--14.30%-- find_lock_page
                                |          grab_cache_page_write_begin
                                |          ext3_write_begin
                                |          generic_file_buffered_write
                                |          __generic_file_aio_write
                                |          generic_file_aio_write
                                |          do_sync_write
                                |          vfs_write
                                |          sys_pwrite64
                                |          system_call_fastpath
                                |          __GI___pwrite64
                                |          
                                 --14.30%-- path_get
                                           d_path
                                           seq_path
                                           show_vfsmnt
                                           seq_read
                                           vfs_read
                                           sys_read
                                           system_call_fastpath
                                           __GI___libc_read

     1.46%        dbench  [kernel.kallsyms]   [k] dput
                  |
                  --- dput
                     |          
                     |--52.83%-- path_put
                     |          |          
                     |          |--57.98%-- do_path_lookup
                     |          |          |          
                     |          |          |--50.17%-- do_filp_open
                     |          |          |          do_sys_open
                     |          |          |          sys_open
                     |          |          |          system_call_fastpath
                     |          |          |          __GI_open64
                     |          |          |          
                     |          |          |--40.77%-- user_path_at
                     |          |          |          |          
                     |          |          |          |--77.78%-- vfs_fstatat
                     |          |          |          |          vfs_stat
                     |          |          |          |          sys_newstat
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI___xstat64
                     |          |          |          |          |          
                     |          |          |          |           --100.00%-- 0x1000
                     |          |          |          |          
                     |          |          |           --22.22%-- sys_statfs
                     |          |          |                     system_call_fastpath
                     |          |          |                     __GI___statfs
                     |          |          |                     |          
                     |          |          |                      --100.00%-- 0x340000006b
                     |          |          |          
                     |          |           --9.06%-- user_path_parent
                     |          |                     do_unlinkat
                     |          |                     sys_unlink
                     |          |                     system_call_fastpath
                     |          |                     __unlink
                     |          |          
                     |          |--39.39%-- d_path
                     |          |          seq_path
                     |          |          show_vfsmnt
                     |          |          seq_read
                     |          |          vfs_read
                     |          |          sys_read
                     |          |          system_call_fastpath
                     |          |          __GI___libc_read
                     |          |          
                     |           --2.63%-- mounts_release
                     |                     fput
                     |                     filp_close
                     |                     sys_close
                     |                     system_call_fastpath
                     |                     __GI_close
                     |          
                     |--44.40%-- link_path_walk
                     |          |          
                     |          |--93.75%-- do_path_lookup
                     |          |          |          
                     |          |          |--56.66%-- user_path_at
                     |          |          |          |          
                     |          |          |          |--88.24%-- vfs_fstatat
                     |          |          |          |          vfs_stat
                     |          |          |          |          sys_newstat
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI___xstat64
                     |          |          |          |          
                     |          |          |           --11.76%-- sys_statfs
                     |          |          |                     system_call_fastpath
                     |          |          |                     __GI___statfs
                     |          |          |                     |          
                     |          |          |                      --100.00%-- _int_malloc
                     |          |          |          
                     |          |          |--40.00%-- do_filp_open
                     |          |          |          do_sys_open
                     |          |          |          sys_open
                     |          |          |          system_call_fastpath
                     |          |          |          __GI_open64
                     |          |          |          
                     |          |           --3.33%-- user_path_parent
                     |          |                     do_unlinkat
                     |          |                     sys_unlink
                     |          |                     system_call_fastpath
                     |          |                     __unlink
                     |          |          
                     |           --6.25%-- do_filp_open
                     |                     do_sys_open
                     |                     sys_open
                     |                     system_call_fastpath
                     |                     __GI_open64
                     |          
                      --2.78%-- follow_managed
                                do_lookup
                                link_path_walk
                                do_path_lookup
                                |          
                                |--50.00%-- do_filp_open
                                |          do_sys_open
                                |          sys_open
                                |          system_call_fastpath
                                |          __GI_open64
                                |          
                                 --50.00%-- user_path_at
                                           vfs_fstatat
                                           vfs_stat
                                           sys_newstat
                                           system_call_fastpath
                                           __GI___xstat64

     0.77%       swapper  [kernel.kallsyms]   [k] poll_idle
                 |
                 --- poll_idle
                     cpu_idle
                    |          
                    |--4.82%-- start_secondary
                    |          
                     --3.90%-- rest_init
                               start_kernel
                               x86_64_start_reservations
                               x86_64_start_kernel

     0.74%        dbench  [kernel.kallsyms]   [k] link_path_walk
                  |
                  --- link_path_walk
                     |          
                     |--87.50%-- do_path_lookup
                     |          |          
                     |          |--52.37%-- user_path_at
                     |          |          vfs_fstatat
                     |          |          vfs_stat
                     |          |          sys_newstat
                     |          |          system_call_fastpath
                     |          |          __GI___xstat64
                     |          |          
                     |          |--38.10%-- do_filp_open
                     |          |          do_sys_open
                     |          |          sys_open
                     |          |          system_call_fastpath
                     |          |          __GI_open64
                     |          |          
                     |           --9.52%-- user_path_parent
                     |                     do_unlinkat
                     |                     sys_unlink
                     |                     system_call_fastpath
                     |                     __unlink
                     |          
                     |--8.34%-- do_filp_open
                     |          do_sys_open
                     |          sys_open
                     |          system_call_fastpath
                     |          __GI_open64
                     |          
                      --4.17%-- user_path_at
                                vfs_fstatat
                                vfs_stat
                                sys_newstat
                                system_call_fastpath
                                __GI___xstat64

     0.61%        dbench  libc-2.11.so        [.] __strchr_sse42
                  |
                  --- __strchr_sse42
                      0x608500
                     |          
                     |--11.99%-- 0x524f464e495f4854
                     |          
                     |--8.00%-- 0x353300004b4f5f53
                     |          
                     |--8.00%-- 0x746e65696c632f73
                     |          
                     |--8.00%-- 0x5443454a424f5f53
                     |          
                     |--8.00%-- 0x65696c632f222058
                     |          
                     |--4.01%-- 0x647e00004b4f5f53
                     |          
                     |--4.00%-- 0x4355535f4f4e5f53
                     |          
                     |--4.00%-- 0x4b4f00004b4f5f53
                     |          
                     |--4.00%-- 0x4f4e00004b4f5f53
                     |          
                     |--4.00%-- 0x3120302035303130
                     |          
                     |--4.00%-- 0x3335353620363335
                     |          
                     |--4.00%-- 0x535f544e20343132
                     |          
                     |--4.00%-- 0x3535362032373031
                     |          
                     |--4.00%-- 0x4d5500004b4f5f53
                     |          
                     |--4.00%-- 0x4154535f544e2036
                     |          
                     |--4.00%-- 0x4f5f535554415453
                     |          
                     |--4.00%-- 0x5f5355544154535f
                     |          
                     |--4.00%-- 0x2036393034203032
                     |          
                      --4.00%-- 0x535f544e20363930

     0.59%        dbench  [kernel.kallsyms]   [k] mntput_no_expire
                  |
                  --- mntput_no_expire
                     |          
                     |--97.30%-- mntput
                     |          |          
                     |          |--88.89%-- path_put
                     |          |          |          
                     |          |          |--49.99%-- do_path_lookup
                     |          |          |          |          
                     |          |          |          |--62.50%-- user_path_at
                     |          |          |          |          vfs_fstatat
                     |          |          |          |          vfs_stat
                     |          |          |          |          sys_newstat
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI___xstat64
                     |          |          |          |          
                     |          |          |          |--31.25%-- do_filp_open
                     |          |          |          |          do_sys_open
                     |          |          |          |          sys_open
                     |          |          |          |          system_call_fastpath
                     |          |          |          |          __GI_open64
                     |          |          |          |          
                     |          |          |           --6.25%-- user_path_parent
                     |          |          |                     do_unlinkat
                     |          |          |                     sys_unlink
                     |          |          |                     system_call_fastpath
                     |          |          |                     __unlink
                     |          |          |          
                     |          |          |--40.63%-- d_path
                     |          |          |          seq_path
                     |          |          |          show_vfsmnt
                     |          |          |          seq_read
                     |          |          |          vfs_read
                     |          |          |          sys_read
                     |          |          |          system_call_fastpath
                     |          |          |          __GI___libc_read
                     |          |          |          
                     |          |          |--3.13%-- do_filp_open
                     |          |          |          do_sys_open
                     |          |          |          sys_open
                     |          |          |          system_call_fastpath
                     |          |          |          __GI_open64
                     |          |          |          
                     |          |          |--3.13%-- mounts_release
                     |          |          |          fput
                     |          |          |          filp_close
                     |          |          |          sys_close
                     |          |          |          system_call_fastpath
                     |          |          |          __GI_close
                     |          |          |          
                     |          |           --3.13%-- vfs_fstatat
                     |          |                     vfs_stat
                     |          |                     sys_newstat
                     |          |                     system_call_fastpath
                     |          |                     __GI___xstat64
                     |          |          
                     |          |--5.56%-- link_path_walk
                     |          |          do_path_lookup
                     |          |          |          
                     |          |          |--50.02%-- user_path_parent
                     |          |          |          do_unlinkat
                     |          |          |          sys_unlink
                     |          |          |          system_call_fastpath
                     |          |          |          __unlink
                     |          |          |          
                     |          |           --49.98%-- user_path_at
                     |          |                     vfs_fstatat
                     |          |                     vfs_stat
                     |          |                     sys_newstat
                     |          |                     system_call_fastpath
                     |          |                     __GI___xstat64
                     |          |          
                     |           --5.55%-- fput
                     |                     filp_close
                     |                     sys_close
                     |                     system_call_fastpath
                     |                     __GI_close
                     |          
                      --2.70%-- path_put
                                vfs_fstatat
                                vfs_stat
                                sys_newstat
                                system_call_fastpath
                                __GI___xstat64

     0.53%        dbench  [kernel.kallsyms]   [k] __d_lookup
                  |
                  --- __d_lookup
                     |          
                     |--93.55%-- do_lookup
                     |          link_path_walk
                     |          |          
                     |          |--96.55%-- do_path_lookup
                     |          |          |          
                     |          |          |--46.43%-- user_path_at
                     |          |          |          vfs_fstatat
                     |          |          |          vfs_stat
                     |          |          |          sys_newstat
                     |          |          |          system_call_fastpath
                     |          |          |          __GI___xstat64
                     |          |          |          
                     |          |          |--39.28%-- do_filp_open
                     |          |          |          do_sys_open
                     |          |          |          sys_open
                     |          |          |          system_call_fastpath
                     |          |          |          __GI_open64
                     |          |          |          
                     |          |           --14.29%-- user_path_parent
                     |          |                     |          
                     |          |                     |--74.99%-- do_unlinkat
                     |          |                     |          sys_unlink
                     |          |                     |          system_call_fastpath
                     |          |                     |          __unlink
                     |          |                     |          
                     |          |                      --25.01%-- sys_renameat
                     |          |                                sys_rename
                     |          |                                system_call_fastpath
                     |          |                                __GI_rename
                     |          |          
                     |           --3.45%-- do_filp_open
                     |                     do_sys_open
                     |                     sys_open
                     |                     system_call_fastpath
                     |                     __GI_open64
                     |          
                      --6.45%-- link_path_walk
                                do_path_lookup
                                do_filp_open
                                do_sys_open
                                sys_open
                                system_call_fastpath
                                __GI_open64

