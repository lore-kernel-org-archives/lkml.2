Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1JMLCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:02:39 -0400
Received: from bubo.tul.cz ([147.230.16.1]:57588 "EHLO bubo.tul.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab1JMLCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:02:38 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Organization: TUL
Subject: [RFC][PATCH][TRIVIAL] System ACE fails in look for root devices
To: grant.likely@secretlab.ca
Date: Thu, 13 Oct 2011 13:02:42 +0200
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Petr Cvek" <petr.cvek@tul.cz>
Message-ID: <op.v3aeassn4x40tt@localhost>
User-Agent: Opera Mail/10.63 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I sent this mail some time ago, but nobody replied :-(.


I'm using microblaze linux on ML506 board and I found problem with  
SystemACE CF driver.

When xsysace driver is probed, and dts file does not include entry  
"port-number" (existence of line not actually tested) on line:

	of_property_read_u32(dev->dev.of_node, "port-number", &id);

kernel fails to boot with this message:

	<4>VFS: Cannot open root device "xsa2" or unknown-block(0,0)
	<4>Please append a correct "root=" boot option; here are the available  
partitions:
	<4>fff:ffff0     990864 xs`  (driver?)
	<4>  fff:ffff1     124960 xs`1 00000000-0000-0000-0000-000000000000
	<4>  fff:ffff2     865872 xs`2 00000000-0000-0000-0000-000000000000
	<0>Kernel panic - not syncing: VFS: Unable to mount root fs on  
unknown-block(0,0)

(note xs` xs`1 xs`2 partition names)

So I've done some searching and found "ace->id" variable, which has value  
"-1". Because this value define letter of drive and is incremented by 'a',  
then with its value of -1, creates letter before 'a' thus '`'.

"ace->id" value is assigned in ace_probe function on line

       of_property_read_u32(dev->dev.of_node, "port-number", &id);
       if (id < 0)
           id = 0;

This condition should prevents value to be less than zero, but is does  
not. It's because type, which is u32 few lines before, condition is never  
true.  So I suggest changing it to int. Actually, there was patch some  
time ago, which has changed it into u32 (last patch for xsysace.c).

	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=5d10302f46df1d9a85c34ea97f9b6c29e414482e

And finally here is my patch, which suggests changing this line back:

Test for signed value is never true, because of unsigned type.

From: Petr Cvek <petr.cvek@tul.cz>

Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
---
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index fb1975d..3ed920c 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1155,7 +1155,7 @@ static int __devinit ace_probe(struct
platform_device *dev)
    {
           resource_size_t physaddr = 0;
           int bus_width = ACE_BUS_WIDTH_16; /* FIXME: should not be hard
coded */
-       u32 id = dev->id;
+       int id = dev->id;
           int irq = NO_IRQ;
           int i;

