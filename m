Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2KIOrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:47:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab2KIOrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:47:21 -0500
Date: Fri, 9 Nov 2012 09:39:38 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matthew Garrett <mjg@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>, Peter Jones <pjones@redhat.com>
Subject: Re: Kdump with signed images
Message-ID: <20121109143938.GD4842@redhat.com>
References: <20121101145225.GB10269@srcf.ucam.org>
 <20121102132318.GA3300@redhat.com>
 <87boffd727.fsf@xmission.com>
 <20121105180353.GC28720@redhat.com>
 <87mwyv96mn.fsf@xmission.com>
 <20121106193419.GH4548@redhat.com>
 <87k3tynvc0.fsf@xmission.com>
 <20121108194050.GB27586@redhat.com>
 <20121108194522.GC27586@redhat.com>
 <87vcdfn6y2.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vcdfn6y2.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 01:03:17PM -0800, Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Thu, Nov 08, 2012 at 02:40:50PM -0500, Vivek Goyal wrote:
> >> On Tue, Nov 06, 2012 at 03:51:59PM -0800, Eric W. Biederman wrote:
> >> 
> >> [..]
> >> 
> >> Thnking more about executable signature verification, I have another question.
> >> 
> >> While verifyign the signature, we will have to read the whole executable
> >> in memory. That sounds bad as we are in kernel mode and will not be killed
> >> and if sombody is trying to execute a malformed exceptionally large
> >> executable, system will start killing other processess. We can potentially
> >> lock all the memory in kernel just by trying to execute a signed huge
> >> executable. Not good.
> >> 
> >
> > Also, even if we try to read in whole executable, can't an hacker modify
> > pages in swap disk and then they will be faulted back in and bingo hacker
> > is running its unsigned code. (assuming root has been compromised otherwise
> > why do we have to do all this exercise).
> 
> You make a decent case for an implicit mlockall(MCL_FUTURE) being
> required of signed executables, that are going to be granted privileges
> based on signature verification.

implicity lockall for signed executables sounds reasonable to avoid the
swap hack.

> 
> As for size if the executable won't fit in memory, there is no point in
> checking the signature.

Well I am worried about malformed executables. One can sign a huge
executable (which is never meant to run successfully) and cause all
kind of memory issues. 

Can we first look at the signature, decrypt it using certificates in
kernel ring, and if we find out that executable was signed by any
of the certificates, only then we go on to read in whole executable
and try to calculate the digest. May be at the time of signing we can put
 a string, say "LINUX", along with digest and then sing/encrypt it. Upon
decryption we can check if LINUX is there and if yes, we know it was
signed by the certifcate loaded in kernel and then go on to load the
full executable and calculate digest.

Not sure if above is doable or not but if it is, it might reduce the
risk significantly as we will not try to integrity verify executables
not signed by genuine certificates.

> 
> It should be fairly straight forward to make the signature checking
> process preemptable and killable.

hmm..., not sure how to do this. Will have to read more code to understand
process killing and see what can I do this while I am in kernel mode
and I possibly might have done kernel memory allocations using
vmalloc()/kmalloc() etc.

Thanks
Vivek
