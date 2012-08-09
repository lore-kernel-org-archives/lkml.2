Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab2HIKAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 06:00:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479Ab2HIKAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 06:00:16 -0400
Message-ID: <50238A29.3060808@redhat.com>
Date: Thu, 09 Aug 2012 12:00:09 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: tytso@mit.edu,
        "Linux Kernel Mailinlinux-ext4@vger.kernel.orgg List" 
	<linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: ext4fs error "ext4_mb_generate_buddy:741:group 16, 8160 clusters
 in bitmap, 4064 in gd" (with repro)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is how to reproduce it.  It happens during fstrim.  I found other
occurrences of the error in the mailing list, but they were not related
to trim so they may be something different.

modprobe scsi_debug dev_size_mb=256 lbpws=1
dd if=/dev/zero of=/dev/sdb bs=1M      
fdisk /dev/sdb
 >> create a new partition accepting all defaults
fdisk -lu /dev/sdb|tail -1
 >> should show: /dev/sdb1     57      524285      262114+  83  Linux

mkfs.ext4 /dev/sdb1
mkdir test
mount /dev/sdb1 test
fstrim ./test

Here is the output in dmesg:

[140934.644166] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
[140941.562060] EXT4-fs error (device sdb1): ext4_mb_generate_buddy:741: group 16, 8160 clusters in bitmap, 4064 in gd
[140941.603066] EXT4-fs error (device sdb1): ext4_mb_generate_buddy:741: group 25, 8192 clusters in bitmap, 7934 in gd
[140941.613060] EXT4-fs error (device sdb1): ext4_mb_generate_buddy:741: group 27, 8192 clusters in bitmap, 7934 in gd
[140941.634074] EXT4-fs error (device sdb1): ext4_mb_generate_buddy:741: group 31, 8192 clusters in bitmap, 8159 in gd

Hope this helps,

Paolo
