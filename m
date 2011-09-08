Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1IHCLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 22:11:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44387 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1IHCLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 22:11:34 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20110218145502.GA7138@localhost>
References: <20110218145502.GA7138@localhost>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Thu, 8 Sep 2011 04:05:34 +0200
Message-ID: <CAKgNAkgi6Xd7DPjg-YqkkNs8nzPpbOnXqDWUu6DKxvUJ1=NojA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Update manpages with CAP_SYSLOG info
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Kees Cook <kees@ubuntu.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

On Fri, Feb 18, 2011 at 3:55 PM, Serge E. Hallyn
<serge.hallyn@canonical.com> wrote:
> Hi Michael,
>
> Here my attempt at a man-pages update to specify CAP_SYSLOG.
>
> thanks,
> -serge
>
> Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
> ---
>  man2/syslog.2       |    4 +++-
>  man7/capabilities.7 |    9 +++++++++
>  2 files changed, 12 insertions(+), 1 deletions(-)
>
> diff --git a/man2/syslog.2 b/man2/syslog.2
> index fb018a6..7383e2f 100644
> --- a/man2/syslog.2
> +++ b/man2/syslog.2
> @@ -237,7 +237,9 @@ An attempt was made to change console_loglevel or clear the kernel
>  message ring buffer by a process without sufficient privilege
>  (more precisely: without the
>  .B CAP_SYS_ADMIN
> -capability).
> +or
> +.B CAP_SYSLOG
> +(since 2.6.38) capability).
>  .TP
>  .B ERESTARTSYS
>  System call was interrupted by a signal; nothing was read.
> diff --git a/man7/capabilities.7 b/man7/capabilities.7
> index a751b21..55177dc 100644
> --- a/man7/capabilities.7
> +++ b/man7/capabilities.7
> @@ -236,6 +236,9 @@ Perform a range of system administration operations including:
>  .BR umount (2),
>  .BR swapon (2),
>  .BR swapoff (2),
> +privileged
> +.BR syslog(2)
> +operations (see CAP_SYSLOG),
>  .BR sethostname (2),
>  and
>  .BR setdomainname (2);
> @@ -421,6 +424,12 @@ set real-time (hardware) clock.
>  .B CAP_SYS_TTY_CONFIG
>  Use
>  .BR vhangup (2).
> +.TP
> +.B CAP_SYSLOG
> +Since 2.6.38, this capability can be substituted for CAP_SYS_ADMIN for
> +privileged syslog(2) actions.  When dmesg_restrict is set, that means
> +any call to syslog.  Otherwise, it means any action other than reading
> +the last kernel messages or getting the size of the log buffer.
>  .\"
>  .SS Past and Current Implementation
>  A full implementation of capabilities requires that:
> --
> 1.7.2.3
>

Thanks. I used that as the basis to add the changes below, for man-pages-2.33.

Cheers,

Michael

--- a/man2/syslog.2
+++ b/man2/syslog.2
@@ -72,7 +72,21 @@ as follows:

 Type 9 was added in Linux 2.4.10; type 10 in Linux 2.6.6.

-Only command types 3 and 10 are allowed to unprivileged processes.
+In Linux kernels before 2.6.37,
+only command types 3 and 10 are allowed to unprivileged processes.
+Since Linux 2.6.37,
+command types 3 and 10 are only allowed to unprivileged processes if
+.IR /proc/sys/kernel/dmesg_restrict
+has the value 0.
+Before Linux 2.6.37, "privileged" means that the caller has the
+.BR CAP_SYS_ADMIN
+capability.
+Since Linux 2.6.37,
+"privileged" means that the caller has either the
+.BR CAP_SYS_ADMIN
+capability (now deprecated for this purpose) or the (new)
+.BR CAP_SYSLOG
+capability.
 .SS The kernel log buffer
 The kernel has a cyclic buffer of length
 .B LOG_BUF_LEN
@@ -233,6 +247,8 @@ An attempt was made to change console_loglevel or
clear the kernel
 message ring buffer by a process without sufficient privilege
 (more precisely: without the
 .B CAP_SYS_ADMIN
+or
+.BR CAP_SYSLOG
 capability).
 .TP
 .B ERESTARTSYS
@@ -250,4 +266,5 @@ In libc4 and libc5 the number of this call was defined by
 In glibc 2.0 the syscall is baptized
 .BR klogctl ().
 .SH "SEE ALSO"
-.BR syslog (3)
+.BR syslog (3),
+.BR capabilities (7)

--- a/man7/capabilities.7
+++ b/man7/capabilities.7
@@ -41,10 +41,10 @@
 .\"     Add text noting that if we set the effective flag for one file
 .\"     capability, then we must also set the effective flag for all
 .\"     other capabilities where the permitted or inheritable bit is set.
-.\" FIXME: Linux 2.6.38 added CAP_SYSLOG
+.\" 2011-09-07, mtk/Serge hallyn: Add CAP_SYSLOG
 .\" FIXME: Linux 3.0 added CAP_WAKE_ALARM
 .\"
-.TH CAPABILITIES 7 2010-06-19 "Linux" "Linux Programmer's Manual"
+.TH CAPABILITIES 7 2011-09-07 "Linux" "Linux Programmer's Manual"
 .SH NAME
 capabilities \- overview of Linux capabilities
 .SH DESCRIPTION
@@ -242,6 +242,12 @@ Perform a range of system administration operations includi
ng:
 and
 .BR setdomainname (2);
 .IP *
+perform privileged
+.BR syslog (2)
+operations (since Linux 2.6.37,
+.BR CAP_SYSLOG
+should be used to permit such operations);
+.IP *
 perform
 .B IPC_SET
 and
@@ -423,6 +429,14 @@ set real-time (hardware) clock.
 .B CAP_SYS_TTY_CONFIG
 Use
 .BR vhangup (2).
+.TP
+.BR CAP_SYSLOG " (since Linux 2.6.37)"
+Perform privileged
+.BR syslog (2)
+operations.
+See
+.BR syslog (2)
+for information on which operations require privilege.
 .\"
 .SS Past and Current Implementation
 A full implementation of capabilities requires that:





-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
