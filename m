Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1HFDVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 23:21:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24717 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1HFDVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 23:21:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=vz8Mtc0eknt6yLgw4J1mN/z+m2tzo2zh3g8TXBWY9V3g+PJ/339HN9j/Al8F2DTrf
	paSkgrvQfX7WF+9Y7SIFw==
MIME-Version: 1.0
In-Reply-To: <1312582209.28695.51.camel@twins>
References: <20110805204040.GG2522@redhat.com> <1312582209.28695.51.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 5 Aug 2011 20:20:35 -0700
Message-ID: <CAPM31RKTPC96dVsqakJ+mMRTTc7A8XEQH2YoQdZk9vdZ6fVWqw@mail.gmail.com>
Subject: Re: [PATCH] jump label: Reduce the cycle count by changing the link order
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jason Baron <jbaron@redhat.com>, rostedt@goodmis.org, mingo@elte.hu,
        rth@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 3:10 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2011-08-05 at 16:40 -0400, Jason Baron wrote:
>> In the course of testing jump labels for use with the CFS bandwidth controller,
>> Paul Turner, discovered that using jump labels reduced the branch count and the
>> instruction count, but did not reduce the cycle count or wall time.
>>
>> I noticed that having the jump_label.o included in the kernel but not used in
>> any way still caused this increase in cycle count and wall time. Thus, I moved
>> jump_label.o in the kernel/Makefile, thus changing the link order, and
>> presumably moving it out of hot icache areas. This brought down the cycle
>> count/time as expected.
>>
>> In addition to Paul's testing,  I've tested the patch using a single
>> 'static_branch()' in the getppid() path, and basically running tight loops of
>> calls to getppid(). Here are my results for the branch disabled case:
>
> Those numbers don't seem to be pre/post patch, but merely
> CONFIG_JUMP_LABEL=y/n so they don't tell us what the patch does.
>

I have some numbers to support this:

[
Key:

npo_XXX = with CONFIG_JUMP_LABEL, without link order patch (no patched order)
po_XXX = with CONFIG_JUMP_LABEL, with link order patch (patched order)
nojl_XXX = without CONFIG_JUMP_LABEL

head is tip (c5bafb3)

Test was repeated 3 times, each run was 50 repeats w/ typically ~<0.1
in-test variance on reported output
]
[
Key:

npo_XXX = with CONFIG_JUMP_LABEL, without link order patch (no patched order)
po_XXX = with CONFIG_JUMP_LABEL, with link order patch (patched order)
nojl_XXX = without CONFIG_JUMP_LABEL

base is tip (c5bafb3)

Test was repeated 3 times, each run was 50 repeats w/ typically ~<0.1
in-test variance on reported output
]

                          instructions            cycles
   branches              elapsed
---------------------------------------------------------------------------------------------------------------------
       Westmere:
njl_base.1                  798832892               722624737
     145375836             0.203218936
njl_base.2                  798888783 (+0.01)       746118188 (+3.25)
     145386807 (+0.01)     0.208573683 (-2.18)
njl_base.3                  798864253 (+0.00)       731537139 (+1.23)
     145382747 (+0.00)     0.204098175 (-4.28)
npo_base.1                  797033521 (-0.23)       731239359 (+1.19)
     144571358 (-0.55)     0.206910496 (-2.96)
npo_base.2                  797166434 (-0.21)       728926020 (+0.87)
     144603465 (-0.53)     0.202906392 (-4.84)
npo_base.3                  797165370 (-0.21)       725930458 (+0.46)
     144603438 (-0.53)     0.202118274 (-5.21)
po_base.1                   797019904 (-0.23)       699008145 (-3.27)
     144567652 (-0.56)     0.197272615 (-7.48)
po_base.2                   797037682 (-0.22)       705732419 (-2.34)
     144572115 (-0.55)     0.197101692 (-7.56)
po_base.3                   797079804 (-0.22)       698007668 (-3.41)
     144580964 (-0.55)     0.194871253 (-8.61)

       Barcelona:
njl_base.1                  816842028               748362637
     147462095             0.341654152
njl_base.2                  816849735 (+0.00)       748480742 (+0.02)
     147462652 (+0.00)     0.341450734 (-2.90)
njl_base.3                  816834963 (-0.00)       747083797 (-0.17)
     147460200 (-0.00)     0.340802353 (-3.09)
npo_base.1                  815068563 (-0.22)       775012690 (+3.56)
     146661357 (-0.54)     0.353797321 (+0.61)
npo_base.2                  815033261 (-0.22)       759613364 (+1.50)
     146654106 (-0.55)     0.346462671 (-1.48)
npo_base.3                  815029611 (-0.22)       762660196 (+1.91)
     146654169 (-0.55)     0.347565129 (-1.16)
po_base.1                   815026489 (-0.22)       767229109 (+2.52)
     146653376 (-0.55)     0.350241833 (-0.40)
po_base.2                   815035127 (-0.22)       770224495 (+2.92)
     146654019 (-0.55)     0.351352092 (-0.09)
po_base.3                   815109904 (-0.21)       774954096 (+3.55)
     146662020 (-0.54)     0.353505054 (+0.53)

At least on Nehalem/Westmere systems it looks worthwhile.

> Anyway, should we put a comment in the Makefile telling us we should
> keep jump_label.o last?

Without doing some sort of FDO sampling this list is always going to
have junk arbitrary ordering constraints (which unfortunately extend
beyond jump_label.o).

This commit being in the reflog for the file is already going to serve
as evidence to that. :(


>
> Also, pjt mentioned on IRC that mucking about with link order is
> something google is not unfamiliar with.. could we use some sort of
> runtime feedback to generate linker layout maps or so? That seems like a
> more scalable version than randomly mucking about with Makefiles :-)
>

I think this is a good longer term direction, but that getting there
will take a while (What are the right workloads to drive the FDO data
for example?).

In the short term it's probably just worth taking since the effects
aren't going away.
