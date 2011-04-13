Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab1DMUgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:36:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53690 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1DMUgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:36:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W6NjzFLfYvqcwWy2YW/25Mg5GNaw9TytF1s2qmgQI2uBjHUSnAmAAanRgLCuMtWYIs
         y99gVVn2O8R52tDNknBP7ie/KGkbj9vM6Kwo4Gl4zOlZLG51xerBoNEXU20DikZTBYl9
         YGzF6BF8H2AizYSrvLnZcjacATmcpPm2+ztUg=
Date: Wed, 13 Apr 2011 23:36:08 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        behlendorf1@llnl.gov
Subject: Re: [PATCH] remove abs64()
Message-ID: <20110413203608.GA4284@p183>
References: <20110412210045.GA19901@p183>
 <20110413142703.GA1511@redhat.com>
 <20110413114808.12783565.akpm@linux-foundation.org>
 <20110413202031.GA19113@redhat.com>
 <20110413132629.6111f7f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413132629.6111f7f2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 01:26:29PM -0700, Andrew Morton wrote:
> On Wed, 13 Apr 2011 22:20:31 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > > > But, we have some stupid users which do something like abs(u32_value)
> > > > and expecting that abs() should treat this value as "signed".
> > > >
> > >
> > > um, yes, I'd forgotten that one.  That's a show-stopper.
> > 
> > May be we can demand to fix them?
> > 
> > I agree with Alexey, it is a bit ugly to have abs() and abs64(), and abs()
> > itself doesn't look very nice.
> > 
> > What if we simply add
> > 
> > 	BUILD_BUG_ON( (typeof(_x)-1) > 0 );
> > 
> > into abs()?
> > 
> > After that it would be trivial to find the offenders and fix them,
> > 
> > 	- abs(unsigned_int)
> > 	+ abs((int) unsigned_int)
> 
> Something like that.  But it should be done before we change abs(), to
> avoid nasty breakage in obscure places.
> 
> Or we rework the abs() implementation so that the abs(unsigned)
> behavior is unchanged.
> 
> There will remain the problem that the abs() return value's signedness
> has changed.

Maybe I can sneak in kabs() ang gradually convert?

Reading abs(3) manpage, it returns int minumum, so semantic change
notice would be nice.

Anyway patch as posted was buggy in the following sense:

	_b_t_c_p(char, signed char) == 0

		AND
	
	_b_t_c_p(char, unsigned char) == 0

so if char is signed, it doesn't work.
