Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab1FJUmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:42:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56805 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab1FJUme convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:42:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RNK+xal72jgQnGEavz0Z2NcamaFbUDR/qrHtWJ/0+kuLAtcYC2QqUwW8yCoj16p5gy
         U2jCX5901iJLhv9OnTImTDslZ/a4oUjVce0pT0ahIbF+WSaDMUaAAPOLSdOZ9AEVtFRb
         kbUy9a3D2SLhyUe1k3hi7XsUKnldYMuMK8C+8=
MIME-Version: 1.0
In-Reply-To: <4DF1D0EF.7090109@jp.fujitsu.com>
References: <4df13cae2729896ba5@agluck-desktop.sc.intel.com>
	<4DF1D0EF.7090109@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 13:42:33 -0700
X-Google-Sender-Auth: 0CBG-hksmXau36CJE-CF7QAbUSI
Message-ID: <BANLkTikkYevvkUeQz4YYGauF52YcDRdokQ@mail.gmail.com>
Subject: Re: [PATCH 07/10] MCE: replace mce.c use of TIF_MCE_NOTIFY with user_return_notifier
From: Tony Luck <tony.luck@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/10 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
> Now I'm reconsidering the MCE event notification mechanism.
> One of something nervous is whether it is really required to process
> "_AO" memory poisoning (i.e. mce_process_ring()) here in a process
> context that unfortunately interrupted by MCE (or preempted after that).
> I'm uncertain how long walking though the task_list for unmap will takes,
> and not sure it is acceptable if the unlucky thread is a kind of latency
> sensitive...
>
> If we can move mce_process_ring() to worker thread completely, what
> we have to do will be:
>  1) from NMI context, request non-NMI context by irq_work()
>  2) from (irq) context, wake up loggers and schedule work if required
>  3) from worker thread, process "_AO" memory poisoning etc.
>
> So now question is why user_return_notifier is needed here.
> Is it just an alternative of irq_work() for !LOCAL_APIC ?

I switched this notification over from old TIF_MCE_NOTIFY to
using user_return_notifier to preserve existing semantics, and
free up that TIF bit for the task notifier for the action required case.

You are right that we should have some better method - the
shot-gun approach of hitting every task on every cpu in the hope
that one of them will run our code soon sounds like overkill.
Using some NMI-saf method to wake a single worker thread
sounds a good idea for a subsequent clean up.

-Tony
