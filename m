Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2JDNLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:11:06 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:53438 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab2JDNLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:11:05 -0400
Date: Thu, 4 Oct 2012 15:11:01 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty_init_dev: 24 callbacks suppressed
Message-ID: <20121004131101.GA245@x4>
References: <20121004092055.GA21028@aftab.osrc.amd.com>
 <20121004112347.GA245@x4>
 <20121004115157.GA245@x4>
 <20121004124025.GC21028@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004124025.GC21028@aftab.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.10.04 at 14:40 +0200, Borislav Petkov wrote:
> On Thu, Oct 04, 2012 at 01:51:57PM +0200, Markus Trippelsdorf wrote:
> > diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
> > index e11ccb4..d8de255 100644
> > --- a/include/linux/ratelimit.h
> > +++ b/include/linux/ratelimit.h
> > @@ -46,20 +46,17 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
> >  #define WARN_ON_RATELIMIT(condition, state)			\
> >  		WARN_ON((condition) && __ratelimit(state))
> >  
> > -#define __WARN_RATELIMIT(condition, state, format...)		\
> > -({								\
> > -	int rtn = 0;						\
> > -	if (unlikely(__ratelimit(state)))			\
> > -		rtn = WARN(condition, format);			\
> > -	rtn;							\
> > -})
> > -
> > -#define WARN_RATELIMIT(condition, format...)			\
> > +#define WARN_RATELIMIT(condition, fmt, ...)			\
> >  ({								\
> >  	static DEFINE_RATELIMIT_STATE(_rs,			\
> >  				      DEFAULT_RATELIMIT_INTERVAL,	\
> >  				      DEFAULT_RATELIMIT_BURST);	\
> > -	__WARN_RATELIMIT(condition, &_rs, format);		\
> > +	int rtn = !!(condition);				\
> > +								\
> > +	if (unlikely(rtn && __ratelimit(&_rs)))		\
> > +		WARN(rtn, fmt, ##__VA_ARGS__);			\
> > +								\
> > +	rtn;							\
> >  })
> 
> Aha, I see it. We need to look at the condition before the __ratelimit,
> otherwise we WARN unnecessarily, good catch.
> 
> >  #else
> > @@ -67,15 +64,9 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
> >  #define WARN_ON_RATELIMIT(condition, state)			\
> >  	WARN_ON(condition)
> >  
> > -#define __WARN_RATELIMIT(condition, state, format...)		\
> > -({								\
> > -	int rtn = WARN(condition, format);			\
> > -	rtn;							\
> > -})
> > -
> > -#define WARN_RATELIMIT(condition, format...)			\
> > +#define WARN_RATELIMIT(condition, fmt, ...)			\
> 
> ... except this change is unrelated and unneeded - there's enough room
> in 80 cols to leave it as "format" instead of shortening it.
> 
> Other than that:
> 
> Acked-and-tested-by: Borislav Petkov <borislav.petkov@amd.com>

I'll let Jiri handle this :). It's his patch anyway.

-- 
Markus
