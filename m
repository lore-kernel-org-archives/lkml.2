Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2KGLFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:05:03 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54332 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2KGLE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:04:59 -0500
Date: Wed, 7 Nov 2012 03:01:52 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: [RFC 3/3] man-pages: Add man page for vmpressure_fd(2)
Message-ID: <20121107110152.GC30462@lizard>
References: <20121107105348.GA25549@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121107105348.GA25549@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMPRESSURE_FD(2)        Linux Programmer's Manual       VMPRESSURE_FD(2)

NAME
       vmpressure_fd - Linux virtual memory pressure notifications

SYNOPSIS
       #define _GNU_SOURCE
       #include <unistd.h>
       #include <sys/syscall.h>
       #include <asm/unistd.h>
       #include <linux/types.h>
       #include <linux/vmpressure.h>

       int vmpressure_fd(struct vmpressure_config *config)
       {
            config->size = sizeof(*config);
            return syscall(__NR_vmpressure_fd, config);
       }

DESCRIPTION
       This  system  call creates a new file descriptor that can be used
       with blocking (e.g.  read(2)) and/or polling (e.g.  poll(2)) rou-
       tines to get notified about system's memory pressure.

       Upon  these  notifications,  userland programs can cooperate with
       the kernel, achieving better system's memory management.

   Memory pressure levels
       There are currently three memory pressure levels, each  level  is
       defined via vmpressure_level enumeration, and correspond to these
       constants:

       VMPRESSURE_LOW
              The system is reclaiming memory for new allocations. Moni-
              toring reclaiming activity might be useful for maintaining
              overall system's cache level.

       VMPRESSURE_MEDIUM
              The system is experiencing medium memory  pressure,  there
              might  be  some  mild  swapping activity. Upon this event,
              applications may decide to free any resources that can  be
              easily reconstructed or re-read from a disk.

       VMPRESSURE_OOM
              The  system  is  actively thrashing, it is about to out of
              memory (OOM) or even the in-kernel OOM killer  is  on  its
              way  to  trigger. Applications should do whatever they can
              to help the system. See proc(5) for more information about
              OOM killer and its configuration options.

       Note that the behaviour of some levels can be tuned through the
       sysctl(5)      mechanism.      See      /usr/src/linux/Documenta-
       tion/sysctl/vm.txt for various vmpressure_*  tunables  and  their
       meanings.

   Configuration
       vmpressure_fd(2) accepts vmpressure_config structure to configure
       the notifications:

       struct vmpressure_config {
            __u32 size;
            __u32 threshold;
       };

       size is a part of ABI  versioning  and  must  be  initialized  to
       sizeof(struct vmpressure_config).

       threshold  is  used to setup a minimal value of the pressure upon
       which the events will be delivered by the kernel  (for  algebraic
       comparisons,   it   is  defined  that  VMPRESSURE_LOW  <  VMPRES-
       SURE_MEDIUM < VMPRESSURE_OOM, but applications should not put any
       meaning into the absolute values.)

   Events
       Upon  a  notification,  application  must  read  out events using
       read(2) system call.  The events are delivered using the  follow-
       ing structure:

       struct vmpressure_event {
            __u32 pressure;
       };

       The pressure shows the most recent system's pressure level.

RETURN VALUE
       On  success,  vmpressure_fd()  returns  a new file descriptor. On
       error, a negative value is returned and errno is set to  indicate
       the error.

ERRORS
       vmpressure_fd() can fail with errors similar to open(2).

       In addition, the following errors are possible:

       EINVAL The  failure  means  that  an improperly initalized config
              structure has been passed to the call.

       EFAULT The failure means that the kernel was unable to  read  the
              configuration  structure, that is, config parameter points
              to an inaccessible memory.

VERSIONS
       The system call is available on Linux since kernel  3.8.  Library
       support is yet not provided by any glibc version.

CONFORMING TO
       The system call is Linux-specific.

EXAMPLE
       Examples can be found in /usr/src/linux/tools/testing/vmpressure/
       directory.

SEE ALSO
       poll(2), read(2), proc(5), sysctl(5), vmstat(8)

Linux                          2012-10-16               VMPRESSURE_FD(2)

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 man2/vmpressure_fd.2 | 163 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 163 insertions(+)
 create mode 100644 man2/vmpressure_fd.2

diff --git a/man2/vmpressure_fd.2 b/man2/vmpressure_fd.2
new file mode 100644
index 0000000..eaf07d4
--- /dev/null
+++ b/man2/vmpressure_fd.2
@@ -0,0 +1,163 @@
+.\" Copyright (C) 2008 Michael Kerrisk <mtk.manpages@gmail.com>
+.\" Copyright (C) 2012 Linaro Ltd.
+.\" 		       Anton Vorontsov <anton.vorontsov@linaro.org>
+.\"
+.\" Based on ideas from:
+.\" KOSAKI Motohiro, Leonid Moiseichuk, Mel Gorman, Minchan Kim and Pekka
+.\" Enberg.
+.\"
+.\" This program is free software; you can redistribute it and/or modify
+.\" it under the terms of the GNU General Public License as published by
+.\" the Free Software Foundation; either version 2 of the License, or
+.\" (at your option) any later version.
+.\"
+.\" This program is distributed in the hope that it will be useful,
+.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\" GNU General Public License for more details.
+.\"
+.\" You should have received a copy of the GNU General Public License
+.\" along with this program; if not, write to the Free Software
+.\" Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+.\" MA  02111-1307  USA
+.\"
+.TH VMPRESSURE_FD 2 2012-10-16 Linux "Linux Programmer's Manual"
+.SH NAME
+vmpressure_fd \- Linux virtual memory pressure notifications
+.SH SYNOPSIS
+.nf
+.B #define _GNU_SOURCE
+.B #include <unistd.h>
+.B #include <sys/syscall.h>
+.B #include <asm/unistd.h>
+.B #include <linux/types.h>
+.B #include <linux/vmpressure.h>
+.\" TODO: libc wrapper
+
+.BI "int vmpressure_fd(struct vmpressure_config *"config )
+.B
+{
+.B
+	config->size = sizeof(*config);
+.B
+	return syscall(__NR_vmpressure_fd, config);
+.B
+}
+.fi
+.SH DESCRIPTION
+This system call creates a new file descriptor that can be used with
+blocking (e.g.
+.BR read (2))
+and/or polling (e.g.
+.BR poll (2))
+routines to get notified about system's memory pressure.
+
+Upon these notifications, userland programs can cooperate with the kernel,
+achieving better system's memory management.
+.SS Memory pressure levels
+There are currently three memory pressure levels, each level is defined
+via
+.IR vmpressure_level " enumeration,"
+and correspond to these constants:
+.TP
+.B VMPRESSURE_LOW
+The system is reclaiming memory for new allocations. Monitoring reclaiming
+activity might be useful for maintaining overall system's cache level.
+.TP
+.B VMPRESSURE_MEDIUM
+The system is experiencing medium memory pressure, there might be some
+mild swapping activity. Upon this event, applications may decide to free
+any resources that can be easily reconstructed or re-read from a disk.
+.TP
+.B VMPRESSURE_OOM
+The system is actively thrashing, it is about to out of memory (OOM) or
+even the in-kernel OOM killer is on its way to trigger. Applications
+should do whatever they can to help the system. See
+.BR proc (5)
+for more information about OOM killer and its configuration options.
+.TP 0
+Note that the behaviour of some levels can be tuned through the
+.BR sysctl (5)
+mechanism. See
+.I /usr/src/linux/Documentation/sysctl/vm.txt
+for various
+.I vmpressure_*
+tunables and their meanings.
+.SS Configuration
+.BR vmpressure_fd (2)
+accepts
+.I vmpressure_config
+structure to configure the notifications:
+
+.nf
+struct vmpressure_config {
+	__u32 size;
+	__u32 threshold;
+};
+.fi
+
+.I size
+is a part of ABI versioning and must be initialized to
+.IR "sizeof(struct vmpressure_config)" .
+
+.I threshold
+is used to setup a minimal value of the pressure upon which the events
+will be delivered by the kernel (for algebraic comparisons, it is defined
+that
+.BR VMPRESSURE_LOW " <"
+.BR VMPRESSURE_MEDIUM " <"
+.BR VMPRESSURE_OOM ,
+but applications should not put any meaning into the absolute values.)
+.SS Events
+Upon a notification, application must read out events using
+.BR read (2)
+system call.
+The events are delivered using the following structure:
+
+.nf
+struct vmpressure_event {
+	__u32 pressure;
+};
+.fi
+
+The
+.I pressure
+shows the most recent system's pressure level.
+.SH "RETURN VALUE"
+On success,
+.BR vmpressure_fd ()
+returns a new file descriptor. On error, a negative value is returned and
+.I errno
+is set to indicate the error.
+.SH ERRORS
+.BR vmpressure_fd ()
+can fail with errors similar to
+.BR open (2).
+
+In addition, the following errors are possible:
+.TP
+.B EINVAL
+The failure means that an improperly initalized
+.I config
+structure has been passed to the call.
+.TP
+.B EFAULT
+The failure means that the kernel was unable to read the configuration
+structure, that is,
+.I config
+parameter points to an inaccessible memory.
+.SH VERSIONS
+The system call is available on Linux since kernel 3.8. Library support is
+yet not provided by any glibc version.
+.SH CONFORMING TO
+The system call is Linux-specific.
+.SH EXAMPLE
+Examples can be found in
+.I /usr/src/linux/tools/testing/vmpressure/
+directory.
+.SH "SEE ALSO"
+.BR poll (2),
+.BR read (2),
+.BR proc (5),
+.BR sysctl (5),
+.BR vmstat (8)
-- 
1.8.0
