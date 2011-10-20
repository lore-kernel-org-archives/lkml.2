Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab1JTSkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 14:40:22 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:45479 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1JTSkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 14:40:21 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Chen, Gong" <gong.chen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Thu, 20 Oct 2011 14:39:36 -0400
Subject: RE: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Thread-Topic: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Thread-Index: AcyPUIklcPuRmINOSRShvoYk0k6EwQABW1BA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C575669A7@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
 <20111017164715.e42591d5.akpm@linux-foundation.org>
 <20111018124929.GA3452@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57565D3A@USINDEVS01.corp.hds.com>
 <20111018151058.GE3452@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5756688D@USINDEVS01.corp.hds.com>
 <20111020174826.GA3452@redhat.com>
In-Reply-To: <20111020174826.GA3452@redhat.com>
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
 definitions=main-1110200207
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>I am confused.  Did you mean 'panic' kernel parameter is _not_ set?
>

I meant that  if panic parameter _is_ set (like panic=1), 
emergency_restart() will be called in panic path.
And then, kmsg_dump(KMSG_DUMP_EMERG) will be called.

        <snip>
	60 NORET_TYPE void panic(const char * fmt, ...)  
	61 {
	.
	.
	123         if (panic_timeout != 0) { 
	124                 /* 
	125                  * This will not be a clean reboot, with everything 
	126                  * shutting down.  But if there is a chance of 
	127                  * rebooting the system it will be rebooted. 
	128                  */ 
	129                 emergency_restart(); 
	130         }
	<snip>

>Actually, BUG_ON is probably overkill, perhaps a WARN_ON would be more
>appropriate.

I don't think both BUG_ON and WARN_ON are appropriate.
kmsg_dump(KMSG_DUMP_EMERG) should be called successfully in panic path.

>I wonder if it would be smarter to split your patch in half.  The part
>where you move kmsg_dump to below stop_cpus is probably non-controversial.
>That might make it sooner than the more controversial bust_spinlock
>pieces.

Thank you for your suggestion. I will split my patch.

Seiji

>On Thu, Oct 20, 2011 at 11:13:26AM -0400, Seiji Aguchi wrote:
>> Don,
>>
>> >That is part of the wider problem with kmsg_dump that Vivek talks about
>> >with me, is that it is just a giant hook in the panic path with limited
>> >auditing.  So we need to explicit set our expectations with BUG_ONs/WARNs
>> >otherwise we might get bit later by them.
>>
>> I found an issue while developing a patch v2.
>>
>> We can't call BUG_ON(in_nmi() && reason != KMSG_DUMP_PANIC)
>> because kmsg_dump(KMSG_DUMP_EMERG) is called in NMI context if "panic" kernel parameter is set.
>
>I am confused.  Did you mean 'panic' kernel parameter is _not_ set?
>
>Actually, BUG_ON is probably overkill, perhaps a WARN_ON would be more
>appropriate.
>
>>
>> I will keep doing research bust_spinlock() or vprintk() so that lockdep checking works and we can avoid any deadlocks.
>
>I wonder if it would be smarter to split your patch in half.  The part
>where you move kmsg_dump to below stop_cpus is probably non-controversial.
>That might make it sooner than the more controversial bust_spinlock
>pieces.
>
>Cheers,
>Don
