Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab2JTUok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 16:44:40 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48948 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2JTUoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 16:44:39 -0400
Message-ID: <50830D33.5050807@ursulin.net>
Date: Sat, 20 Oct 2012 21:44:35 +0100
From: Tvrtko Ursulin <tvrtko@ursulin.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: dm-crypt@saout.de
CC: linux-kernel@vger.kernel.org
Subject: cryptsetup not working under 3.6  - regression from 3.4?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I can't open my LUKS formatted crypto files in 3.6 any more while 3.4 
works fine.

Error is:

# cryptsetup --key-file=- luksOpen /luks.file target
Enter passphrase:
device-mapper: reload ioctl on  failed: No such file or directory
Failed to setup dm-crypt key mapping for device /dev/loop0.
Check that kernel supports aes-cbc-essiv:sha256 cipher (check syslog for 
more info).
Failed to read from key storage.

I don't think kernel misses any modules because:

a) I built 3.6 from 3.4 config via make oldconfig, and,
b) I checked what crypto modules get loaded under 3.4 and loaded them 
under 3.6 before attempting to run cryptsetup. Those are:

Module                  Size  Used by
sha256_generic         10207  0
cryptd                  8665  0
aes_x86_64              7614  0
aes_generic            26764  1 aes_x86_64

I am not sure module auto-loading for crypto works under 3.6 because if 
I just run the cryptsetup command none of the above gets loaded.

But I repeat, even if I load the required modules before hand things do 
not work.

Kernel says this:
  device-mapper: table: 252:1: crypt: Error allocating crypto tfm
  device-mapper: ioctl: error adding target to table

And strace on cryptsetup says there DM ioctls are issued:
  ioctl(3, DM_VERSION, 0x1d65db0) = 0
  ioctl(3, DM_LIST_VERSIONS, 0x1d65d20) = 0
  ioctl(3, DM_TABLE_STATUS, 0x1d66730) = -1 ENXIO (No such device or 
address)
  ioctl(3, DM_DEV_CREATE, 0x1d78290) = 0
  ioctl(3, DM_TABLE_LOAD, 0x1d78290) = -1 ENOENT (No such file or directory)
  ioctl(3, DM_DEV_REMOVE, 0x1d781d0) = 0

Perhaps I am missing something obvious?

Thanks,

Tvrtko
