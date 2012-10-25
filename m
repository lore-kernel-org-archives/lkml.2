Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab2JYFq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 01:46:59 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48447 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab2JYFq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 01:46:58 -0400
Message-ID: <1351143839.18115.57.camel@falcor>
Subject: Re: [RFC] Kdump with signed images
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Matthew Garrett <mjg@redhat.com>, Khalid Aziz <khalid@gonehiking.org>,
        kexec@lists.infradead.org, horms@verge.net.au,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Kees Cook <keescook@chromium.org>
Date: Thu, 25 Oct 2012 01:43:59 -0400
In-Reply-To: <20121024171926.GD1821@redhat.com>
References: <20121018193831.GD18147@redhat.com>
	 <874nlrv2ni.fsf@xmission.com> <20121019020630.GA27052@redhat.com>
	 <877gqnnnf0.fsf@xmission.com> <20121019143112.GB27052@redhat.com>
	 <871ugqb4gj.fsf@xmission.com> <20121023131854.GA16496@redhat.com>
	 <20121023145920.GD16496@redhat.com> <20121023154123.GA30730@srcf.ucam.org>
	 <87d309xhmc.fsf_-_@xmission.com> <20121024171926.GD1821@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102505-5406-0000-0000-000001671193
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 13:19 -0400, Vivek Goyal wrote:
> On Tue, Oct 23, 2012 at 09:44:59AM -0700, Eric W. Biederman wrote:
> > Matthew Garrett <mjg@redhat.com> writes:
> > 
> > > On Tue, Oct 23, 2012 at 10:59:20AM -0400, Vivek Goyal wrote:
> > >
> > >> But what about creation of a new program which can call kexec_load()
> > >> and execute an unsigned kernel. Doesn't look like that will be
> > >> prevented using IMA.

Like the existing kernel modules, kexec_load() is not file descriptor
based.  There isn't an LSM or IMA-appraisal hook here.

> > > Right. Trusting userspace would require a new system call that passes in 
> > > a signature of the userspace binary, and the kernel would then have to 
> > > verify the ELF object in memory in order to ensure that it 
> > > matches the signature. Verifying that the copy on the filesystem is 
> > > unmodified isn't adequate - an attacker could simply have paused the 
> > > process and injected code. 

I haven't looked at kexec_load() in detail, but like kernel modules, I
think the better solution would be to pass a file descriptor, especially
if you're discussing a new system call.  (cc'ing Kees.)

> > Verifying the copy on the filesystem at exec time is perfectly adequate
> > for gating extra permissions.  Certainly that is the model everywhere
> > else in the signed key chain.
> > 
> > Where IMA falls short is there is no offline signing capability in IMA
> > itself.  I think EVM may fix that.

I'm not sure what you mean by offline signing capability.  IMA-appraisal
verifies a file's 'security.ima' xattr, which may contain a hash or a
digital signature.  EVM protects a file's metadata, including
'security.ima'.  'security.evm' can be either an hmac or a digital
signature.

> [ CCing lkml. I think it is a good idea to open discussion to wider
> audience. Also CCing IMA/EVM folks ]

thanks!

> Based on reading following wiki page, looks like EVM also does not allow
> offline signing capability. And EVM is protecting IMA data to protect
> against offline attack. If we can assume that unisgned kernels can't be
> booted on the platform, then EVM might not be a strict requirement in
> this case.

> So as you said, one of the main problem with IMA use to verify /sbin/kexec
> is that IMA does not provide offline signing capability.

?
 
> > 
> > > Realistically, the only solution here is for 
> > > the kernel to verify that the kernel it's about to boot is signed and 
> > > for it not to take any untrusted executable code from userspace.

>From an IMA, as opposed to an IMA-appraisal, perspective, kexec is
problematic.  IMA maintains a measurement list and extends a PCR with
the file hash.  The measurement list and PCR value are used to attest to
the integrity of the running system.  As the original measurement list
is lost after kexec, but the PCR value hasn't been reset, the
measuremnet list and PCR value won't agree.

> > Hogwash.  The kernel verifing a signature of /sbin/kexec at exec time is
> > perfectly reasonable, and realistic.  In fact finding a way to trust
> > small bits of userspace even if root is compromised seems a far superior
> > model to simply solving the signing problem for /sbin/kexec.

Huh?  I don't understand what you're suggesting.  Once root has been
compromised, that's it.

> > Although I do admit some part of the kexec process will need to verify
> > keys on the images we decide to boot.

Which keys?  Isn't the kernel module key builtin to the kernel and
included in the kernel image signature?

> It should be an option, isn't it? Either /sbin/kexec can try to verify the
> integrity of kernel or we extend try to extend kexec() system call to also
> pass the signature of kernel and let kernel verify it (as you mentioned
> previously).
> 
> Thanks
> Vivek
> 

As suggested above, please consider passing a file descriptor, at least
in addition, if not in lieu of a signature.

thanks,

Mimi

