Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2KANLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:11:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab2KANLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:11:09 -0400
Date: Thu, 1 Nov 2012 09:10:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Matthew Garrett <mjg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>
Subject: Re: Kdump with signed images
Message-ID: <20121101131003.GA14573@redhat.com>
References: <87fw552mb4.fsf_-_@xmission.com>
 <20121024173651.GE1821@redhat.com>
 <1351145401.18115.78.camel@falcor>
 <20121025141048.GD9377@redhat.com>
 <1351190421.18115.92.camel@falcor>
 <20121025185520.GA17995@redhat.com>
 <1351214158.18115.186.camel@falcor>
 <20121026023916.GA16762@srcf.ucam.org>
 <20121026170609.GB24687@redhat.com>
 <1351276649.18115.217.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351276649.18115.217.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 02:37:29PM -0400, Mimi Zohar wrote:
> On Fri, 2012-10-26 at 13:06 -0400, Vivek Goyal wrote:
> > On Fri, Oct 26, 2012 at 03:39:16AM +0100, Matthew Garrett wrote:
> > > On Thu, Oct 25, 2012 at 09:15:58PM -0400, Mimi Zohar wrote:
> > > 
> > > > On a running system, the package installer, after verifying the package
> > > > integrity, would install each file with the associated 'security.ima'
> > > > extended attribute.  The 'security.evm' digital signature would be
> > > > installed with an HMAC, calculated using a system unique key. 
> > > 
> > > The idea isn't to prevent /sbin/kexec from being modified after 
> > > installation - it's to prevent it from being possible to install a 
> > > system that has a modified /sbin/kexec. Leaving any part of this up to 
> > > the package installer means that it doesn't solve the problem we're 
> > > trying to solve here. It must be impossible for the kernel to launch any 
> > > /sbin/kexec that hasn't been signed by a trusted key that's been built 
> > > into the kernel, and it must be impossible for anything other than 
> > > /sbin/kexec to make the kexec system call.
> > 
> > I am kind of lost now so just trying to summarize whatever I have
> > learned so far from this thread.
> 
> Thanks for summarizing.
> 
> > - So say we can sign /sbin/kexec at build time and distros can do that.
> > - Verify the signature at exec time using kernel keyring and if
> >   verification happens successfully, say process gains extra capability.
> > - Use this new capability to determine whether kexec_load() will be
> >   successful or not.
> > 
> > Even if we can do all this, it still has the issue of being able to
> > stop the process in user space and replace the code at run time
> > and be able to launch unsigned kernel.

Thinking more about it. Can we just keep track whether a process was
ptraced or not and disallow kexec_load() syscall if it was ptraced.
(I am assuming that ptrace is the only way to change process code/data).

So binaries can be signed offline. Signature verification can take place
using kernel keyring at exec() time. And we can keep track of ptraced
processes and disallow calling kexec_load() for such processes. If this
is implementable, this should take care of following requirement raised
by matthew.

************************************************************************
It must be impossible for the kernel to launch any /sbin/kexec that hasn't
been signed by a trusted key that's been built into the kernel, and it
must be impossible for anything other than /sbin/kexec to make the kexec
system call.
*************************************************************************

Thoughts?

Thanks
Vivek
