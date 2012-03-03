Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2CCRSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 12:18:17 -0500
Received: from mta1.math.wisc.edu ([144.92.166.194]:48059 "EHLO
	mta1.math.wisc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2CCRSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 12:18:16 -0500
Message-ID: <BFFDBC9B6BA14BE1AC8E266A3A456A63@hinkle>
From: "John G. Heim" <jheim@math.wisc.edu>
To: <linux-kernel@vger.kernel.org>
Subject: speakup bug
Date: Sat, 3 Mar 2012 11:18:12 -0600
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 15.4.3538.513
X-MimeOLE: Produced By Microsoft MimeOLE V15.4.3538.513
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need help fixing a bug in the driver for serial hardware  speech synths in 
the speakup screen reader. According to the comments in the code, it is in a 
part of the code that is trying to "steal" the serial port.

First it calls request_region and when that fails (it always fails), it 
calls         __release_region(&then it calls release_region again to see if 
__release_region worked. But it never works because the region being 
requested is already taken.

The code in question is in 2 source code files in drivers/staging/speakup. 
It starts in serialio.c on line 38. Here it calls a function named 
synth_request_region which in turn, calls request_region. On line 41 it 
calls __release_region, and on line 42 it calls synth_request_region again. 
The function synth_request_region (which calls request_region) is in a file 
named synth.c. But this code always fails.  Here is a kind of simplified 
version of it...

int error;
struct resource tmp;
tmp .name = "ltlk";
tmps.start = 0x3F8;
tmp.end = 0x3FF;
tmp.flags = IORESOURCE_BUSY;
error = request_resource (&ioport_resource, &tmp);

The error returned is always -16. I looked at the code in kernel/resource.c 
where the request_region function is  defined. It builds a linked list of 
resources with start & end addresses. If you request a region that is 
already within the start-end range of a resource already in the list, it 
returns an error code. But it looks as if the region for a serial port, 
0x3f8 - 0x3ff,  in ioport_resource cannot be reserved because the entire 
range from 0x000 through 0xcf7 is already taken by something named "PCI Bus 
0000:00".  Therefore calling request_resource always fails and the driver 
for the speech synth errors out.

And therefore I can't use my hardware speech synth without modifying the 
kernel code.  If you comment out the line that checks the return code from 
request_region, it works. So you have to modify  the kernel code and compile 
a custom kernel to use a hardware speech synth. That's not such a problem 
for me but it is for a lot of people. Plus, the grml live CD doesn't work 
with hardware speech.  That is a problem for me.

Can anyone tell me how to fix this so it can be patched in the official 
kernel code?


