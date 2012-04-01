Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2DAQFL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:05:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47289 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753204Ab2DAQFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:05:04 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX19A8rU4xuBAsmkDg3InUjZhGmH6cyaEOIYFlTif+V
	ARMUlQOsCuXBH6
Message-ID: <4F787C9C.8050206@gmx.net>
Date: Sun, 01 Apr 2012 18:04:44 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] PNP: Allow PNP resources to be disabled (interface)
References: <4F68D14B.60409@gmx.net> <CAErSpo7Xt2Pz5EqDO_NJGyRkPMrY21vzWJBK1ORwu=j+9t55Gg@mail.gmail.com>
In-Reply-To: <CAErSpo7Xt2Pz5EqDO_NJGyRkPMrY21vzWJBK1ORwu=j+9t55Gg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/03/12 22:57, Bjorn Helgaas wrote:

[...]

>
> If I understand this correctly, even with this patches, you still have
> to manually muck around with "/sys/bus/pnp/devices/*/resources" to get
> these ThinkPads to work?  If that's the case, there must be more PNP
> work we could do to make them Just Work.  And that's fine; I'm just
> trying to understand the current situation better.  Is there a
> bugzilla or other URL with more details?
>

Yes, this is true: even with this patch applied it is necessary to 
explicitly set the IRQ link to disabled.  Let me briefly explain it, 
using an excerpt from the 600E's DSDT (printer port):

    Name (PLPT, ResourceTemplate ()
    {
        StartDependentFnNoPri ()
        {
            IO (Decode16, 0x03BC, 0x03BC, 0x01, 0x04)
            IRQNoFlags () {7}
        }
        /* Some entries deleted */
        StartDependentFnNoPri ()
        {
            IO (Decode16, 0x03BC, 0x03BC, 0x01, 0x04)
            IRQNoFlags () {}
        }
        EndDependentFn ()
    })

As you can see, the IRQ line for the second option is empty/disabled. 
Also, both options share the same priority, there is no priority of 
the first option over the second option.

In order to be able to use the IRQ 7 for some other device, I need 
to be able to select the second option, which can be done with the 
patch series applied.

As for a bugzilla entry: I did not find any.  Frankly, I don't 
think there is one, for until recently, disabled resources were 
not handled at all (at least in the PNPACPI case).  Though, it is 
(remotely?) possible the handling of optional IRQ lines 
(IORESOURCE_IRQ_OPTIONAL) is obsolete these days (because the 
quirks that introduce that flag seem to fix a symptom that could 
have been fixed by commit 18fd470a48396c8795ba7256c5973e92ffa25cb3).


--- Witold
