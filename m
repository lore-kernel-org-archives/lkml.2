Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1HKGnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 02:43:15 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:33366 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1HKGnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 02:43:12 -0400
Date: Thu, 11 Aug 2011 08:43:04 +0200
From: Borislav Petkov <bp@amd64.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>
Subject: Re: linux-next: build failure in Linus' tree
Message-ID: <20110811064304.GA9994@aftab>
References: <20110811115926.655a067c61de5f430ef5e772@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110811115926.655a067c61de5f430ef5e772@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 09:59:26PM -0400, Stephen Rothwell wrote:
> Hi Linus,
> 
> With Linus' tree, today's linux-next build (x86_64 allmodconfig) failed
> like this:
> 
> drivers/edac/i7core_edac.c:259:19: error: field 'edac_mce' has incomplete type
> drivers/edac/i7core_edac.c:262:24: error: 'MCE_LOG_LEN' undeclared here (not in a function)
> drivers/edac/i7core_edac.c: In function 'i7core_mce_output_error':
> drivers/edac/i7core_edac.c:1671:25: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1672:20: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1673:23: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1674:15: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1675:18: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1676:18: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1680:7: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1742:22: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1742:31: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1743:39: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1744:15: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1751:7: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c: In function 'i7core_check_error':
> drivers/edac/i7core_edac.c:1787:50: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1791:3: error: invalid use of undefined type 'struct mce'
> drivers/edac/i7core_edac.c:1793:49: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c: In function 'i7core_mce_check_error':
> drivers/edac/i7core_edac.c:1838:11: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1842:9: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1847:6: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1859:52: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1864:9: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c: In function 'i7core_unregister_mci':
> drivers/edac/i7core_edac.c:1910:2: error: implicit declaration of function 'edac_mce_unregister'
> drivers/edac/i7core_edac.c: In function 'i7core_register_mci':
> drivers/edac/i7core_edac.c:2008:2: error: implicit declaration of function 'edac_mce_register'
> 
> Caused by commit af9d220bac41 ("EDAC: Correct Kconfig dependencies").
> Since CONFIG_EDAC_MCE is no longer selected most of the stuff in
> linux/edac_mce.h is not available.  I have reverted that commit for today.

§$%§$&&§! (please excuse my french).

And I build-tested this patch with randconfigs a whole night and didn't
see any issues. But I think I see what happens, the above is the result
of a chain of unfortunate events :-)

* Randy mistakenly reported the original randconfig issue against
3.1-rc1. However, in reality it was against linux-next. It was caused by
the fact that i7core_edac now needs to depend on X86_MCE_INTEL (which
pulls in X86_MCE for the notifier chain).

* I sent the proper fix which was for Mauro to apply _ontop_ of

git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/edac.git linux_next

where the rest of the i7core_edac changes are. This patch depends on them.

* I wasn't clear enough with the patch though, and I see Linus has
applied it already on his tree, which is clearly too early - it has to
go in in the next merge window together with the rest of the stuff in
Mauro's branch.

So, I guess we're reverting for now, Linus?

Thanks and sorry for the trouble.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
