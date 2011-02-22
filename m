Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1BVUjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:39:16 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43373 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab1BVUjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:39:15 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: extremely slow resume with 2.6.37
Date: Tue, 22 Feb 2011 21:39:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-tp42-rtime-00004-g9eb63ce; KDE/4.5.3; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102222139.12599.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

A moment ago I had an extremely slow resume with 2.6.37. So slow that I 
aborted it.

It was at 37% as I looked and then took a minute or more for each percent. 
I am using in kernel suspend to disk via hibernate 1.99 which uses sysfs 
power state disk.

Anyone have seen something like this? This was the first occurence, and I 
am using 2.6.37 for quite a while.

I am calling hibernate-disk from this script:

shambhala:~> cat /etc/acpi/hibernate-extra.sh 
#!/bin/sh

# Zur Sicherheit gleich am Anfang alle ausstehenden Änderungen schreiben
sync

# Versuchen, möglichst viele LowMem Pages freizubekommen
# Dir Entries legt Ext4 offenbar auch ins LowMem
# Und mit zu wenig LowMem Pages klappt der Tiefschlaf mit
# Radeon DRM KMS nicht.
echo 3 > /proc/sys/vm/drop_caches

# Network Manager schlafen legen
# siehe /usr/lib/pm-utils/sleep.d/55NetworkManager
dbus-send --print-reply --system                        \
        --dest=org.freedesktop.NetworkManager \
        /org/freedesktop/NetworkManager       \
        org.freedesktop.NetworkManager.sleep

# Systemzeit in Hardware-Uhr speichern
/etc/init.d/hwclock.sh stop

# Uptimed stoppen, damit er die Rekorde schreibt
/etc/init.d/uptimed stop

# Zur Sicherheit hier nochmal alle ausstehenden Änderungen schreiben
sync

# Gutnacht
# /etc/acpi/hibernate.sh
#echo 1 > /sys/power/tuxonice/do_hibernate
#pm-suspend-hybrid
#pm-hibernate
hibernate-disk

# Uptimed wieder starten. Dabei schreibt er erneut die Rekorde
/etc/init.d/uptimed start

# Rekorde gleich schreiben
sync

# Festplatten-Parameter wieder setzen
/etc/init.d/hdparm start

# Systemzeit anhand Hardware-Uhr wieder setzen
/etc/init.d/hwclock.sh start

# Network Manager aufwecken
dbus-send --print-reply --system                        \
        --dest=org.freedesktop.NetworkManager \
        /org/freedesktop/NetworkManager       \
        org.freedesktop.NetworkManager.wake


I am echoing 3 onto drop_caches cause often in kernel suspend - as well as 
TuxOnIce as I used it back then - was not able to free lowmem pages in 
order for the image to be allocated after I switched to radeon kms which 
seems to require quite some lowmem pages of its own, but I will post a 
different mail about this one.

I am using

shambhala:~> cat /proc/version
Linux version 2.6.37-tp42-rtime-00004-g9eb63ce (martin@shambhala) (gcc 
version 4.4.5 (Debian 4.4.5-8) ) #1 PREEMPT Thu Jan 13 10:59:19 CET 2011

which is 2.6.37 + some recursive mtime changes from Jan Kara, which should 
only affect Ext3 and Ext4.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
