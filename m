Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1ESKQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 06:16:04 -0400
Received: from merlot.office.isoc.org.il ([192.115.211.194]:36721 "EHLO
	merlot.office.isoc.org.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab1ESKQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 06:16:02 -0400
X-Greylist: delayed 1835 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 May 2011 06:16:01 EDT
Date: Thu, 19 May 2011 12:45:24 +0300
From: Emil Natan <ena@isoc.org.il>
To: linux-kernel@vger.kernel.org
Subject: Problem: df on tmpfs not reported correctly when filesystem is full
Message-ID: <20110519094524.GA7516@isoc.org.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The problem seems to have been introduced in version linux-2.6.36 and up, it works well in 2.6.35.13. When tmpfs filesystem is full, in the output of df command the "Used", "Available" and  "Use%" the numbers are replaced with hyphens:

# df /images/1
Filesystem           1K-blocks      Used Available Use% Mounted on
tmpfs                     1024         -         -   -  /images/1

Here is how it looks with "good" and "bad" kernel and how to reproduce the issue. Please let me know if more debug information is needed in a mail cc-ied directly to me.

bad: kernel version 2.6.36.4

# ./kernels/linux-2.6.36.4/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux xxx 2.6.36.4 #1 SMP Wed May 18 16:52:45 IDT 2011 i686 GNU/Linux
 
Gnu C                  4.4.5
Gnu make               3.81
binutils               2.20.1
util-linux             2.17.2
mount                  support
module-init-tools      3.12
e2fsprogs              1.41.12
Linux C Library        2.11.2
Dynamic linker (ldd)   2.11.2
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
Sh-utils               8.5
Modules Loaded         ipmi_devintf ipmi_si ipmi_msghandler ipv6 loop hpwdt pcspkr psmouse joydev evdev serio_raw ext3 jbd mbcache sg sr_mod cdrom usbhid uhci_hcd ata_piix libata ehci_hcd hpsa scsi_mod usbcore bnx2 cciss



# mount -t tmpfs -o size=1m tmpfs /images/1
# dd if=/dev/zero of=/images/1/file bs=1k count=1017
1017+0 records in
1017+0 records out
1041408 bytes (1.0 MB) copied, 0.00164136 s, 634 MB/s

# df /images/1
Filesystem           1K-blocks      Used Available Use% Mounted on
tmpfs                     1024         -         -   -  /images/1

# > /images/1/file
# df /images/1
Filesystem           1K-blocks      Used Available Use% Mounted on
tmpfs                     1024         0      1024   0% /images/1

# dd if=/dev/zero of=/images/1/file bs=1k count=500
500+0 records in
500+0 records out
512000 bytes (512 kB) copied, 0.000784176 s, 653 MB/s

# df /images/1
Filesystem           1K-blocks      Used Available Use% Mounted on
tmpfs                     1024       508       516  50% /images/1

good: kervel version 2.6.35.13

#./linux-2.6.35.13/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux xxx 2.6.35.13 #1 SMP Wed May 18 17:07:00 IDT 2011 i686 GNU/Linux
 
Gnu C                  4.4.5
Gnu make               3.81
binutils               2.20.1
util-linux             2.17.2
mount                  support
module-init-tools      3.12
e2fsprogs              1.41.12
Linux C Library        2.11.2
Dynamic linker (ldd)   2.11.2
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
Sh-utils               8.5
Modules Loaded         ipmi_devintf ipmi_si ipmi_msghandler ipv6 loop pcspkr hpwdt psmouse serio_raw joydev evdev ext3 jbd mbcache sg sr_mod cdrom usbhid ata_piix libata hpsa uhci_hcd scsi_mod ehci_hcd usbcore bnx2 cciss


#mount -t tmpfs -o size=1m tmpfs /images/1

#dd if=/dev/zero of=/images/1/file bs=1k count=1017
dd: writing `/images/1/file': No space left on device
1017+0 records in
1016+0 records out
1040384 bytes (1.0 MB) copied, 0.00173007 s, 601 MB/s

#df /images/1
Filesystem           1K-blocks      Used Available Use% Mounted on
tmpfs                     1024      1024         0 100% /images/1


Regards,
-- 

Emil Natan
Technical Officer
Israel Internet Association (ISOC-IL)
Phone: +972 3 9700900
