Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab0FZQRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 12:17:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab0FZQRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 12:17:52 -0400
Message-ID: <4C262824.6080806@redhat.com>
Date: Sat, 26 Jun 2010 18:17:40 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Christoph Anton Mitterer <calestyo@scientia.net>
CC: linux-kernel@vger.kernel.org, dm-crypt <dm-crypt@saout.de>
Subject: Re: how to (really) cleanly shutdown the system when root is on multiple
 stacked block devices
References: <1277552682.29791.23.camel@fermat.scientia.net>
In-Reply-To: <1277552682.29791.23.camel@fermat.scientia.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2010 01:44 PM, Christoph Anton Mitterer wrote:

> I stumbled however across a problem for the shutdown/reboot:
> What Debian does about is the following (via sysvinit 0 or 6):
> 1. cryptdisks stop
> 2. lvm2 stop
> 3. umountroot
> 4. halt/reboot
>
> That 1 and 2 are before 3 is (I guess) because they simply don't expect
> root-fs to be on the stacked block devices, and want to cleanly close
> everything else, before umounting the root-fs

For the device-mapper device (and this applies to other type devices too),
you cannot remove device (unload mapping table) when device is still open.

This applies even for active stacked mapping of devices (LVM over LUKS)
- you cannot remove LUKS device while LVs are active on top of it.
(even unmounted)

remount RO will not help here - it still keeps the device open.

> Now my question:
> Is it strictly guaranteed, that when the mount -o remount,ro / in
> umountroot returns,... everything that the filesystem flushed out,...
> has already went down throught all the different block layers to the
> disk?

With recent kernel and flush (issuing barrier internally) device-mapper
properly propagates barrier request.

But note that you are running shutdown scripts from device itself
if it is root-fs script itself produces reads to the device.
...

> Now I guess with a filesystem having barriers... it's secure, right? But
> what about filesystem not having them?

btw block device flush is implemented using barrier too.

> So I think in the end my question is:
> Is it by design secured, that I do _NOT_ cleanly disable any (possible
> stacked block layers like lvm/md/dm-crypt/etc), when halting/rebooting
> the system and when I do an remount,ro in the end.

 From the data integrity point of view, remounting to RO should probably
be enough (correct me please if I am wrong:-).

But from the security point of view dm-crypt encryption key remains in memory
because you cannot properly remove LUKS device thus wipe the key.

Anyone with proper boot image can recover such key from RAM memory using
so called cold-boot attack.

You have several options how to solve this, but I am afraid all require
some kind of ramdisk, where are the basic tools are copied before unmounting
root-fs and unmapping devices and reboot.

(For non-root devices it is easy, you can even call luksSuspend to wipe
key on still active device as workaround before reboot. After luksSuspend
device is frozen - until the key is provided back using luksResume.
So only some e.g. page cache leaks of plaintext data are possible -
but not encryption key itself.)

I mean something like this on shutdown:

- create ramdisk containing basic utilities
   (mount, sync, lvm, cryptsetup, halt, etc)
- remount device read-only, iow sync and flush write IO
- switch to ramdisk, all command now must run from there
- try to cleanly unmout root-fs, deactivate underlying LV, deactivate LUKS
   - if deactivation fails, fallback to wipe LUKS device key in memory
     using luksSuspend
   (more options here, like trying to dmsetup remove -f do remap to error target,
    which disconnects underlying devices and allows deactivate them,
    but it is quite dangerous)
- reboot

(sounds like we need shutdownramfs but initramfs can be probably reused here:-)

Milan
