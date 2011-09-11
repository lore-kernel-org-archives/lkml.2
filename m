Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab1IKQxX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 12:53:23 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37615 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab1IKQxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 12:53:22 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
Subject: Re: graceful handling of removing a plugable storage device that is being written to
Date: Sun, 11 Sep 2011 18:53:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <1315751507.52552.YahooMailClassic@web29517.mail.ird.yahoo.com> (sfid-20110911_183202_857806_256156E9)
In-Reply-To: <1315751507.52552.YahooMailClassic@web29517.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201109111853.20530.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 11. September 2011 schrieb Hin-Tak Leung:
> --- On Sun, 11/9/11, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Cc to BTRFS mailinglist as it
> > triggered the idea of mine again.
> > 
> > 
> > Hi!
> > 
> > Today I did it again and removed a BTRFS partition that is
> > written too.
> > That BTRFS as of Kernel 3.0.3 (debian package) does not
> > like very much. I
> > think thats a known issue and I wrote a mail to BTRFS
> > mailing list about
> > it.
> > 
> > In there I wrote:
> > > Expected results:
> > > 
> > > BTRFS fails gracefully except the loss of data from
> > 
> > writes in flight, the
> > 
> > > machine remains usable and BTRFS can be mounted
> > 
> > again.
> > 
> > And then cause the expected results IMHO are by no way the
> > 
> > ideal results:
> > > Ideal results (IMHO):
> > > 
> > > Linux behaved like AmigaOS and told me that I *must*
> > 
> > insert the device
> > 
> > > again and *continues* writing after I did this.
> > 
> > But I never saw any other OS that did that.
> > 
> > And I see the problems with high bandwidth writes piling up
> > in memory
> > causing severe memory pressure.
> > 
> > But then could Linux just freeze processes that continue
> > writing to the
> > drive until it is replugged again? Of course that
> > shouldn´t happen to the
> > drive / resides on.
> > 
> > And there is a userspace part in it - the possibly udev and
> > dbus  driven
> > notification to the user.
> 
> How do you cope with
> (1) headless systems (one where there is no udev/dbus notification or
> display). (2) the user walking off in a hurry and never seeing the
> notification? Should the kernel/user processes freeze indefinitely?
> 
> There is also a 3rd scenario - how how one malicious person or process
> doing a repeat insert/remove/write and get resource to pile up and
> crash the machine?
> 
> It is probably possible/recommended with Amiga because Amiga is
> seldomly run headless?

This all are important and valid questions, IMHO. Still I think the 
approach taken by AmigaOS has some merit here.

(1) headless systems:

a) servers usually do not have much to do with removable media. But still, 
what about FC or iSCSI LUNs? What should the kernel do here? Frankly, I 
don´t know. Maybe its best to default to current behavior which imposes a 
risk for data loss. But then NFS is used in enterprise environments, too, 
and it does block by default. Indefinetely. I have seen loads of 300 and 
more cause of that behavior which is there to *prevent* data loss on NFS 
clients.

b) headless media systems: maybe its best to have to default to current 
behavior, when its known that a notification can´t be done. But how to 
tell? Maybe best would be a timeout. Then the user even would have a 
chance to reinsert the media.

(2) I thought about how long to wait / possibly freeze processes as well: 
Maybe it would be good to let go after a while. But I think that also 
depends on whether more writes are done. If its an USB stick and the user 
just copied some files to it and removed it prematurely without noticing 
the notification, then I think the kernel could wait indefinetely.

*But* and this brings up a serious issue, I did not think about before: 
When the user mounts the USB stick somewhere else and finds out about the 
missing files only by then, there is a real risk for data loss, if the 
kernel of the machine that stalled the I/O insists on completing the 
writes if the user inserts the USB stick again.

Thus it seems to me that the kernel would have to check the last mount 
time and the filesystem state. If the last mount time is newer and/or the 
filesystem is cleanly unmounted, I think the kernel must refuse any further 
attempts to complete outstanding writes in order to protect filesystem 
integrity.

Frankly, I never tried this on AmigaOS. I know that AmigaOS expects the 
exact same floppy disk to be inserted again. Only the same name isn´t 
enough. But I have no idea, what AmigaOS would have done, when I inserted 
the disk into another Amiga, did something there and then insert it into 
the Amiga with the notification and pressed "okay". Probably it would have 
eaten the disk then.

This is a serious issue which makes implementing my suggestion more 
difficult. The kernel has to make sure not to eat a filesystem in order to 
complete outstanding writes!

(3) I wouldn´t worry too much about malicious persons. Why? Cause with 
current standard ulimit values there are way easier methods to stall a 
machine to a halt. I have seen more than once during holding Linux 
performance tuning courses, that running the command "stress" with 
aggressive parameters effectively offlines a Linux machine. I often do a 
check list on how often course participants make one of the Linux servers 
we work so unresponsive that a reboot is in order. So I think graceful 
handling of media removal doesn´t add much to the existing issues 
regarding that topic.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
