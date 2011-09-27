Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1I0Xgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:36:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37023 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750803Ab1I0Xga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:36:30 -0400
Message-ID: <1317166589.19340.14.camel@Joe-Laptop>
Subject: Re: [PATCH 25/26] dynamic_debug: add pr_fmt_dbg() for
 dynamic_pr_debug
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Date: Tue, 27 Sep 2011 16:36:29 -0700
In-Reply-To: <CAJfuBxxZdNRZAix8ARUjqjNzrQeG2iVea_rMYKysOaX4c=Avig@mail.gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
	 <1316642115-20029-26-git-send-email-jim.cromie@gmail.com>
	 <1316725066.29447.16.camel@Joe-Laptop>
	 <CAJfuBxxZdNRZAix8ARUjqjNzrQeG2iVea_rMYKysOaX4c=Avig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.92- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 14:37 -0600, Jim Cromie wrote:
> On Thu, Sep 22, 2011 at 2:57 PM, Joe Perches <joe@perches.com> wrote:
> > On Wed, 2011-09-21 at 15:55 -0600, jim.cromie@gmail.com wrote:
> >> dynamic_pr_debug can add module, function, file, and line selectively,
> > []
> >> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> > []
> >> +#ifndef pr_fmt_dbg
> >> +#define pr_fmt_dbg(fmt) fmt
> >> +#endif
> > []
> >> +#ifndef pr_fmt_dbg
> >> +#define pr_fmt_dbg(fmt) pr_fmt(fmt)
> >> +#endif
> >
> > This might better be placed in printk.h just
> > once.
> >
> 
> yes.  it seems to work smoothly.
> Only minor annoyance is having to put local defns
> above the #includes, but thats no different than previously.
> 
> 
> > I think pr_fmt_debug is better than pr_fmt_dbg
> > because the function/macro is named pr_debug.
> 
> Ok.  Done.
> 
> > Maybe add all the pr_<level> variants too because
> > some like to prefix __func__ to pr_err but not pr_info
> > etc.
> >
> 
> Done. Only wrinkle is wrt pr_warning() vs pr_warn()
> I added to your suggestion:
> +#define pr_fmt_warn pr_fmt_warning
> 
> the imperfection is that user has 4 combos of warn/warning
> rather than 2 pairs, but the latter seems less defensible.

I'd just use pr_fmt_warn.

Instead of all this other extra stuff:

What did you think of avoiding all of this and
having __dynamic_pr_debug move the fmt pointer over
any initial KBUILD_MODULE ": "

int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
{
[...]
	size_t modsize = strlen(descriptor->modname);
	if (0 == strncmp(fmt, descriptor->modname, modsize) &&
	    0 == strncmp(fmt + modsize, ": ", 2))
		fmt += modsize + 2;
	
	vprintk(fmt, ...)

?

