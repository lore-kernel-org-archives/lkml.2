Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1HCTLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:11:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568Ab1HCTLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:11:47 -0400
Date: Wed, 3 Aug 2011 15:11:30 -0400
From: Don Zickus <dzickus@redhat.com>
To: ZAK Magnus <zakmagnus@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v3 2/2] Make hard lockup detection use timestamps
Message-ID: <20110803191130.GC1972@redhat.com>
References: <20110722195340.GF3765@redhat.com>
 <CAAuSN93tiSehpNXxjOgrq7oV-U+1ZPi2eqr+2dNSBG0yu0jxmA@mail.gmail.com>
 <20110725124451.GA2866@redhat.com>
 <CAAuSN93Qjk4eEAvm_Xn=O-0t+qhAyKmxy6HyPuyzJ35tX2u_CQ@mail.gmail.com>
 <20110729205538.GD14343@redhat.com>
 <CAAuSN93ouWrPn9xWb9Zd3E2Dp0hQxC4JmFH1utbyy1_aMnfkLA@mail.gmail.com>
 <20110801125234.GE14343@redhat.com>
 <CAAuSN92UAjuJXprBAj9z0sekk=iBWGe3PP88z8NmrZ5fExOyjg@mail.gmail.com>
 <20110801192407.GE2581@redhat.com>
 <CAAuSN92zxF9ZDuMhgrB_sBUrt+O4jGJ=AMe_iNMYSwXo9o79Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAuSN92zxF9ZDuMhgrB_sBUrt+O4jGJ=AMe_iNMYSwXo9o79Kw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 01:11:27PM -0700, ZAK Magnus wrote:
> On Mon, Aug 1, 2011 at 12:24 PM, Don Zickus <dzickus@redhat.com> wrote:
> > One idea I thought of to workaround this is to save the timestamp and the
> > watchdog bool and restore after the stack dump.  It's a cheap hack and I
> > am not to sure about the locking as it might race with
> > touch_nmi_watchdog().  But it gives you an idea what I was thinking.
> Yes, I see. Is the hackiness of it okay?

Hi,

I don't think it is too bad.  Most of the stuff is per_cpu and is intended
to be per_cpu.  There might be a random case where another cpu is trying
to zero out the watchdog_nmi_touch or watchdog_touch_ts variables.

I was trying to fix the cross-cpu case for watchdog_nmi_touch to eliminate
that problem but Ingo wanted me to implement some panic ratelimit first
(which I lost track of doing).  And being in the NMI context and staying
per_cpu should make that case safe I believe, despite the hackiness of it.

The watchdog_touch_ts is only called on another cpu in the
touch_all_softlockup_watchdogs() case, which only happens when the
scheduler is spewing stats currently.  This should happen rarely.  This
leaves the problem of softlockups being preempted in the interrupt
context and touched by another interrupt handler.  I don't know how to
solve this reliably but I think it should be ok most of the time.  The
only downside is a premature softlockup I would think.

I can't think of a better way to workaround the problem and still move
forward with your idea of warning on future stalls.

Then again I have been busy here and haven't put enough thought into it.

Cheers,
Don
