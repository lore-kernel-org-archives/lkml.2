Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab2JVLZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:25:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46034 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2JVLY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:24:58 -0400
Date: Mon, 22 Oct 2012 04:22:01 -0700
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
Subject: [RFC 2/2] man-pages: Add man page for vmevent_fd(2)
Message-ID: <20121022112201.GB29325@lizard>
References: <20121022111928.GA12396@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121022111928.GA12396@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMEVENT_FD(2)           Linux Programmer's Manual          VMEVENT_FD(2)

NAME
       vmevent_fd - Linux virtual memory management events

SYNOPSIS
       #define _GNU_SOURCE
       #include <unistd.h>
       #include <sys/syscall.h>
       #include <asm/unistd.h>
       #include <linux/types.h>
       #include <linux/vmevent.h>

       syscall(__NR_vmevent_fd, config);

DESCRIPTION
       This  system  call creates a new file descriptor that can be used
       with polling routines (e.g.  poll(2)) to get notified about vari-
       ous  in-kernel  virtual memory management events that might be of
       interest for userspace. The interface can also be used  to  effe-
       ciently  monitor  memory  usage  (e.g.  number  of  idle and swap
       pages).

       Applications can make overall  system's  memory  management  more
       nimble  by  adjusting  theirs  resources usage upon the notifica-
       tions.

   Attributes
       Attributes are the basic concept, they are described by the  fol-
       lowing structure:

       struct vmevent_attr {
            __u64 value;
            __u32 type;
            __u32 state;
       };

       type may correspond to these values:

       VMEVENT_ATTR_NR_AVAIL_PAGES
              The  attribute  reports total number of available pages in
              the system, not including  swap  space  (i.e.  just  total
              RAM).   value  is  used to setup a threshold (in number or
              pages) upon which the event will be delivered by the  ker-
              nel.

              Upon   notifications   kernel   updates   all   configured
              attributes, so the attribute is mostly  used  without  any
              thresholds, just for getting the value together with other
              attributes and avoid reading and parsing /proc/vmstat.

       VMEVENT_ATTR_NR_FREE_PAGES
              The attribute reports total number of unused (idle) RAM in
              the system.

              value  is  used  to setup a threshold (in number or pages)
              upon which the event will be delivered by the kernel.

       VMEVENT_ATTR_NR_SWAP_PAGES
              The attribute reports total number of swapped pages.

              value is used to setup a threshold (in  number  or  pages)
              upon which the event will be delivered by the kernel.

       VMEVENT_ATTR_PRESSURE
              The  attribute  reports  Linux  virtual  memory management
              pressure. There are three discrete levels:

              VMEVENT_PRESSURE_LOW: By setting  the  threshold  to  this
              value  it's possible to watch whether system is reclaiming
              memory for new allocations. Monitoring reclaiming activity
              might  be  useful  for  maintaining overall system's cache
              level.

              VMEVENT_PRESSURE_MED: The system  is  experiencing  medium
              memory  pressure,  there  is  some mild swapping activity.
              Upon this  event  applications  may  decide  to  free  any
              resources that can be easily reconstructed or re-read from
              a disk.

              VMEVENT_PRESSURE_OOM: The system is actively thrashing, it
              is  about to out of memory (OOM) or even the in-kernel OOM
              killer is on its way to trigger.  Applications  should  do
              whatever they can to help the system. See proc(5) for more
              information  about  OOM  killer  and   its   configuration
              options.

              value  is  used  to setup a threshold upon which the event
              will be delivered by the  kernel  (for  algebraic  compar-
              isons,   it   is   defined   that  VMEVENT_PRESSURE_LOW  <
              VMEVENT_PRESSURE_MED < VMEVENT_PRESSURE_OOM, but  applica-
              tions  should  not  put any meaning into the absolute val-
              ues.)

       state  is used to  setup  thresholds'  behaviour,  the  following
              flags can be bitwise OR'ed:

       VMEVENT_ATTR_STATE_VALUE_LT
              Notification  will  be delivered when an attribute is less
              than a user-specified value.

       VMEVENT_ATTR_STATE_VALUE_GT
              Notifications will  be  delivered  when  an  attribute  is
              greater than a user-specified value.

       VMEVENT_ATTR_STATE_VALUE_EQ
              Notifications will be delivered when an attribute is equal
              to a user-specified value.

       VMEVENT_ATTR_STATE_EDGE_TRIGGER
              Events will be only delivered when  an  attribute  crosses
              value threshold.

   Events
       Upon  a  notification,  application  must  read  out events using
       read(2) system call.  The events are delivered using the  follow-
       ing structure:

       struct vmevent_event {
            __u32               counter;
            __u32               padding;
            struct vmevent_attr attrs[];
       };

       The  counter  specifies  a number of reported attributes, and the
       attrs array  contains  a  copy  of  configured  attributes,  with
       vmevent_attr's value overwritten to attribute's value.

   Config
       vmevent_fd(2)  accepts  vmevent_config structure to configure the
       notifications:

       struct vmevent_config {
            __u32               size;
            __u32               counter;
            __u64               sample_period_ns;
            struct vmevent_attr attrs[VMEVENT_CONFIG_MAX_ATTRS];
       };

       size must be initialized to sizeof(struct vmevent_config).

       counter specifies a number of initialized attrs elements.

       sample_period_ns specifies sampling period  in  nanoseconds.  For
       applications  it  is  recommended  to set this value to a highest
       suitable period. (Note that for some attributes the delivery tim-
       ing is not based on the sampling period, e.g.  VMEVENT_ATTR_PRES-
       SURE.)

RETURN VALUE
       On success, vmevent_fd() returns a new file descriptor. On error,
       a  negative  value  is  returned and errno is set to indicate the
       error.

ERRORS
       vmevent_fd() can fail with errors similar to open(2).

       In addition, the following errors are possible:

       EINVAL The failure means that  an  improperly  initalized  config
              structure  has been passed to the call (this also includes
              improperly initialized attrs arrays).

       EFAULT The failure means that the kernel was unable to  read  the
              configuration  structure, that is, config parameter points
              to an inaccessible memory.

VERSIONS
       The system call is available on Linux since kernel  3.8.  Library
       support is yet not provided by any glibc version.

CONFORMING TO
       The system call is Linux-specific.

EXAMPLE
       Examples  can  be  found in /usr/src/linux/tools/testing/vmevent/
       directory.

SEE ALSO
       poll(2), read(2), proc(5), vmstat(8)

Linux                          2012-10-16                  VMEVENT_FD(2)

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 man2/vmevent_fd.2 | 235 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 235 insertions(+)
 create mode 100644 man2/vmevent_fd.2

diff --git a/man2/vmevent_fd.2 b/man2/vmevent_fd.2
new file mode 100644
index 0000000..b631455
--- /dev/null
+++ b/man2/vmevent_fd.2
@@ -0,0 +1,235 @@
+.\" Copyright (C) 2008 Michael Kerrisk <mtk.manpages@gmail.com>
+.\" Copyright (C) 2012 Linaro Ltd.
+.\" 		       Anton Vorontsov <anton.vorontsov@linaro.org>
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
+.TH VMEVENT_FD 2 2012-10-16 Linux "Linux Programmer's Manual"
+.SH NAME
+vmevent_fd \- Linux virtual memory management events
+.SH SYNOPSIS
+.nf
+.B #define _GNU_SOURCE
+.B #include <unistd.h>
+.B #include <sys/syscall.h>
+.B #include <asm/unistd.h>
+.B #include <linux/types.h>
+.B #include <linux/vmevent.h>
+
+.\" TODO: libc wrapper
+.BI "syscall(__NR_vmevent_fd, "config );
+.fi
+.SH DESCRIPTION
+This system call creates a new file descriptor that can be used with polling
+routines (e.g.
+.BR poll (2))
+to get notified about various in-kernel virtual memory management events
+that might be of interest for userspace. The interface can
+also be used to effeciently monitor memory usage (e.g. number of idle and
+swap pages).
+
+Applications can make overall system's memory management more nimble by
+adjusting theirs resources usage upon the notifications.
+.SS Attributes
+Attributes are the basic concept, they are described by the following
+structure:
+
+.nf
+struct vmevent_attr {
+	__u64 value;
+	__u32 type;
+	__u32 state;
+};
+.fi
+
+.I type
+may correspond to these values:
+.TP
+.B VMEVENT_ATTR_NR_AVAIL_PAGES
+The attribute reports total number of available pages in the system, not
+including swap space (i.e. just total RAM).
+.I value
+is used to setup a threshold (in number or pages) upon which the event
+will be delivered by the kernel.
+
+Upon notifications kernel updates all configured attributes, so the
+attribute is mostly used without any thresholds, just for getting the
+value together with other attributes and avoid reading and parsing
+.IR /proc/vmstat .
+.TP
+.B VMEVENT_ATTR_NR_FREE_PAGES
+The attribute reports total number of unused (idle) RAM in the system.
+
+.I value
+is used to setup a threshold (in number or pages) upon which the event
+will be delivered by the kernel.
+.TP
+.B VMEVENT_ATTR_NR_SWAP_PAGES
+The attribute reports total number of swapped pages.
+
+.I value
+is used to setup a threshold (in number or pages) upon which the event
+will be delivered by the kernel.
+.TP
+.B VMEVENT_ATTR_PRESSURE
+The attribute reports Linux virtual memory management pressure. There are
+three discrete levels:
+
+.BR VMEVENT_PRESSURE_LOW :
+By setting the threshold to this value it's possible to watch whether
+system is reclaiming memory for new allocations. Monitoring reclaiming
+activity might be useful for maintaining overall system's cache level.
+
+.BR VMEVENT_PRESSURE_MED :
+The system is experiencing medium memory pressure, there is some mild
+swapping activity. Upon this event applications may decide to free any
+resources that can be easily reconstructed or re-read from a disk.
+
+.BR VMEVENT_PRESSURE_OOM :
+The system is actively thrashing, it is about to out of memory (OOM) or
+even the in-kernel OOM killer is on its way to trigger. Applications
+should do whatever they can to help the system. See
+.BR proc (5)
+for more information about OOM killer and its configuration options.
+
+.I value
+is used to setup a threshold upon which the event will be delivered by
+the kernel (for algebraic comparisons, it is defined that
+.BR VMEVENT_PRESSURE_LOW " <"
+.BR VMEVENT_PRESSURE_MED " <"
+.BR VMEVENT_PRESSURE_OOM ,
+but applications should not put any meaning into the absolute values.)
+
+.TP
+.I state
+is used to setup thresholds' behaviour, the following flags can be bitwise
+OR'ed:
+....
+.TP
+.B VMEVENT_ATTR_STATE_VALUE_LT
+Notification will be delivered when an attribute is less than a
+user-specified
+.IR "value" .
+.TP
+.B VMEVENT_ATTR_STATE_VALUE_GT
+Notifications will be delivered when an attribute is greater than a
+user-specified
+.IR "value" .
+.TP
+.B VMEVENT_ATTR_STATE_VALUE_EQ
+Notifications will be delivered when an attribute is equal to a
+user-specified
+.IR "value" .
+.TP
+.B VMEVENT_ATTR_STATE_EDGE_TRIGGER
+Events will be only delivered when an attribute crosses
+.I value
+threshold.
+.SS Events
+Upon a notification, application must read out events using
+.BR read (2)
+system call.
+The events are delivered using the following structure:
+
+.nf
+struct vmevent_event {
+	__u32			counter;
+	__u32			padding;
+	struct vmevent_attr	attrs[];
+};
+.fi
+
+The
+.I counter
+specifies a number of reported attributes, and the
+.I attrs
+array contains a copy of configured attributes, with
+.IR "vmevent_attr" 's
+.I value
+overwritten to attribute's value.
+.SS Config
+.BR vmevent_fd (2)
+accepts
+.I vmevent_config
+structure to configure the notifications:
+
+.nf
+struct vmevent_config {
+	__u32			size;
+	__u32			counter;
+	__u64			sample_period_ns;
+	struct vmevent_attr	attrs[VMEVENT_CONFIG_MAX_ATTRS];
+};
+.fi
+
+.I size
+must be initialized to
+.IR "sizeof(struct vmevent_config)" .
+
+.I counter
+specifies a number of initialized
+.I attrs
+elements.
+
+.I sample_period_ns
+specifies sampling period in nanoseconds. For applications it is
+recommended to set this value to a highest suitable period. (Note that for
+some attributes the delivery timing is not based on the sampling period,
+e.g.
+.IR VMEVENT_ATTR_PRESSURE .)
+.SH "RETURN VALUE"
+On success,
+.BR vmevent_fd ()
+returns a new file descriptor. On error, a negative value is returned and
+.I errno
+is set to indicate the error.
+.SH ERRORS
+.BR vmevent_fd ()
+can fail with errors similar to
+.BR open (2).
+
+In addition, the following errors are possible:
+.TP
+.B EINVAL
+The failure means that an improperly initalized
+.I config
+structure has been passed to the call (this also includes improperly
+initialized
+.I attrs
+arrays).
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
+.I /usr/src/linux/tools/testing/vmevent/
+directory.
+.SH "SEE ALSO"
+.BR poll (2),
+.BR read (2),
+.BR proc (5),
+.BR vmstat (8)
-- 
1.7.12.3
