Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab1BWBxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:53:31 -0500
Received: from smtp-out.google.com ([74.125.121.67]:45933 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab1BWBx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:53:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=J3cfbo04xlFpksBk2XOJ10v8CUP3VKi+nbyj0utPAwZR6Dl3LRTCHSdN/+qcyDukK
	PxstPzrooeAWlbH0fyJHA==
Subject: [PATCH v2 0/5] Exporting DMI entries via sysfs
To: Greg KH <greg@kroah.com>, Olof Johansson <olofj@chromium.org>,
        Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Robert Lippert <rlippert@google.com>
From: Mike Waychison <mikew@google.com>
Cc: Jon Mayer <jonmayer@google.com>, Tony Luck <tony.luck@intel.com>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>,
        David Hendrix <dhendrix@chromium.org>, linux-api@vger.kernel.org
Date: Tue, 22 Feb 2011 17:53:07 -0800
Message-ID: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset applies to v2.6.38-rc6.

The following series exports information the DMI / SMBIOS tables via
sysfs under the path /sys/firmware/dmi.

For our purposes, we actively use the System Event Log, as described by
DMI entry Type 15.  Currently, we have to grub around /dev/mem to find
this thing, and potentially need to issue IOs directly from userland to
get at the event log, which is suboptimal in terms of security and
architecture.

This series implements the basics needed to iterate through the DMI
entries safely from userland.  Each entry has the handle, the formatted
length and the raw bytes exposed in their own sub-directory under
/sys/firmware/dmi/entries/<type>-<instance>.

As well, this series explodes type 15 as a proof-of-concept of how we
can expose kernel interpretations of the entry data.  For most entries,
there isn't much sense in parsing the entry and exposing each field
as a sysfs attribute as they can be interpreted from userland by
accessing the raw entry itself.  Type 15 however describes an
indirection (pointing at the system event log), and it is generally
useful to export this log in raw form to the user (which requires
interpreting the DMI entry).

This driver relies solely on dmi_walk() for access to the dmi entries.
They are not kept mapped in the "rest" state.  The only bits memo-ized
by the objects in sysfs are the dmi headers, which are used to the find
the entries via dmi_walk on read.   Reading the raw bytes however is
'uncached' by this driver, so that any changes to the entries themselves
are reflected properly by the user-exposed interface.

We intend to use this on our production servers, though it seems to
also be sufficient in suiting Chrome OS's needs
(http://code.google.com/p/chromium-os/issues/detail?id=6795).

Thanks,

Mike Waychison

Related discussions
===================

   - Andi Kleen suggesting that perhaps this data could be exported via
     sysfs:

http://kerneltrap.org/mailarchive/linux-kernel/2010/9/28/4625643/thread

   - Tim Hockin suggesting a potential layout:

https://lkml.org/lkml/2011/2/10/550


Patchset summary
================

firmware: Add DMI entry types to the headers
firmware: Basic dmi-sysfs support
firmware: Break out system_event_log in dmi-sysfs
firmware: Expose DMI type 15 System Event Log
firmware: Add documentation for /sys/firmware/dmi

Diffstat
========

 Documentation/ABI/testing/sysfs-firmware-dmi |  110 ++++
 drivers/firmware/Kconfig                     |   11 
 drivers/firmware/Makefile                    |    1 
 drivers/firmware/dmi-sysfs.c                 |  698 +++++++++++++++++++++++++++
 include/linux/dmi.h                          |   47 +
 5 files changed, 867 insertions(+)

Changelog:
==========
- v2
   - Added 'type', 'instance' and 'position' attributes to each DMI entry.
   - Don't printk KERN_INFO on module load/unload.
   - Default to 'n' for Kconfig.
   - Grammar fixes.
   - Fixed bug reading raw files when multiple instances of the same
     type exist.
- v1
   - Initial public send-out.
