Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab1ESNf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:35:28 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41133 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab1ESNf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:35:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:sender:from:date:x-google-sender-auth
         :message-id:subject:to:cc:content-type:content-transfer-encoding;
        b=iUBlX53T6sK2t8hvnYT9uzLZRoatZngz46OVCPSk6WpYdJI87uC63QCpa6LbZeoAbJ
         Iuc0k/aApRy90eAzdjpF63dtJfiFyKcj4buc2PcAPTYsK7Wnc2I/gq2E3uUx+TJC9C8d
         HE04IWVsN8cLo3VcG7A507pTQzA/a9PC05/h8=
MIME-Version: 1.0
Reply-To: d.g.jansen@googlemail.com
From: Dennis Jansen <Dennis.Jansen@web.de>
Date: Thu, 19 May 2011 15:34:46 +0200
X-Google-Sender-Auth: 3nqhf5lC4214Ho4U_fjFw-hfhN0
Message-ID: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
Subject: [rfc] Ignore Fsync Calls in Laptop_Mode
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tytso@mit.edu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my first proper kernel code proposal so please bear with me!

=Summary for busy kernel hackers=
Problem: laptop_mode wants to keep applications from waking the hard
disks but fsync calls can "sneak through". (IMHO this is a bug.)

Proposed solution: Pretend the fsync was executed and successful.
Insert two lines into the fsync and fdatasync calls in fs/sync.c:
if (unlikely(laptop_mode))
   return 0;

=More background information and flamewar suggestions below=

What is Laptop_Mode?
Laptop_Mode is a feature that saves power by forced buffering of hard
disk writes in memory. It flushes the data out to disk only e.g. every
15 minutes, means it can be off most of the time. Check this for
Andrew's intro: http://lwn.net/Articles/1652/. It is disabled by
default in most distributions afaik, e.g.
http://samwel.tk/laptop_mode/packages/ubuntu.

The Problem: Any time an application uses fsync, the hard disk wakes
up despite laptop_mode being active. This not only causes higher
energy consumption than necessary (either because laptop_mode can't be
used or because of constat hd spin ups), it also damages hard disks,
as they are created to last only a certain amount of head load cycles.
See https://ata.wiki.kernel.org/index.php/Known_issues#Drives_which_perform_frequent_head_unloads_under_Linux
for details. Applications that use fsync include LibreOffice, Firefox
3 (used to a lot), Syslog
(https://www-304.ibm.com/support/docview.wss?uid=swg21255028) and e.g.
anything which uses sqlite in synchronious mode
(http://www.sqlite.org/speed.html).

The Fix was already suggested by tytso here, but not followed up:
http://tytso.livejournal.com/2009/03/15/

Existing Workarounds:
 - Libraries: Severeal libraries exist which you can use with
LD_PRELOAD to disable fsync for certain applications.
 - Applications: You could disable fsync in the applications.

Why are they not enough?
 - Lib raries: Libraries don't allow a switch to comfortably enable
and disable fsync. You always miss a program. It's a hassle.
 - Applications: Disabling the fsync call may not make sense in the
libraries. One good example is Office Software. Normally, I do want it
to fsync the file after saving. But on battery I prefer the data to be
left in memory. So fixing LibreOffice would not make a lot of sense.
Not saving there would also not be ideal: If it crashes, I would end
up with nothing. If I keep autosave active, I will at least be save
from the software crashing.
The big advantige of this proposal is not only that laptop_mode will
work as advertized and prevent all automatic spin ups to write data.
("sync" on the command line still works.), but also that this behavior
is already implemented in many distributions via laptop-mode to switch
depending on battery/AC status.

Side effects:
This would make laptop_mode a great way to cheat benchmarks that rely
on fsync for their timing, (to ensure data is actually written to disk
before the timer ends). People who don't care so much about data
safety can gain some disk speed with one switch. Crashing applications
are _not_ affected. Their data is written to memory, just not flushed
to disk.

"But this means work will be lost"
This is a complaint against this solution made e.g. here in the second
part. http://lwn.net/Articles/323780/
Yes, this is true. But Laptop_Mode makes that very, very clear. The
configuration file actually calls the setting
"LM_BATT_MAX_LOST_WORK_SECONDS". Also laptop_mode decreases and then
disables itself when the battery runs down. And finally, I don't know
distributions that enable it out of the box. If a user does enable
laptop_mode without reading anything at all about what it means, I
don't think he should be protected. If a distribution uses it by
default, it should warn users about possible consequences.
In short: That it makes laptop_mode work as advertised IHO is no valid
point against this solution. And if, we could consider a sending a
printk the first time an fsync is skipped.

"This is not necessary with SSDs"
I'm not sure, but I think that SSDs will also keep an active SATA
connection if you write to them all the time. They also have standby
modes which also save power. But yes, this make not or hardly make
sense with them. But as long as you don't send me one, I still like a
fix. Also, this might extend SSD lifetime as this reduces the total
times a sector is written.

Testing:
I've been using this workaround on my netbook for over six months now.
It works as expected for me with all software in a Ubuntu 9.10
environment and saves me at least 0.5 Watt or roughly 10 % battery
time - without destroying my hard disk. I have seen no negative side
effects.

What I didn't test:
I didn't test this on different platforms and environments. But as
it's generic code I expect no different behavior. I didn't benchmark
how this might affect performance due to the additional if() check for
every fsync call. But as the fsync is rather expensive and not used
*that* much, I think it should have not noticeable impact.

Implementation Ideas:
If this patch does turn out to affect some scenarios negatively, a
switch would be necessary. Laptop_Mode is in proc, but we don't want
more files in there. In any case, a configuration on a by device level
would make sense (e.g. no fsync on sda when laptop_mode active). That
would fit nicely into sys and allow to disable fsync only for the hard
disk, but not for the SSD or usb stick if both are present. But let's
try not to blow this up too much.

Where's the Trojan Horse?
Laptop_Mode was the trojan horse, this is a soldier.
There's no need. This already is "_obviously_ good at first sight". ;-)

Great Flame Topics (please add [flame] to the subject for better overview!):
 - User Space vs. Kernel Space Fixes
 - Is this obsoleted by SSDs
 - Is this a bug or a feature

Thanks for your feedback! Thanks for the feedback at LinuxTag Kernel
Kwestioning.
