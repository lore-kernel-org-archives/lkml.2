Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0KXLqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:46:36 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48672 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab0KXLqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:46:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=VUtm4tGiR3/P+b3Z4BUZoxPhDu8J3JFVIi1vIFjTGvTmqFzilGuTuBFtV+EOYWnngO
         5IZeSiEK6oFfTh5wpKdcmyrba9B/gyoTqByw8cYjFIEqaAlCHU5txQRvY6OWO6c2id5t
         EajgxVG/1SsUWInIOyKO+rxlvbf1yBsiwKp40=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Emgr=gYLgg+PXkubmiRyFpLDjPE=kO6DFQwhi@mail.gmail.com>
References: <20101123224601.766827604@openvz.org>
	<20101123224800.658686382@openvz.org>
	<1290587537.2072.430.camel@laptop>
	<AANLkTinac7XwdARsLSeLmbc4Kj6my5MHQ=hAgV+A7o-W@mail.gmail.com>
	<1290589356.2072.433.camel@laptop>
	<AANLkTi=Emgr=gYLgg+PXkubmiRyFpLDjPE=kO6DFQwhi@mail.gmail.com>
Date: Wed, 24 Nov 2010 14:46:34 +0300
X-Google-Sender-Auth: doJVQcc7VIDjGfsi7Ho9RSbU0rM
Message-ID: <AANLkTimo2CoYvcSyKB-s_iGVEpir5qh7SxL5oOGd7MXk@mail.gmail.com>
Subject: Re: [rfc 3/3] perf, x86: P4 PMU -- export ABI part of event config to userspace
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        ming.m.lin@intel.com, eranian@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 12:39 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> On 11/24/10, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Wed, 2010-11-24 at 11:48 +0300, Cyrill Gorcunov wrote:
>>> On 11/24/10, Peter Zijlstra <peterz@infradead.org> wrote:
>>> > On Wed, 2010-11-24 at 01:46 +0300, Cyrill Gorcunov wrote:
>>> >> plain text document attachment (x86-perf-export-abi)
>>> >> Due to tight 64 bit size of event config field (where we have to track
>>> >> pretty lot of info during event lifetime) some bits are to be exported
>>> >> via header into userspace.
>>> >>
>>> >> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>>> >> CC: Lin Ming <ming.m.lin@intel.com>
>>> >> CC: Stephane Eranian <eranian@google.com>
>>> >> CC: Peter Zijlstra <peterz@infradead.org>
>>> >> ---
>>> >>
>>> >> Note that I don't like much the idea to export anything into userspace
>>> >> but it seems there is no other choise. So there is a minimum which
>>> >> should
>>> >> be exported.
>>> >
>>> >
>>> > Could you say what exactly is exposed to userspace and why?
>>>
>>> yes, we need two enums to be exported, because we use custom encoding,
>>> which is described in first patch. peter i'll describe more detailed
>>> in a couple of hours, ok?
>>
>> Sure, but have you seen my sysfs patches? wouldn't describing the format
>> in there suffice?
>>
>> http://lkml.org/lkml/2010/11/17/154
>>
>>
> just looked at them, but the main problem is that a few fields in
> .config consist of custom values about which userspace knows nothing,
> ie these fields are not described in SDM but we define own ones. this
> mess is because we need to pack a lot of info in single 64bit field so
> kernel would track event properly in terms of hardware resources. i
> will describe the details as only reach the computer.
>

Peter, would the following change log make more sense?
---
perf, x86: P4 PMU -- export ABI part of event config to userspace v2

Due to tight 64 bit size of event config field (where we have to track
pretty lot of info during event lifetime) some bits are to be exported
via header into userspace, so the caller (regardless if it's a kernel
side caller or call from userspace) should pass them to get event running.

In particular we have to export enums P4_PEBS_METRIC and P4_EVENTS.

The P4_PEBS_METRIC is used to inform the perf subsystem that an
event needs PEBs metric to be set (which tells the kernel to program
tow additional MSR for such event).

In turn P4_EVENTS is used as a primary key for tracking event's
hardware resource.

The proper places of these enums in config are described in comments
in header (the comments are exported as well).

Such a bit complex scheme grows from nature of P4 events, the kernel
has to track ESCR+CCCR+COUNTER+METRIC for every event and 64 bits solely
is not enough for that. Moreover, some events share ESCR "Event Select"
and CCCR "EventMask", so to make every event unique from kernel point
of veiew we define own keys to be used instead of ESCR "Event Select".

v2: Describe what we need to export in commit message

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/Kbuild          |    1 +
 arch/x86/include/asm/perf_event_p4.h |    8 ++++++++
 2 files changed, 9 insertions(+)

Index: linux-2.6.git/arch/x86/include/asm/Kbuild
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/Kbuild
+++ linux-2.6.git/arch/x86/include/asm/Kbuild
@@ -23,3 +23,4 @@ header-y += unistd_32.h
 header-y += unistd_64.h
 header-y += vm86.h
 header-y += vsyscall.h
+header-y += perf_event_p4.h
Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
@@ -5,6 +5,8 @@
 #ifndef PERF_EVENT_P4_H
 #define PERF_EVENT_P4_H

+#ifdef __KERNEL__
+
 #include <linux/cpu.h>
 #include <linux/bitops.h>

@@ -201,6 +203,8 @@ static inline u32 p4_default_escr_conf(i
 	return escr;
 }

+#endif /* __KERNEL__ */
+
 /*
  * This are the events which should be used in "Event Select"
  * field of ESCR register, they are like unique keys which allow
@@ -256,6 +260,8 @@ enum P4_EVENTS {
 	P4_EVENT_INSTR_COMPLETED,
 };

+#ifdef __KERNEL__
+
 #define P4_OPCODE(event)		event##_OPCODE
 #define P4_OPCODE_ESEL(opcode)		((opcode & 0x00ff) >> 0)
 #define P4_OPCODE_EVNT(opcode)		((opcode & 0xff00) >> 8)
@@ -767,6 +773,8 @@ enum P4_ESCR_EMASKS {

 #define p4_config_pebs_has(v, mask)	(p4_config_unpack_pebs(v) & (mask))

+#endif /* __KERNEL__ */
+
 enum P4_PEBS_METRIC {
 	P4_PEBS_METRIC__none,
