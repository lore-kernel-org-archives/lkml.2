Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab1JDTfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:35:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34682 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932752Ab1JDTfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:35:51 -0400
Subject: Re: [RFCv3][PATCH 1/4] replace string_get_size() arrays
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com
In-Reply-To: <1317497626.22613.1.camel@Joe-Laptop>
References: <20111001000856.DD623081@kernel>
	 <1317497626.22613.1.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 12:35:42 -0700
Message-ID: <1317756942.7842.38.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-01 at 12:33 -0700, Joe Perches wrote:
> On Fri, 2011-09-30 at 17:08 -0700, Dave Hansen wrote:
> > Instead of explicitly storing the entire string for each
> > possible units, just store the thing that varies: the
> > first character.
> 
> trivia

I'm not sure what you mean by that.

> > diff -puN lib/string_helpers.c~string_get_size-pow2 lib/string_helpers.c
> > --- linux-2.6.git/lib/string_helpers.c~string_get_size-pow2	2011-09-30 16:50:31.628981352 -0700
> > +++ linux-2.6.git-dave/lib/string_helpers.c	2011-09-30 17:04:02.211607364 -0700
> > @@ -8,6 +8,23 @@
> >  #include <linux/module.h>
> >  #include <linux/string_helpers.h>
> >  
> > +static const char byte_units[] = "_KMGTPEZY";
> 
> u64 could be up to ~1.8**19 decimal
> zetta and yotta are not possible or necessary.
> u128 maybe someday, but then other changes
> would be necessary too.

Right, but we're only handling u64.

> > +static char *__units_str(enum string_size_units unit, char *buf, int index)
> > +{
> > +	int place = 0;
> > +
> > +	/* index=0 is plain 'B' with no other unit */
> > +	if (index) {
> > +		buf[place++] = byte_units[index];
> 
> index is unbounded (doesn't matter currently, it will for u128)

It's bound by the division or the log2 at least.  You do have to know
what you're passing in to __units_str, just like you had to know what
you were indexing with in to units_2[] and units_10[].

Is there something else you'd like to see done here?  We can
bounds-check index, but that seems a bit unnecessary since it's static
and the two callers are visible on the same page of code.

> > @@ -23,26 +40,19 @@
> >  int string_get_size(u64 size, const enum string_size_units units,
> >  		    char *buf, int len)
> []
> >  	const unsigned int divisor[] = {
> >  		[STRING_UNITS_10] = 1000,
> >  		[STRING_UNITS_2] = 1024,
> >  	};
> 
> static const or it might be better to use
> 	unsigned int divisor = (string_size_units == STRING_UNITS_2) ? 1024 : 1000;
> as that would make the code clearer in a
> couple of uses of divisor[] later.
> 
> > @@ -61,7 +71,7 @@ int string_get_size(u64 size, const enum
> >  	}
> >  
> >  	snprintf(buf, len, "%lld%s %s", (unsigned long long)size,
> 
> %llu

These two are about existing code, and not really necessary for this
set.  They'd make good follow-on patches, though.

-- Dave

