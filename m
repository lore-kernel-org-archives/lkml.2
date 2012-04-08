Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2DHTQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 15:16:45 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:42284 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab2DHTQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 15:16:44 -0400
MIME-Version: 1.0
In-Reply-To: <4F81D254.9090000@zytor.com>
References: <4F80892A.7050104@zytor.com> <20120407202056.472d8ad9@pyramind.ukuu.org.uk>
 <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com> <20120407212705.GD11295@thunk.org>
 <4F80B9AC.2010103@zytor.com> <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com>
 <4F81D254.9090000@zytor.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sun, 8 Apr 2012 21:16:22 +0200
Message-ID: <CAPXgP10-_kS7VtdWonBhOxKJD2KatB9SznZ_xUUaxBz7-boT2A@mail.gmail.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@linux-foundation.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 8, 2012 at 20:00, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/08/2012 12:30 AM, Kay Sievers wrote:
>>
>> I don't think it has much to do with udev, it follows 100%
>> instructions from the kernel, and it does not create the device node
>> that is in the way here.
>>
>> Udev does not name any device in the system since a long time. Since
>> quite a while it has not even the code to do mknod() and requires
>> devtmpfs. The device node part of udev these day is limited to manage
>> device node permissions and creating additional symlinks. All device
>> node creation happens inside the kernel itself - where it belongs -
>> and not in userspace.
>>
>> If the default behaviour of /dev/pts/* should be changed, the kernel
>> should be changed to support the multi-instance mode right away
>> without involving userspace. We better do not require userspace to
>> gain any knowledge about such stuff. I'm confident, that we should not
>> add more, or require to support multiple alternative ways of handling
>> kernel internals in userspace.
>>
>> So, I think we either remove the '/sys/class/tty/ptmx' device from the
>> system, and let the devpts code create the symlink in the 'devtmpfs'
>> filesystem, or alternatively the '/sys/class/tty/ptmx' device supports
>> the multi-instance mode itself, instead of requiring a symlink. Such
>> stuff belongs entirely into the kernel these day. Anything else seems
>> to just ask for trouble.
>>
>
> OK, this seems very reasonable, and something that could (and probably
> *has to*) be done as an atomic change... maybe.
>
> There is no way for /dev/ptmx to support the multiinstance mode since it
> is located outside any devpts filesystem; it *has* to be inside the
> devpts filesystem in order to function... if that wasn't the case this
> whole thing would have been trivial from the get-go.

In theory the open() could possibly find out to which namespace it
belongs, but I guess the other alternative is much simpler and cleaner
anyway.

> Greg, do you have any insights in what would have to be necessary
> mechanics to make this.

I guess the following:
  - remove the 'ptmx' cdev from drivers/tty/pty.c
  - add a new devtmpfs_create_link() to drivers/base/devtmpfs.c
  - call devtmpfs_create_link() from _init in fs/devpts/inode.c
  - change the default of ptxmode=0 to a sane default = 0666
  - get rid of the (rather broken) idea of 'legacy' vs 'non-legacy mode'
    mount options in the default setup; I don't think userspace should
    ever be required to fiddle with such stuff

The only difference between multi- and single instantiated would be
that you get the same and in the other case a new instance, when you
mount. If we remove the CONFIG_ option from the kernel or not, will
probably not matter that much any more.

I guess, it would involve zero userspace changes, then unlike your
marked-as-[easy] item, it is not easy at all. All initramfs generators
would need to be changed to support the new mount options that, and
they usually have no config file to add that to. We also do not add
kernel filesystems to fstab these days, fstab is almost entirely left
to the administrator's customization, and not the distribution's
defaults, so it should/can not just be added there, because it is not
in there today.

Kay
