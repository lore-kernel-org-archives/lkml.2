Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab2I0WeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:34:15 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:53338 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab2I0WeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:34:13 -0400
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
Thread-Index: Ac2YWrA+n8Wn2uRQSgKoDvfneAuZiQClgnuAAIOLIPA=
Date: Thu, 27 Sep 2012 22:33:36 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41385F33C@USINDEM103.corp.hds.com>
 <50612729.2080307@zytor.com>
In-Reply-To: <50612729.2080307@zytor.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-09-27_07:2012-09-27,2012-09-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=1 spamscore=1
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1209270292
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8RMYKtA007552

Hi,

> ... except the cost can be reduced to zero *AND* be made into a more general mechanism by simply hooking the IDT.

Thank you for giving me the comment.
In my understanding,  we can introduce a more general mechanism by sandwiching an existing handler between tracepoints.
The pseudo code is like this:

@@ -17,7 +18,7 @@ static void default_threshold_interrupt(void)
 
 void (*mce_threshold_vector)(void) = default_threshold_interrupt;
 
-asmlinkage void smp_threshold_interrupt(void)
+static void do_smp_threshold_interrupt(void)
 {
 	irq_enter();
 	exit_idle();
@@ -27,3 +28,10 @@ asmlinkage void smp_threshold_interrupt(void)
 	/* Ack only at the end to avoid potential reentry */
 	ack_APIC_irq();
 }
+
+asmlinkage void smp_threshold_interrupt(void) {
+	trace_arch_irq_vector_entry(THRESHOLD_APIC_VECTOR);
+	do_smp_threshold_interrupt();
+	trace_arch_irq_vector_exit(THRESHOLD_APIC_VECTOR);
+}

If I misunderstand something, please let me know.

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
