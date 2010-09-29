Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0I2PLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:11:30 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:45590 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab0I2PL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:11:29 -0400
Date: Wed, 29 Sep 2010 17:11:18 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Olof Johansson <olof@lixom.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] dmi: export dmi data through debugfs
Message-ID: <20100929171118.1dbf3fbb@endymion.delvare>
In-Reply-To: <20100929145330.GA9351@lixom.net>
References: <20100928211246.GA20941@lixom.net>
	<20100929093403.7db92388@endymion.delvare>
	<20100929145330.GA9351@lixom.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 09:53:30 -0500, Olof Johansson wrote:
> On Wed, Sep 29, 2010 at 09:34:03AM +0200, Jean Delvare wrote:
> > Hi Olaf,
> > 
> > On Tue, 28 Sep 2010 16:12:46 -0500, Olof Johansson wrote:
> > > I've found this quite useful since it allows dmidecode to run without
> > > root privileges using --from-dump to read this file instead
> > 
> > This is a bad idea. We do NOT want every user to have access to all the
> > DMI information. There is sensitive information in there (serial
> > numbers and UUIDs, and possibly even more sensitive data in
> > OEM-specific records.) If you look in /sys/class/dmi/id/, you'll see
> > that files board_serial, chassis_serial, product_serial and
> > product_uuid are only readable by root exactly for this reason.
> 
> > So this is a NACK from me, sorry.
> 
> So how about a change to mode 0400 on the debugfs file then?

This is a requirement, yes.

> It's
> still better than having a userspace tool dig around /dev/mem for the
> information.

How is that better, please? Unless /dev/mem is going away, I don't see
any benefit. "Digging around" is exactly what the kernel is doing to
get the information. dmidecode has been around for over 7 years now,
it's always been reading its information from /dev/mem, and while there
has been some technical challenge with this (mmap vs. read) it has been
solved long ago.

And we now have an option limiting what can be accessed
through /dev/mem (CONFIG_STRICT_DEVMEM), so we should be safe.

The only objection I ever heard is that one had to be rootto run
dmidecode, but there's no way to address this, which is why the
relevant DMI strings are now exposed through sysfs. If there's a string
you consider useful which is missing there, you could just add it.

Now if you really insist on exposing the whole DMI table through sysfs,
I can't prevent you from doing that. After all, ACPI already exposes
its tables under /sys/firmware/acpi/tables (mode 0400). But then you'd
rather expose the DMI entry point and tables
under /sys/firmware/dmi/tables for consistency, rather than using
debugfs. But again, I don't think it is adding any value over what we
already have.

Please note that anyway, dmidecode is not going to stop getting the
table from /dev/mem, because it is used on several non-Linux operating
systems (all the BSDs in particular) which do not have sysfs.

-- 
Jean Delvare
