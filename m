Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab1FMRNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:13:38 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38147 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1FMRNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=M3V5Q18wJ3XKIfj7TlF5HIpn1luc0LVD+CInAvrzLmL1sEdV22Iu9Lc16Cu8Z3TI2+
         Q4o58KwHKC2VcZFUvP9nXz6LFkPQ9ER/i+nVLXS4u54xAYYfCpVcbkOfKSIWg+HzYZqZ
         kfmLjetYR3qX5fyK4roueewXsrt5iEU5jZCG0=
MIME-Version: 1.0
In-Reply-To: <4DF63B7A.1030805@redhat.com>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
	<4df13cea27302b7ccf@agluck-desktop.sc.intel.com>
	<20110612223840.GA23218@aftab>
	<BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>
	<4DF5C36A.1040707@redhat.com>
	<20110613095521.GA26316@aftab>
	<4DF5F729.4060609@redhat.com>
	<20110613124003.GA27918@aftab>
	<4DF606C9.90308@redhat.com>
	<20110613151208.GA29045@aftab>
	<4DF63B7A.1030805@redhat.com>
Date: Mon, 13 Jun 2011 10:13:35 -0700
X-Google-Sender-Auth: 8oqQxl9zSFg_FnAuGndFokGv0bg
Message-ID: <BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
From: Tony Luck <tony.luck@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 9:31 AM, Avi Kivity <avi@redhat.com> wrote:
> I don't think a user_return_notifier is needed here.  You don't just want to
> do things before a userspace return, you also want to do them soon.  A user
> return notifier might take a very long time to run, if a context switch
> occurs to a thread that spends a lot of time in the kernel (perhaps a
> realtime thread).
>
> So I think the best choice here is MCE -> irq_work -> realtime kernel thread
> (or work queue)

In the AO (action optional case (e.g. patrol scrubber) - there isn't much rush.
We'd like to process things "soon" (before someone hits the corrupt location)
but we don't need to take extraordinary efforts to make "soon" happen.

In the AR (action required - instruction or data fetch from a corrupted
memory location) our main priority is making sure that we don't continue
the task that hit the error - because we don't want to hit it again (as Boris
said, on Intel cpus this is very disruptive to the system as every cpu is
sent the machine check signal - and the code has to read a large number
of slow "msr" registers to figure out what happened. If we can guarantee
that we won't run this task - then the time pressure is greatly reduced.

So if we can do:

  MCE -> irq_work -> make-task-not-runnable -> thread-or-work-queue

in a reliable way, then that would meet the needs.  PeterZ didn't like the
idea of setting TASK_STOPPED or _UNINTERRUPTIBLE in NMI
context in the MC handler - but I think he was okay with it inside the
irq_work handler.

-Tony
