Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab2JDVG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:06:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55821 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757271Ab2JDVG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:06:27 -0400
Message-ID: <506DFA41.3080803@zytor.com>
Date: Thu, 04 Oct 2012 14:06:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Randy Wright <rwright@hp.com>
CC: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        tmac@hp.com
Subject: Re: [PATCH] Fix devmem_is_allowed for below 1MB accesses for an efi
 machine
References: <jQim6-6MC-7@gated-at.bofh.it> <jQiFt-6UB-13@gated-at.bofh.it> <jQoUx-33k-3@gated-at.bofh.it> <jQp4d-37r-3@gated-at.bofh.it> <jQpxf-3Cv-1@gated-at.bofh.it> <506DEC95.8050806@hp.com>
In-Reply-To: <506DEC95.8050806@hp.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 01:07 PM, Randy Wright wrote:
> 
> I wanted to mention in this context a patch RFC I posted yesterday as a
> distinct thread which is visible as https://lkml.org/lkml/2012/10/3/589
> with the subject: [PATCH RFC] function probe_roms accessing improper
> addresses on UEFI systems.
> 

And it's equally as wrong.  It has nothing to do with UEFI vs BIOS at
all; this is rather a change in the classic behavior on x86 to return -1
on an impossible read rather than #MC.

Normally I would say probe_roms() doesn't really make any sense in the
EFI context anyway, but I believe there are systems which actually need
to probe at least for the video ROM even when running under EFI (and I
think there are storage devices which have parameter blocks in their
ROMs with similar issues).

Excluding reserved regions in general is a non-option, because on a lot
of systems the ROMs that *do* need to be probed for are marked just
RESERVED.

One option would be to quirk it; obviously there is some piece of
hardware which does cause this #MC and hopefully we could use that to
detect that specific regions should be excluded; another option would be
to trap the #MC during ROM probing.

	-hpa
