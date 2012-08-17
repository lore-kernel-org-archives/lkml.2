Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab2HQVQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 17:16:15 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:39465 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab2HQVQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 17:16:11 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH 2/2] efi_pstore: Introducing workqueue updating
 sysfs entries
Thread-Topic: [RFC][PATCH 2/2] efi_pstore: Introducing workqueue updating
 sysfs entries
Thread-Index: Ac18sHkwmdnRbMTcT9KbT5zgh21KoAAKK1YAAAgJvvA=
Date: Fri, 17 Aug 2012 21:15:56 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413800155@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D413800090@USINDEM103.corp.hds.com>
 <CAGTjWtA-zE-UCsqC5H4VvLfz94J_5bjYzMwF5RaHLdr9O_MoRA@mail.gmail.com>
In-Reply-To: <CAGTjWtA-zE-UCsqC5H4VvLfz94J_5bjYzMwF5RaHLdr9O_MoRA@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-17_05:2012-08-17,2012-08-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208170234
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm not a fan of creating a periodic timer that wakes up here to check for an event that should be considered very rare.
> 
> Can this just become scheduled work?  Scheduling work itself is a very lightweight process and should be relatively safe to do from a
> pstore write.

I agree that the periodic timer is heavy a bit.
But I would like to keep a write callback simple as much as possible in panic situation.
For example, I'm concerned that efi_pstore hangs up due to some spin_locks related workqueue like gcwq->lock.

Also,  a situation which this workqueue is needed is just oops case because, system will be down and users can't access to sysfs files
 in other cases, panic, reboot and emergency_restart.

So, Can I call schedule_work in oops case only as follows?

efi_pstore_write()
{
   <write log to NVRAM>

 if (reason != KMSG_DUMP_OOPS)
	return;

schedule_work()

}
