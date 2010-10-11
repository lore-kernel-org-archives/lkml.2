Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0JKLHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 07:07:16 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:39806
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754132Ab0JKLHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 07:07:09 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275dhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0LA4HJI-01-GGC-02
X-M-MSG: 
Date: Mon, 11 Oct 2010 13:06:54 +0200
From: Robert Richter <robert.richter@amd.com>
To: Matt Fleming <matt@console-pimps.org>, Paul Mundt <lethal@linux-sh.org>
CC: Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 7/7] sh: oprofile: Use perf-events oprofile backend
Message-ID: <20101011110654.GR13563@erda.amd.com>
References: <cover.1286584677.git.matt@console-pimps.org>
 <a0c83396f5fb8a29baff3daf43d29b2e601511ff.1286584677.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a0c83396f5fb8a29baff3daf43d29b2e601511ff.1286584677.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.10.10 20:46:22, Matt Fleming wrote:
> Now that we've got a generic perf-events based oprofile backend we might
> as well make use of it seeing as SH doesn't do anything special with its
> oprofile backend. Also introduce a new CONFIG_HW_PERF_EVENTS symbol so
> that we can fallback to using the timer interrupt for oprofile if the
> CPU doesn't support perf events.
> 
> Also, to avoid a section mismatch warning we need to annotate
> oprofile_arch_exit() with an __exit marker.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>
> Acked-by: Paul Mundt <lethal@linux-sh.org>
> ---
>  arch/sh/Kconfig            |   13 +++++
>  arch/sh/oprofile/Makefile  |    4 ++
>  arch/sh/oprofile/common.c  |  115 +++++++++-----------------------------------
>  arch/sh/oprofile/op_impl.h |   33 -------------
>  4 files changed, 40 insertions(+), 125 deletions(-)
>  delete mode 100644 arch/sh/oprofile/op_impl.h

> -static int op_sh_create_files(struct super_block *sb, struct dentry *root)
> +char *op_name_from_perf_id(void)
>  {
> -	int i, ret = 0;
> +	const char *pmu;
> +	char buf[20];
> +	int size;
>  
> -	for (i = 0; i < model->num_counters; i++) {
> -		struct dentry *dir;
> -		char buf[4];
> +	pmu = perf_pmu_name();
> +	if (!pmu)
> +		return NULL;
>  
> -		snprintf(buf, sizeof(buf), "%d", i);
> -		dir = oprofilefs_mkdir(sb, root, buf);
> +	size = snprintf(buf, sizeof(buf), "sh/%s", pmu);

Matt and Paul,

are those (upper case) cpu_type strings already supported by the
oprofile userland?

-Robert

> +	if (size > -1 && size < sizeof(buf))
> +		return buf;
>  
> -		ret |= oprofilefs_create_ulong(sb, dir, "enabled", &ctr[i].enabled);
> -		ret |= oprofilefs_create_ulong(sb, dir, "event", &ctr[i].event);
> -		ret |= oprofilefs_create_ulong(sb, dir, "kernel", &ctr[i].kernel);
> -		ret |= oprofilefs_create_ulong(sb, dir, "user", &ctr[i].user);
> -
> -		if (model->create_files)
> -			ret |= model->create_files(sb, dir);
> -		else
> -			ret |= oprofilefs_create_ulong(sb, dir, "count", &ctr[i].count);
> -
> -		/* Dummy entries */
> -		ret |= oprofilefs_create_ulong(sb, dir, "unit_mask", &ctr[i].unit_mask);
> -	}
> -
> -	return ret;
> +	return NULL;
>  }

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

