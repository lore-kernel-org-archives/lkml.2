Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab0FZXKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 19:10:24 -0400
Received: from mailgw02.dd24.net ([193.46.215.43]:40978 "EHLO
	mailgw02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab0FZXKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 19:10:23 -0400
Subject: Re: how to (really) cleanly shutdown the system when root is on
 multiple stacked block devices
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-kernel@vger.kernel.org
In-Reply-To: <4C265258.3080508@redhat.com>
References: <1277552682.29791.23.camel@fermat.scientia.net>
	 <4C262824.6080806@redhat.com>
	 <1277570658.3245.71.camel@fermat.scientia.net>
	 <4C265258.3080508@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Jun 2010 01:10:16 +0200
Message-ID: <1277593816.3239.78.camel@fermat.scientia.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-26 at 21:17 +0200, Milan Broz wrote:
> IIRC barriers are fully supported for DM devices since 2.6.31
thx.

> but every fs must properly flush IO on umount or remount RO
> (using whatever method is possible).
But... shouldn't literally every filesystem do that? At least all the
ones that are used as rootfs (ext234,btrfs,reiser34,xfs,jfs,... I guess)


> Just that every command run will issue some reads when it need to load
> libraries etc.
But that shouldn't harm, if you just remount,ro and as long as all
different block layers (dm-crypt/lvm2/md/etc) are still there,.. which
is as far as I understood you definitely the case,.. as one cannot
remove them as long as something above uses them.


> See http://citp.princeton.edu/memory/
thx =)


> (just FYI: luksSuspend is simple wrapper for dm-crypt wipe key functionality;
> it was written to provide tool to safely wipe all dm-crypt encryption keys
> in memory without need to close device, it is de-initialising cryptoAPI
> modules etc.
Then why can't one do this at the dm-crypt device which has root-fs on
top? If the data flushing is secure as you've said before,... we should
be fine...
Oh... wait... if the key was gone we could not call halt / reboot
anymore, right?


> It was intended to provide something which can help "suspend to RAM" to be
> at least partially immune to cold boot attack on RAM-suspended laptop.)
I've always thought suspend-to-RAM would be generally insecure with full
disk encryption,... and only suspend-to-disk could be made secure (with
encrypted swap)?!


> > I guess non-root devices should be cleanly closed, with luksClose, or
> > not?
> yes. But for security reasons there still should be some fallback if it
> fails - so at least key is properly wiped if all other attempts to unmout fails.
So you mean,... if non-root devices are shut down,.. but the umount
doesn't (still blocking or so)... then we should still clear the keys?
Wouldn't that lead to data corruption?


> That will solve only one problem. Then you will have some some device which
> need ioctl to wipe its state (including possible sensitive data in
> its buffers) etc. It is just an example, hack to wipe memory on reboot is
> not proper solution.
But we don't do all this right now either, right?

> I think this should be solved systematically - clean shutdown should keep
> machine in safe state.
Would be great....


> It is always amusing these discussions which super-hyper encryption mode
> to use and then we are not able to properly shutdown it, keeping the root-fs
> encryption key in memory.
> Seriously, this is problem and must be solved if we are serious with
> full disk encryption.
It's especially interesting,.. as with modern checksummed filesystems
fully encrypted systems should also provide some level of
integrity/authenticity... as it's like a MAC.


> > And it's quite complex I guess,... given the fact that there are
> > basically arbitrary ways to stack your block devices...
> It is exactly the same complexity like in initramfs, just steps are reversed.
Yes...


> But I think that solution which 1) flush page cache 2) remount read-only
> and 3) wipe all encryption keys for remaining devices is enough.
What about the "some device which need ioctl to wipe its state
(including possible sensitive data in its buffers)" ?
After step (3) we won't be anymore able to invoke the init-scripts which
came after "unmountroot" and e.g. reboot/hald, would we?


> > Right now when I shutdown,... I get errors for lvm/dm-crypt/md,... as
> > they all can't close there devices,... as the root-fs is just ro-mounted
> > (ok the Debian cryptsetup package seems to not display that error,.. but
> > it's probably there).
> 
> cryptsetup should print error when device is busy on luksClose,
> report it to upstream (currently probably me) if not:-)
> (It prints "Device <dev> is busy." in that situtation and fails.)
> 
> Anyway, I am sure that other distro maintainers must solved similar problem...
For Debian I was planing to organise some round table bringing all the
related maintainers (lvm2, cryptsetup, mdadm, perhaps even initscripts
because of the shutdown stuff together).

Less for that security related problem,... but more for the question,
how can we provide a generic way, that root/non-root devices can be
stacked,... that the initramfs is fitted with only the required tools
(which means we must build a tree starting from the fstab entry down to
the bootom... to really get any device which can have parts of root)...
that the different stuff (e.g. vgchange) is called in the right order in
it... and the same for the non-root devices,... which are mounted
outside initramfs.

And of course the same vice versa when shutting down...


Which place would you suggest for such discussions (not sure if lkml is
the right place ;) )? I mean it would be great if already people form
multiple distros (e.g. you from RedHat) would take part. I know that at
least Jonas from Debian is already following this :)
And I guess it's generally great if you take part,... as dm-crypt/lvm
developer :) you easily see if something stupid is done ;)
I mean for some parts of the whole picture I have already some ideas how
things should work,.. but I guess I have far to less technical knowledge
(as you see from my questions ;) ) to do this (alone).


Best wishes,
Chris.

