Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1JOSEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 14:04:44 -0400
Received: from eterpe-smout.broadpark.no ([80.202.8.16]:36826 "EHLO
	eterpe-smout.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1JOSEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 14:04:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Message-id: <4E99CB18.2080302@bakke.com>
Date: Sat, 15 Oct 2011 20:04:08 +0200
From: DagB <dag@bakke.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20111005
 Lightning/1.0b3pre Thunderbird/3.1.12
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] Device node major comes out wrong on HFS+ under linux
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Executive summary:

/dev/null:
osx:	crw-rw-rw- 1 root wheel 1, 3 Oct 13 04:12 null	
linux:	crw-rw-rw- 1 root root 16, 3 Oct 13 02:12 /dev/null

/dev/console:
osx:	crw------- 1 root wheel 5, 1 Oct 13 04:12 console
linux:	crw------- 1 root root 80, 1 Oct 13 02:12 /dev/console

/dev/sda4:
osx:	brw-r----- 1 root wheel  8, 4 Oct 13 04:12 sda4
linux:	brw-r----- 1 root root 128, 4 Oct 13 02:12 /dev/sda4




Details:

I am slowly figuring out how to boot linux on my shiny new macbook air.

The actual *booting* bit turns out to be incredibly easy with rEFIt,
keithp's macbook air tree, and mfleming's efi stub tree. (3.1.0-ish)
Just pop a suitable kernel somewhere rEFIt can see it, and off you go.
No mucking with bootloaders or repartitioning with esoteric tools and
options. Slick. Got to use a built-in kernel command line, though.

Shrinking the existing OSX HFS+ partition and adding another for a linux
root fs from within OSX also turned out to be a breeze.

I decided to give HFS+ a go for the root fs, just for a POC.
(I'll make an initramfs for making a sane fs. Would be cooler to do
everything from within OSX, and just reboot straight into Linux.)

Untarring a root fs on a my new HFS+ filesystem was straightforward. I
*do* get a warning from OSX' tar when creating the devicenodes, but the
nodes are created with the correct perms and major/minor.

tar: qtn_file_apply_to_path(./dev/console): Operation not permitted
results in (when viewed from OSX):

crw-------  1 root  wheel    5,   1 Oct 13 04:12 dev/console
which nicely reflects what the source filesystem has.


Booting a linux kernel (with init=/bin/sh) results in:
crw------- 1 root wheel	80, 1	Oct 13 02:12 /dev/console

Clearly a Major bug.  ("ka-pisch".....)



Looks like an endianness issue at hand here:
1 p
1
16 p
10000


5 p
101
80 p
1010000


8 p
1000
128 p
10000000


Good thing I didn't end up trying to dial out through my HDD....


Anyone care to squash this bug, please?

Dag B
