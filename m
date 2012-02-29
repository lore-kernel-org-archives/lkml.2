Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2B2SBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:01:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757469Ab2B2SA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:00:59 -0500
Message-ID: <4F4E67C3.9030000@redhat.com>
Date: Wed, 29 Feb 2012 15:00:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
References: <1330445487-15020-1-git-send-email-bp@amd64.org> <1330445487-15020-2-git-send-email-bp@amd64.org> <4F4D7BF9.9070104@jp.fujitsu.com> <20120229101047.GA21224@aftab> <4F4E145E.4040901@redhat.com> <3908561D78D1C84285E8C5FCA982C28F040162@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F040162@ORSMSX104.amr.corp.intel.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 29-02-2012 14:20, Luck, Tony escreveu:
>> IMHO, before removing those fields, it would be better to first implement
>> what is there at the mcelog userspace parser for the Intel machines into
>> kernelspace (or to look into its source code), and check what registers
>> aren't used by either AMD 64 MCE decoder or by the Intel MCE decoder.
>>
>> Tony,
>>
>> Is there anyone at Intel working on porting it to kernelspace?
> 
> The mcelog code just looks at model specific fields in MCi_STATUS
> and MCi_MISC.  We could move it to the kernel - but I don't see
> much value in doing so. 

I see a few reasons:

	- it would be consistent with what's being done at AMD. So, all x86
	  arch will report errors at the same way;

	- userspace won't need to run an extra daemon/tool to decode the
	  errors;

	- fatal errors won't be lost (well, in fact, you have there already 
	  a parser for fatal errors. Not sure if all possible fatal errors
	  are covered here, nor what else is needed, as you have already 
	  there part of mcelog decoder);

	- a single place to maintain, when new cpu families are added;

	- it makes easier to centralize the hardware error information,
	  as there's no need to enrich the error on userspace.

> In this case all the information we need
> is carried in status/misc - so as long as we keep all of those
> bits (and the cpu family/model) we can safely decode/analyze later.

Hmm... the mcelog tool opens the /proc/cpuinfo:

$ grep cpuinfo *
mcelog.c:	f = fopen("/proc/cpuinfo","r");
mcelog.c:			Eprintf("warning: Cannot parse /proc/cpuinfo\n"); 
mcelog.c:		Eprintf("warning: Cannot open /proc/cpuinfo\n");
tsc.c:	asprintf(&fn, "/sys/devices/system/cpu/cpu%d/cpufreq/cpuinfo_max_freq", cpu);
tsc.c:		/* /sys exists, but no cpufreq -- use value from cpuinfo */

That probably means that the needed cpu family/model info is not (or may not) be
stored at the MCE structure.

> 
> -Tony

