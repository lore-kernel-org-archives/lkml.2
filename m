Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab0FZTRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 15:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab0FZTRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 15:17:48 -0400
Message-ID: <4C265258.3080508@redhat.com>
Date: Sat, 26 Jun 2010 21:17:44 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Christoph Anton Mitterer <calestyo@scientia.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: how to (really) cleanly shutdown the system when root is on multiple
 stacked block devices
References: <1277552682.29791.23.camel@fermat.scientia.net>	 <4C262824.6080806@redhat.com> <1277570658.3245.71.camel@fermat.scientia.net>
In-Reply-To: <1277570658.3245.71.camel@fermat.scientia.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2010 06:44 PM, Christoph Anton Mitterer wrote:
> On Sat, 2010-06-26 at 18:17 +0200, Milan Broz wrote:

>> With recent kernel and flush (issuing barrier internally) device-mapper
>> properly propagates barrier request.
> a) What is recent? ;)
> b) The barrier thingy,... does it have to be supported by the thing
> (e.g. filesystem, LV, etc.) on top? Or is this something generically
> implemented for flushing?

IIRC barriers are fully supported for DM devices since 2.6.31
but every fs must properly flush IO on umount or remount RO
(using whatever method is possible).
  
>> But note that you are running shutdown scripts from device itself
>> if it is root-fs script itself produces reads to the device.
>> ...
> Uhm what exactly do you mean?

Just that every command run will issue some reads when it need to load
libraries etc.

>> But from the security point of view dm-crypt encryption key remains in memory
>> because you cannot properly remove LUKS device thus wipe the key.
>>
>> Anyone with proper boot image can recover such key from RAM memory using
>> so called cold-boot attack.
> How long is this about staying in the RAM (after poweroff)?
> And after reboot.... isn't everything set to 0x0? Otherwise,... booting
> e.g. another OS or a compromised Linux could leak the key...

See http://citp.princeton.edu/memory/

>> You have several options how to solve this, but I am afraid all require
>> some kind of ramdisk, where are the basic tools are copied before unmounting
>> root-fs and unmapping devices and reboot.
> I've already feared that... so we need de-initramfs? ;)
>
>
>> (For non-root devices it is easy, you can even call luksSuspend to wipe
>> key on still active device as workaround before reboot.

(just FYI: luksSuspend is simple wrapper for dm-crypt wipe key functionality;
it was written to provide tool to safely wipe all dm-crypt encryption keys
in memory without need to close device, it is de-initialising cryptoAPI
modules etc.
It was intended to provide something which can help "suspend to RAM" to be
at least partially immune to cold boot attack on RAM-suspended laptop.)

> I guess non-root devices should be cleanly closed, with luksClose, or
> not?

yes. But for security reasons there still should be some fallback if it
fails - so at least key is properly wiped if all other attempts to unmout fails.
  
>> After luksSuspend
>> device is frozen - until the key is provided back using luksResume.
>> So only some e.g. page cache leaks of plaintext data are possible -
>> but not encryption key itself.)
> Isn't it possible to patch the kernel,.. that always when halting or
> rebooting,.. it "simply" wipes _ALL_ dm-cryptkeys available,...
> And why/how are plaintext leaks possible?

That will solve only one problem. Then you will have some some device which
need ioctl to wipe its state (including possible sensitive data in
its buffers) etc. It is just an example, hack to wipe memory on reboot is
not proper solution.

I think this should be solved systematically - clean shutdown should keep
machine in safe state.

>> I mean something like this on shutdown:
>>
>> - create ramdisk containing basic utilities
>>     (mount, sync, lvm, cryptsetup, halt, etc)
>> - remount device read-only, iow sync and flush write IO
>> - switch to ramdisk, all command now must run from there
>> - try to cleanly unmout root-fs, deactivate underlying LV, deactivate LUKS
>>     - if deactivation fails, fallback to wipe LUKS device key in memory
>>       using luksSuspend
>>     (more options here, like trying to dmsetup remove -f do remap to error target,
>>      which disconnects underlying devices and allows deactivate them,
>>      but it is quite dangerous)
>> - reboot
>>
>> (sounds like we need shutdownramfs but initramfs can be probably reused here:-)
> Already thought about that before,... but it seems impossible to me,...
> to convice distros to do that...

It is always amusing these discussions which super-hyper encryption mode
to use and then we are not able to properly shutdown it, keeping the root-fs
encryption key in memory.
Seriously, this is problem and must be solved if we are serious with
full disk encryption.

> And it's quite complex I guess,... given the fact that there are
> basically arbitrary ways to stack your block devices...

It is exactly the same complexity like in initramfs, just steps are reversed.

But I think that solution which 1) flush page cache 2) remount read-only
and 3) wipe all encryption keys for remaining devices is enough.

> Right now when I shutdown,... I get errors for lvm/dm-crypt/md,... as
> they all can't close there devices,... as the root-fs is just ro-mounted
> (ok the Debian cryptsetup package seems to not display that error,.. but
> it's probably there).

cryptsetup should print error when device is busy on luksClose,
report it to upstream (currently probably me) if not:-)
(It prints "Device <dev> is busy." in that situtation and fails.)

Anyway, I am sure that other distro maintainers must solved similar problem...

Milan
