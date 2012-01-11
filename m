Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab2AKXPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 18:15:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2AKXPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 18:15:46 -0500
Date: Wed, 11 Jan 2012 15:15:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -mm] make swapin readahead skip over holes
Message-Id: <20120111151545.4636bc49.akpm@linux-foundation.org>
In-Reply-To: <CAHGf_=qtpA5VTw5W0zaAhB2WCX1+-k59szTnDLnqDJeg+q9Jsw@mail.gmail.com>
References: <20120109181023.7c81d0be@annuminas.surriel.com>
	<4F0B7D1F.7040802@gmail.com>
	<4F0BABE0.8080107@redhat.com>
	<CAHGf_=qtpA5VTw5W0zaAhB2WCX1+-k59szTnDLnqDJeg+q9Jsw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012 02:14:32 -0500
KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> > Another factor is that swapping on modern systems is often a
> > temporary thing. During a load spike, things get swapped out
> > and run slowly. After the load spike is over, or some memory
> > hog process got killed, we want the system to recover to normal
> > performance as soon as possible. __This often involves swapping
> > everything back into memory.
> 
> Hmmm.... OK, I have to agree this.
> But if so, to skip hole is not best way. I think we should always makes
> one big IO, even if the swap cluster have some holes. one big IO is
> usually faster than multiple small IOs. Isn't it?

Not necessarily.  If we have two requests in the disk for blocks 0-3
and 8-11, one would hope that the disk is smart enough to read both
blocks within a single rotation.

If the kernel were to recognise this situation and request the entire
12 blocks then we'd see lower command overhead but higher transfer
costs.

Still, Rik's testing shows that either approach would be superior to
what we have at present, which is to not read blocks 8-11 at all!


It sounds like Rik will be doing a v2 with some minor updates?
