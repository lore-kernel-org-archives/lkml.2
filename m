Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0JRMdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:33:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39600 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab0JRMda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:33:30 -0400
MIME-Version: 1.0
In-Reply-To: <4CBC32CC.6010506@hitachi.com>
References: <4CAEAAD4.2080504@hitachi.com> <20101008204802.GA21542@kroah.com> <4CBC32CC.6010506@hitachi.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 18 Oct 2010 14:33:13 +0200
Message-ID: <AANLkTi=HzjWZbz7J92h9LCQijG8Zsv1YptFzN7d_G7eG@mail.gmail.com>
Subject: Re: [RFD] Device Renaming Mechanism
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: Greg KH <greg@kroah.com>, James.Bottomley@suse.de, rwheeler@redhat.com,
        linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, Matt_Domsch@dell.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 13:43, Nao Nishijima
<nao.nishijima.xt@hitachi.com> wrote:
>>       - Kernel device renaming is very fragile and only done for
>>         netdevs because they can't have symlinks. There are many
>>         cross-refs for blockdevs like holders/ slaves/ sysfs dirs,
>>         they all need to be renamed atomically and race-free, which is
>>         almost impossible I would say.
>>
>>       - Biggest problem with renaming is that the device gets
>>         advertised and is accessed immediately by userspace. Renaming
>>         after advertising (sysfs, devtmpfs, uevent) is very difficult,
>>         racy, almost impossible.
>>
>
> I agree that renaming after advertising to be difficult, but network goes well?

Not at all. It's a complete mess I wouldn't recommend doing. Udev's
default does this for the common case, but it has many cases where
stuff just goes wrong and can never be solved properly.

Netif names need to be swapped sometimes, and then you need temporary
renaming to a non-clashing name, and sleep() until the desired name
becomes available. During all that, the netlink messages announce all
these changes/new names to possible applications. Uevents get out of
sync, the devpaths of devices swap around.

In short: it's a complete nightmare from the view of reliability, and
I strongly suggest not even to think about to try that model on any
other subsystem.

>>       - The only option to have named block devs is to have change the
>>         block layer to create intermediate devices in sysfs (which are
>>         advertised but not accessible as blockdevs) and then let
>>         userspace hook into it and request a real blockdev with a
>>         specified name, and only _after_ this create the real
>>         blockdev. This is, and must be, not  a renaming, but a naming.
>>
>
> It sounds good to me. but i don't understand clearly.
> Is "Not accessible as blockdevs" meaning that a device not register
> bdi(backing_dev_info) list or Major/miner not given to device?
> Could you tell me in detail?

It's all about the userspace visible device state. You can't export a
blockdev which you are going to rename shortly after this, it does
confuse usespace, and can not made work reliably.

How it's implemented inside the kernel does not really matter for the
outside as long as it has a step for userspace to provide the name,
that is used to create(not rename) and announce the device with.

It would need to be some intermediate device, which is not a blockdev,
and has no dev_t assigned, and exports needed metadata to compose a
device name from it. This name is then used to create the real
blockdev.

Note, that I'm not suggesting to do anything like that. It would just
be the only model that *could* be made working. The way network
interfaces are handled must not be applied to other subsystems.

Things like device-mapper could probably get a reasonable way to
provide a fixed name for the dm device to create. They are created by
userspace request only, they know the metadata before the request --
so this sounds feasible in some way. As long as they can not be
renamed afterwards, which can't work for many other reasons.

Device-mapper could maybe make the dm UUID mandatory, and use it as
the device name. It will break a bunch of tools, which match on device
names, but I guess it *could* be made working (if it does not involve
any later renaming).

> I think that network people will face the same mismatch problems because they
> use symlinks.

The thing is that unlike blockdevs, netif names may have meaning
inside the kernel, like matching wildcards in iptables and such. That
makes any out-of-kernel "alias"-model for netifs much more complicated
than it is for blockdevs where "aliases" only need to exist in
userspace.

> I understand that renaming is a problem. I'd like to try Kay's idea.
I wouldn't even try. Besides the mentioned device mapper
mandatory/non-changeable UUID==device-name approach which could work,
I don't think that renaming of sd devices can be made working, without
rewriting half of all existing userspace. :)

Kay
