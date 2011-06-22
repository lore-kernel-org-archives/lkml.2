Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab1FVXZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 19:25:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878Ab1FVXZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 19:25:45 -0400
Date: Thu, 23 Jun 2011 01:25:32 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Nai Xia <nai.xia@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Izik Eidus <izik.eidus@ravellosystems.com>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
Message-ID: <20110622232532.GA20843@redhat.com>
References: <201106212055.25400.nai.xia@gmail.com>
 <201106212132.39311.nai.xia@gmail.com>
 <4E01C752.10405@redhat.com>
 <4E01CC77.10607@ravellosystems.com>
 <4E01CDAD.3070202@redhat.com>
 <4E01CFD2.6000404@ravellosystems.com>
 <4E020CBC.7070604@redhat.com>
 <BANLkTikidXPzyxySbmrXK=EUXOzqMtm-0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikidXPzyxySbmrXK=EUXOzqMtm-0g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 07:13:54AM +0800, Nai Xia wrote:
> I agree on this point. Dirty bit , young bit, is by no means accurate. Even
> on 4kB pages, there is always a chance that the pte are dirty but the contents
> are actually the same. Yeah, the whole optimization contains trade-offs and

Just a side note: the fact the dirty bit would be set even when the
data is the same is actually a pros, not a cons. If the content is the
same but the page was written to, it'd trigger a copy on write short
after merging the page rendering the whole exercise wasteful. The
cksum plays a double role, it both "stabilizes" the unstable tree, so
there's less chance of bad lookups, but it also avoids us to merge
stuff that is written to frequently triggering copy on writes, and the
dirty bit would also catch overwrites with the same data, something
the cksum can't do.
