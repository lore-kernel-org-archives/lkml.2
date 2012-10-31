Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935428Ab2JaLQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:16:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933211Ab2JaLQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:16:40 -0400
Date: Wed, 31 Oct 2012 04:16:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Janne Kulmala <janne.t.kulmala@tut.fi>
Cc: Stefani Seibold <stefani@seibold.net>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kfifo: round up the fifo size power of 2
Message-Id: <20121031041626.0011c748.akpm@linux-foundation.org>
In-Reply-To: <5090DD1A.8010801@tut.fi>
References: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
	<20121029135935.bb8b0b2a.akpm@linux-foundation.org>
	<20121031055916.GC29509@yliu-dev.sh.intel.com>
	<1351665033.23165.6.camel@wall-e>
	<20121030235210.4dfc6ef7.akpm@linux-foundation.org>
	<5090DD1A.8010801@tut.fi>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012 10:11:06 +0200 Janne Kulmala <janne.t.kulmala@tut.fi> wrote:

> On 10/31/2012 08:52 AM, Andrew Morton wrote:
> > On Wed, 31 Oct 2012 07:30:33 +0100 Stefani Seibold <stefani@seibold.net> wrote:
> >
> >>> Yes, and I guess the same to give them a 64-element one.
> >>>
> >>>>
> >>>> If there's absolutely no prospect that the kfifo code will ever support
> >>>> 100-byte fifos then I guess we should rework the API so that the caller
> >>>> has to pass in log2 of the size, not the size itself.  That way there
> >>>> will be no surprises and no mistakes.
> >>>>
> >>>> That being said, the power-of-2 limitation isn't at all intrinsic to a
> >>>> fifo, so we shouldn't do this.  Ideally, we'd change the kfifo
> >>>> implementation so it does what the caller asked it to do!
> >>>
> >>> I'm fine with removing the power-of-2 limitation. Stefani, what's your
> >>> comment on that?
> >>>
> >>
> >> You can't remove the power-of-2-limitation, since this would result in a
> >> performance decrease (bit wise and vs. modulo operation).
> >
> > Probably an insignificant change in performance.
> >
> > It could be made much smaller by just never doing the modulus operation
> > - instead do
> >
> > 	if (++index == max)
> > 		index = 0;
> >
> 
> This can not be done, since the index manipulation kfifo does not use locks.

Oh come on.  Look:

                        __kfifo->out++; \

and look:

 * Note that with only one concurrent reader and one concurrent
 * writer, you don't need extra locking to use these macro.


