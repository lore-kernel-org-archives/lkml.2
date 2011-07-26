Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1GZJoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:44:25 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:40958 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1GZJoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:44:20 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: oomichi@mxs.nes.nec.co.jp, linux-s390@vger.kernel.org,
        mahesh@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, hbabu@us.ibm.com, horms@verge.net.au,
        ebiederm@xmission.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        kexec@lists.infradead.org
In-Reply-To: <20110725160244.GB11009@redhat.com>
References: <20110718123140.GB31986@redhat.com>
	 <1310997641.4427.10.camel@br98xy6r> <20110718141943.GE31986@redhat.com>
	 <1311000253.4427.23.camel@br98xy6r> <20110718152532.GF31986@redhat.com>
	 <1311012188.4427.58.camel@br98xy6r> <20110720192509.GD10079@redhat.com>
	 <1311260298.6160.43.camel@br98xy6r> <20110721212257.GI12373@redhat.com>
	 <1311327191.5772.51.camel@br98xy6r>  <20110725160244.GB11009@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 26 Jul 2011 11:44:01 +0200
Message-ID: <1311673441.4146.10.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 12:02 -0400, Vivek Goyal wrote:
> On Fri, Jul 22, 2011 at 11:33:11AM +0200, Michael Holzheu wrote:

[snip]

> > crash_kexec can be entered by e.g.:
> > * panic -> kdump shutdown action -> crash_kexec
> > * panic -> s390 dump shutdown action -> auto IPL dump tool -> s390_kdump_entry -> crash_kexec
> 
> So after panic() You will still jump to dump tools?

This is our current mechanism to create an automatic dump in case of
panic. I do not see a reason to change that now.

>  The only thing you
> need to do there is installing program check handler and could have been
> easily done in kernel too.
> 
> > * hard hang -> manual IPL dump tool -> s390_kdump_entry -> crash_kexec
> 
> This one makes sense as kernel is hard hung and dump tools need to
> force crash_kexec() now. It is more like x86 NMI handler.
> 
> > 
> > Handling for corrupted kdump:
> > 
> > New idea for returning to dump tools in case of program check:
> > We could force a program check for s390, if purgatory checksum
> > fails. Then we would automatically return to stand-alone dump
> > tools.
> > 
> > The flow would look like the following in this case:
> > 
> > IPL dump tool -> s390_kdump_entry -> crash_kexec +--> purgatory -+->[checksum ok]---> kdump
> >       ^                                          |               |
> >       |                                          |        [checksum fail]
> >       |                                          |               |
> >       |                                          |     [forced program check]
> >       +------[program check]---------------------+               |
> >       |                                                          |
> >       +----------------------------------------------------------+
> > 
> > Then of course also the kernel code would have to install a special
> > program check handler before calling purgatory.
> 
> If kernel code is going to install the program check handler before
> calling purgatory, then we don't need to jump to dump tools at all
> after panic()?

Independent from hard wait or panic, if dump tools have control, we want
to jump back to the dump tools code in order to be able to create
full-blown dump as backup method.

I think we now have a design, where almost no change of your kdump
framework is needed. I will resend the updated patch series.

Michael


