Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1HZRAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 13:00:17 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:47918 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753280Ab1HZRAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 13:00:14 -0400
Date: Fri, 26 Aug 2011 10:00:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Mimi Zohar <zohar@us.ibm.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 22 (evm)
Message-Id: <20110826100011.9213d872.rdunlap@xenotime.net>
In-Reply-To: <1314362342.3224.19.camel@localhost.localdomain>
References: <20110822145304.980529cb921e5f1321c622da@canb.auug.org.au>
	<20110822125355.bb01d76b.rdunlap@xenotime.net>
	<CACqU3MVjg60pTPyNWm+41w144QzPgtHQ4wZPUUV=vok8gGffuQ@mail.gmail.com>
	<20110822174958.73dd96c7.rdunlap@xenotime.net>
	<1314065358.3225.44.camel@localhost.localdomain>
	<20110823164035.ca28fdc6.rdunlap@xenotime.net>
	<CACqU3MWfKji5BcGRmwO_Y4_15oOq7Trw3u6j1g2meFAaG-s9-w@mail.gmail.com>
	<1314362342.3224.19.camel@localhost.localdomain>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 08:39:02 -0400 Mimi Zohar wrote:

> On Tue, 2011-08-23 at 22:10 -0400, Arnaud Lacombe wrote:
> > Hi,
> > 
> > On Tue, Aug 23, 2011 at 7:40 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > > I think that you are going to need to do something like Arnaud suggested
> > > and use "depends on TCG_TPM=y" instead of just "depends on TCG_TPM",
> > > unless you can convince someone that this is a kconfig bug.
> > >
> > dammit... I guess there is...
> > 
> > If you consider the following Kconfig:
> > 
> > config MOD
> >         bool
> >         default y
> >         option modules
> > 
> > config EXPERIMENTAL
> >         bool
> >         default y
> > 
> > menuconfig A
> >         tristate "A"
> >         depends on EXPERIMENTAL
> > 
> > config B
> >         bool "B"
> > 
> > config B0
> >         bool
> > 
> > config C
> >         tristate "C"
> >         depends on B
> > 
> > config C0
> >         tristate
> > 
> > config D
> >         boolean "D"
> >         depends on A && B
> >         select C
> >         select C0
> > 
> > config E
> >         tristate "E"
> > 
> > config F
> >         tristate "F"
> >         select E
> > 
> > B (KEYS) allows to set C (TRUSTED_KEYS). Also, B (KEYS) and A
> > (TCG_TPM) allows to set D (EVM), which will select (C). Now,
> > menuconfig highlight the problem very well. Proceeding as following
> > A=m, B=y, C=m, E=y, F=y, we ends up having:
> > 
> >  <M> A  --->
> >  [*] B
> >  {M} C
> >  [*] D
> >  -*- E
> >  <*> F
> > 
> > which translate in the following config:
> > 
> > CONFIG_MOD=y
> > CONFIG_EXPERIMENTAL=y
> > CONFIG_A=m
> > CONFIG_B=y
> > CONFIG_C=m
> > CONFIG_C0=m
> > CONFIG_D=y
> > CONFIG_E=y
> > CONFIG_F=y
> > 
> > I would have expected CONFIG_C and CONFIG_C0 to be 'y', just as 'E'.
> > If you remove D's dependency on 'A', everything works as expected. So
> > it would seem direct dependency state influence the state of reverse
> > dependencies...
> > 
> > Will have a look...
> > 
> >  - Arnaud
> 
> Thanks for looking into this!  Instead of changing 'TCG_TPM' to
> 'TCG_TPM=y', the dependency should be on 'TRUSTED_KEYS=y'.  Then when
> I've refactored ENCRYPTED_KEYS, removing the ENCRYPTED_KEYS dependency
> on TRUSTED_KEYS, the EVM dependency would be '(TRUSTED_KEYS=y ||
> TRUSTED_KEYS=n)'.  Do you want a temporary fix for now?

Yes, linux-next (randconfig) builds are still failing, so we need something
to prevent that.

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
