Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1ESFiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 01:38:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:33395 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab1ESFix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 01:38:53 -0400
Subject: Re: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
 not atomic
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Roland Dreier <roland@kernel.org>
Cc: Milton Miller <miltonm@bga.com>, Hitoshi Mitake <h.mitake@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@redhat.com>,
        "Desai, Kashyap" <Kashyap.Desai@lsi.com>,
        "Prakash, Sathya" <Sathya.Prakash@lsi.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Matthew Wilcox <matthew@wil.cx>,
        linux scsi dev <linux-scsi@vger.kernel.org>,
        "paulus@samba.org" <paulus@samba.org>,
        linux powerpc dev <linuxppc-dev@lists.ozlabs.org>,
        linux pci <linux-pci@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
In-Reply-To: <BANLkTimDktq8SxOU3HZkPpj=J9pdkzVX-w@mail.gmail.com>
References: <20110504115324.GE17855@lsi.com>
	 <1305616571.6008.23.camel@mulgrave.site>
	 <B2FD678A64EAAD45B089B123FDFC3ED70157F7BCE5@inbmail01.lsi.com>
	 <20110518041551.GL15227@parisc-linux.org>
	 <1305692584.2580.3.camel@mulgrave.site> <1305702010.2781.33.camel@pasglop>
	 <mpt2sas-writeq-powerpc64@mdm.bga.com>
	 <4565AEA676113A449269C2F3A549520F80B66280@cosmail03.lsi.com>
	 <x86-32-writeq-is-broken@mdm.bga.com>
	 <BANLkTimDktq8SxOU3HZkPpj=J9pdkzVX-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 15:34:02 +1000
Message-ID: <1305783242.7481.42.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 21:16 -0700, Roland Dreier wrote:
> On Wed, May 18, 2011 at 11:31 AM, Milton Miller <miltonm@bga.com> wrote:
> > So the real question should be why is x86-32 supplying a broken writeq
> > instead of letting drivers work out what to do it when needed?
> 
> Sounds a lot like what I was asking a couple of years ago :)
> http://lkml.org/lkml/2009/4/19/164
> 
> But Ingo insisted that non-atomic writeq would be fine:
> http://lkml.org/lkml/2009/4/19/167

Yuck... Ingo, I think that was very wrong.

Those are for MMIO, which must almost ALWAYS know precisely what the
resulting access size is going to be. It's not even about atomicity
between multiple CPUs. I have seen plenty of HW for which a 64-bit
access to a register is -not- equivalent to two 32-bit ones. In fact, in
some case, you can get the side effects twice ... or none at all.

The only case where you can be lax is when you explicitely know that
there is no side effects -and- the HW cope with different access sizes.
This is not the general case and drivers need at the very least a way to
know what the behaviour will be.

Cheers,
Ben.


