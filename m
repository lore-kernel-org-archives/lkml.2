Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab2JBTLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:11:12 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:40590 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2JBTLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:11:10 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH v4] trace,x86: add x86 irq vector tracepoints
Thread-Topic: [PATCH v4] trace,x86: add x86 irq vector tracepoints
Thread-Index: Ac2YWrA+n8Wn2uRQSgKoDvfneAuZiQClgnuAAIOLIPAAEMXIAADi3wmQ
Date: Tue, 2 Oct 2012 19:10:29 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413869FD7@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41385F33C@USINDEM103.corp.hds.com>
 <50612729.2080307@zytor.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>
 <50650A7E.90807@zytor.com>
In-Reply-To: <50650A7E.90807@zytor.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-02_04:2012-10-02,2012-10-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1210020210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q92JBI6q001318

> >
> > If I misunderstand something, please let me know.
> >
> 
> Quite.
> 
> These functions are being invoked from the IDT, which is an indirect pointer structure.  When not being traced, there is absolutely no
> reason why it should go through a thunk with tracepoints.

I agree that the cost can be absolutely zero by switching  each interrupt hander when turning on/off the tracepoint.

But I would like to talk about a time penalty of a tracepoint more.

When not being traced, the tracepoint is just nop.
And it is described in the documentation below.
So, the tracepoint seems to be designed to add to performance critical paths.

Documentation/trace/tracepoints.txt
<snip>
* Purpose of tracepoints

A tracepoint placed in code provides a hook to call a function (probe) that you can provide at runtime. A tracepoint can be "on" (a probe is connected to it) or "off" (no probe is attached). When a tracepoint is "off" it has no effect, except for adding a tiny time penalty (checking a condition for a branch) and space penalty (adding a few bytes for the function call at the end of the instrumented function and adds a data structure in a separate section).  When a tracepoint is "on", the function you provide is called each time the tracepoint is executed, in the execution context of the caller. When the function provided ends its execution, it returns to the caller (continuing from the tracepoint site).

You can put tracepoints at important locations in the code. They are lightweight hooks that can pass an arbitrary number of parameters, which prototypes are described in a tracepoint declaration placed in a header file.
<snip>

Also, as I submitted an actual latency measurement, the time penalty is almost zero.

<snip>
(1-1) local_timer_entry

 - 3.6-rc6 original
   	<...>-2788    2dNh. 894834337us : exit_idle <-smp_apic_timer_interrupt
   	<...>-2788    2dNh. 894834337us : hrtimer_interrupt <-smp_apic_timer_interrupt

 - 3.6-rc6 + this patch + trace off
   	<...>-1981    0d.h. 210538us : exit_idle <-smp_apic_timer_interrupt
   	<...>-1981    0d.h. 210538us : hrtimer_interrupt <-smp_apic_timer_interrupt
<snip>

When switching each interrupt handler, all cpus have to be interrupt-disable with smp_call_funciton() or something like that.

IMO, rather than doing such a complex thing, just adding a tracepoint is reasonable.

What do you think?

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
