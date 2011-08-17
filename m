Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1HQTCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:02:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:15360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab1HQTCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:02:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="38747795"
Message-ID: <4E4C1039.5050203@linux.intel.com>
Date: Wed, 17 Aug 2011 12:02:17 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "lkml, " <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Gary Thomas <gary@mlbassoc.com>,
        "Woodhouse, David" <david.woodhouse@intel.com>
Subject: Re: can't build modules after clean for powerpc
References: <4E4B0D28.7010905@linux.intel.com> <20110817074931.GA2629@merkur.ravnborg.org>
In-Reply-To: <20110817074931.GA2629@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2011 12:49 AM, Sam Ravnborg wrote:
> On Tue, Aug 16, 2011 at 05:36:56PM -0700, Darren Hart wrote:
>> According to the Makefile comments and
>> Documentation/kconfig/makefile.txt, make clean should leave enough
>> intact to build modules with:
>>
>> ###
>> # Cleaning is done on three levels.
>> # make clean     Delete most generated files
>> #                Leave enough to build external modules
>>
>> The following line in the arch/powerpc/Makefile prevents that from working:
>>
>> KBUILD_LDFLAGS_MODULE += arch/powerpc/lib/crtsavres.o
>>
>> External module compilation fails to link as it can't find
>> arch/powerpc/lib/crtsavres.o.
>>
>> It appears from the make logs that crtsavres.o is linked in to
>> built-in.o, and thus vmlinux. If that is the case, it doesn't seem like
>> crtsavres.o should need to be singled out. What am I missing here?
>>
>> If I comment it out:
>>
>> #KBUILD_LDFLAGS_MODULE += arch/powerpc/lib/crtsavres.o
>>
>> my example module builds successfully.
>>
>> If it is necessary, then we need a means to instruct the top level
>> makefile to not delete it during "clean". Is there such a directive?
>>
>> KBUILD_CLEAN_EXCLUDE_MODULES or something?
> 
> Hi Darren.
> Try this small patch. Untested and cut'n'pasted...
> 
> 	Sam
> 

Hi Sam,

> 
> diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
> index 166a6a0..7a577f8 100644
> --- a/arch/powerpc/lib/Makefile
> +++ b/arch/powerpc/lib/Makefile
> @@ -30,3 +30,6 @@ obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
>  obj-y                  += code-patching.o
>  obj-y                  += feature-fixups.o
>  obj-$(CONFIG_FTR_FIXUP_SELFTEST) += feature-fixups-test.o
> +
> +# crtsavres is used by modules - so we need it after "make clean"
> +no-clean-files := crtsavres.o

This doesn't cut it unfortunately:

linux-powerpc-poky-linux-ld: cannot find arch/powerpc/lib/crtsavres.o:
No such file or directory

The .o file is purged by the top level Makefile here:

 clean: $(clean-dirs)
	$(call cmd,rmdirs)
	$(call cmd,rmfiles)
	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
		-o -name '*.symtypes' -o -name 'modules.order' \
		-o -name modules.builtin -o -name '.tmp_*.o.*' \
		-o -name '*.gcno' \) -type f -print | xargs rm -f

Which is why I was thinking of something similar to RCS_FIND_IGNORE that
we could use, like KBUILD_FIND_IGNORE_MODULE.

--
Darren

> 
>>
>> Thanks,
>>
>> -- 
>> Darren Hart
>> Intel Open Source Technology Center
>> Yocto Project - Linux Kernel
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
