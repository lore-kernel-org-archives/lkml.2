Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502Ab2BBWJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:09:00 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:18345 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933479Ab2BBWI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:08:59 -0500
Date: Thu, 2 Feb 2012 17:08:53 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
Message-ID: <20120202220853.GA13723@elliptictech.com>
References: <20120202200621.GB9279@leaf>
 <20120202202207.GA10041@elliptictech.com>
 <20120202211638.GA11308@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202211638.GA11308@leaf>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-02 13:16 -0800, Josh Triplett wrote:
> On Thu, Feb 02, 2012 at 03:22:07PM -0500, Nick Bowler wrote:
> > On 2012-02-02 12:06 -0800, Josh Triplett wrote:
> > > Documentation/CodingStyle recommends not splitting quoted strings across
> > > lines, because it breaks the ability to grep for the string.  checkpatch
> > > already makes an exception to the 80-column rule for quoted strings to
> > > allow this.  Rather than just allowing it, actively warn about quoted
> > > strings split across lines.
> > [...]
> > > +# Check for strings broken across lines (breaks greppability).  Make an
> > > +# exception when the previous string ends in a newline (multiple lines in one
> > > +# string constant) or \n\t (common in inline assembly to indent the instruction
> > > +# on the following line).
> > 
> > There are tons of strings in the kernel that this makes checkpatch warn
> > about where it probably shouldn't.  For example, this one (from
> > kernel/auditsc.c:1476):
> > 
> >   		audit_log_format(ab,
> >   			"oflag=0x%x mode=%#ho mq_flags=0x%lx mq_maxmsg=%ld "
> >   			"mq_msgsize=%ld mq_curmsgs=%ld",
> > 
> >   WARNING: quoted string split across lines
> >   #1478: FILE: auditsc.c:1478:
> >   +			"mq_msgsize=%ld mq_curmsgs=%ld",
> > 
> > Breaking "greppability" of this string is a non-issue, because this sort
> > of string is not really greppable to begin with (and would certainly not
> > be any easier to grep for if it were all on one line).
> 
> While I agree that in that particular case (heavy on the %formats and
> light on the text) you can't easily grep to begin with, the guideline
> from CodingStyle still applies,

The guideline from CodingStyle talks about "user-visible strings".  I
don't think this string counts, because it contains code that is not
displayed to the user (hence, the string is not user-visible).  That is
the reason why it's not greppable in the first place.

There are hundreds, if not thousands of similar strings in the kernel.

> as does the standard guideline about checkpatch (namely "don't go
> globally fixing everything it says, but fix it in new or changed
> code").
> 
> I certainly don't think joining those lines would *hurt*.

I disagree.  Joining those lines will push the conversion specifiers way
off to the right (possibly off the screen), and these specifiers are
vital to understanding the rest of the function parameters.  In other
words, the specifiers should be treated the same as actual *code*.

> Making that change blindly across the entire kernel doesn't seem worth
> it, but changing it on new code seems like a good idea.

For reasons that I've already outlined, I don't think it's a good idea
to change it in new code, either.

> In theory checkpatch could try to heuristically ignore cases where the
> split in the string occurs immediately before or after a %format, but I
> don't fancy writing a regex to match valid printf format specifiers. :)

It doesn't hurt to be conservative, erring on the side of not warning
(the status quo) rather than warning.  Regardless, writing a regex for
printf conversion specifiers should be straightforward, because the
format is so rigid.

Here's a perl regex which should match all the valid possibilities
according to ISO C99 (untested!).  Catching the Linux extensions is
left as an exercise to the reader.

 %[-+ #0]*(hh|ll|[ljztL])?[*[:digit:]]*(\.[*[:digit:]]*)?[diouxXfFeEgGaAcspn%]

> I still think this patch provides a net win, and I don't think the
> example you mentioned represents a false positive.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

