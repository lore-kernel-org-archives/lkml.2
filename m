Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab0DSKmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 06:42:33 -0400
Received: from ananke.wxnz.net ([58.28.4.122]:52852 "EHLO ananke.wxnz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab0DSKmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 06:42:31 -0400
X-Greylist: delayed 1323 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2010 06:42:31 EDT
From: skitching@apache.org
To: jkt@gentoo.org
To: linux-kernel@vger.kernel.org
Subject: Re: boot device order troubleshooting without an initrd
In-Reply-To: <20100418165125.1d2b2843@infradead.org>
Date: Mon, 19 Apr 2010 22:20:23 +1200
Message-Id: <1271672423.005324.28333.nullmailer@xnet.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it happens, I've been looking into this issue recently.
[Warning: kernel newbie speaking!]

Without an initrd, the options for the root= kernel parameters are only those supported in init/do_mount.c:
  1.   root=MAJOR:MINOR
  2.   root=integer   where integer is MAJOR<<n + minor
  3    root=/dev/xxx
(well, apart fron "mtd" and "ubi" options).

Unfortunately, all of these options are sensitive to hardware changes, ie device enumeration order. So I 
think that right now the answer to your question is: no, you can't get what you want without an initrd.

And I doubt that changes to the linux device-enumeration code "to be consistent with the BIOS" would be accepted.

Perhaps one thing that could be reasonably easily supported is:
  root=gptguid
where gptguid is the id of a partition on a GPT-formatted disk. With msdos partition tables, partitions do not
have unique identifiers; Windows does puts a 32-bit "windows nt disk signature" field in the MBR, which could
possibly be used but it isn't really standard. However the GPT format (part of the EFI standard) mandates a
unique GUID be assigned to every partition which sounds like an excellent way to specify the location of the
root fs.

I *think* that it would be a matter of enhancing the "struct hd_struct" held by "struct gendisk" to store this
info when scanning a GPT partition table, then enhancing do_mount.c to check the root param against these values.

See: http://en.wikipedia.org/wiki/GUID_Partition_Table

Thoughts?

If this sounds sane to people, I would be keen to have a go at implementing this. Are there any specific
people or lists that should be cc'd when discussing this?

Regards, Simon

