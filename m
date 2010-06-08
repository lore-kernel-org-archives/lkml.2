Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0FHJNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:13:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53856 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0FHJNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:13:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=eWyEZqv0EVtl/D6okOaGE4sqcliDfNVNwy+h723n+hovfGS+F5BH47+bRuGo/ZX+W
	RtWyFV2WCZTbS7pKvE+EQ==
Date: Tue, 8 Jun 2010 02:13:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: kbuild: Fix the breakage caused by "improve version string
 logic"
In-Reply-To: <4C0DFFFF.1010704@panasas.com>
Message-ID: <alpine.DEB.2.00.1006080200190.18052@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
 <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com> <4C0DFFFF.1010704@panasas.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, Boaz Harrosh wrote:

> 
> The patch: 85a256d8e0116c8f5ad276730830f5d4d473344d
> 	Author: David Rientjes <rientjes@google.com>
> 	Title: kbuild: improve version string logic
> 
> Broke none Linus trees that supply their own version string and
> tag system via a presence of a localversion* file at the Kernel's
> root subdirectory.
> 
> After This patch. The "+" (plus) is not added if a localversion*
> file is present or a CONFIG_LOCALVERSION is configured.
> 

The only reason the `+' is being appended to your version string is 
because your scm is reporting that there have been commits to the tree 
since the last release; for git, that means anything that isn't at a 
tagged commit.

If you were to create a tarball of your tree, for instance, and distribute 
it to someone else, there would be no appended `+' because there is no 
revision history.  The `+' being appended simply implies that you're 
beyond the base kernel version in an scm.  The motivation is to be more 
descriptive about what kernel is being run: the most common case where 
this comes into play is when someone is running a kernel off of Linus' 
tree and a bug report incorrectly shows that it is a vanilla 2.6.35-rc2 
kernel, for instance.

When we discussed adding this indicator of revision history, we explicitly 
noted that the `+' is a modification of the base kernel version, not the 
entire string.

As mentioned previously, you can easily suppress that from being added by 
using "make LOCALVERSION=-foo" to create a 2.6.35-rc2-foo kernel when you 
do not have CONFIG_LOCALVERSION_AUTO enabled.  You already found that you 
cannot pass an empty LOCALVERSION string, so it must be something to 
identify itself as unique from vanilla 2.6.35-rc2.

The usecase that you've cited before is your colleagues pulling your git 
tree and then getting this `+' appended when they really don't want it.  
Although localversion* files are better than (ab)using the EXTRAVERSION 
variable in the Makefile, they won't suppress the `+' because your 
revision history shows that you're beyond a released (tagged) kernel.  The 
solution is to use git-tag to indicate your particular version of Linux 
that differentiates it from vanilla 2.6.35-rc2 and pass along your version 
information with either localversion* files or CONFIG_LOCALVERSION if you 
package your .config as well.
