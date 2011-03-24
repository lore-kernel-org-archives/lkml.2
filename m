Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab1CXSXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:23:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39610 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1CXSXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:23:51 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=PRQypbUqLZAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=TLCSTjHGQZU57JiwCsEA:9 a=tE7DGJWGJbWKsce4GzfBmg6974kA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC] checkpatch: add option to change warning return value.
From: Steven Rostedt <rostedt@goodmis.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <20110324154010.GA863@xanatos>
References: <20110322231310.GA7338@xanatos> <20110322232246.GA7450@xanatos>
	 <20110323014117.GA15728@home.goodmis.org>  <20110324154010.GA863@xanatos>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 24 Mar 2011 14:23:49 -0400
Message-ID: <1300991029.14261.148.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 08:40 -0700, Sarah Sharp wrote:
> On Tue, Mar 22, 2011 at 09:41:17PM -0400, Steven Rostedt wrote:
> > On Tue, Mar 22, 2011 at 04:22:46PM -0700, Sarah Sharp wrote:
> > > > @@ -1096,6 +1099,9 @@ sub report {
> > > >  
> > > >  	push(our @report, $line);
> > > >  
> > > > +	if ($lazy == 1) {
> > > > +		return 0;
> > > > +	}
> > > >  	return 1;
> > > >  }
> > > >  sub report_dump {
> > 
> > Instead of this hunk, have:
> > 
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index 58848e3..54ec3d9 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -316,7 +316,7 @@ for my $filename (@ARGV) {
> >  	}
> >  	close($FILE);
> >  	if (!process($filename)) {
> > -		$exit = 1;
> > +		$exit = 1 if (!$lazy);
> >  	}
> >  	@rawlines = ();
> >  	@lines = ();
> 
> Hmm, but isn't that going to skip returning an exit value if there's an
> error as well?  I really do want it to fail if there's an error, just
> not if there's a warning.

Ah, I was a bit confused as you had report return 0, which is used by
both errors and warnings.

Would you want something like this:

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 58848e3..40cbc2f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1109,7 +1109,7 @@ sub ERROR {
 }
 sub WARN {
 	if (report("WARNING: $_[0]\n")) {
-		our $clean = 0;
+		our $clean = 0 if (!$lazy);
 		our $cnt_warn++;
 	}
 }

-- Steve


