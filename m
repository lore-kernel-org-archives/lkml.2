Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab0GUBay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 21:30:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:1252 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761771Ab0GUBaw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 21:30:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,235,1278313200"; 
   d="scan'208";a="820022528"
From: "Zheng, Jiajia" <jiajia.zheng@intel.com>
To: Michal Marek <mmarek@suse.cz>
CC: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Date: Wed, 21 Jul 2010 09:30:39 +0800
Subject: RE: "make rpm" failed with parameter "--scm-only"
Thread-Topic: "make rpm" failed with parameter "--scm-only"
Thread-Index: AcsoD3c2zhGwi4caSJKT4xqxa1QImAAXi5EA
Message-ID: <A24AE1FFE7AEC5489F83450EE98351BF1BDE3704AC@shsmsx502.ccr.corp.intel.com>
References: <A24AE1FFE7AEC5489F83450EE98351BF1BD77643B1@shsmsx502.ccr.corp.intel.com>
 <20100715084233.GA5835@sepie.suse.cz> <20100720132851.GA31205@sepie.suse.cz>
In-Reply-To: <20100720132851.GA31205@sepie.suse.cz>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Michal Marek wrote:
> On Thu, Jul 15, 2010 at 10:42:33AM +0200, Michal Marek wrote:
>> On Thu, Jul 15, 2010 at 11:23:19AM +0800, Zheng, Jiajia wrote:
>>> # make rpm
>>> make clean
>>> set -e; cd ..; ln -sf /usr/src/iwlwifi-2.6 kernel-2.6.35rc4wl
>>> /bin/sh /usr/src/iwlwifi-2.6/scripts/setlocalversion --scm-only >
>>> /usr/src/iwlwifi-2.6/.scmversion cat: .scmversion: input file is
>>> output file 
>>> make[1]: *** [rpm] Error 1
>>> make: *** [rpm] Error 2
>> 
>> Ah crap :-/. The following patch should fix it. BTW, if you remove
>> the --scm-only option and use the LOCALVERSION mechanism, then the
>> resulting 
>> kernel release string will have the localversion twice.
> 
> Hi jiajia,
> 
> were you able to test the fix? I'd like to send it to Linus.
> 
> Michal
Thank you. This patch works OK. 
But I still saw below warnings. Of course, it was not introduced by your patch because that I saw such warnings before. Could you also take a look if there's some problem with Makefile? 
...
+ make clean
make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
+ make -j4
make[2]: warning: -jN forced in submake: disabling jobserver mode.
...
I got a RPM package: kernel-2.6.35rc5wl+-6.x86_64.rpm

bests, 
jiajia
> 
>> From 1df62f9175665a0573fe9708cb8604584a9b7bd5 Mon Sep 17 00:00:00
>> 2001 
>> From: Michal Marek <mmarek@suse.cz>
>> Date: Thu, 15 Jul 2010 10:36:37 +0200
>> Subject: [PATCH] kbuild: Fix make rpm
>> 
>> make rpm was broken by commit 0915512:
>> make clean
>> set -e; cd ..; ln -sf /usr/src/iwlwifi-2.6 kernel-2.6.35rc4wl
>> /bin/sh /usr/src/iwlwifi-2.6/scripts/setlocalversion --scm-only >
>> /usr/src/iwlwifi-2.6/.scmversion
>> cat: .scmversion: input file is output file
>> make[1]: *** [rpm] Error 1
>> 
>> Reported-by: "Zheng, Jiajia" <jiajia.zheng@intel.com>
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>> 
>> diff --git a/scripts/package/Makefile b/scripts/package/Makefile
>> index 3a681ef..d2c29b6 100644
>> --- a/scripts/package/Makefile
>> +++ b/scripts/package/Makefile
>> @@ -44,7 +44,7 @@ rpm-pkg rpm: $(objtree)/kernel.spec FORCE  	fi
>>  	$(MAKE) clean
>>  	$(PREV) ln -sf $(srctree) $(KERNELPATH)
>> -	$(CONFIG_SHELL) $(srctree)/scripts/setlocalversion --scm-only >
>> $(objtree)/.scmversion +	$(CONFIG_SHELL)
>>  	$(srctree)/scripts/setlocalversion --save-scmversion $(PREV) tar
>>  	-cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz $(KERNELPATH)/. 
>> $(PREV) rm $(KERNELPATH) rm -f $(objtree)/.scmversion 
>> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
>> index d6a866e..951b067 100755
>> --- a/scripts/setlocalversion
>> +++ b/scripts/setlocalversion
>> @@ -10,13 +10,13 @@
>>  #
>> 
>>  usage() {
>> -	echo "Usage: $0 [--scm-only] [srctree]" >&2
>> +	echo "Usage: $0 [--save-scmversion] [srctree]" >&2  	exit 1
>>  }
>> 
>>  scm_only=false
>>  srctree=.
>> -if test "$1" = "--scm-only"; then
>> +if test "$1" = "--save-scmversion"; then
>>  	scm_only=true
>>  	shift
>>  fi
>> @@ -131,7 +131,10 @@ collect_files()
>>  }
>> 
>>  if $scm_only; then
>> -	scm_version
>> +	if test ! -e .scmversion; then
>> +		res=$(scm_version)
>> +		echo "$res" >.scmversion
>> +	fi
>>  	exit
>>  fi


