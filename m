Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337Ab0EUSwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 14:52:19 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:41985 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab0EUSwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 14:52:18 -0400
MIME-Version: 1.0
In-Reply-To: <20100521182325.GO3991@agk-dp.fab.redhat.com>
References: <1274371640.302.5.camel@yio.site> <AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com> 
	<AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com> 
	<201005211909.29326.knikanth@suse.de> <AANLkTimGBgpqB7HEZrecv7uEis6L8b5Yv7jfD6iv_f4J@mail.gmail.com> 
	<20100521182325.GO3991@agk-dp.fab.redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 21 May 2010 20:51:49 +0200
Message-ID: <AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com>
Subject: Re: add devname module aliases to allow module on-demand auto-loading
To: Kay Sievers <kay.sievers@vrfy.org>, Nikanth Karthikesan <knikanth@suse.de>,
       Peter Rajnoha <prajnoha@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Ian Kent <raven@themaw.net>, dm-devel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 20:23, Alasdair G Kergon <agk@redhat.com> wrote:
> On Fri, May 21, 2010 at 03:55:21PM +0200, Kay Sievers wrote:
>> On Fri, May 21, 2010 at 15:39, Nikanth Karthikesan <knikanth@suse.de> wrote:
>> > On Friday 21 May 2010 18:41:38 Kay Sievers wrote:
>> >> On Fri, May 21, 2010 at 13:51, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> >> > On Fri, May 21, 2010 at 13:34, Alasdair G Kergon <agk@redhat.com> wrote:
>> >> >
>> >> > There is no harm to make a well-know device node static, it just
>> >> > solves a lot of problems, and also makes it possible to work off of a
>> >> > static /dev.
>
> Well until now we've tried to make everything possible treat device numbers as
> dynamic, so I'd like to see some compelling logic behind the change.

It's a well known single-instance device, and the static assignment
solves a few problems with on-demand subsystem activation (which is
the new fashion :)) and makes it possible to hide the
compiled-in/modular issues we see, and have no proper solution for it.

>> >> To illustrate:
>> >>
>> >> On my box without this patch:
>> >>   dmsetup version
>> >>   Library version:   1.02.42 (2010-01-14)
>> >>   /proc/misc: No entry for device-mapper found
>> >>   Is device-mapper driver missing from kernel?
>> >>   Failure to communicate with kernel device-mapper driver.
>
> (Curiously this is not an issue I remember anyone raising with me as a problem
> before.)

Because distros go the easy and stupid way and just load everything
they configured as a module. :) That is something to solve, or at
least avoid and hide a bit.

> So what concepts are at stake here.
> The module is available to the kernel but has not been loaded.
> Some users do not need the module, so it should not be loaded by default.
> Users who *do* need it would like it to get loaded automatically.

Yes. Like many other things too. Ideally we just hide as much as we
can that stuff is a module and not compiled-in.

> The matter under discussion is what mechanism to use to load it automatically.
>
> The unique information is the module name so the mechanism should
> ideally be tied directly to that.  Anything wanting to use dm already
> knows that name.  The character device only becomes available later,
> after the module is loaded, and userspace obtains it from /proc/misc.
>
> The modprobe mechanism is tied to the name, so we should really look for
> a solution based on that in the first instance.
>
> A related matter - not yet mentioned or discussed between us - is how
> the /dev/mapper/control node gets created and what it should be called,
> as that name obviously goes against the udev standard of placing
> everything in a flat /dev namespace with kernel-based names (so
> something like '/dev/miscNNN' in this case) and creating symlinks from
> the traditional filesystem locations like /dev/mapper/control.

The kernel itself creates /dev/mapper/control today. And if devtmpfs
is not used (all recent released or upcoming distro releases depend on
it) the kernel will supply this name to udev, and udev will create it.

> Currently libdevmapper creates /dev/mapper/control as required based on
> /proc/misc.  Presumably we should now hand that over to udev as a
> special case of the way we transferred the entries for the actual
> devices with similar waiting & notification.

It like this already for a while. But it's all in the kernel, and is
race free regarding the module loading, At the moment modprobe comes
back, we are sure the node exists.

> Currently tools (not libdevmapper) take responsibility for checking and
> autoloading.  E.g. lvm issues modprobes to autoload dm target modules.
> (The kernel does also handle this but lvm doesn't use it because
> it wants to know earlier that the operation would fail to avoid more
> complex error-handling code.)

That's what this is about. The kernel will block the process that
accesses /dev/mapper/control until it is loaded. No need to sync
anything or then, or handle complex error cases.

> So I think we should first try to make an extension of the existing
> mechanisms work.  Everything is keyed off a single piece of information,
> the module name, shared between userspace and kernel.

I think its all covered with this patch. :) But if yo have any better
idea, let us know.

Thanks,
Kay
