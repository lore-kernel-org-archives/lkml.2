Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2GFOtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:49:25 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42461 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2GFOtY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 6 Jul 2012 10:49:24 -0400
Message-Id: <4FF7174C020000780008E1FF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jul 2012 15:50:20 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>
Cc: <kexec@lists.infradead.org>, <xen-devel@lists.xensource.com>,
        "Daniel Kiper" <dkiper@net-space.pl>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S
 during kexec boot
References: <20120705210607.GA26908@aepfle.de>
 <20120706084120.GA31219@router-fw-old.local.net-space.pl>
 <20120706120750.GA8970@aepfle.de>
 <4FF6FCA9020000780008E0BB@nat28.tlf.novell.com>
 <20120706133105.GA20600@aepfle.de> <20120706141419.GA21951@aepfle.de>
In-Reply-To: <20120706141419.GA21951@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.07.12 at 16:14, Olaf Hering <olaf@aepfle.de> wrote:
> On Fri, Jul 06, Olaf Hering wrote:
> 
>> I will cleanup my debug changes and post the output.
> 
> What I see is that the content of the uncompressed vmlinux is
> appearently already corrupted after decompress().  After I made small
> changes to arch/x86/boot/compressed/misc.c and arch/x86/kernel/head_64.S
> the offset in memory changed from 0x2c to 0x8.
> 
> This could mean that the unzip code is broken, but this is rather
> unlikely. The odd thing is, if the first kernel is forced to return
> false in xen_hvm_platform() to disable the PVonHVM features then kexec
> works ok.
> 
> Could it be that some code tweaks the stack content used by decompress()
> in some odd way? But that would most likely lead to a crash, not to
> unexpected uncompressing results.

Especially if the old and new kernel are using the exact same
image, how about the decompression writing over the shared
info page causing all this? As the decompressor wouldn't
expect Xen to possibly write stuff there itself, it could easily be
that some repeat count gets altered, thus breaking the
decompressed data without the decompression code necessarily
noticing.

If that's the case, there would be a more general problem here
(for kdump at least), as granted pages could also still get written
to when the new kernel already is in the process of launching.

Jan

