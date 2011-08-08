Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab1HHRsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:48:08 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:57943 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1HHRsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:48:04 -0400
Subject: Re: [patch v2 04/10] kdump: Trigger kdump via panic notifier chain
 on s390
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20110804211432.GE429@redhat.com>
References: <20110727125504.491183728@linux.vnet.ibm.com>
	 <20110727125808.028895659@linux.vnet.ibm.com>
	 <20110801204114.GJ3805@redhat.com> <1312274279.4881.18.camel@br98xy6r>
	 <20110802192147.GJ6399@redhat.com> <1312365039.3783.36.camel@br98xy6r>
	 <20110804211432.GE429@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 08 Aug 2011 19:47:39 +0200
Message-ID: <1312825659.3537.62.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Thu, 2011-08-04 at 17:14 -0400, Vivek Goyal wrote:
> On Wed, Aug 03, 2011 at 11:50:39AM +0200, Michael Holzheu wrote:

[snip]
 
> > Only if the user has specified panic action stand-alone dump, we do the
> > detour via the stand-alone dump tools.
> 
> If a user decides to load kdump kernel to capture dump, then why does it
> still make sense to set panic action as "stand-alone dump tools". One
> could argue that user loaded kdump kernel but not necessarily wants
> that mechanism to use, in that case dump-tools does not have to jump
> to kdump kernel at all. 

The user on s390 can currently freely configure the panic action. If we
would always do kdump on panic, when kdump is active, we would have to
ensure in sysfs that the user can't change the setting any more.
Technically we could do that of course.

One use case we had in mind was that the s390 Linux administrator does
not have to learn new things when using kdump. kdump can be used as
extension of the already existing mechanism. Today users configure
stand-alone dump via sysfs. With kdump + trigger via dump tools they
could do it still the same way. And also for manual dump they just IPL
the dump tool as they are used to do it and if kdump is fine, kdump will
be triggered. Nothing new has to be learned.

If users only want to use kdump without stand-alone dump tools as on
other architectures also this is possible. Then the panic action will be
just kdump.

> > 
> > > like other architectures and jump to stand
> > > alone kernel only if some piece of code is corrupted and that action
> > > failed.
> > > 
> > > What's the point of jumping to stand alone kenrel in case of panic()
> > > and then re-enter it back to original kernel using crash_kexec(). Sound
> > > like a very odd design choice to me.
> > > 
> > > I am now I am repeating this question umpteen time simply because
> > > I never got a good answer except "we have to do it this way".
> > 
> > Sometimes communication is really hard and frustrating.
> > ... but at least we are still communicating.
> > 
> > Ok very last try:
> > 
> > * We can use the same mechanism for manual dump and automatic dump on
> > panic: IPL the stand-alone dump tools.
> 
> So manual dump/intervention is only required if automatic dump failed?

Manual intervention is required only if panic code does not make it to
the "IPL stand-alone dump tools" code.

> 
> > kdump check and backup
> > stand-alone dump is implemented only in the stand-alone dump code.
> 
> My argument is that why stand alone dump is trying to trigger kdump
> at all? Shouldn't it all be part of loading kdump kernel and user
> setting panic() action to kdump?

To summarize: Our approach was to do it in the stand-alone dump tools
code for both the manual and the automatic on panic case:

panic ------+                                 +- valid -> kdump
            +-> IPL dump tools -> try kdump --+
hard hang --+                                 +- invalid -> stand-alone dump

Your suggestion looks like the following:

panic --> try kdump +-- valid ---> kdump
                    |
                    +-- invalid -> IPL dump tools --> stand-alone dump

                                            +- valid -> kdump
hard hang --> IPL dump tools -> try kdump --+ 
                                            +- invalid -> stand-alone dump

Is that what you are suggesting? We can do it that way, too. Then
we would not need the #ifdef CONFIG_S390 in panic().

Michael

