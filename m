Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1FMQng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 12:43:36 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60996 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab1FMQne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 12:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=QF3qzNZvPZVHEXq74Qq7w0MV35yOsSLywI1/1zfq/q78agGAelh8uY+PHmpuOH/AiH
         PhdcL7O1NJy6UE8cWUb4QtN9WjU1FpQRR5vvCiN5qj0zxX7n6FFaf67rsbbuPrkC+jiH
         b7GIuZzNR639YGdVCc4Hl+wBa+iLGjv7Gmmf4=
MIME-Version: 1.0
In-Reply-To: <20110613124003.GA27918@aftab>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
	<4df13cea27302b7ccf@agluck-desktop.sc.intel.com>
	<20110612223840.GA23218@aftab>
	<BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>
	<4DF5C36A.1040707@redhat.com>
	<20110613095521.GA26316@aftab>
	<4DF5F729.4060609@redhat.com>
	<20110613124003.GA27918@aftab>
Date: Mon, 13 Jun 2011 09:43:33 -0700
X-Google-Sender-Auth: U500fju_YmE6NSmNXB7Qqy6xYzU
Message-ID: <BANLkTinLvotvcqGU6-OHe2Bj87r-YB_xzA@mail.gmail.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 5:40 AM, Borislav Petkov <bp@amd64.org> wrote:
> Well, in the ActionRequired case, the error is obviously reported
> through a #MC exception meaning that the core definitely generates the
> MCE before we've made a context switch (CR3 change etc) so in that case
> 'current' will point to the task at fault.
>
> The problem is finding which 'current' it is, from all the tasks running
> on all cores when the #MC is raised. Tony, can you tell from the hw
> which core actually caused the MCE? Is it the monarch, so to speak?

We can tell which cpu hit the problem by looking at MCG_STATUS register.
All the innocent bystanders who were dragged into this machine check will
have the RIPV bit set and EIPV bit clear (SDM Vol 3A, Table 15-20 in section
15.3.9.2).  With my patch to re-order processing this will usually be the
monarch (though it might not be if more that one cpu has RIPV==0).

> I'm thinking that in cases were we have a page shared by multiple
> processes, we still would want to run a 'main' user return notifier on
> one core which does the rmap lookup _but_, _also_ very importantly, the
> other cores still hold off from executing userspace until that main
> notifier hasn't finished finding out how big the fallout is,i.e. how
> many other processes would run into the same page.

I don't think that we have any hope of fixing the "multiple processes
about to hit the same page" problem. We can't track down all the users
from the MC handler (because the data structures may be in the process
of being changed by some threads that we in the kernel at the time of the
machine check).  Our only hope to solve this would be to let all the kernel
threads return from the MC handler - with a self-IRQ to grab them back
into our clutches when they get out of any critical sections.

But that sounds like something to defer to "phase N+1" after we have
solved all the easier cases.

-Tony
