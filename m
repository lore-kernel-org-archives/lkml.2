Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab0FOOwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:52:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38556 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab0FOOwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:52:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z5r+dP96+SprDw6aOe8o5dE0xEf+ywrASnhDZHZjGqioS0FGEz0svPFODct4Dm+VDK
         8lyLsZLEHQT1kkEZp0CW5+xOfSyB3b9MWovSwzOP5iciwVkkrpSnD003T3LjAAaLcqgk
         xGftgkcbm3+DbEpXJZfs0NfLz2rVCaHGNh3Y4=
MIME-Version: 1.0
In-Reply-To: <AANLkTimp4_TaQuGPlnw9ZpQCoTiTeFxtWQeZgfsdUBnK@mail.gmail.com>
References: <AANLkTimnqVSom2qHetXMBPiCNTYd-yc8Tl6a64n0zTSk@mail.gmail.com>
	<20100614162002.GA13902@kroah.com>
	<AANLkTinwaYy5Z528PraVuWUsU2pJBLoq0c2hgIGirTNn@mail.gmail.com>
	<4C16BFF5.7070308@gmail.com>
	<AANLkTimp4_TaQuGPlnw9ZpQCoTiTeFxtWQeZgfsdUBnK@mail.gmail.com>
Date: Tue, 15 Jun 2010 08:52:44 -0600
Message-ID: <AANLkTimOvFsGZU6Brd-VjzBQGCoP7pgM1rO0wLrZjZZW@mail.gmail.com>
Subject: Re: e-SATA ExpressCard - OOPS plus incrementing "ataX" on 
	Linux-2.6.xx
From: Robert Hancock <hancockrwd@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Jeff Garzik <jgarzik@redhat.com>, Greg KH <greg@kroah.com>,
       kristen.c.accardi@intel.com, Dely Sy <dely.l.sy@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Wilcox <willy@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 6:08 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Tue, Jun 15, 2010 at 7:49 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
>
>> The ataX number incrementing is normal (it always increments when an ATA
>> host is initialized, it doesn't appear the numbers get reused). The other
>> messages are the expected result when you surprise-remove the card. I think
>> there should be a way to trigger the hotplug code to disable the device
>> before you eject it, but I'm not sure what that is supposed to be - maybe
>> echo 1 to /sys/device/pci_somethingorother/remove ?
>
> Robert,
>
> Thanks for the pointer. I found this "remove" is in
> /sys/bus/pci/devices/0000:05:00.0/remove
>
> # echo 1 >/sys/bus/pci/devices/0000:05:00.0/remove
>
> ata14.00: disabled
> sd 17:0:0:0: [sdb] Synchronizing SCSI cache
> sd 17:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
> sd 17:0:0:0: [sdb] Stopping disk
> sd 17:0:0:0: [sdb] START_STOP FAILED
> sd 17:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
> ahci 0000:05:00.0: PCI INT A disabled
>
>
> It's getter better. Next is to really shutdown the "sdb" hard disk. Is
> that possible? Would be nice to make the "sd 17:0:0:0: [sdb]
> START_STOP FAILED" go away gracefully. Any command to do that?

Try echoing 1 to the file for the SCSI disk's "delete" file, something
like: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/delete

>
>
> On Tue, Jun 15, 2010 at 9:26 AM, Jeff Garzik <jeff@garzik.org> wrote:
>
>> The incrementing of ataX is unrelated to anything else...  Each "new" ata interface gets a new id.
>
> Jeff,
>
> With the "remove" command working, it'll be nice to make "ahci"
> _reuse_ the interface now that it's removed cleanly. I'm just afaid
> that each time the card is removed and reinserted, the ataXX interface
> kept incrementing and will eventually does harm to the kernel?

I don't think so, it's just a number used to associate debug output
for the device. I suppose if you did it 2 billion times it might wrap
negative but even that would just be cosmetic..

>
>
>> "failed to stop engine" is where the driver is attempting to talk to the card, and gracefully shut things down.  > If the card does not exist (ie. has been removed/ejected), then this is normal behavior.
>
> Ok, that's fixed with "echo 1 >/sys/bus/pci/devices/0000:05:00.0/remove".
>
>
>
> Thanks,
> Jeff
>
