Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0FZLvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 07:51:52 -0400
Received: from mailgw01.dd24.net ([193.46.215.41]:48633 "EHLO
	mailgw01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab0FZLvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 07:51:51 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jun 2010 07:51:50 EDT
Subject: how to (really) cleanly shutdown the system when root is on
 multiple stacked block devices
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Jun 2010 13:44:42 +0200
Message-ID: <1277552682.29791.23.camel@fermat.scientia.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.


I'm currently investigating in Debian's boot process with the goal to
allow having the root-fs on perhaps even multiple stacked block devices
(e.g. something like disk->md/raid->lvm2->dm-crypt->fs or
disk->md/raid->dm-crypt->lvm2->fs).

For booting this works in principle quite fine via initramfs images
(although it's currently yet very configurable and has a quite fixed
order of the block devices)..

I stumbled however across a problem for the shutdown/reboot:
What Debian does about is the following (via sysvinit 0 or 6):
1. cryptdisks stop
2. lvm2 stop
3. umountroot
4. halt/reboot

That 1 and 2 are before 3 is (I guess) because they simply don't expect
root-fs to be on the stacked block devices, and want to cleanly close
everything else, before umounting the root-fs

Step 3 is actually a remount,ro of / ... followed by the halt/reboot...
and I guess there is no other way to do this (e.g. doing a real umount).


I guess it's quite obvious, that if the root-fs is e.g. on top of lvm
and/or dm-crypt,... closing of some LV/VG/dm-crypt-devices will fail
(which is what I see and why I wrote here).


Now my question:
Is it strictly guaranteed, that when the mount -o remount,ro / in
umountroot returns,... everything that the filesystem flushed out,...
has already went down throught all the different block layers to the
disk?

I could imagine that future block layers to some caching, or that
encryption at dm-crypt takes some CPU time,... so if the mount would
return before everything gone through all layers,... the halt/reboot
would come "immediately" next... and the date would be gone without
being cleanly flushed.

Now I guess with a filesystem having barriers... it's secure, right? But
what about filesystem not having them?


So I think in the end my question is:
Is it by design secured, that I do _NOT_ cleanly disable any (possible
stacked block layers like lvm/md/dm-crypt/etc), when halting/rebooting
the system and when I do an remount,ro in the end.



Thanks,
Chris.

