Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab1AIBRI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 20:17:08 -0500
Received: from cerebellum.reolight.net ([88.191.59.200]:44700 "EHLO
	cerebellum.reolight.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1AIBRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 20:17:07 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Jan 2011 20:17:07 EST
Message-ID: <4D290AFD.40809@reolight.net>
Date: Sun, 09 Jan 2011 02:10:21 +0100
From: Gregory Auzanneau <greg@reolight.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Loop devices not supported concurrent access ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Report: hits=-0.8 required=5.0 tests=ALL_TRUSTED,AWL autolearn=ham 
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.6 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

During some tests, I've remark an interesting issue with loop devices.
loop devices queues concurrent access by multi-threaded software.

This issue can easily be highlighted by this tool : 
http://box.houkouonchi.jp/seeker_baryluk.c
This tool permit to test how many iop/s your system can handle (don't 
forget to use deadline scheduler).

First of all, we will define a loop device on a raw device (raw device 
permit to avoid filesystem interaction) :
losetup /dev/loop1 /dev/sda5

Now we will test the number our raw device and our loop device can 
handle with only one thread :
./seeker_baryluk /dev/sda5 1 => Results: 196 seeks/second, 5.081 ms 
random access time
./seeker_baryluk /dev/loop1 1 => Results: 194 seeks/second, 5.131 ms 
random access time

Results : raw device and loop device have approximately the same 
performance with one thread.

Here is the problem : we will now test with 32 threads :
./seeker_baryluk /dev/sda5 32 => Results: 631 seeks/second, 1.585 ms 
random access time
./seeker_baryluk /dev/loop1 32 => Results: 194 seeks/second, 5.148 ms 
random access time

As you can see, loop device deals request one by one even with parrallel 
request.
This involve that we lost a lot of performance performed by NCQ/TCQ 
and/or disk balancing.

The same thing also appears in Xen when mapping a disk with a "file".

Is this problem solvable ?



/Thank you all for the good work with linux, keep up with it ! :)

Greg

/
