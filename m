Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab1HPF1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:27:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:44144 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab1HPF1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:27:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="38115864"
Message-ID: <4E49FFB4.8070601@linux.intel.com>
Date: Mon, 15 Aug 2011 22:27:16 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, Andy Lutomirski <luto@mit.edu>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3.1-rc2] x86: fix mm/fault.c build
References: <CA+55aFycTvbuNzdgbHjoiNkTeDpzgu6Yf=vx9DU+PDOtC_17zA@mail.gmail.com> <20110815101846.58809a89.rdunlap@xenotime.net> <CA+55aFxsOMc9=p02r8-QhJ=h=Mqwckk4_Pnx9LQt5+fqMp_exQ@mail.gmail.com>
In-Reply-To: <CA+55aFxsOMc9=p02r8-QhJ=h=Mqwckk4_Pnx9LQt5+fqMp_exQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 07:09 PM, Linus Torvalds wrote:
> On Mon, Aug 15, 2011 at 10:18 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> arch/x86/mm/fault.c needs to include asm/vsyscall.h to fix a
>> build error:
>>
>> arch/x86/mm/fault.c: In function '__bad_area_nosemaphore':
>> arch/x86/mm/fault.c:728: error: 'VSYSCALL_START' undeclared (first use in this function)
> 
> Grr. This seems to be one of those "under certain configurations
> only". I can trigger it with "allnoconfig", but not with my common
> configuration or "allmodconfig"
> 
> I just don't see *why* it ends up being config-related. Can anybody
> fill me in? It looks like some header file does a conditional include
> of fixmap.h or something. Urgh. I *hate* those kinds of "some configs
> work" cases.
> 

It's due to the following in <asm/smp.h>:

#ifdef CONFIG_X86_LOCAL_APIC
# include <asm/mpspec.h>
# include <asm/apic.h>
# ifdef CONFIG_X86_IO_APIC
#  include <asm/io_apic.h>
# endif
#endif

<asm/apic.h> pulls in <asm/fixmap.h> which pulls in <asm/vsyscall.h>,
bypassing the fact that arch/x86/mm/fault.c is missing <asm/vsyscall.h>.

I'll have a patch for it shortly.

	-hpa
