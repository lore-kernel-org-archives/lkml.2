Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0KIQFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:05:20 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56079 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab0KIQFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:05:15 -0500
X-Sasl-enc: yPJfiIYcV+di9xuDHl69GCuBuUmUm0Caa8cgkxC9NRaP 1289318714
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
To: David Safford <safford@watson.ibm.com>
Subject: Re: [PATCH v1.2 3/4] keys: add new trusted key-type
Date: Tue, 9 Nov 2010 17:02:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-61.fc13.x86_64; KDE/4.5.2; x86_64; ; )
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
References: <1289230246-3856-1-git-send-email-zohar@linux.vnet.ibm.com> <20101109064016.GF16307@obsidianresearch.com> <1289315838.16976.38.camel@localhost.localdomain>
In-Reply-To: <1289315838.16976.38.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011091702.58449.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 09, 2010 04:17:18 pm David Safford wrote:
> On Mon, 2010-11-08 at 23:40 -0700, Jason Gunthorpe wrote:
> > It just seems like really odd functionality. I'm not familiar with the
> > KH api, but is there any chance now (or in future) that non-root could
> > access this function?
> 
> good point - we really should explicitly require CAP_SYS_ADMIN for
> pcrlock to be safe. Willdo.
> 
> > A few random observations
> >  - I'm sure someone will say kdoc format should be used for those
> >    function comments?
> 
> that's not required for static functions.
> 
> >  - Using a random value to extend the PCR effectively wastes it
> >    and creates a tiny risk the random extend could result in 0.
> 
> 2^-160? And using a fixed value, or one under user control
> would be worse.
> 
> >  - It would be nice to formally state the datablob is a
> >    TPM_STORED_DATA with no embellishments. The expectation is
> >    userspace can validate the sealInfo prior to loading the
> >    key.
> 
> It's not obvious from the code? :-) Will clarify in comments.
> 
> (It also needs to be documented somewhere in some userspace 
> documentation. We will be posting trusted key userspace utilities 
> (such as for generating/inspecting pcrinfo blobs and fields in 
> sealed blobs), and will certainly document it there too. Perhaps 
> the trusted keys information should be added to keyctl or a new
> man page too?)
>
 
Hi dave

i want to inform you i've created a set of utilities for the creation of
trusted and encrypted keys which also works with the TrustedGRUB software:
for instance the new "trk_create" tool generates or updates a trusted key
passing the pcrinfo structure relative to the future configuration
by performing the same extend operations done by TrustedGRUB during the
boot process:

    * PCR 4 contains MBR information and stage1
    * PCR 8 contains bootloader information stage2 part1
    * PCR 9 contains bootloader information stage2 part2
    * PCR 12 contains all commandline arguments from menu.lst and those entered in the shell
    * PCR 13 contains all files checked via the checkfile-routine
    * PCR 14 contains all files which are actually loaded (e.g., Linux kernel, initrd, modules...) 

My utility, which uses TrouSerS, creates a PCRComposite object at the TSP layer containing the same
set of PCRs listed above. 
Then, it parses the TrustedGRUB configuration file, determines the default boot entry
in order to extend the PCR 14 with the proper kernel and initial ramdisk (it is also possible to
select a different entry, by specifying it in the command line), extends the PCR 12 with the digest
of all commands executed for the selected entry and, finally, retrieves the file containing the
list of files which digest will be used to extend the PCR 13.

I have tested these tools using the Fedora 13 operating system and they may be of interest
if the TrustedGRUB part is not yet implemented by your tools. 

Roberto


> >  - I'm unclear on the merits of using raw random data from the TPM.
> >    I'd feel much better if this was mixed with random
> >    from the kernel pool too. Ideally using a FIPS DBRNG transform..
> 
> The TPM's have a FIPS certified random number generator, which must
> pass a power-on self test before it is used. I have done extensive
> DieHard tests on various TPM chips, and they have all passed, showing
> in my tests unmeasurable correlation. Particularly at boot time, I
> trust the TPM random numbers more than the kernel pool, which has
> not yet been reseeded or had time to accumulate much entropy.
> 
> >  - Shouldn't all the TPM RPC functions live together in the TPM code
> >    someplace? You've done a good job of adding many more general
> >    primitives to build RPC's with.
> >    FWIW, last time I worked with TPMs I built a RPC code generator
> >    for this stuff, which if any more are added would be a really smart
> >    direction to head in.
> 
> The seal and unseal are now pretty general, and could be moved to 
> the TPM code, but unless there are other kernel users of the functions,
> they might as well stay static and with the trusted key code, since
> that's the only place they are being used. Easy enough to move and
> make public later if someone wants them...
> 
> dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
