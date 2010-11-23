Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab0KWAGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 19:06:08 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42738 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab0KWAGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 19:06:07 -0500
Subject: Re: [RFC] persistent store
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 16:06:03 -0800
Message-ID: <1290470763.3008.252.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's a patch based on some discussions I had with Thomas
> Gleixner at plumbers conference that implements a generic
> layer for persistent storage usable to pass tens or hundreds
> of kilobytes of data from the dying breath of a crashing
> kernel to its successor.
> 
> The usage model I'm envisioning is that a platform driver
> will register with this code to provide the actual storage.
> I've tried to make this interface general, but I'm working
> from a sample of one (the ACPI ERST code), so if anyone else
> has some persistent store that can't be handled by this code,
> speak up and we can put in the necessary tweaks.

I recently posted a patch set for powerpc to capture the most recent
oops or panic message in NVRAM:
http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-November/087032.html
It covers a lot of the same ground, and could be adapted to use your
framework.  See below for concerns and suggestions.  I'd also be
interested in feedback about the design decisions I mention below.

On powerpc, the amount of NVRAM available for this may be as little
as 1-2 Kbytes.  The minimal oops report (with essentially no backtrace)
is about 1800 bytes.  See below for implications.

We currently read our NVRAM contents via /dev/nvram and the nvram
command.  NVRAM is divided up into several "partitions" -- only
one of which is used for the oops/panic report -- so the user-space
code needs to know about how the partitions are laid out.  It also
needs to know how much text we actually wrote to the partition, and
whether or not it's compressed.  Since the kernel already knows how
to determine all this, it would probably be more convenient to get
at the oops/panic partition through your /sys interface.

> ...
> 2) "Why do you read in all the data from the device when it
> registers and save it in memory? Couldn't you just get the
> list of records and pick up the data from the device when
> the user reads the file?"
> I don't think this is going to be very much data, just a few hundred
> kilobytes (i.e. less that $0.01 worth of memory, even expensive server
> memory). The memory is freed when the record is erased ... which is
> likely to be soon after boot.

Since the amount of text we capture is so tiny, this is unlikely to be
an issue in my case.

> ...
> 6) "Is this widely useful? How many systems have persistent storage?"
> Although ERST was only added to the ACPI spec earlier this year, it
> merely documents existing functionality required for WHEA (Windows
> Hardware Error Architecture). So most modern server systems should
> have it (my test system has it, and it has a BIOS written in mid 2008).
> Sorry desktops & laptops - no love for you here.
> 

Powerpc p Series does, obviously, and we're looking to exploit it in
just this way.

> ...
> +static void
> +pstore_dump(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
> + const char *s1, unsigned long l1,
> + const char *s2, unsigned long l2)
> +{
> + unsigned long s1_start, s2_start;
> + unsigned long l1_cpy, l2_cpy;
> + char *dst = pstore_buf + psinfo->header_size;
> +
> + /* Don't dump oopses to persistent store */

Why not?  In our case, we capture every oops and panic report, but keep
only the most recent.  Seems like catching the last oops could be useful
if your system hangs thereafter and can't be made to panic.  I suggest
you pass along the reason (KMSG_DUMP_OOPS or whatever) and let the
callback decide.

You'd have to serialize the oops handling, I guess, in case multiple
CPUs oops simultaneously.  (Gotta fix that in my code.)

> + if (reason == KMSG_DUMP_OOPS)
> + return;
> +
> + l2_cpy = min(l2, psinfo->data_size);
> + l1_cpy = min(l1, psinfo->data_size - l2_cpy);
> +
> + s2_start = l2 - l2_cpy;
> + s1_start = l1 - l1_cpy;
> +
> + memcpy(dst, s1 + s1_start, l1_cpy);
> + memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
> +
> + psinfo->writer(PSTORE_DMESG, pstore_buf, l1_cpy + l2_cpy);

This assumes that you always want to capture the last psinfo->data_size
bytes of the printk buffer.  Given the small capacity of our NVRAM
partition, I handle the case where the whole oops report doesn't fit.
In that case, I sacrifice the end of the oops report to capture the
beginning.  Patch #3 in my set is about this.

> ...
> +static int
> +pstore_create_sysfs_entry(struct pstore_entry *new_pstore)
> +{
> ...
> + new_pstore->attr.attr.mode = 0444;

/var/log/messages is typically not readable by everybody.  This
appears to circumvent that.

> ...

Thanks.

Jim Keniston
IBM Linux Technology Center
Beaverton, OR


