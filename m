Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1F0TGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 15:06:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5581 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1F0TG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 15:06:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IfjNm8PqGnhCAjbFl96EKRHzon3FtpsFYJ0bZOBZLqV4Vj3E7TwU+tKtbSM6mBPYb6
         XFd8KgnN6ybSyYiQfrkA==
MIME-Version: 1.0
In-Reply-To: <20110627190358.GQ3765@redhat.com>
References: <20110623124918.GC13050@sun>
	<20110627190358.GQ3765@redhat.com>
Date: Mon, 27 Jun 2011 21:06:25 +0200
Message-ID: <BANLkTinR-pxPKOhGfvuKNCyysZ=k8NDX1g@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Add hw_watchdog_set_attr() in a sake of
 nmi-watchdog on P4
From: Stephane Eranian <eranian@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 9:03 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Thu, Jun 23, 2011 at 04:49:18PM +0400, Cyrill Gorcunov wrote:
>> Due to restriction and specifics of Netburst PMU we need a separated
>> event for NMI watchdog. In particular every Netburst event consume not
>> just a counter and config register, but also an additional ESCR register.
>> Since ESCR registers are grouped upon counters (i.e. if ESCR is occupied
>> for some event there is no room for another event to enter until it's
>> released) we need to pick up "least" used ESCR (or most available)
>> for nmi-watchdog purpose -- MSR_P4_CRU_ESCR2/3 was chosen.
>
> I have tested this on a p4 and a westmere using 'perf top' and then
> lkdtm's 'HARDLOCKUP' command.  Both seemed to work correctly indicating
> that the watchdog and perf were co-existing peacefully. :-)
>

I tested the patch on a P4 and it worked for me too.

Tested-and-reviewed-by: Stephane Eranian <eranian@google.com>

I like the patch now. It is far simpler than when we started.
Thanks.

> Thanks Cyrill.
>
> Tested-and-reviewed-by: Don Zickus <dzickus@redhat.com>
>
>> Index: linux-2.6.git/kernel/watchdog.c
>> ===================================================================
>> --- linux-2.6.git.orig/kernel/watchdog.c
>> +++ linux-2.6.git/kernel/watchdog.c
>> @@ -200,6 +200,8 @@ static int is_softlockup(unsigned long t
>>  }
>>
>>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>> +void __weak hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr) { }
>> +
>
> Though I do wonder about this call in the watchdog.  I thought it might be
> better elsewhere but not sure where.
>
> Cheers,
> Don
>
