Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab1EYXxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:53:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50730 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1EYXxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ROijzOWDAZfB4joAm35NgTMcu80pbefbHnilVa9cLY9VmURq+IXNo4mqLgxps5vg/9
         p1E2R5Njhue+adHIKbulFQMqK5SeIMDsVu8kbCgFtNB4c66R1ceBsOSkts0rpI/01auH
         HjpOhpyikjamqp7UBF058FUnf+ZVAqt3LVD+M=
MIME-Version: 1.0
In-Reply-To: <20110525134414.GB19118@elte.hu>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
	<20110524034023.GB25230@elte.hu>
	<987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
	<20110525134414.GB19118@elte.hu>
Date: Wed, 25 May 2011 16:53:10 -0700
X-Google-Sender-Auth: 0I1lcvQHTRduWXxyNgOS3ib3j4w
Message-ID: <BANLkTinAFL+KPZwBwH6f21Op_X9ZoVW2YQ@mail.gmail.com>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
From: Tony Luck <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/25 Ingo Molnar <mingo@elte.hu>:
> Well, the primary thing TIF_MCE_NOTIFY does is a roundabout way to
> iterate through repeat calls to memory_failure(), with all pfns that
> got buffered so far.
>
> We already have a generic facility to do such things at
> return-to-userspace: _TIF_USER_RETURN_NOTIFY.

This looked really promising as a way to drop one use of TIF_MCE_NOTIFY,
but it doesn't currently quite do what is needed for my new case.

What I need is a way to grab the current task just before it returns to user
space - what this code appears to do is to catch the current
*processor* just before
it sees a flagged process trying to return to user space.

These aren't quite the same ... if I use "user_return_notifier_register()" in
my machine check handler, what might happen is that entry_64.S
paranoid_userspace may see _TIF_NEED_RESCHED, and call schedule.
Now my "i don't want this to run" process could be picked up by a different
cpu that doesn't have the notifier registered.

The big clue was
     head = &get_cpu_var(return_notifier_list);
in fire_user_return_notifiers()


But I wonder if I'm misreading the code - I'm not quite certain
what the kvm code is trying to do when using this, but it looks
to me that it might also suffer from the resched and migrate to
another cpu possibility.

-Tony
