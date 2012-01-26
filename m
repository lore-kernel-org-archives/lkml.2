Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2AZQGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:06:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab2AZQGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:06:30 -0500
Date: Thu, 26 Jan 2012 07:59:25 -0800
From: Greg KH <gregkh@suse.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Renninger <trenn@suse.de>, Bruno Friedmann <bruno@ioda-net.ch>,
        Len Brown <len.brown@intel.com>
Subject: Re: [67/90] intel idle: Make idle driver more robust
Message-ID: <20120126155925.GA1404@suse.de>
References: <20120123234211.GA19504@kroah.com>
 <20120123234028.628058547@clark.kroah.org>
 <20120126144533.GA1731@shutemov.name>
 <4F217585.2070302@msgid.tls.msk.ru>
 <20120126155427.GA2310@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120126155427.GA2310@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 05:54:27PM +0200, Kirill A. Shutemov wrote:
> On Thu, Jan 26, 2012 at 07:47:17PM +0400, Michael Tokarev wrote:
> > 26.01.2012 18:45, Kirill A. Shutemov wrote:
> > 
> > >>From: Thomas Renninger<trenn@suse.de>
> > >>
> > >>commit 5c2a9f06a9cd7194f884cdc88144866235dec07d upstream.
> > >>
> > >>kvm -cpu host passes the original cpuid info to the guest.
> > >>
> > >>Latest kvm version seem to return true for mwait_leaf cpuid
> > >>function on recent Intel CPUs. But it does not return mwait
> > >>C-states (mwait_substates), instead zero is returned.
> > >>
> > []
> > >>  drivers/idle/intel_idle.c |    3 ++-
> > >>  1 file changed, 2 insertions(+), 1 deletion(-)
> > >>
> > >>--- a/drivers/idle/intel_idle.c
> > >>+++ b/drivers/idle/intel_idle.c
> > >>@@ -321,7 +321,8 @@ static int intel_idle_probe(void)
> > >>  	cpuid(CPUID_MWAIT_LEAF,&eax,&ebx,&ecx,&mwait_substates);
> > >>
> > >>  	if (!(ecx&  CPUID5_ECX_EXTENSIONS_SUPPORTED) ||
> > >>-		!(ecx&  CPUID5_ECX_INTERRUPT_BREAK))
> > >>+	    !(ecx&  CPUID5_ECX_INTERRUPT_BREAK) ||
> > >>+	    !mwait_substates)
> > >>  			return -ENODEV;
> > >
> > >It breaks build for me.
> > []
> > >   CC      drivers/idle/intel_idle.o
> > >/home/space/kas/git/public/linux-3.0-mid/drivers/idle/intel_idle.c: In function ‘intel_idle_probe’:
> > >/home/space/kas/git/public/linux-3.0-mid/drivers/idle/intel_idle.c:508:7: error: ‘mwait_substates’ undeclared (first use in this function)
> > >/home/space/kas/git/public/linux-3.0-mid/drivers/idle/intel_idle.c:508:7: note: each undeclared identifier is reported only once for each function it appears in
> > >make[3]: *** [drivers/idle/intel_idle.o] Error 1
> > >
> > >Variable 'substates' hasn't renamed to 'mwait_substates' in 3.0.
> > >See c423628 intel_idle: delete substates DEBUG modparam
> > 
> > I wonder why in my 3.0.18 this variable is properly defined
> > in the same file, in line 77:
> > 
> > ...
> > 74 /* intel_idle.max_cstate=0 disables driver */
> > 75 static int max_cstate = MWAIT_MAX_NUM_CSTATES - 1;
> > 76
> > 77 static unsigned int mwait_substates;
> > 78
> > 79 #define LAPIC_TIMER_ALWAYS_RELIABLE 0xFFFFFFFF
> > ...
> 
> Oosp. Sorry for noise. My local patch breaks it.

So, 3.0.18 is just fine, right?

