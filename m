Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0HPO02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:26:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49442 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab0HPO00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:26:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Date: Mon, 16 Aug 2010 16:26:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>
References: <cover.1281956490.git.richard.cochran@omicron.at> <363bd749a38d0b785d8431e591bf54c38db4c2d7.1281956490.git.richard.cochran@omicron.at>
In-Reply-To: <363bd749a38d0b785d8431e591bf54c38db4c2d7.1281956490.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008161626.24083.arnd@arndb.de>
X-Provags-ID: V02:K0:A1ab6rt/QzFhAanEocSYkmYGdclbwZrH/vZVyLbRf20
 QGaBawvRTD91MIZOdWVexWSHCABT+SxlVTEMj4jQDkSOqPXe9K
 25Bw4wuzcufSKkFSHjT/5q9uK6s3DS0fEmQLctoz7PYepIOkrB
 f3ZauBWEynl5cBjF9PEv4Vm5YIhqTnsZhGCocdDyDHKL4XyYkh
 46O5bG2V/JRRPpSXry5iQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 August 2010, Richard Cochran wrote:
> This patch adds an infrastructure for hardware clocks that implement
> IEEE 1588, the Precision Time Protocol (PTP). A class driver offers a
> registration method to particular hardware clock drivers. Each clock is
> exposed to user space as a character device with ioctls that allow tuning
> of the PTP clock.

Have you considered integrating the subsystem into the Posix clock/timer
framework?

I can't really tell from reading the source if this is possible or
not, but my feeling is that if it can be done, that would be a much
nicer interface. We already have clock_gettime/clock_settime/
timer_settime/... system calls, and while you'd need to add another
clockid and some syscalls, my feeling is that it will be more
usable in the end.

> +static const struct file_operations ptp_fops = {
> +       .owner          = THIS_MODULE,
> +       .ioctl          = ptp_ioctl,
> +       .open           = ptp_open,
> +       .poll           = ptp_poll,
> +       .read           = ptp_read,
> +       .release        = ptp_release,
> +};

.ioctl is gone, you have to use .unlocked_ioctl and make sure that
your ptp_ioctl function can handle being called concurrently.

You should also add a .compat_ioctl function, ideally one that
points to ptp_ioctl so you don't have to list every command as
being compatible. Right now, some commands are incompatible,
which means you need more changes to the interface.

> +struct ptp_clock_timer {
> +       int alarm_index;       /* Which alarm to query or configure. */
> +       int signum;            /* Requested signal. */
> +       int flags;             /* Zero or TIMER_ABSTIME, see TIMER_SETTIME(2) */
> +       struct itimerspec tsp; /* See TIMER_SETTIME(2) */
> +};

This data structure is incompatible between 32 and 64 bit user space,
so you would need a compat_ioctl() function to convert between the
two formats. Better define the structure in a compatible way, avoiding
variable-length fields and implicit padding.

> +struct ptp_clock_request {
> +       int type;  /* One of the ptp_request_types enumeration values. */
> +       int index; /* Which channel to configure. */
> +       struct timespec ts; /* For period signals, the desired period. */
> +       int flags; /* Bit field for PTP_ENABLE_FEATURE or other flags. */
> +};

Same problem here, timespec is either 64 or 128 bits long and has different
alignment.

> +struct ptp_extts_event {
> +       int index;
> +       struct timespec ts;
> +};

here too.

> +#define PTP_CLOCK_VERSION 0x00000001
> +
> +#define PTP_CLK_MAGIC '='
> +
> +#define PTP_CLOCK_APIVERS _IOR (PTP_CLK_MAGIC, 1, __u32)

Try avoiding versioned ABIs. It's better to just add new ioctls
or syscalls when you need some extra functionality and leave the
old ones around.

> +#define PTP_CLOCK_ADJTIME _IOW (PTP_CLK_MAGIC, 3, struct timespec)
> +#define PTP_CLOCK_GETTIME _IOR (PTP_CLK_MAGIC, 4, struct timespec)
> +#define PTP_CLOCK_SETTIME _IOW (PTP_CLK_MAGIC, 5, struct timespec)

These are also incompatible.

	Arnd
