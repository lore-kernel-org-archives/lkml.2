Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab0IBKwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:52:35 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35089 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab0IBKwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:52:33 -0400
Date: Thu, 2 Sep 2010 11:52:29 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: add memset checks to checkpatch.pl
Message-ID: <20100902105229.GI2406@shadowen.org>
References: <20100818204016.GA29640@redhat.com>
 <1282167133.6724.165.camel@Joe-Laptop>
 <20100818214818.GA31094@redhat.com>
 <1282168679.6724.174.camel@Joe-Laptop>
 <20100818221721.GA2667@redhat.com>
 <1282174721.6724.202.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282174721.6724.202.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 04:38:41PM -0700, Joe Perches wrote:
> On Wed, 2010-08-18 at 18:17 -0400, Dave Jones wrote:
> > On Wed, Aug 18, 2010 at 02:57:59PM -0700, Joe Perches wrote:
> >  > > I'm all for improving my shoddy perl where possible, but this doesn't seem to actually
> >  > > catch any of the test cases I wrote.  (it's also missing a } )
> >  > I intend never to be a perl monk.
> >  > I notice the missing { before the elsif after I sent it.
> >  > Oh well.
> >  > I just typed it in the emailer, so it's not tested at all.
> >  > Also it's missing a $ after 1 in the second $memset_size test.
> > still didn't catch anything for me.
> >  > What are your test cases anyway?
> > 
> > memset(foo, 0, 10);
> > memset(foo, 10, 0);
> > memset(foo, 1, 10);
> > memset(foo, 10, 1);
> > 
> >  > Likely $Lval isn't matching things like
> >  > sizeof(*foo) so this isn't checked:
> >  > 
> >  > 	memset(foo, bar, sizeof(*foo));
> > 
> > I chose to just ignore any non integer arguments to keep things simple.
> 
> This seems to work.
> 
> I think $FuncArg is not great though.
> 
> Because $FuncArg uses $match_balanced_parens, the
> match list args are unexpected.
> 
> $2, $4, and $6 are the args of any memset argument
> that uses style func(args)
> 
> ie: memset(addr(foo), val(bar), sizeof(*foo))
> 
> Andy, what do you think?

Generally we deal with these by simplifying the contained bracketed
sections.  This allows simpler textual comparisons on the result.
Something like the patch below.  Perhaps you could test the version at
the URL below and see if that does what you expected:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw

commit 46e399ce79f2e76578a3208e901eb50727c1e95e
Author: Andy Whitcroft <apw@canonical.com>
Date:   Thu Sep 2 11:47:41 2010 +0100

    checkpatch: check for common memset parameter issues
    
    Add checks for 0 and 1 used as lengths.  Generally these indicate badly
    ordered parameters.
    
    Based on patches by Dave Jones <davej@redhat.com> and
    Joe Perches <joe@perches.com>.
    
    Signed-off-by: Andy Whitcroft <apw@canonical.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5c60e16..6da84cc 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2719,6 +2719,26 @@ sub process {
 			WARN("sizeof(& should be avoided\n" . $herecurr);
 		}
 
+# Check for misused memsets
+		if (defined $stat && $stat =~ /\bmemset\s*\((.*)\)/s) {
+			my $args = $1;
+
+			# Flatten any parentheses and braces
+			while ($args =~ s/\([^\(\)]*\)/10/s ||
+			       $args =~ s/\{[^\{\}]*\}/10/s ||
+			       $args =~ s/\[[^\[\]]*\]/10/s)
+			{
+			}
+			# Extract the simplified arguments.
+			my ($ms_addr, $ms_val, $ms_size) =
+						split(/\s*,\s*/, $args);
+                       if ($ms_size =~ /^(0x|)0$/i) {
+                               ERROR("memset uses second argument as constant byte value, not third.\n" . $herecurr);
+                       } elsif ($ms_size =~ /^(0x|)1$/i) {
+                               WARN("single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . $herecurr);
+                       }
+		}
+
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)
