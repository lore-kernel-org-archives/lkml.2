Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab1DQVyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 17:54:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47744 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab1DQVyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 17:54:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ginkel.com; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-type:content-transfer-encoding;
        b=qGGoJD9TFFjintPGL8VLmkK/SsnmeHIffCR+tm9dgWaWfFOMrIjlRIlIIPTNPTZ57e
         DbWc/Q3tWD3DL5ThzaytwjpoF4aSefW17k5pGwIyvXBtjiyGM87B4FGOu9c9U6trel8y
         qsOUDtfaBAw2PvVJy1ENbbSIgqO+U7NEC75z4=
MIME-Version: 1.0
X-Originating-IP: [91.17.187.68]
In-Reply-To: <201104172135.40189.arnd@arndb.de>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
 <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com> <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
 <201104172135.40189.arnd@arndb.de>
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Sun, 17 Apr 2011 23:53:42 +0200
Message-ID: <BANLkTimS2DqZTjq3Kx-p8CfZ5iFra_M2DA@mail.gmail.com>
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 21:35, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 14 April 2011, Thilo-Alexander Ginkel wrote:
>> All right... I verified all my bisect tests and actually found yet
>> another bug. After correcting that one (and verifying the correctness
>> of the other tests), git bisect actually came up with a commit, which
>> makes some more sense:
>>
>> | e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c is the first bad commit
>> | commit e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c
>> | Author: Tejun Heo <tj@kernel.org>
>> | Date:   Tue Jun 29 10:07:14 2010 +0200
>> |
>> |     workqueue: implement concurrency managed dynamic worker pool
>
> Is it possible to make it work by reverting this patch in 2.6.38?

Unfortunately, that's not that easy to test as the reverted patch does
not apply cleanly against 2.6.38 (23 failed hunks) and I am not sure
whether I want to revert it manually ;-).

>> The good news is that I am able to reproduce the issue within a KVM
>> virtual machine, so I am able to test for the soft lockup (which
>> somewhat looks like a race condition during worker / CPU shutdown) in
>> a mostly automated fashion. Unfortunately, that also means that this
>> issue is all but hardware specific, i.e., it most probably affects all
>> SMP systems (with a varying probability depending on the number of
>> CPUs).
>>
>> Adding some further details about my configuration (which I replicated
>> in the VM):
>> - lvm running on top of
>> - dmcrypt (luks) running on top of
>> - md raid1
>>
>> If anyone is interested in getting hold of this VM for further tests,
>> let me know and I'll try to figure out how to get it (2*8 GB, barely
>> compressible due to dmcrypt) to its recipient.
>
> Adding dm-devel to Cc, in case the problem is somewhere in there.

In the meantime I also figured out that 2.6.39-rc3 seems to fix the
issue (there have been some work queue changes, so this is somewhat
sensible) and that raid1 seems to be sufficient to trigger the issue.
Now one could try to figure out what actually fixed it, but if that
means another bisect series I am not too keen to perform that
exercise. ;-) If someone else feels inclined to do so, my test
environment is available for download, though:
  https://secure.tgbyte.de/dropbox/lockup-test.tar.bz2 (~ 700 MB)

Boot using:
  kvm -hda LockupTestRaid-1.qcow2 -hdb LockupTestRaid-2.qcow2 -smp 8
-m 1024 -curses

To run the test, log in as root / test and run:
  /root/suspend-test

Regards,
Thilo
