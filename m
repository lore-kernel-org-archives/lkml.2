Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1IDSks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 14:40:48 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:37383 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab1IDSkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 14:40:41 -0400
MIME-Version: 1.0
In-Reply-To: <3546423.kFMPx0aPCi@wuerfel>
References: <4E582577.2060805@zytor.com>
	<19229.1315070217@turing-police.cc.vt.edu>
	<4E62638E.40308@zytor.com>
	<3546423.kFMPx0aPCi@wuerfel>
Date: Sun, 4 Sep 2011 11:40:39 -0700
Message-ID: <CAMe9rOqJoy=S4-=tZXrti7w_GtSqaTgX9i69FR92Tv6pPfSDRQ@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 4, 2011 at 8:17 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 03 September 2011 10:27:42 H. Peter Anvin wrote:
>> On 09/03/2011 10:16 AM, Valdis.Kletnieks@vt.edu wrote:
>> >>
>> >> The complexity of changing that would be enormous.
>> >
>> > Oh, I know changing the x86-32 ABI is impossible - I meant changing the
>> > decision to emulate that ABI (as opposed to emulating the x86-64 ABI, or a
>> > variant thereof, or something else).  Or are we already commited to that
>> > route, even if we're still trying to figure out what syscalls to include?
>> >
>>
>> About ioctl in particular, the ABI has dependencies into almost every
>> single driver in the Linux kernel.  It is hard-coded in the kernel that
>> there are two paths -- native and compat.  Since pointers are going to
>> be 4 bytes, it means we have to use the compat path.
>>
>> We may be able to cheat a little bit since we encode the argument sizes
>> in the ioctl numbers; this solves the case of PPGETTIME/PPSETTIME for
>> example (in fact, this ioctl looks currently broken in compat mode!)
>> However, at some point the sheer number of data types that can be
>> consumed by ioctl is a real concern, so changing the ones we really care
>> about -- like timespec/timeval -- while leaving the rest intact so we
>> can use the compat path as a general rule would be highly useful.
>
> The ppdev ioctls are indeed missing in user space, and they are
> an example for a different problem than the one I meant.
>
> We really have a number of different cases that we will have to
> deal with in different ways:
>
> * different layout and ioctl code due to padding on x86-32,
>  x32 is compatible:
>  DRM_IOCTL_RADEON_SETPARAM
>  DRM_IOCTL_UPDATE_DRAW32
>  EXT4_IOC32_GROUP_ADD
>
> * different layout due to padding on x86-32, but same ioctl code:
>  RAW_SETBIND
>  RAW_GETBIND
>
> * uses time_t, different ioctl code:
>  PPPIOCGIDLE32
>  VIDIOC_DQBUF32
>  VIDIOC_QBUF32
>  VIDIOC_QUERYBUF32
>  VIDIOC_DQEVENT32
>
> * uses time_t, same ioctl code:
>  VIDEO_GET_EVENT
>  LPSETTIMEOUT
>
> * Different alignment, three different ioctl numbers:
>  FS_IOC_RESVSP_32
>  FS_IOC_RESVSP64_32
>
> * manually checks if compat_task:
>  input/evdev
>
> * Very complex, no easy solution:
>  XFS_IOC_*
>
> * Only needed for x86-32, not for x32:
>  sys_quotactl
>
> * Data structures embed time values, not an ioctl
>  sys_sendmsg (cmsg)
>  sys_recvmsg (cmsg)
>  sys_mq_*
>  sys_semtimedop
>
> For a lot of these cases, the best option is to change the
> kernel headers to use new definitions on x32 before someone
> tries to ship a distro, especially when the ioctl command code
> is fixed. In case of the XFS ioctls, I think the only sane
> way is define the x32 ABI to match the 64 bit ABI completely,
> while for RAW_GETBIND and VIDEO_GET_EVENT it's probably enough
> to make x32 match x86-32.
>
>        Arnd
>

I need to use the following compat system calls for x32 due to
pointers or longs in struct passed to system calls.

-- 
H.J.
---
#define __NR_x32_rt_sigaction
#define __NR_x32_rt_sigprocmask
#define __NR_x32_rt_sigreturn
#define __NR_x32_ioctl
#define __NR_x32_readv
#define __NR_x32_writev
#define __NR_x32_recvfrom
#define __NR_x32_sendmsg
#define __NR_x32_recvmsg
#define __NR_x32_execve
#define __NR_x32_times
#define __NR_x32_rt_sigpending
#define __NR_x32_rt_sigtimedwait
#define __NR_x32_rt_sigqueueinfo
#define __NR_x32_sigaltstack
#define __NR_x32__sysctl
#define __NR_x32_timer_create
#define __NR_x32_mq_notify
#define __NR_x32_kexec_load
#define __NR_x32_waitid
#define __NR_x32_set_robust_list
#define __NR_x32_get_robust_list
#define __NR_x32_vmsplice
#define __NR_x32_move_pages
#define __NR_x32_preadv
#define __NR_x32_pwritev
#define __NR_x32_rt_tgsigqueueinfo
#define __NR_x32_recvmmsg
#define __NR_x32_sendmmsg
