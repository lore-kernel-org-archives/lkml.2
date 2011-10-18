Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab1JROxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:53:17 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:39629 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab1JROxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:53:15 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Chen, Gong" <gong.chen@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Date: Tue, 18 Oct 2011 10:52:22 -0400
Subject: RE: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Thread-Topic: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Thread-Index: AcyNlTIkuR7liOlRTYa1gjBa5vE74gADPKpA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57565D3A@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
 <20111017164715.e42591d5.akpm@linux-foundation.org>
 <20111018124929.GA3452@redhat.com>
In-Reply-To: <20111018124929.GA3452@redhat.com>
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
 definitions=main-1110180143
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> afacit this assumes that (reason == KMSG_DUMP_PANIC) if in_nmi().  Is
>> that always the case, and will it always be the case in the future?
>

Currently, when kernel is in nmi context and kmsg_dump() are called, its reason is always "KMSG_DUMP_PANIC".

>
>Perhaps a 'BUG_ON(in_nmi() && reason != KMSG_DUMP_PANIC)'?

I don't think BUG_ON() is needed.

If someone would like to log messages in the case of "in_nmi() && reason != KMSG_DUMP_PANIC",
he/she will add a new trigger as follows.

We can discuss implementation of kmsg_dump() at that time.
But I can't see any use case now.

	371 static notrace __kprobes void 
	372 unknown_nmi_error(unsigned char reason, struct pt_regs *regs) 
	373 {
	374         if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) == 
	375                         NOTIFY_STOP) 
	376                 return; 
	377 #ifdef CONFIG_MCA 
	378         /* 
	379          * Might actually be able to figure out what the guilty party 
	380          * is: 
	381          */ 
	382         if (MCA_bus) { 
	383                 mca_handle_nmi(); 
	384                 return; 
	385         } 
	386 #endif 
	387         pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n", 
	388                  reason, smp_processor_id()); 
	389  
	390         pr_emerg("Do you have a strange power saving mode enabled?\n"); 
	391         if (unknown_nmi_panic || panic_on_unrecovered_nmi) 
	392                 panic("NMI: Not continuing"); 
	393  
	394         pr_emerg("Dazed and confused, but trying to continue\n");
		    *kmsg_dump(NMI);*
	395 }

>>
>> I felt that the spin_trylock() approach was less horrid than this.  I
>> assume that the new approach will cause lockdep to go berzerk?
>
>Heh.  Good point.  That is probably a good test case.  Though finding a
>working GHES implementation in the firmware isn't easy these days, making
>it hard to test. :-/

Thank you for supporting my patch.
But I can resend another patch below in accordance with Chen's request.
We can avoid potential deplock issue with this patch.
And this is simpler than trylock approach.

> <snip>
> If(!panic)
> 	spin_lock_irqsave();
>
>       .
>       .
> If(!panic)
> 	spin_unlock_restore();
> <snip>

Seiji
