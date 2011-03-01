Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab1CAIWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:22:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab1CAIWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:22:00 -0500
From: Ludwig Nussel <ludwig.nussel@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] fix mmap random address range on x86 (try2)
Date: Tue, 1 Mar 2011 09:21:57 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37-20-default; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Thomas Gleixner (maintainer:X86 ARCHITECTURE...) 
	<tglx@linutronix.de>,
        Ingo Molnar (maintainer:X86 ARCHITECTURE...) <mingo@redhat.com>,
        "H. Peter Anvin" (maintainer:X86 ARCHITECTURE...) <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>
References: <1298904783-4291-1-git-send-email-ludwig.nussel@suse.de> <20110228084222.eb52e7c4.rdunlap@xenotime.net>
In-Reply-To: <20110228084222.eb52e7c4.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_lyKbNc+nJTo0Mjk"
Message-Id: <201103010921.57716.ludwig.nussel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_lyKbNc+nJTo0Mjk
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Randy Dunlap wrote:
> On Mon, 28 Feb 2011 15:53:03 +0100 Ludwig Nussel wrote:
> > On x86 casting the unsigned int result of get_random_int() to long
> > may result in a negative value. On x86 the range of mmap_rnd()
> > therefore was -255 to 255. The 32bit mode on x86_64 used 0 to 255 as
> > intended.
> > 
> > The bug was introduced by commit 675a081 in January 2008.
> > 
> > Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
> > ---
> >  arch/x86/mm/mmap.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> > index 1dab519..f927429 100644
> > --- a/arch/x86/mm/mmap.c
> > +++ b/arch/x86/mm/mmap.c
> > @@ -87,9 +87,9 @@ static unsigned long mmap_rnd(void)
> >  	*/
> >  	if (current->flags & PF_RANDOMIZE) {
> >  		if (mmap_is_ia32())
> > -			rnd = (long)get_random_int() % (1<<8);
> > +			rnd = get_random_int() % (1<<8);
> >  		else
> > -			rnd = (long)(get_random_int() % (1<<28));
> > +			rnd = get_random_int() % (1<<28);
> >  	}
> >  	return rnd << PAGE_SHIFT;
> >  }
> 
> Is there a test case for this?
> Can it be tested/checked/observed?

Sure. The attached program prints the address of the main function
to stdout. Compile it for i586, run it several times in a loop and
count the number of distinct addresses.

x86_64:
$ gcc -g -O2 -Wall -fpie -pie -m32 -o mainaddr mainaddr.c && for ((i=0;i<5000;++i)); do ./mainaddr; done | sort -u | wc -l
256

On native i586 without the patch the result is 511

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)

--Boundary-00=_lyKbNc+nJTo0Mjk
Content-Type: text/x-csrc;
  charset="UTF-8";
  name="mainaddr.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mainaddr.c"

#include <stdio.h>

int main(int argc, char *argv[])
{
	printf("%lu\n", (unsigned long)main);
	return 0;
}


--Boundary-00=_lyKbNc+nJTo0Mjk--
