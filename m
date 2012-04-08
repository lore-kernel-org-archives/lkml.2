Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2DHHa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 03:30:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42074 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab2DHHa2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 03:30:28 -0400
MIME-Version: 1.0
In-Reply-To: <4F80B9AC.2010103@zytor.com>
References: <4F80892A.7050104@zytor.com> <20120407202056.472d8ad9@pyramind.ukuu.org.uk>
 <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com> <20120407212705.GD11295@thunk.org>
 <4F80B9AC.2010103@zytor.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sun, 8 Apr 2012 09:30:07 +0200
Message-ID: <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@linux-foundation.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 8, 2012 at 00:03, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/07/2012 02:27 PM, Ted Ts'o wrote:
>> On Sat, Apr 07, 2012 at 01:02:33PM -0700, H. Peter Anvin wrote:
>>> The problem is that the lack of migration at the root causes real
>>> problems for the people who need the extra funkiness, and unlike BSD
>>> ttys it's not an application-level change at all.
>>
>> Could you explain what the issues are?  I haven't been following
>> devpts all that carefully.
>>
>
> The issue is that to make the "ptys are private to an instance of the
> devpts filesystem", /dev/ptmx has to live inside the /dev/pts
> filesystem.  This was traditionally not the case.  To avoid breaking
> everything all at once, we have a legacy mode which supports the "all
> devpts instances are the same" (effectively bind mounts) and which
> support a /dev/ptmx outside /dev/pts.
>
> The problem is that anyone who wants to take advantage of the new
> functionality has to make sure *all* instances of devpts work with the
> new protocol.  This means modifying your distro to:
>
> 1. Add "newinstance" and "ptmxmode" to /etc/fstab [easy]
> 2. Make /dev/ptmx a symlink to /dev/pts/ptmx.
>
> 2 would be easy if it wasn't for udev, which makes it very hard.  It is
> not reasonable for udev to support both modes, so the *only* mode that
> is reasonable for it to support is the new mode.  However, it is
> increasingly obvious that if we don't force it, this will never happen.

I don't think it has much to do with udev, it follows 100%
instructions from the kernel, and it does not create the device node
that is in the way here.

Udev does not name any device in the system since a long time. Since
quite a while it has not even the code to do mknod() and requires
devtmpfs. The device node part of udev these day is limited to manage
device node permissions and creating additional symlinks. All device
node creation happens inside the kernel itself - where it belongs -
and not in userspace.

If the default behaviour of /dev/pts/* should be changed, the kernel
should be changed to support the multi-instance mode right away
without involving userspace. We better do not require userspace to
gain any knowledge about such stuff. I'm confident, that we should not
add more, or require to support multiple alternative ways of handling
kernel internals in userspace.

So, I think we either remove the '/sys/class/tty/ptmx' device from the
system, and let the devpts code create the symlink in the 'devtmpfs'
filesystem, or alternatively the '/sys/class/tty/ptmx' device supports
the multi-instance mode itself, instead of requiring a symlink. Such
stuff belongs entirely into the kernel these day. Anything else seems
to just ask for trouble.

Kay
