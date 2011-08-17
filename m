Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab1HQHtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 03:49:36 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:27880 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1HQHte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 03:49:34 -0400
Date: Wed, 17 Aug 2011 09:49:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: "lkml, " <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Gary Thomas <gary@mlbassoc.com>,
        "Woodhouse, David" <david.woodhouse@intel.com>
Subject: Re: can't build modules after clean for powerpc
Message-ID: <20110817074931.GA2629@merkur.ravnborg.org>
References: <4E4B0D28.7010905@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4B0D28.7010905@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 05:36:56PM -0700, Darren Hart wrote:
> According to the Makefile comments and
> Documentation/kconfig/makefile.txt, make clean should leave enough
> intact to build modules with:
> 
> ###
> # Cleaning is done on three levels.
> # make clean     Delete most generated files
> #                Leave enough to build external modules
> 
> The following line in the arch/powerpc/Makefile prevents that from working:
> 
> KBUILD_LDFLAGS_MODULE += arch/powerpc/lib/crtsavres.o
> 
> External module compilation fails to link as it can't find
> arch/powerpc/lib/crtsavres.o.
> 
> It appears from the make logs that crtsavres.o is linked in to
> built-in.o, and thus vmlinux. If that is the case, it doesn't seem like
> crtsavres.o should need to be singled out. What am I missing here?
> 
> If I comment it out:
> 
> #KBUILD_LDFLAGS_MODULE += arch/powerpc/lib/crtsavres.o
> 
> my example module builds successfully.
> 
> If it is necessary, then we need a means to instruct the top level
> makefile to not delete it during "clean". Is there such a directive?
> 
> KBUILD_CLEAN_EXCLUDE_MODULES or something?

Hi Darren.
Try this small patch. Untested and cut'n'pasted...

	Sam


diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 166a6a0..7a577f8 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -30,3 +30,6 @@ obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
 obj-y                  += code-patching.o
 obj-y                  += feature-fixups.o
 obj-$(CONFIG_FTR_FIXUP_SELFTEST) += feature-fixups-test.o
+
+# crtsavres is used by modules - so we need it after "make clean"
+no-clean-files := crtsavres.o


> 
> Thanks,
> 
> -- 
> Darren Hart
> Intel Open Source Technology Center
> Yocto Project - Linux Kernel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
