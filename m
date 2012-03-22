Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2CVRRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:17:12 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:41950 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751124Ab2CVRRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:17:08 -0400
Date: Thu, 22 Mar 2012 13:17:02 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, apw@canonical.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
Message-ID: <20120322171702.GA27776@elliptictech.com>
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <4F6B51C9.6010904@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6B51C9.6010904@suse.cz>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-22 17:22 +0100, Jiri Slaby wrote:
> On 03/22/2012 04:27 PM, Phil Carmody wrote:
[...]
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
> parameters.

Nevertheless, an empty identifier list in a declaration is still not the
same as a parameter type list with (void).  In particular, the empty
identifier list *is not a prototype declaration for the function*.  That
means that arguments passed to the function are not subject to the usual
checks/conversions implied by a prototype.

Consider:

  int foo()
  {
     return 0;
  }

  int main(void)
  {
    return foo(1, 2, 3, 4, 5); /* this is syntactically OK; undefined
                                  behaviour at runtime. */
  }

GCC will not normally warn about the above (unless you pass
-Wold-style-definition) which warns for all function definitions that
lack a prototype.  On the other hand, changing it to int foo(void)
provides the required prototype for the arguments to be checked, and the
above becomes a proper error.

> So what you are trying to force here holds only for (forward)
> declarations. Not for functions with definitions (bodies). Is
> checkpatch capable to differ between those?

For the above reasons, non-prototype declarations of any sort should be
avoided.  No need for checkpatch to distinguish between whether or not
there's a function body.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

