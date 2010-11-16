Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab0KPSpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:45:18 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:32914 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab0KPSpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:45:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tFlGtGOp9AIOBmmA5o304Egk4kIjbvJwJDtCLc9fFOfdUyAqRTuMEJ30QbNhu3TMrf
         sKo0Z9IiVlSOQuKiHUldCpXEUmk/nEdG0dY8MRiauHYUyDNK3rurtMA89Y6/6za08Yo5
         CMWPLLzYUHnZMMnmJxPbu+leOi5pAMQJLf3bQ=
Date: Tue, 16 Nov 2010 21:45:09 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
Message-ID: <20101116184509.GA7336@albatros>
References: <1289421483-23907-1-git-send-email-segooon@gmail.com>
 <20101112120834.33062900.akpm@linux-foundation.org>
 <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca>
 <20101114092533.GB5323@albatros>
 <20101114180643.593d19ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101114180643.593d19ac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 18:06 -0800, Andrew Morton wrote:
> On Sun, 14 Nov 2010 12:25:33 +0300 Vasiliy Kulikov <segoon@openwall.com> wrote:
> 
> > On some architectures __kernel_suseconds_t is int.  On these archs
> > struct timeval has padding bytes at the end.  This struct is copied to
> > userspace with these padding bytes uninitialized.  This leads to leaking
> > of contents of kernel stack memory.
> > 
> > Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> > ---
> >  Patch v1 used memset(), it was waste of cycles on almost all archs.
> > 
> >  Compile tested.
> > 
> >  fs/select.c |    7 ++++---
> >  1 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/select.c b/fs/select.c
> > index b7b10aa..43d4805 100644
> > --- a/fs/select.c
> > +++ b/fs/select.c
> > @@ -288,7 +288,6 @@ static int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
> >  				      int timeval, int ret)
> >  {
> >  	struct timespec rts;
> > -	struct timeval rtv;
> >  
> >  	if (!p)
> >  		return ret;
> > @@ -306,8 +305,10 @@ static int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
> >  		rts.tv_sec = rts.tv_nsec = 0;
> >  
> >  	if (timeval) {
> > -		rtv.tv_sec = rts.tv_sec;
> > -		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
> > +		struct timeval rtv = {
> > +			.tv_sec = rts.tv_sec,
> > +			.tv_usec = rts.tv_nsec / NSEC_PER_USEC
> > +		};
> >  
> >  		if (!copy_to_user(p, &rtv, sizeof(rtv)))
> >  			return ret;
> 
> Please check the assembly code - this will still leave four bytes of
> uninitalised stack data in 'rtv', surely.

This concrete c code generates movl + movq, movl would zero unnamed
4 bytes.  However, I cannot find whether this behavior is guaranteed...

-- 
Vasiliy Kulikov
