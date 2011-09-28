Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1I1Cy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 22:54:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36859 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab1I1Cyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 22:54:55 -0400
MIME-Version: 1.0
In-Reply-To: <1317166589.19340.14.camel@Joe-Laptop>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
 <1316642115-20029-26-git-send-email-jim.cromie@gmail.com> <1316725066.29447.16.camel@Joe-Laptop>
 <CAJfuBxxZdNRZAix8ARUjqjNzrQeG2iVea_rMYKysOaX4c=Avig@mail.gmail.com> <1317166589.19340.14.camel@Joe-Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 27 Sep 2011 20:54:24 -0600
Message-ID: <CAJfuBxyZ63mi_onv8uWc3MCGgKDPfQMOgUOT7isJ-hA=o7sfqA@mail.gmail.com>
Subject: Re: [PATCH 25/26] dynamic_debug: add pr_fmt_dbg() for dynamic_pr_debug
To: Joe Perches <joe@perches.com>
Cc: jbaron@redhat.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 5:36 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2011-09-27 at 14:37 -0600, Jim Cromie wrote:
>>
>> Done. Only wrinkle is wrt pr_warning() vs pr_warn()
>> I added to your suggestion:
>> +#define pr_fmt_warn pr_fmt_warning
>>
>> the imperfection is that user has 4 combos of warn/warning
>> rather than 2 pairs, but the latter seems less defensible.
>
> I'd just use pr_fmt_warn.
>
> Instead of all this other extra stuff:
>

trouble is that pr_warn & pr_warning are synonyms,
and not having matching synonyms for pr_fmt_warn*
creates a few corner-case oddities that I think
somebody will trip over eventually.

Cleanest way is to drop the original synonym, and just use
warn (its shorter), but that creates some churn (havent grepped to see
how much).

I picked what looked like least effort & fewest corner-cases.
ICBW..


> What did you think of avoiding all of this and
> having __dynamic_pr_debug move the fmt pointer over
> any initial KBUILD_MODULE ": "
>
> int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
> {
> [...]
>        size_t modsize = strlen(descriptor->modname);
>        if (0 == strncmp(fmt, descriptor->modname, modsize) &&
>            0 == strncmp(fmt + modsize, ": ", 2))
>                fmt += modsize + 2;
>
>        vprintk(fmt, ...)
>
> ?

I was getting to that... ;-)

Im not crazy about it.  It feels like too much ..
Its a runtime workaround for what I think is a
problem in users' (or header's) #defines.

something like this would fix it at compile time,
similar to how I had it in dynamic-debug.h previously:

#if (CONFIG_DYNAMIC_DEBUG)
#define pr_fmt_debug(fmt) KBUILD_MODNAME ": " fmt
#endif
// defaulting to pr_fmt as given by user, or by printk.h

without dynamic-debug, pr_debug() would get same value
as as used by pr_info() etc.

With patchset as proposed, user needs to do the above
to get 'proper' output for both CONFIG_DYNAMIC_DEBUG=y/n.
It may be appropriate to do that in printk.h or dynamic_debug.h
TBDiscussed.

thanks
Jim
