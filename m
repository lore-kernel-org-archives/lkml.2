Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0LPUqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:46:47 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:39928
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753207Ab0LPUqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:46:46 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zzbb2dK936eK1432N98dN14f9mzz1202hzzz2fh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D0A7A85.3050808@am.sony.com>
Date: Thu, 16 Dec 2010 12:45:57 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "frank.rowand@gmail.com" <frank.rowand@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/5] Reduce runqueue lock contention -v2
References: <20101216145602.899838254@chello.nl>	 <4D0A649B.9080505@am.sony.com> <4D0A6A40.2040907@am.sony.com>	 <4D0A6B03.6080603@am.sony.com> <1292528576.2708.81.camel@laptop>
In-Reply-To: <1292528576.2708.81.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/10 11:42, Peter Zijlstra wrote:
> On Thu, 2010-12-16 at 11:39 -0800, Frank Rowand wrote:
>>   select_task_rq() uses the smp_processor_id() of the old task_cpu(p) instead
>>   of the waking smp_processor_id().
> 
> So first you bounce the wakeup to the previous task cpu, when you do
> select_task_rq() and then you bounce it to the new target?

Yes.  (This is the answer when only the first patch is applied.)

The wakeup is bounced to the previous task cpu.  The bounce adds extra
overhead (including an IRQ on the previous task cpu) in return for a
reduction in the number of rq->lock contentions.

Then the try_to_wake_up() on the previous task cpu may wake the task
on a different cpu, but the bias should be the cpu that try_to_wake_up()
is now running on.

The second patch in my series instead feeds the waking cpu number to
select_task_rq(), so the bias will be to wake the task on the waking
cpu.

-Frank

