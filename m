Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab2A3VHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:07:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34357 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab2A3VHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:07:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.145.210 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Tue, 31 Jan 2012 01:07:02 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch cr 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120130210702.GG4282@moon>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.309402052@openvz.org>
 <20120130125812.0075dd04@dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130125812.0075dd04@dt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 12:58:12PM -0700, Jonathan Corbet wrote:
> Just a couple of silly little things that came to mind while I was looking
> at the code...
> 
> > +/*
> > + * We don't expose real in-memory order of objects for security
> > + * reasons, still the comparision results should be suitable for
> > + * sorting. Thus, we obfuscate kernel pointers values (using random
> > + * cookies obtaned at early boot stage) and compare the production
> > + * instead.
> > + */
> > +static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
> > +
> > +static long kptr_obfuscate(long v, int type)
> > +{
> > +	return (v ^ cookies[type][0]) * cookies[type][1];
> > +}
> 
> I don't understand the purpose of this at all.  Obfuscation will cause a
> random shuffling in the ordering of the pointers - it's intended to - so
> how is the result "suitable for sorting"?  More to the point, is there
> ever a time when a user of this will care about some contrived ordering
> value?  It seems like equality is all that really matters.
> 

It won't be completely random shuffling but rather re-ordering in some
new order, which means the results might be passed to qsort or anything.
And yes, in c/r we need at least this "re-ordered" order which will help
to figure out shared file descriptors in case of huge number of files opened.

> > +
> > +/*
> > + * 0 - equal
> > + * 1 - less than
> > + * 2 - greater than
> > + * 3 - not equal but ordering unavailable (reserved for future)
> > + */
> > +static int kcmp_ptr(void *v1, void *v2, enum kcmp_type type)
> > +{
> > +	long ret;
> > +
> > +	ret = kptr_obfuscate((long)v1, type) - kptr_obfuscate((long)v2, type);
> > +
> > +	return (ret < 0) | ((ret > 0) << 1);
> > +}
> 
> That's a cute trick, but do we know that every compiler that will ever see
> this code will use 1 for a true integer comparison?  Simply spelling it
> out with an if statement might be more robust, just as efficient, and, at
> the same time, easier for others to understand.

Well, I believe if this become true, and (ret < 0) wont emit 1 -- the
number of places in kernel will be broken as well (for example see
math_div() function). But of course I don't insist and can rewrite
this code in straight fashion if needed.

	Cyrill
