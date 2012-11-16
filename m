Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2KPWyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 17:54:07 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49971 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab2KPWyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 17:54:02 -0500
Subject: [RFC] Expand available hwcap bits with AT_HWCAP2 in auxv
From: Ryan Arnold <rsa@us.ibm.com>
Reply-To: rsa@us.ibm.com
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 16 Nov 2012 16:53:54 -0600
Message-ID: <1353106434.10806.14067.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111622-8974-0000-0000-00001144DAE9
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000295; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00191924; UDB=6.00043465; UTC=2012-11-16
 22:54:00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We're out of bits in the AT_HWCAP entry for PowerPC. Per the following
discussion on libc-alpha, I'd like to propose the expansion of the auxv
to make additional space available for further system feature flags.  

http://www.sourceware.org/ml/libc-alpha/2012-10/msg00438.html

There are a few ways to do this (as pointed out by Ben Herrenschmidt).
glibc would prefer to parse an AT_HWCAP2 entry from the auxv and compose
those bits into the high 32-bits of the existing glibc uint64_t hwcap
field.

Currently, the high 32-bits of this field are only available in 64-bit
userspace, and only for platforms where the kernel designates the auxv
hwcap as unsigned long int (example: s390). Platforms like PowerPC, arm,
and x86 maintain parity between 64-bit and 32-bit userspace and thus
only allow 32-bits for capabilities.

I propose that the kernel shift capabilities designated in the high
32-bits into an AT_HWCAP2 auxv entry. In userspace, glibc will compose
that into the available high 32-bits of glibc's hwcap field making the
rest of it available to all platforms.

The beauty of this approach is that if either the Kernel or glibc lack
the AT_HWCAP2 improvement the high 32-bits of glibc's hwcap field will
remain empty, i.e., feature not available.

With this in mind, I need to reserve an identifier in
include/linux/auxvec.h for AT_HWCAP2.  I was thinking:

#define AT_HWCAP  26

GLIBC will have parity with this identifier in elf/elf.h.

I think Ben H. had planned to work on the kernel side of this and I have
a GLIBC patch in process.

Comments?

Ryan S. Arnold
IBM Linux Technology Center
glibc PowerPC maintainer

