Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3ACSiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 13:38:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab3ACSiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 13:38:01 -0500
Date: Thu, 3 Jan 2013 19:36:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tty: Only wakeup the line discipline idle queue when
	queue is active
Message-ID: <20130103183611.GA28225@redhat.com>
References: <1355842130-15482-1-git-send-email-meltedpianoman@gmail.com> <50E3FDFA.4070203@suse.cz> <20130102114311.66215bf5@pyramind.ukuu.org.uk> <CAMSQXEHmDb5rUQnT1JNcMCzdaN+gAr+1hR=PyPiDMu7vK5ykxA@mail.gmail.com> <50E4854E.8060801@suse.cz> <CAMSQXEGU2WmhmMqP7XMK2x39GN9iDDWpg-Wa7_cAauHWx5OWbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMSQXEGU2WmhmMqP7XMK2x39GN9iDDWpg-Wa7_cAauHWx5OWbQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03, Ivo Sieben wrote:
>
> Oleg, Peter, Ingo, Andi & Preeti,
>
> 2013/1/2 Jiri Slaby <jslaby@suse.cz>:
> > On 01/02/2013 04:21 PM, Ivo Sieben wrote:
> >> I don't understand your responses: do you suggest to implement this
> >> "if active" behavior in:
> >> * A new wake_up function called wake_up_if_active() that is part of
> >> the waitqueue layer?
> >
> > Sounds good.
> >
> > --
> > js
> > suse labs
>
> I want to ask you 'scheduler' people for your opinion:
>
> Maybe you remember my previous patch where I suggested an extra
> 'waitqueue empty' check before entering the critical section of the
> wakeup() function (If you do not remember see
> https://lkml.org/lkml/2012/10/25/159)
>
> Finally Oleg responded that a lot of callers do
>
> 	if (waitqueue_active(q))
> 		wake_up(...);
>
> what made my patch pointless and adds a memory barrier.

Plus this change doesn't look 100% correct, at least in theory.

> I then decided
> to also implement the 'waitqueue_active' approach for my problem.

Well, if you ask me I think this is the best solution ;)

But I won't insist.

> But now I get a review comment by Jiri that he would like to hide this
> 'if active behavior' in a wake_up_if_active() kind of function. I
> think he is right that implementing this check in the wakeup function
> would clean things up, right?
>
> I would like to have your opinion on the following two suggestions:
> - We still can do the original patch on the wake_up() that I
> suggested. I then can do an additional code cleanup patch that removes
> the double 'waitqueue_active' call (a quick grep found about 150 of
> these waitqueue active calls) on several places in the code.

In this case we should also fix some users of add_wait_queue().

> - Or - as an alternative - I could add extra _if_active() versions of
> all wake_up() functions, that implement this extra test.

Not sure this will actually help to make the code cleaner. The last
patch you sent looks simple and clean. IMHO it doesn't make sense
to create _if_active helper for each wake_up*.

Oleg.

