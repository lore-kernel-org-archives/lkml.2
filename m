Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab1DFWRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:17:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48367 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab1DFWRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:17:20 -0400
MIME-Version: 1.0
Date: Wed, 6 Apr 2011 19:17:19 -0300
Message-ID: <BANLkTik1wb6Px+K+bBkzkt=dEMi_Xx3T3Q@mail.gmail.com>
Subject: [RFC] NFC subsystem prototype
From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
To: linux-kernel@vger.kernel.org
Cc: Aloisio Almeida <aloisio.almeida@openbossa.org>,
        Arnd Bergmann <arnd@arndb.de>, Waldemar.Rymarkiewicz@tieto.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As previously mentioned in this list, a NFC (Near Field Communication)
subsystem is required to standardize the NFC device drivers
development and create an unified userspace interface. This email
describes our NFC subsystem proposal.

The NFC protocols implementation is divided in some parts:

* The NFC subsystem in the kernel side is responsible for:
	- NFC adapters management;
	- Polling for targets;
	- Low level data exchange;

* All the commands to access the tags data (e.g. MIFARE commands:
READ, WRITE, SECTOR_SELECT) are implemented in the userspace using the
low level data exchange provided by kernel.

* The peer-to-peer NFC protocol (LLCP) will be implemented on kernel
side in order to provide a socket interface (DGRAM and STREAM) with
userspace. The LLCP will be implemented on top of the low level data
exchange provided by NFC subsystem.

+----------------------------------------------------+
|                    USER SPACE                      |
+----------------------------------------------------+
        ^                            ^
        | netlink                    |
        v                            |
+---------------+                    |
|     nlnfc     |                    | AF_NFC socket
+---------------+                    |
        ^                            |
        |                            |
        v                            v
+---------------+      +-----------------------------+
|    nfccore    | <--> | high-level-protocols (LLCP) |
+---------------+      +-----------------------------+
        ^
        |
        v
+---------------+
| Device driver |
+---------------+


In order to validate this idea, we developed a NFC subsystem prototype.
For testing purpose, we also implemented a device driver (PN533) and
an userspace test application.

The prototype implementation can be found at:
	git://186.215.206.130/linux-nfc.git

The userspace test application (list targets and read/write MIFARE
tags) can be found at:
	git://186.215.206.130/nfc-example.git

Prototype Scope:
	- Tag Reader/Writer
	- Protocols: MIFARE, ISO14443, FELICA, JEWEL

Subsystem Operations:
	- start poll - start polling for targets using the protocols given as parameter
	- stop poll - stop polling
	- activate target - activate a target for communication using a
specific protocol
	- deactivate target - deactivate a target
	- reset device - put the adapter in idle mode
	- data exchange - low level data exchange (send and receive data)

Subsystem Event:
	- targets found - report all targets found by the polling

Device Driver Interface:
The device driver interface is a direct correspondence from the NFC
subsystem interface.

User space interface:
When we were designing this subsystem, we were in doubt between
netlink (as in nl80211) and sockets (as in bluez) for userspace
communication. For this prototype, we decided to use generic netlink.

However, the netlink choice has not proven to be the best solution for
the data exchange operation. So we plan to have a new prototype
version using another solution. The options are:
	- sockets for all operations as in bluez implementation;
	- sockets for data exchange and keep netlink for the other operations.

Further work:
	- Define subsystem operations for adapters in "target mode"
	- Implement LLCP
	- Add support to the "secure elements"


Regards,

Lauro Ramos Venancio
INdT - Instituto Nokia de Tecnologia
