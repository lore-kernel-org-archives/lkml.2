Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab1INSmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 14:42:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46698 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab1INSmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 14:42:20 -0400
Message-ID: <4E70F6FD.2060709@colorfullife.com>
Date: Wed, 14 Sep 2011 20:48:29 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH -rt] ipc/sem: Rework semaphore wakeups
References: <alpine.LFD.2.02.1109101052340.2723@ionos> <1315737307.6544.1.camel@marge.simson.net> <1315817948.26517.16.camel@twins> <1315835562.6758.3.camel@marge.simson.net> <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins> <1315927699.6445.6.camel@marge.simson.net> <1315994224.5040.1.camel@twins>
In-Reply-To: <1315994224.5040.1.camel@twins>
Content-Type: multipart/mixed;
 boundary="------------020204060504040505020908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020204060504040505020908
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/14/2011 11:57 AM, Peter Zijlstra wrote:
> Subject: ipc/sem: Rework semaphore wakeups
> From: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Date: Tue Sep 13 15:09:40 CEST 2011
>
> Current sysv sems have a weird ass wakeup scheme that involves keeping
> preemption disabled over a potential O(n^2) loop and busy waiting on
> that on other CPUs.
Have you checked that the patch improves the latency?
Note that  the busy wait only happens if there is a simultaneous timeout 
of a semtimedop() and a true wakeup.

The code does:

     spin_lock()
     preempt_disable();
     usually_very_simple_but_worstcase_O_2
     spin_unlock()
     usually_very_simple_but_worstcase_O_1
     preempt_enable();

with your change, it becomes:

     spin_lock()
     usually_very_simple_but_worstcase_O_2
     usually_very_simple_but_worstcase_O_1
     spin_unlock()

The complex ops remain unchanged, they are still under a lock.

What about removing the preempt_disable?
It's only there to cover a rare race on uniprocessor preempt systems.
(a task is woken up simultaneously due to timeout of semtimedop() and a 
true wakeup)

Then fix the that race - something like the attached patch [obviously 
buggy - see the fixme]

--
     Manfred

--------------020204060504040505020908
Content-Type: text/plain;
 name="patch-rt-sem"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="patch-rt-sem"

ZGlmZiAtLWdpdCBhL2lwYy9zZW0uYyBiL2lwYy9zZW0uYwppbmRleCBhZGQ5M2QyLi45NmFl
ZjZkIDEwMDY0NAotLS0gYS9pcGMvc2VtLmMKKysrIGIvaXBjL3NlbS5jCkBAIC00MTYsMTEg
KzQxNiwxMyBAQCBzdGF0aWMgdm9pZCB3YWtlX3VwX3NlbV9xdWV1ZV9wcmVwYXJlKHN0cnVj
dCBsaXN0X2hlYWQgKnB0LAogCQkJCXN0cnVjdCBzZW1fcXVldWUgKnEsIGludCBlcnJvcikK
IHsKIAlpZiAobGlzdF9lbXB0eShwdCkpIHsKKyNpZm5kZWYgQ09ORklHX1BSRUVNUFRfUlRf
QkFTRQogCQkvKgogCQkgKiBIb2xkIHByZWVtcHQgb2ZmIHNvIHRoYXQgd2UgZG9uJ3QgZ2V0
IHByZWVtcHRlZCBhbmQgaGF2ZSB0aGUKIAkJICogd2FrZWUgYnVzeS13YWl0IHVudGlsIHdl
J3JlIHNjaGVkdWxlZCBiYWNrIG9uLgogCQkgKi8KIAkJcHJlZW1wdF9kaXNhYmxlKCk7Cisj
ZW5kaWYKIAl9CiAJcS0+c3RhdHVzID0gSU5fV0FLRVVQOwogCXEtPnBpZCA9IGVycm9yOwpA
QCAtNDQ5LDggKzQ1MSwxMCBAQCBzdGF0aWMgdm9pZCB3YWtlX3VwX3NlbV9xdWV1ZV9kbyhz
dHJ1Y3QgbGlzdF9oZWFkICpwdCkKIAkJc21wX3dtYigpOwogCQlxLT5zdGF0dXMgPSBxLT5w
aWQ7CiAJfQotCWlmIChkaWRfc29tZXRoaW5nKQorCWlmIChkaWRfc29tZXRoaW5nKSB7Cisj
aWZuZGVmIENPTkZJR19QUkVFTVBUX1JUX0JBU0UKIAkJcHJlZW1wdF9lbmFibGUoKTsKKyNl
bmRpZgogfQogCiBzdGF0aWMgdm9pZCB1bmxpbmtfcXVldWUoc3RydWN0IHNlbV9hcnJheSAq
c21hLCBzdHJ1Y3Qgc2VtX3F1ZXVlICpxKQpAQCAtMTI4MCw2ICsxMjg0LDEzIEBAIHN0YXRp
YyBpbnQgZ2V0X3F1ZXVlX3Jlc3VsdChzdHJ1Y3Qgc2VtX3F1ZXVlICpxKQogCWVycm9yID0g
cS0+c3RhdHVzOwogCXdoaWxlICh1bmxpa2VseShlcnJvciA9PSBJTl9XQUtFVVApKSB7CiAJ
CWNwdV9yZWxheCgpOworI2lmZGVmIENPTkZJR19QUkVFTVBUX1JUX0JBU0UKKwkJLypGSVhN
RTogb2J2aW91c2x5IGJyb2tlbiBpZiBjYWxsZWQgd2l0aCBzZW1hcGhvcmUgc3BpbmxvY2sg
aGVsZAorIAkJICogc2NoZWRfeWllbGQoKSBzaG91bGQgb25seSBiZSBjYWxsZWQgaWYgZ2V0
X3F1ZXVlX3Jlc3VsdCgpIGlzCisgCQkgKiBjYWxsZWQgb3V0c2lkZSBvZiB0aGUgc2VtYXBo
b3JlIGxvY2sKKyAJCSovCisJCXNjaGVkX3lpZWxkKCk7CisjZW5kaWYKIAkJZXJyb3IgPSBx
LT5zdGF0dXM7CiAJfQogCg==
--------------020204060504040505020908--
