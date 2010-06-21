Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab0FUS2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 14:28:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62689 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab0FUS2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 14:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iAhBlxpFu91+7AC+qsKXsrcU3lrKHbWp9pxmY2pavKWXlgRyeTVLOoTci7TcdrHnO/
         1o3ErPuhKL1TtkYidLDl4673P7JavUpDYavgs/wWaJLieg80HMeg07korK/LGc5u1tDN
         HDU9kr9SVSDHq6uS+VIs+Z1gScoYUQZGi7TGo=
MIME-Version: 1.0
In-Reply-To: <4C0E9E03.1010508@kernel.org>
References: <4C08FF36.80806@kernel.org>
	<4C0E9E03.1010508@kernel.org>
Date: Mon, 21 Jun 2010 11:28:33 -0700
X-Google-Sender-Auth: 6vwLWEzT5yU_uL7vHOxeF31DVC4
Message-ID: <AANLkTimL2dEhIaxztoiDRBY3CsalcVNU54Mko6yg8ZqG@mail.gmail.com>
Subject: Re: [PATCH UPDATED] sched: adjust when cpu_active and cpuset 
	configurations are updated during cpu on/offlining
From: Tony Luck <tony.luck@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 8, 2010 at 12:46 PM, Tejun Heo <tj@kernel.org> wrote:
> * Ingo's test discovered __cpuinit/exit markups were incorrect.
>  Fixed.

No it isn't :-(

> +static int __cpuexit cpuset_cpu_active(struct notifier_block *nfb,
> +                                      unsigned long action, void *hcpu)
...
> +static int __cpuexit cpuset_cpu_inactive(struct notifier_block *nfb,
> +                                        unsigned long action, void *hcpu)

This patch arrived in linux-next (tag next-20100621) and breaks the
ia64 build for configurations where CONFIG_HOTPLUG_CPU=n
with the following cryptic error:

`.cpuexit.text' referenced in section `.IA_64.unwind.cpuexit.text' of
kernel/built-in.o: defined in discarded section `.cpuexit.text' of
kernel/built-in.o

This is because ia64 link stage drops __exit functions from
built-in code (under the logic that they can never be called).

Is the problem in the !CONFIG_HOTPLUG_CPU definition of
hotcpu_notifier() in <linux/cpu.h> which still references the
function argument:

#define hotcpu_notifier(fn, pri)        do { (void)(fn); } while (0)

Or should these functions not be marked __cpuexit?

-Tony
