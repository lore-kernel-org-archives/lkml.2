Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0IPXhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:37:40 -0400
Received: from mail-da-3.dns-solutions.net ([69.12.112.3]:58278 "HELO
	mail-da-3.dns-solutions.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754395Ab0IPXhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:37:37 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2010 19:37:37 EDT
From: "Joshua Hintze" <joshh@imsar.com>
To: <linux-kernel@vger.kernel.org>
Subject: PATA IDE is slower in newer versions of kernel
Date: Thu, 16 Sep 2010 17:30:51 -0600
Message-ID: <00d401cb55f7$33a78210$9af68630$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: ActV9zHDLVs33MBcStCtH/cComYPDg==
Content-Language: en-us
x-cr-hashedpuzzle: xT4= 7T4= AJ6g AQ58 BBMU BeKQ CQ2b DS8Y FZMS GCzY GVxy G1/r IfKb IrV5 KPFw KcDU;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{B27C10AA-4023-4F31-811A-60345BE422F0};agBvAHMAaABoAEAAaQBtAHMAYQByAC4AYwBvAG0A;Thu, 16 Sep 2010 23:30:49 GMT;UABBAFQAQQAgAEkARABFACAAaQBzACAAcwBsAG8AdwBlAHIAIABpAG4AIABuAGUAdwBlAHIAIAB2AGUAcgBzAGkAbwBuAHMAIABvAGYAIABrAGUAcgBuAGUAbAA=
x-cr-puzzleid: {B27C10AA-4023-4F31-811A-60345BE422F0}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

I've been digging into this for a couple weeks now. I have an embedded board
that runs Linux Kernel 2.6.10 that is connected to a SSD over a PATA
connection. Data is transferred using UDMA4 speeds and I get a nice
sustained write speed of about 20 MBps which is adequate for us. 

I have recently taken the plunge to update to a newer version of the kernel
starting at 2.6.32 (also tried 2.6.33) and what I am seeing writes speeds
drop to about 18 MBps peak with large jumps going from 8 MBps->16 MBs for
sustained throughput.

I decided to read up on the ATA specification and I connected a logic
analyzer to the PATA bus and here is what is happening...after a large chunk
of data is written to the device, instead of the device pausing the transfer
by asserting DDMARDY it actual initiates a device data-out termination by
pulling DMARQ low.

The old kernel 2.6.10 responds to this by strobing the STOP line 8 times
within 800uS and the device releases DMARQ shortly afterwards. On the newer
kernels the strobing of the STOP line takes near 8mS of time. Since the hard
drive only release DMARQ after this 8 pulse strobe I believe this is the
cause of the slower write speeds on the newer kernels. This whole process
happens thousands of times when writing megs of data. So those extra 7mS
begin to add up fast.

My problem is I've been digging through the ide.c/ide-dma.c and other code
but I'm not exactly sure where the code would jump to upon a device
initiated termination on a data-out dma transfer.

My guess is ide_dma_intr(...). Is this correct?

Any other areas I could look at?

Thanks in advance.


