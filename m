Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab1JCReJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:34:09 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:41794 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab1JCReE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:34:04 -0400
Date: Mon, 3 Oct 2011 20:33:59 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [3.1 patch] x86: default to vsyscall=native
Message-ID: <20111003173359.GA3072@localhost.pp.htv.fi>
References: <20111003090846.GA25136@localhost.pp.htv.fi>
 <CAObL_7GSQFr_PRtKY=H7r=yD7Qk-xvgbg5bV1=nU-qayG-mJdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAObL_7GSQFr_PRtKY=H7r=yD7Qk-xvgbg5bV1=nU-qayG-mJdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Oct 03, 2011 at 06:04:53AM -0700, Andrew Lutomirski wrote:
> On Mon, Oct 3, 2011 at 2:08 AM, Adrian Bunk <bunk@stusta.de> wrote:
> > After upgrading a kernel the existing userspace should just work
> > (assuming it did work before ;-) ), but when I upgraded my kernel
> > from 3.0.4 to 3.1.0-rc8 a UML instance didn't come up properly.
> >
> > dmesg said:
> >  linux-2.6.30.1[3800] vsyscall fault (exploit attempt?) ip:ffffffffff600000 cs:33 sp:7fbfb9c498 ax:ffffffffff600000 si:0 di:606790
> >  linux-2.6.30.1[3856] vsyscall fault (exploit attempt?) ip:ffffffffff600000 cs:33 sp:7fbfb13168 ax:ffffffffff600000 si:0 di:606790
> >
> > Looking throught the changelog I ended up at commit 3ae36655
> > ("x86-64: Rework vsyscall emulation and add vsyscall= parameter").
> >
> > Linus suggested in https://lkml.org/lkml/2011/8/9/376 to default to
> > vsyscall=native.
> >
> > That sounds reasonable to me, and fixes the problem for me.
> 
> At this point in the -rc cycle, this sounds fine.
> 
> That being said, I'd like to fix it for real for 3.2.  This particular
> failure is suspicious -- the "vsyscall fault" message means that
> sys_gettimeofday returned EFAULT, which means that the old (3.0 and
> before) vgettimeofday should *also* have segfaulted.

This 2.6.30.1 UML kernel binary from 2009 worked for me for all host 
kernels from 2.6.30 to 3.0, and with 3.1.0-rc8 and vsyscall=native
it also seems to run nicely.

Looking deeper into "a UML instance didn't come up properly",
the problem is that it comes up in a strange (readonly) state.

There are "Using makefile-style concurrent boot in runlevel S."
and "Using makefile-style concurrent boot in runlevel 2." in the
logs with a Debian userspace, but no output from the init scripts
in these broken bootups (normal messages are in non-broken bootups).

Perhaps the two the messages I see in dmesg on the host are from the 
processes running rcS and rc2 failing early?

In a working startup with a Debian userspace, I'm getting during rcS
 Setting the system clock.
 Cannot access the Hardware Clock via any known method.
 Use the --debug option to see the details of our search for an access method.
 Unable to set System Clock to: Mon Oct 3 17:01:35 UTC 2011 ... (warning).

> We do have a bit
> of a bug in that the new code doesn't report si_addr properly, but
> that sounds unlikely as a culprit.  Did you try with the offending
> commit reverted (i.e. fce8dc0)?  I bet that it also fails there.

fce8dc0 is "x86-64: Wire up getcpu syscall", is that really the one you 
want me to revert?

> What's the .config for your UML binary?  I'd like to see if I can
> reproduce this.

It's attached.

> --Andy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=config-uml

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.30-rc4
# Thu Apr 30 22:55:45 2009
#
CONFIG_DEFCONFIG_LIST="arch/$ARCH/defconfig"
CONFIG_GENERIC_HARDIRQS=y
CONFIG_UML=y
CONFIG_MMU=y
CONFIG_NO_IOMEM=y
# CONFIG_TRACE_IRQFLAGS_SUPPORT is not set
CONFIG_LOCKDEP_SUPPORT=y
# CONFIG_STACKTRACE_SUPPORT is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_IRQ_RELEASE_METHOD=y
CONFIG_HZ=100

#
# UML-specific options
#

#
# Host processor type and features
#
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
# CONFIG_X86_CMPXCHG is not set
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=3
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_UML_X86=y
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_3_LEVEL_PGTABLES=y
# CONFIG_ARCH_HAS_SC_SIGNALS is not set
# CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA is not set
CONFIG_SMP_BROKEN=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_STATIC_LINK is not set
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_LD_SCRIPT_DYN=y
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HOSTFS=y
# CONFIG_HPPFS is not set
CONFIG_MCONSOLE=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_KERNEL_STACK_ORDER=1

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=128
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_EXTRA_PASS=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
# CONFIG_SLOW_WORK is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
# CONFIG_FREEZER is not set
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_UBD=y
# CONFIG_BLK_DEV_UBD_SYNC is not set
CONFIG_BLK_DEV_COW_COMMON=y
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_ATA_OVER_ETH is not set

#
# Character Devices
#
CONFIG_STDERR_CONSOLE=y
CONFIG_STDIO_CONSOLE=y
CONFIG_SSL=y
CONFIG_NULL_CHAN=y
CONFIG_PORT_CHAN=y
CONFIG_PTY_CHAN=y
CONFIG_TTY_CHAN=y
CONFIG_XTERM_CHAN=y
# CONFIG_NOCONFIG_CHAN is not set
CONFIG_CON_ZERO_CHAN="fd:0,fd:1"
CONFIG_CON_CHAN="xterm"
CONFIG_SSL_CHAN="pts"
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
# CONFIG_RAW_DRIVER is not set
CONFIG_LEGACY_PTY_COUNT=32
# CONFIG_WATCHDOG is not set
# CONFIG_UML_SOUND is not set
# CONFIG_SOUND is not set
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_HOSTAUDIO is not set
# CONFIG_HW_RANDOM is not set
CONFIG_UML_RANDOM=y
# CONFIG_MMAPPER is not set

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# UML Network Devices
#
CONFIG_UML_NET=y
CONFIG_UML_NET_ETHERTAP=y
CONFIG_UML_NET_TUNTAP=y
# CONFIG_UML_NET_SLIP is not set
# CONFIG_UML_NET_DAEMON is not set
# CONFIG_UML_NET_VDE is not set
# CONFIG_UML_NET_MCAST is not set
# CONFIG_UML_NET_PCAP is not set
# CONFIG_UML_NET_SLIRP is not set
CONFIG_NETDEVICES=y
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_DUMMY=y
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_CONNECTOR is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_NLS is not set
# CONFIG_DLM is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_CRYPTO is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_MD is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INPUT is not set

#
# Kernel hacking
#
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_SAMPLES is not set
# CONFIG_DEBUG_STACK_USAGE is not set

--RnlQjJ0d97Da+TV1--
