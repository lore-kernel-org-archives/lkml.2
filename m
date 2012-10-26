Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966129Ab2JZTQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:16:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47133 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933966Ab2JZTQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:16:36 -0400
MIME-Version: 1.0
In-Reply-To: <508ADD2F.6030805@redhat.com>
References: <20121025121617.617683848@chello.nl> <20121025124832.840241082@chello.nl>
 <CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com>
 <5089F5B5.1050206@redhat.com> <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com>
 <508A0A0D.4090001@redhat.com> <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com>
 <CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com>
 <m2pq45qu0s.fsf@firstfloor.org> <508A8D31.9000106@redhat.com>
 <20121026132601.GC9886@gmail.com> <20121026144615.2276cd59@dull>
 <CA+55aFyS_iJcKz=-zSDK+bjYiNeEzy4T5FrrGL8HBsxTOSwpJQ@mail.gmail.com> <508ADD2F.6030805@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Oct 2012 12:16:14 -0700
X-Google-Sender-Auth: t_R8Q-HydGymzJRIBsb2UHJPFAo
Message-ID: <CA+55aFxo5jHREHS_ftmM6Vy5+rei2KzzCbrsYJwqSB2TfvA=7w@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm,generic: only flush the local TLB in ptep_set_access_flags
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 11:57 AM, Rik van Riel <riel@redhat.com> wrote:
>
> It looks like do_wp_page also sets the write bit in the pte
> "entry" before passing it to ptep_set_access_flags, making
> that the place where the write bit is set in the pte.
>
> Is this a bug in do_wp_page?

Hmm. Right you are. That's indeed worth noting that it can indeed
change access permissions in that particular way (ie enabling writes).

So yeah, good catch. And it's ok to add the writeable bits like this
(and it can't race with hardware like the dirty bit can, since
hardware never sets writability).

In fact, it should probably be documented in the source code
somewhere. In particular, there's a very subtle requirement that you
can only set the writable bit if the dirty bit is also set at the same
time, for example.

                 Linus
