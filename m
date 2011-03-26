Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab1CZElq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 00:41:46 -0400
Received: from m12-14.163.com ([220.181.12.14]:58020 "EHLO m12-14.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab1CZElp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 00:41:45 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Mar 2011 00:41:44 EDT
X-Coremail-DSSMTP: 222.210.222.135
Message-ID: <A97FC25C3A4B47D2A3C623C690CA5FC5@xiewentao>
From: "scxby" <scxby@163.com>
To: <linux-kernel@vger.kernel.org>
Subject: PROBLEM:a bug about pi-futex maybe let the program going to hang
Date: Sat, 26 Mar 2011 12:19:03 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
X-CM-TRANSID: DsCowLD7v432ao1NtMi2BA--.43177S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw4UWFW7uF4rtr17Ary3XFb_yoWkCwcEvr
	43ArW8KF43Gay3WF10kFs8KF1Iqw4Fvr1vvFn5Xr45KFyrKr90qr1rurW2kF47JF1rJrsx
	tr1rArZ8u3WUujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnUKIJUUUUU==
X-CM-SenderInfo: xvf0u5i6rwjhhfrp/1tbiTRMOk00vHoulMAABsg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2Q4frIW032100

hi, all.
 
  Maybe, there is a bug about pi-futex, it would let the program in user-space going to hang.
 
  We have a board: CPU is powerpc 8572, two core. after ran one month, the state of pi-futex in user-space got bad: mutex->__data.__lock is 0x8000023e, mutex->__data.__count is 0, mutex->__data.__owner is 0.
 
  then, I review file "kernel/funtex.c"(the version is linux 2.6.38), found a case:
 
  if there are 3 thread, named threadA, threadB, threadC¡£thread A hold mutexM, threadB and threadC is waiting mutexM. They run as fllow steps:
 
  1. threadB and threadC sleep at line 1984.
  2. threadB receive a signal, then it will be wake up.
  3. threadA unlock mutexM, and give mutexM to threadB. 
  4. threadB call fixup_owner, try to give mutex to threadC.
  5. at line 1580, threadB trigger a addr-fault, then goto handle_fault.
  6. at line 1617, threadB release spinlock, then handle fault.
  7. threadC got spinlock, and call fixup_owner, and got mutexM.
  8. threadC give mutexM to threadB.
  9. threadB re-got spinlock, it will found "pi_state->owner == oldowner" and retry to fixup.
  10. threadB give mutexM to threadC, that's a bad thing.
 
  we have wrote a program, this program can prove all above.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
