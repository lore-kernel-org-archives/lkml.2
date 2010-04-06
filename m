Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab0DFRen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:34:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42713 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab0DFRei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:34:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ftmoghHmA4HOdTilF0I088E3s4fEhXQiuYp1Tv8Pk1gBqCfNA+DehN85hPNBHVkMRa
         okkW+pSdQd/pev0kfAeNSIjyvcSzLm0AETdBXbyiqwelA8M+ZBjXmGvu8WIfaM2/hV2b
         bDVmKUqqLMAQUlcJISWU9xte0wDYvaJmm2FxE=
MIME-Version: 1.0
In-Reply-To: <20100406174459.60088461@lxorguk.ukuu.org.uk>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> 
	<4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com> 
	<4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com> 
	<4BBB36FA.4020008@redhat.com> <1270560931.1595.342.camel@laptop> 
	<20100406145128.6324ac9a@lxorguk.ukuu.org.uk> <4BBB531A.4070500@us.ibm.com> 
	<20100406174459.60088461@lxorguk.ukuu.org.uk>
From: Ulrich Drepper <drepper@gmail.com>
Date: Tue, 6 Apr 2010 10:34:08 -0700
Message-ID: <j2ia36005b51004061034p8c59ecag87c4d90660f33562@mail.gmail.com>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive 
	spinning
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 6, 2010 at 09:44, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> That gives you something along the lines of
>
>        runaddr = find_run_flag(lock);
>        do {
>                while(*runaddr == RUNNING) {
>                        if (trylock(lock))
>                                return WHOOPEE;
>                        cpu relax
>                }
>                yield (_on(thread));
>        } while(*runaddr != DEAD);

There still has to be an upper limit in the number of rounds of the
wait loop )some locks are held for a long time) since otherwise CPUs
are unnecessarily long tied up.  And the DEAD case is only for robust
mutex handling.  But in theory I agree.

We already have the set_tid_address syscall.  This could be
generalized with a new syscall which can provide the kernel with more
than one pointer to store "stuff" in: TIDs, scheduling info, etc.

The non-swappable part will be tricky.  One doesn't know how many
threads will be created in a process.  This mechanism shouldn't put an
arbitrary limit in place.  So where to allocate the memory?  Perhaps
it's better to implicitly mark the memory page pointed to by the new
syscall as non-swappable?  This could mean one page per thread...
