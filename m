Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab2DNWaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 18:30:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63507 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab2DNWaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 18:30:18 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxToKG2gMqHnUgjkGTr--X4FK9yzX7n0yc9xKuUGGRKmA@mail.gmail.com>
References: <CA+55aFxToKG2gMqHnUgjkGTr--X4FK9yzX7n0yc9xKuUGGRKmA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 15:29:56 -0700
X-Google-Sender-Auth: OwKgXrLHZzgAiCy22rGu2iGb0mc
Message-ID: <CA+55aFyq7fp2nDGJBT+9oPTBU+uCWpp_2JBfGB3HxBSwA=5TBw@mail.gmail.com>
Subject: Re: USB storage SCSI EH oops
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <JBottomley@parallels.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 3:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I've added to the participants list the relevant parties, but I really
> think the bug was introduced in commit 18a4d0a22ed6 ("[SCSI] Handle
> disk devices which can not process medium access commands") which is
> new since 3.3. That's the thing that added that whole
> "scsi_cmd_to_driver()" call to the error path, and I suspect that the
> problem is that it's simply not appropriate at that level. Presumably
> the whole "rq_disk" thing is only set up much later, after the disk
> has actually been recognized.

Confirmed.

I tested twice: with that patch, the oops is repeatable, and happens
something like 30 seconds after plugging in the USB thing into the
monitor.

With that patch reverted, the thing still doesn't *work*, but I don't
get the oops. Instead, I get the appended noise in my dmesg..

The oops seems to happen immediately after it does the first "reset
high-speed USB device".

I am currently planning on just reverting that commit, unless somebody
sends me a fix asap.

                       Linus

---
[   37.801911] usb 2-1.4: new high-speed USB device number 5 using ehci_hcd
[   37.894129] usb 2-1.4: New USB device found, idVendor=0424, idProduct=2502
[   37.894135] usb 2-1.4: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[   37.894394] hub 2-1.4:1.0: USB hub found
[   37.894592] hub 2-1.4:1.0: 2 ports detected
[   38.165342] usb 2-1.4.1: new high-speed USB device number 6 using ehci_hcd
[   38.257582] usb 2-1.4.1: New USB device found, idVendor=0424, idProduct=2602
[   38.257588] usb 2-1.4.1: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[   38.257834] hub 2-1.4.1:1.0: USB hub found
[   38.258027] hub 2-1.4.1:1.0: 4 ports detected
[   38.528797] usb 2-1.4.1.1: new high-speed USB device number 7 using ehci_hcd
[   38.707359] usb 2-1.4.1.1: New USB device found, idVendor=0424,
idProduct=2228
[   38.707365] usb 2-1.4.1.1: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
[   38.707370] usb 2-1.4.1.1: Product: Flash Card Reader
[   38.707373] usb 2-1.4.1.1: Manufacturer: Generic
[   38.707376] usb 2-1.4.1.1: SerialNumber: 26020128B005
[   38.707684] scsi9 : usb-storage 2-1.4.1.1:1.0
[   39.712828] scsi 9:0:0:0: Direct-Access     Generic  Flash HS-CF
  4.44 PQ: 0 ANSI: 0
[   39.712976] sd 9:0:0:0: Attached scsi generic sg2 type 0
[   39.719767] scsi 9:0:0:1: Direct-Access     Generic  Flash HS-COMBO
  4.44 PQ: 0 ANSI: 0
[   39.719855] sd 9:0:0:1: Attached scsi generic sg3 type 0
[   69.989207] usb 2-1.4.1.1: reset high-speed USB device number 7
using ehci_hcd
[   80.181679] usb 2-1.4.1.1: reset high-speed USB device number 7
using ehci_hcd
[   96.369007] usb 2-1.4.1.1: reset high-speed USB device number 7
using ehci_hcd
[   96.580731] usb 2-1.4.1.1: reset high-speed USB device number 7
using ehci_hcd
[  106.773182] usb 2-1.4.1.1: reset high-speed USB device number 7
using ehci_hcd
[  106.911994] sd 9:0:0:1: Device offlined - not ready after error recovery
[  106.912020] sd 9:0:0:1: rejecting I/O to offline device
[  106.912028] sd 9:0:0:1: rejecting I/O to offline device
[  106.912031] sd 9:0:0:1: rejecting I/O to offline device
[  106.912034] sd 9:0:0:1: [sdc] READ CAPACITY failed
[  106.912035] sd 9:0:0:1: [sdc]  Result: hostbyte=0x01 driverbyte=0x00
[  106.912037] sd 9:0:0:1: [sdc] Sense not available.
[  106.912041] sd 9:0:0:1: rejecting I/O to offline device
[  106.912044] sd 9:0:0:1: [sdc] Write Protect is off
[  106.912045] sd 9:0:0:1: [sdc] Mode Sense: 00 00 00 00
[  106.912047] sd 9:0:0:1: rejecting I/O to offline device
[  106.912050] sd 9:0:0:1: [sdc] Asking for cache data failed
[  106.912051] sd 9:0:0:1: [sdc] Assuming drive cache: write through
[  106.912800] sd 9:0:0:1: [sdc] Attached SCSI removable disk
[  106.922403] sd 9:0:0:0: [sdb] Attached SCSI removable disk
