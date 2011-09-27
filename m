Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1I0Tqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 15:46:44 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:47837 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab1I0Tqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 15:46:43 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Tue, 27 Sep 2011 15:46:08 -0400
Subject: RE: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Thread-Topic: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Thread-Index: Acx9P00IirVS6MeSR6qbrDOtpR4M0QAB+ahAAAEAPwA=
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B8AD@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B823@USINDEVS01.corp.hds.com>
 <20110927173413.GJ5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE4211E3@orsmsx505.amr.corp.intel.com>
 <20110927175919.GK5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE421365@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301EE421365@orsmsx505.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1109270219
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>Yes we care - saving panic data is most likely the single most important
>thing that pstore does.  I just have severe doubts that it will actually
>save anything useful if we just blindly continue if we can't get the lock.

I agree with Tony. We may not get useful information if pstore just blindly continues
while other cpus are running.

>Is this patch based on a real-life case of a system deadlocking? I'd
>like to know if we are just talking around the theoretical case that
>the lock may be held at panic time - or something that has actually been
>seen in real life.

This patch is _not_ based on real-life case. I would like to avoid potential deadlock.

If Don disagrees to  my "return" code, I have another idea which moves pstore_dump() behind smp_send_stop().
smp_send_stop() stops other cpus by sending IPI.
So pstore can continue reliably and get useful information by just busting spinlock.

It depends on each backend driver whether it actually accesses to NVRAM/storage.

Idea
====
 Panic()
   |- smp_send_stop() (Send IPI to other cpus)
   |- bust spin_lock(&psinfo->buf_lock)
   |- call pstore_dump()

Seiji


>-----Original Message-----
>From: Luck, Tony [mailto:tony.luck@intel.com]
>Sent: Tuesday, September 27, 2011 3:03 PM
>To: Don Zickus
>Cc: Seiji Aguchi; linux-kernel@vger.kernel.org; Vivek Goyal; Matthew Garrett; Chen, Gong; Andrew Morton;
>dle-develop@lists.sourceforge.net; Satoru Moriya
>Subject: RE: [RFC][PATCH -next] pstore: replace spin_lock with spin_trylock_irqsave in panic path
>
>> Ok.  Do we care?  I assumed the panic data would be more
>> relevant/interesting than whatever pstore was doing before (like loading
>> previous log files).
>
>Yes we care - saving panic data is most likely the single most important
>thing that pstore does.  I just have severe doubts that it will actually
>save anything useful if we just blindly continue if we can't get the lock.
>
>What actually happens next will be dependent on the back-end. For
>the state machine in ERST, one possible outcome is a hang. For many
>people a hang is considered worse than a panic.
>
>> I assumed we are just overwriting the buffer with the current data, so
>> unless the other cpu is chugging along while this cpu is in panic, the new
>> data shouldn't get corrupted, no?
>
>I really have no idea what *will* happen.  Lots of things are possible, only
>some of them are desirable.
>
>Is this patch based on a real-life case of a system deadlocking? I'd
>like to know if we are just talking around the theoretical case that
>the lock may be held at panic time - or something that has actually been
>seen in real life.
>
>-Tony
