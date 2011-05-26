Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab1EZUQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:16:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33543 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab1EZUQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=jSVZpsA+vYPBGGAcxHbU/Vre4PkVqXLiFCzs1x1LjP9Yo2wFo8Ewg+Ij3eujcqzfkX
         Dn1lHn9RWvrm1OVHdzt5hWjklPrD97VnAd+Iqaa2v5MYuGGsx9kO8WmAGyzTsJqjCdyr
         RvV8DmM6RxilJRIy2N/DrGyQgu2nOhpx5b+DM=
MIME-Version: 1.0
In-Reply-To: <BANLkTinAFL+KPZwBwH6f21Op_X9ZoVW2YQ@mail.gmail.com>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
	<20110524034023.GB25230@elte.hu>
	<987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
	<20110525134414.GB19118@elte.hu>
	<BANLkTinAFL+KPZwBwH6f21Op_X9ZoVW2YQ@mail.gmail.com>
Date: Thu, 26 May 2011 13:16:11 -0700
X-Google-Sender-Auth: bwP0mqfBCgX8bqjefUmGZ1ktaVE
Message-ID: <BANLkTi=pKs8a=gyo_NW7ubFY6is0VrDfbQ@mail.gmail.com>
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

2011/5/25 Tony Luck <tony.luck@intel.com>:
> But I wonder if I'm misreading the code - I'm not quite certain
> what the kvm code is trying to do when using this, but it looks
> to me that it might also suffer from the resched and migrate to
> another cpu possibility.

I didn't notice propagate_user_return_notify() ... which runs during
context switch to move TIF_USER_RETURN_NOTIFY from the
old process to the next one.  This deals with the resched problem.

So this really is an "execute this function when the next task
tries to return to user mode" without any regard to *which* task
is being piggy-backed.  It might be the one for which we first set
TIF_USER_RETURN_NOTIFY, or it might be some totally different
task many context switches later (if we happen to run a bunch of
kernel daemons that don't return to user mode).

This could work for the current usage of TIF_MCE_NOTIFY (which
looks like it is just trying to get some task to push the error logs
along their path to /dev/mcelog, and process any "action optional"
faults that have recorded page numbers of memory that needs to
be looked at, but for which there is no rush.

But it doesn't work for the "action required" case where I need to
stop the task that hit the error from running, and figure out the
virtual address that it is using to map the physical address that
the h/w reported as having an error.  To get this behavior I'd need
the list of functions to call have its head in the task structure (so
the list is attached to a specific task). But I'd need another TIF
bit (unless I can re-purpose TIF_MCE_NOTIFY). It would get rid
of the task->mce_error_pfn (since I'd pass parameters in the
structure that is the container of the one that links onto the list).

Would such a change be worth prototyping?

-Tony
