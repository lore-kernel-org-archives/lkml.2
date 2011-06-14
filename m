Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1FNSCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:02:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51748 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1FNSCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:02:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OFohi+KipypyyU+myrO7NnwpaUbEM5tROU1cEdv8xk8wzcMsQy7VaDN7RAP1Si2IPD
         AXbRDrGl5YKZSqmHltxKocdPApz30UEQmm3tN0iv+9YJtXCYqO2cg4iYr3uhGy98i3UZ
         +Qq8RcjBo2lRsVeqHSsW86vmTyrDxx0HgHk7c=
MIME-Version: 1.0
In-Reply-To: <4DF6CD25.7040405@jp.fujitsu.com>
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
	<BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com>
	<4DF6CC58.8050601@jp.fujitsu.com>
	<4DF6CD25.7040405@jp.fujitsu.com>
Date: Tue, 14 Jun 2011 11:02:34 -0700
X-Google-Sender-Auth: GgZIvhIqoScIs-yJUrSjwha-NM8
Message-ID: <BANLkTina_Y5xekoE9SnbG125CVFLopym2A@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86, mce: rework use of TIF_MCE_NOTIFY
From: Tony Luck <tony.luck@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 7:53 PM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> + * Called in process context that interrupted by MCE and marked with
> + * TIF_MCE_NOTFY, just before returning to errorneous userland.
> + * This code is allowed to sleep.
> + * Attempt possible recovery such as calling the high level VM handler to
> + * process any corrupted pages, and kill/signal current process if required.
>  */
>  void mce_notify_process(void)
>  {
> -       mce_notify_irq();
> -       mce_memory_failure_process();
> +       clear_thread_flag(TIF_MCE_NOTIFY);
> +
> +       /* TBD: do recovery for action required event */
>  }

I liked where this series was going - but I'm not sure how we will
be able to write code to fill in the TBD here.  You've got us to
a good state ... the process that hit the action-required error
can't get to user space to re-execute because of TIF_MCE_NOTIFY.
So that part is great.  But ... we don't have the information we
need (failing address) to take some action. That was put into
the ring ... and it might still be there, but it could have been
grabbed and handled by the worker thread (???). So the error
might have been handled (or might be in the process of being
handled - we could be racing with the worker) - but we don't know.

I think that for action-required we need to pass the PFN from
the MC handler to this mce_notify_process() function. Andi
put it into the task structure - and although I didn't like that
much (and Ingo hated it even more) - it was a quite simple way
to pass the information.  The bad "pfn" *is* task relevant data.
It's the reason that the task can't run, and the only hope to get
the process back onto its feet again.

My detour into task-return-notifiers was a massively more
complex way to achieve this same goal (the pfn there was
dropped into the container structure for the "urn" pointer that
was passed to the handler.)

Maybe I'm missing something obvious - but I think that
to fix the action-required error - we need to know some more
about the error than which task is affected.

-Tony
