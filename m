Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab1LWUtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:49:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757744Ab1LWUtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:49:14 -0500
Message-ID: <4EF4E9A8.7070102@suse.cz>
Date: Fri, 23 Dec 2011 21:50:48 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: build failure after merge of the final tree (wireless
 tree related)
References: <20111222165849.df5ea3e2997375de24f1490b@canb.auug.org.au> <4EF3616D.5050506@suse.cz>
In-Reply-To: <4EF3616D.5050506@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 22.12.2011 17:57, Michal Marek napsal(a):
> Dne 22.12.2011 06:58, Stephen Rothwell napsal(a):
>> Hi ,
>>
>> After merging the final tree, today's linux-next build (powerpc
>> allyesconfig) failed like this:
>>
>> drivers/net/wireless/ath/ath6kl/cfg80211.c:27:1: error: expected ')' before 'KBUILD_MODNAME'
>> drivers/net/wireless/ath/ath6kl/cfg80211.c:27:1: error: 'KBUILD_MODNAME' undeclared here (not in a function)
> [...]
>>
>> I can't figure out what goes wrong here.  On the compile command line,
>> KBUILD_MODNAME is not defined, but KBUILD_BASE_NAME is.
> 
> scripts/Makefile.lib says
> # Note: It's possible that one object gets potentially linked into more
> #       than one module. In that case KBUILD_MODNAME will be set to foo_bar,
> #       where foo and bar are the name of the modules.
> 
> but reality does not match this comment:
> modname_flags  = $(if $(filter 1,$(words $(modname))),\
>                  -D"KBUILD_MODNAME=KBUILD_STR($(call name-fix,$(modname)))")

Thinking about this more, the comment is wrong. The reason is that with
the the modules builtin, KBUILD_MODNAME is needed to generate names of
commandline options to set module parameters: <module name>.<param
name>. And ath6kl_sdio_ath6kl_usb.<param> would first look silly, second
the name would change if we disabled one of the drivers.


> But I wonder why you need to link all the object files twice? Usually,
> drivers have a foo_common.ko and foo_{usb,pci,whatever}.ko that provide
> the pci/usb/whatever driver.

Another option is to build both drivers in a single module. Or, as a
band-aid, make the two drivers module-only, by adding 'depends on m' to
their Kconfig entries.

Michal
