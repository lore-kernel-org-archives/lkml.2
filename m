Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab2GEUF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:05:26 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:43032 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab2GEUFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:05:23 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Thread-Topic: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Thread-Index: Ac1ZdICAdYwUKctERYa3qDPOlfZeVABX5VeAAAHWqnA=
Date: Thu, 5 Jul 2012 20:05:06 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D401C288@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAED@USINDEM103.corp.hds.com>
 <20120705133201.GG5637@redhat.com>
In-Reply-To: <20120705133201.GG5637@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-05_05:2012-07-05,2012-07-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1207050222
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don,

Thank you for giving me your comments.
Let me explain what I'm thinking now.

> I would rather see no records overwritten and just make sure there is enough space for a dozen or so records to buffer multiple
> panics before userspace can run.
> 
> Implementing policy like this in the kernel seems like it would be a constant battle between everyone's view point of what is
> important and not important.
> 
> I would rather take the viewpoint, if it is important to log it in a space limited NVRAM, then it is important enough not to overwrite
> until userspace explicitly asks it to be deleted.  Otherwise why log it, if it is not important?
> 

If the simple policy above is workable, it is easy. 
But we have to discuss whether it is useful in each specific use case.
       When I posted a patch introducing kernel parameter ,efi_pstore_overwrite,
       I thought same thing above. But I changed my mind while considering  Tony's comment....

When an user can read kmsg via /dev/pstore and erase old entries,  we don't need to care.
(Hopefully, some user space apps will be developed near future.)

Problem here is at very final stage and early stage which an user can't see /dev/pstore.

1) At very final stage  (system is panicking/rebooting.)

1-1) Kernel panics while system is rebooting(or oopsing)

When kernel panics while system is rebooting, panic message should be logged rather than skipping it.

Even though reboot message is overwritten by panic one, we will probably save both final part of 
reboot message and panic message as follows.

Example of kmsg in NVRAM
	<snip>
	Panic#1							 <- header supplied by pstore
	<6>kvm: exiting hardware virtualization
	<5>sd 0:0:0:0: [sda] Synchronizing SCSI cache
	 <0>Restarting system.						<- reboot message
	<0>BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:0]
	<0> Kernel panic - not syncing: softlockup: hung tasks		<- panic message
	<0>Pid: 0, comm: swapper/0 Not tainted 3.3.8 #4 Call Trace:
  	<0><IRQ>  [<ffffffff8136bdd5>] panic+0xb8/0x1c4
  	<0>[<ffffffff81071f37>] watchdog_timer_fn+0x139/0x15d
  	<0>[<ffffffff81071dfe>] ? __touch_watchdog+0x1f/0x1f
	<snip>

1-2) Double panic 
In this case, 1s panic message should not be overwritten to detect root cause of system failure.

1-3) ) Kernel reboots while system is panicking
Never happens because kmsg_dump in panic case is serialized via smp_send_stop()

2)  At very early stage  (system is booting up.)
2-1)Previous event is panic, and then panic happens again at boot time.
Previous panic should not be overwritten.

2-2)Previous event is reboot, and then panic happens at boot time
This depends on situation.
Some customer would like to have previous reboot message.
Others may want to get latter panic message.

So, in my current patch, I just decided a policy which error message is prioritized higher than normal message.

In the most case, an user can read/erase entries in NVRAM and get all messages.
I think it is understandable setting a policy in preparation for rare situation.

Seiji
