Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0FZQoZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 12:44:25 -0400
Received: from mailgw01.dd24.net ([193.46.215.41]:42549 "EHLO
	mailgw01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab0FZQoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 12:44:24 -0400
Subject: Re: how to (really) cleanly shutdown the system when root is on
 multiple stacked block devices
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-kernel@vger.kernel.org
In-Reply-To: <4C262824.6080806@redhat.com>
References: <1277552682.29791.23.camel@fermat.scientia.net>
	 <4C262824.6080806@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Jun 2010 18:44:18 +0200
Message-ID: <1277570658.3245.71.camel@fermat.scientia.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-26 at 18:17 +0200, Milan Broz wrote:
> For the device-mapper device (and this applies to other type devices too),
> you cannot remove device (unload mapping table) when device is still open.
You just mean I cannot remove/close it, until something above (e.g.
filesystem) is still open/mounted? Yeah that was clear (and that's good,
isn't it?!)


> This applies even for active stacked mapping of devices (LVM over LUKS)
> - you cannot remove LUKS device while LVs are active on top of it.
> (even unmounted)
clear clear ... :)


> remount RO will not help here - it still keeps the device open.
of course :)


> With recent kernel and flush (issuing barrier internally) device-mapper
> properly propagates barrier request.
a) What is recent? ;)
b) The barrier thingy,... does it have to be supported by the thing
(e.g. filesystem, LV, etc.) on top? Or is this something generically
implemented for flushing?


> But note that you are running shutdown scripts from device itself
> if it is root-fs script itself produces reads to the device.
> ...
Uhm what exactly do you mean?


> btw block device flush is implemented using barrier too.
So I understand,.. this means it is something "separate"... and
regardless of whether the filesystem on top supports barriers itself,...
I'll have everything flushed out to disk when doing the remount,ro...
even if the block layer devices below are not yet closed.


> From the data integrity point of view, remounting to RO should probably
> be enough (correct me please if I am wrong:-).
Great :) And I guess you can speak for both lvm and dm-crypt ?! :)
And it should probably also flush through md,... as it's also dm?


> But from the security point of view dm-crypt encryption key remains in memory
> because you cannot properly remove LUKS device thus wipe the key.
> 
> Anyone with proper boot image can recover such key from RAM memory using
> so called cold-boot attack.
How long is this about staying in the RAM (after poweroff)?
And after reboot.... isn't everything set to 0x0? Otherwise,... booting
e.g. another OS or a compromised Linux could leak the key...


> You have several options how to solve this, but I am afraid all require
> some kind of ramdisk, where are the basic tools are copied before unmounting
> root-fs and unmapping devices and reboot.
I've already feared that... so we need de-initramfs? ;)


> (For non-root devices it is easy, you can even call luksSuspend to wipe
> key on still active device as workaround before reboot.
I guess non-root devices should be cleanly closed, with luksClose, or
not?


> After luksSuspend
> device is frozen - until the key is provided back using luksResume.
> So only some e.g. page cache leaks of plaintext data are possible -
> but not encryption key itself.)
Isn't it possible to patch the kernel,.. that always when halting or
rebooting,.. it "simply" wipes _ALL_ dm-cryptkeys available,...
And why/how are plaintext leaks possible?


> I mean something like this on shutdown:
> 
> - create ramdisk containing basic utilities
>    (mount, sync, lvm, cryptsetup, halt, etc)
> - remount device read-only, iow sync and flush write IO
> - switch to ramdisk, all command now must run from there
> - try to cleanly unmout root-fs, deactivate underlying LV, deactivate LUKS
>    - if deactivation fails, fallback to wipe LUKS device key in memory
>      using luksSuspend
>    (more options here, like trying to dmsetup remove -f do remap to error target,
>     which disconnects underlying devices and allows deactivate them,
>     but it is quite dangerous)
> - reboot
> 
> (sounds like we need shutdownramfs but initramfs can be probably reused here:-)
Already thought about that before,... but it seems impossible to me,...
to convice distros to do that...
And it's quite complex I guess,... given the fact that there are
basically arbitrary ways to stack your block devices...


Right now when I shutdown,... I get errors for lvm/dm-crypt/md,... as
they all can't close there devices,... as the root-fs is just ro-mounted
(ok the Debian cryptsetup package seems to not display that error,.. but
it's probably there).
Nevertheless,... what should "we" do now?
- Always seeing a "failed" is rather ugly
- One could simply not call the appropriate initscripts for stopping in
rc0 and rc6.
This would however affect all such devices,... not only those where the
root-fs is on top.
But I guess it's rather complex to find out the correct ones and skip
the error-message only for them...
And it does not solve the crypto-leak issue :(



Cheers,
Chris.

