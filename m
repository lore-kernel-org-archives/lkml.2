Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0EJSGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:06:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38963 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969Ab0EJSGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:06:20 -0400
Message-ID: <4BE84B04.9050607@zytor.com>
Date: Mon, 10 May 2010 11:05:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@vmware.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "hjanssen@microsoft.com" <hjanssen@microsoft.com>,
       "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Alok Kataria <akataria@vmware.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/cpu] Modify the VMware balloon driver for the new x86_hyper
 API
References: <4BE49778.6060800@zytor.com> <201005100917.28980.dtor@vmware.com> <4BE842C3.5040300@zytor.com> <201005101052.22796.dtor@vmware.com>
In-Reply-To: <201005101052.22796.dtor@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2010 10:52 AM, Dmitry Torokhov wrote:
> 
> The usage that you mention only valid in the context of working with
> device nodes. In other cases it can be used to indicate different errors
> altogether:
> 
> mmap:
> 
> [ENODEV]
>     The fildes argument refers to a file whose type is not supported
>     by mmap().
> 
> fallocate:
> 
> [ENODEV]
>     The fd argument does not refer to a regular file.
> 
> Linux mount:
> 
>       ENODEV filesystemtype not configured in the kernel.
> 
>       ENXIO  The major number of the block device source is out of range.
> 

"The major number of the block device source is out of range" is really
nothing but confusion on the part of the man page author.  It's exactly
this kind of confusion which I try to clamp down on, because we have
*so* many instances of it in the existing codebase.  It seems, in fact,
to be one of the most common mistakes

ENXIO really means exactly the same thing as it does elsewhere: no
hardware for the specified device.  For example, create /dev/hda on a
system with no IDE:

mount("/dev/hda", "/mnt", "ext2", MS_MGC_VAL, NULL) = -1 ENXIO (No such
device or address)

[no "out of range" anything there...]

The kernel does indeed return ENODEV for a nonexistent filesystem name,
which can only best be described as "severely confusing", but probably
have to be considered grandfathered in by now.  (mount returns ENOTBLK
for a non-devicenode, which is somewhat accurate -- a non-device is not
a block device, after all...)

	-hpa
