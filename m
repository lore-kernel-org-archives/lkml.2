Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab2CVRf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:35:56 -0400
Received: from smtp.nokia.com ([147.243.128.26]:29306 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab2CVRfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:35:55 -0400
Date: Thu, 22 Mar 2012 19:32:10 +0200
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Jiri Slaby <jslaby@suse.cz>
Cc: apw@canonical.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
Message-ID: <20120322173210.GD19970@pcarmody2.research.nokia.com>
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <4F6B51C9.6010904@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6B51C9.6010904@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/03/12 17:22 +0100, ext Jiri Slaby wrote:
> On 03/22/2012 04:27 PM, Phil Carmody wrote:
> > After HPA's wonderful lkml post, referenced, it seems worth trying to
> > detect this robomatically.
> > 
> > Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> > ---
> >  scripts/checkpatch.pl |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index a3b9782..3993011 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -1881,6 +1881,10 @@ sub process {
> >  				substr($ctx, 0, $name_len + 1, '');
> >  				$ctx =~ s/\)[^\)]*$//;
> >  
> > +				if ($ctx =~ /^\s*(?:\.\.\.)?\s*$/) {
> > +					# HPA explains why: http://lwn.net/Articles/487493/
> > +					ERROR("(...) and () are not sufficiently informative function declarations\n$hereline");
> > +				}
> 
> That explanation is not fully correct. C99 explicitly says (6.7.5.3.14):
> An identifier list declares only the identifiers of the parameters of
> the function. An empty list in a function declarator that is part of a
> definition of that function specifies that the function has no
> parameters. The empty list in a function declarator that is not part of
> a definition of that function specifies that no information about the
> number or types of the parameters is supplied.
>
> So what you are trying to force here holds only for (forward)
> declarations. Not for functions with definitions (bodies). Is checkpatch
> capable to differ between those?

Damn good catch. I will admit that my first attempt was practically
identical to RW's (which I hadn't seen, LKML moves too quickly for me
to follow), but when I searched around for 'declaration' I came across
the above location, and it seemed more appropriate. Does the earlier
patch have the same issue? I presume it does given that the comment is
"""
Functions like this one are evil:

void foo()
{
	...
}
"""

I did a quick grep of the code, and there are few instances of
definitions with no parameters compared to the number with (void). It
might be bold, but could one say that from a _style_ (rather than
correctness) perspective, migrating everyone towards (void) everywhere
is a good thing?

However, if not, all is not lost - even if we don't know the full 
context, the existence of a semicolon after the () might be enough
to be useful.

I can re-bodge with a semicolon if noone offers more info about 
checkpatch.pl's knowledge of context, and uniformity of style is
not considered positive in these situations.

Thanks all for your input,
Phil
