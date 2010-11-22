Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab0KVXvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 18:51:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757899Ab0KVXvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 18:51:24 -0500
Date: Mon, 22 Nov 2010 15:50:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
Message-Id: <20101122155043.fbbb74f4.akpm@linux-foundation.org>
In-Reply-To: <4CE268C8.5010203@panasas.com>
References: <1289421483-23907-1-git-send-email-segooon@gmail.com>
	<20101112120834.33062900.akpm@linux-foundation.org>
	<8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca>
	<20101114092533.GB5323@albatros>
	<20101114180643.593d19ac.akpm@linux-foundation.org>
	<1289848341.2607.125.camel@edumazet-laptop>
	<4CE268C8.5010203@panasas.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 13:19:36 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 11/15/2010 09:12 PM, Eric Dumazet wrote:
> > Le dimanche 14 novembre 2010 __ 18:06 -0800, Andrew Morton a __crit : 
> >> On Sun, 14 Nov 2010 12:25:33 +0300 Vasiliy Kulikov <segoon@openwall.com> wrote:
> >>>  
> >>>  	if (timeval) {
> >>> -		rtv.tv_sec = rts.tv_sec;
> >>> -		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
> >>> +		struct timeval rtv = {
> >>> +			.tv_sec = rts.tv_sec,
> >>> +			.tv_usec = rts.tv_nsec / NSEC_PER_USEC
> >>> +		};
> >>>  
> >>>  		if (!copy_to_user(p, &rtv, sizeof(rtv)))
> >>>  			return ret;
> >>
> >> Please check the assembly code - this will still leave four bytes of
> >> uninitalised stack data in 'rtv', surely.
> > 
> > Thats a good question.
> > 
> > In my understanding, gcc should initialize all holes (and other not
> > mentioned fields) with 0, even for automatic storage [C99 only mandates
> > this on static storage]
> > 
> > I tested on x86_64 and this is the case, but could not find a definitive
> > answer in gcc documentation.
> > 
> > This kind of construct is widely used in networking tree.
> > 
> > Maybe we should ask to gcc experts if this behavior is guaranteed by
> > gcc, or if we must review our code ;(
> > 
> > CC Jakub
> > 
> > Thanks !
> > 
> 
> This is what I thought too. If it is not there are tones of bugs I wrote
> of code that relays on this behaviour.
> 
> It would be interesting to know for sure

Well.  We certainly assume in many places that

	struct foo {
		int a;
		int b;
	} f = {
		.a = 1,
	};

will initialise b to zero.  But I doubt if much code at all assumes
that this initialisation patterm will reliably zero out *holes* in the
struct.

