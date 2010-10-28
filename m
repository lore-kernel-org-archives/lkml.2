Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab0J1LGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:06:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35621 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab0J1LGC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:06:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LqouZRlkqRTVtnmqjLE+lPzu/0gXH+K+pxpbRW0gQKUWanD9uQ6GEbxhcKvWy6OPpo
         0IJymLcJep8+MTMi+MOgK4qx0fxI9E8ZU5LRFHLi4gCPpkBM+h65Tcdmr5DUYHQduiMk
         Y+bkA33ybkMdEioJIgdrAl6D4WO4ZOS+yG0BQ=
MIME-Version: 1.0
In-Reply-To: <201010221749.37928.arnd@arndb.de>
References: <AANLkTimzWPqHBSDyeoObAcxewg_adubgkt1KQYUmpBRA@mail.gmail.com>
	<201010221749.37928.arnd@arndb.de>
Date: Thu, 28 Oct 2010 13:06:00 +0200
Message-ID: <AANLkTin0zQ0pmyck2=zwKXUa6TmY2u8uyhFQXO_iN4mQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] mfd: Add char devices for the ST-Ericsson CG2900.
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linus.walleij@stericsson.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for your comments. Everyone appreciates the time and effort
you've put into the review of this code.
See below for answer.

/P-G

2010/10/22 Arnd Bergmann <arnd@arndb.de>:
> On Friday 22 October 2010 12:36:09 Par-Gunnar Hjalmdahl wrote:
>> This patch adds char devices to the ST-Ericsson CG2900 driver.
>> The reason for this is to allow users of CG2900, such as GPS, to
>> be placed in user space.
>
> Can you be more specific how you expect this to be used?
>
> I guess you have hardware units that then each correspond to
> one character device and can be talked to over a pseudo socket
> interface, right?
>
> For most devices (radio, audio, bluetooth, gps, ...), we already
> have existing user interfaces, so how do they interact with this
> one?
>

Char dev exposes the interfaces to user space. Each char dev should
correspond to a channel in the cg2900.h API. The API allows one user
for each channel and this user can either be a Kernel user through a
direct call or a User space user through opening the corresponding
char dev.
Our reference system have the following users:
BT (cmd, acl, and evt) through Kernel BT stack (/net/bluetooth).
Connected by btcg2900 in this patch set
FM through V2L2 radio device (/drivers/media/radio). Connected by
CG2900 FM driver for V2L2 (under development, will be submitted to
community).
GPS through stack located in User space

We do not however want to block anyone from using a different
combination, e.g. using different BT or FM stack (placed in Kernel or
User space). The CG2900 driver is only intended to present a reliable
and power efficient transport to the different features within the
chip.

Normal flow for a user space stack is:
User space user opens char dev -> char dev registers corresponding
channel user using cg2900_register_user
User space user can now send and receive data to the chip using write,
read, and poll. Data is in raw format, cg2900 only adds first byte (H4
header) to packet.
When finished, User space user closes char dev -> char dev unregisters
channel using cg2900_deregister_user

>> +#define NAME                                 "CharDev "
>
> ?
>
>> +/* Ioctls */
>> +#define CG2900_CHAR_DEV_IOCTL_RESET          _IOW('U', 210, int)
>> +#define CG2900_CHAR_DEV_IOCTL_CHECK4RESET    _IOR('U', 212, int)
>> +#define CG2900_CHAR_DEV_IOCTL_GET_REVISION   _IOR('U', 213, int)
>> +#define CG2900_CHAR_DEV_IOCTL_GET_SUB_VER    _IOR('U', 214, int)
>
> These definitions look wrong -- you never use the ioctl argument...
>

Yes, we return values in the error which is probably not a good
solution. We should probably use argument instead. But I don't see
what's wrong with the defines (but most likely I've misunderstood how
they should be used :-) )?

>> + *
>> + * Returns:
>> + *   Bytes successfully read (could be 0).
>> + *   -EBADF if NULL pointer was supplied in private data.
>> + *   -EFAULT if copy_to_user fails.
>> + *   Error codes from wait_event_interruptible.
>> + */
>> +static ssize_t char_dev_read(struct file *filp, char __user *buf, size_t count,
>> +                          loff_t *f_pos)
>
> The same comment applies here that I made for the test interface:
> Why is this not an AF_BLUETOOTH socket instead of a chardev?
>
> Unless I'm mistaken, you actually send bluetooth frames after all.
>

I've discussed this in another mail, but to repeat in short:
For the BT channels we send raw BT data, but it is not on the same
level as for example the L2CAP socket in the BT stack. So I think it
would not apply, It would only be confusing to have the same kind of
socket on different stack levels (plus it does not apply for FM and
GPS).

>> +     case CG2900_CHAR_DEV_IOCTL_RESET:
>> +             if (!dev) {
>> +                     err = -EBADF;
>> +                     goto error_handling;
>> +             }
>> +             CG2900_INFO("ioctl reset command for device %s", dev->name);
>> +             err = cg2900_reset(dev->dev);
>> +             break;
>> +
>> +     case CG2900_CHAR_DEV_IOCTL_CHECK4RESET:
>> +             if (!dev) {
>> +                     CG2900_INFO("ioctl check for reset command for device");
>> +                     /* Return positive value if closed */
>> +                     err = CG2900_CHAR_DEV_IOCTL_EVENT_CLOSED;
>> +             } else if (dev->reset_state == CG2900_CHAR_RESET) {
>> +                     CG2900_INFO("ioctl check for reset command for device "
>> +                                 "%s", dev->name);
>> +                     /* Return positive value if reset */
>> +                     err = CG2900_CHAR_DEV_IOCTL_EVENT_RESET;
>> +             }
>> +             break;
>
> Strange interface. Why do you need to check for the reset?
>

Any user (Kernel or User space) can reset the chip (this is a HW
reset, not a SW reset). If someone does this, all settings made to the
chip are lost and chip is turned off. We can however not signal up to
User space that it now has to do a close and re-open operation plus
restart its stack (possibly informing the end-user about the restart).
By using poll and ioctl we can do this without disturbing other
operations. If User space application tries to perform operation on a
reset device, e.g. write, this will fail, but using ioctl provides the
opportunity to do this without any fake read or write operations.

>> +     case CG2900_CHAR_DEV_IOCTL_GET_REVISION:
>> +             CG2900_INFO("ioctl check for local revision info");
>> +             if (cg2900_get_local_revision(&rev_data)) {
>> +                     CG2900_DBG("Read revision data revision %d "
>> +                                "sub_version %d",
>> +                                rev_data.revision, rev_data.sub_version);
>> +                     err = rev_data.revision;
>> +             } else {
>> +                     CG2900_DBG("No revision data available");
>> +                     err = -EIO;
>> +             }
>> +             break;
>> +
>> +     case CG2900_CHAR_DEV_IOCTL_GET_SUB_VER:
>> +             CG2900_INFO("ioctl check for local sub-version info");
>> +             if (cg2900_get_local_revision(&rev_data)) {
>> +                     CG2900_DBG("Read revision data revision %d "
>> +                                "sub_version %d",
>> +                                rev_data.revision, rev_data.sub_version);
>> +                     err = rev_data.sub_version;
>> +             } else {
>> +                     CG2900_DBG("No revision data available");
>> +                     err = -EIO;
>> +             }
>> +             break;
>
> These look like could better live in a sysfs attribute of the platform device.
>
>        Arnd
>

I guess so. I thought it would be more simple to have it in the ioctl
since I already have other ioctl parameters, but I can probably fix it
quite easily.

/P-G
