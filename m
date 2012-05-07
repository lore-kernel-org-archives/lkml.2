Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab2EGPPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:15:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37860 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2EGPPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:15:32 -0400
Subject: Re: [PATCH 4/7] perf/x86-ibs: Add support for IBS pseudo events
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120507144756.GG18810@erda.amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
	 <1335983192-23731-5-git-send-email-robert.richter@amd.com>
	 <1336388454.27020.2.camel@laptop>  <20120507144756.GG18810@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 May 2012 17:15:18 +0200
Message-ID: <1336403718.27020.64.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 16:47 +0200, Robert Richter wrote:
> > Who again wasn't decoding anything in perf_event_attr:config* ?
> 
> attr:config is one of the ibs control msrs comparable with perfctr's
> evntsel msr:
> 
>  MSRC001_1030 IBS Fetch Control Register (IbsFetchCtl)
>  MSRC001_1033 IBS Execution Control Register (IbsOpCtl)

You missed reading a '*', even so:

> There are some options (randomisation, cycle/micro-op counting) but
> usually it is null since the period is encoded in attr:period. But ibs
> could be setup by an application using attr:config only which then
> passes the value directly to the ctl msr. 

PMU_FORMAT_ATTR(IbsFetchMaxCnt, "config:0-15"   );
PMU_FORMAT_ATTR(IbsFetchCnt,	"config:16-31"	);
PMU_FORMAT_ATTR(IbsFetchVal,	"config:49"	);
PMU_FORMAT_ATTR(IbsRandEn,	"config:57"	);

and

PMU_FORMAT_ATTR(IbsOpMaxCnt,	"config:0-15"	);
PMU_FORMAT_ATTR(IbsOpVal,	"config:18"	);
PMU_FORMAT_ATTR(IbsOpCntCtl,	"config:19"	); /* subject to ibs_caps */

Are the writable bitfields of those two MSRs resp.

This patch adds:

PMU_FORMAT_ATTR(IbsFilter0Idx,	"config1:0-7"	);
PMU_FORMAT_ATTR(IbsFilter0Type,	"config1:12-15"	);
PMU_FORMAT_ATTR(IbsFilter0Mask,	"config1:16-23"	);
PMU_FORMAT_ATTR(IbsFilter0Match,"config1:24-31"	);
PMU_FORMAT_ATTR(IbsFilter0Any,	"config1:16-31"	);

PMU_FORMAT_ATTR(IbsFilter1Idx,	"config1:32-39"	);
PMU_FORMAT_ATTR(IbsFilter1Type,	"config1:44-47"	);
PMU_FORMAT_ATTR(IbsFilter1Mask,	"config1:48-55"	);
PMU_FORMAT_ATTR(IbsFilter1Match,"config1:56-63"	);
PMU_FORMAT_ATTR(IbsFilter1Any,	"config1:48-63"	);

PMU_FORMAT_ATTR(IbsFilter2Idx,	"config2:0-7"	);
PMU_FORMAT_ATTR(IbsFilter2Type,	"config2:12-15"	);
PMU_FORMAT_ATTR(IbsFilter2Mask,	"config2:16-23"	);
PMU_FORMAT_ATTR(IbsFilter2Match,"config2:24-31"	);
PMU_FORMAT_ATTR(IbsFilter2Any,	"config2:16-31"	);

PMU_FORMAT_ATTR(IbsFilter3Idx,	"config2:32-39"	);
PMU_FORMAT_ATTR(IbsFilter3Type,	"config2:44-47"	);
PMU_FORMAT_ATTR(IbsFilter3Mask,	"config2:48-55"	);
PMU_FORMAT_ATTR(IbsFilter3Match,"config2:56-63"	);
PMU_FORMAT_ATTR(IbsFilter3Any,	"config2:48-63"	);

And you can write your events like:

ibs_fetch/IbsFilter0Type=1,IbsFilter0Idx=48,IbsFilter0Mask=0x4,IbsFilter0Match=0x4/

No need to duplicate the struct and you're free to re-arrange the actual
bitfields if there ever is a need.

Even more, if you were to expose these events through sysfs
ibs_fetch/events/$foo you could modify the lot and it'd still all work.

No need to query cpuid to figure out if you're fam 10h+, no need to read
ibs_caps in userspace to figure out if config:19 is available, and no
need to duplicate that struct.

And don't tell me your config[12] fields are spec'ed somewhere..





