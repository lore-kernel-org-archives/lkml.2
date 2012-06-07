Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893Ab2FGEBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:01:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:33183 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab2FGEBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="152708446"
Message-ID: <4FD02784.3080302@intel.com>
Date: Thu, 07 Jun 2012 12:01:08 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "Yan, Zheng" <zheng.z.yan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Fix intel shared extra msr allocation
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com> <CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com> <CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com> <1338891271.28282.155.camel@twins> <CABPqkBSv8CbMzUiRsN2uOF1v6rFTpzhQqNbo7OKe-nzsus0GDg@mail.gmail.com> <1338892071.28282.157.camel@twins> <CABPqkBSqLpa4X-WbR0PkouYvhODT78r3pxWq70=PTj1j=a307Q@mail.gmail.com> <1338898024.28282.160.camel@twins> <1338899999.28282.164.camel@twins> <CABPqkBRCMAnPH3UW0=afMw4-YXgwQ5D-NLMEtnNWde_Tzh3aew@mail.gmail.com> <1338901490.28282.167.camel@twins> <CABPqkBRF_2LXE-54tLMBnQgLKbKyR9qo+4VohQiOchpqe1pgyw@mail.gmail.com> <1338903164.28282.177.camel@twins> <CABPqkBQ0OM__Ny9N9ZunKc2nCoqBH+cFY91CUH19xNUbM5NmGw@mail.gmail.com> <1338904039.28282.180.camel@twins> <CABPqkBSMi1ru3Grdh0kyBf6cqLk+=ugy66E0a6KFvFYzmjbgtQ@mail.gmail.com> <CABPqkBRe_+AAFTtuQuA-WKoFx1x3CkSbFBx+yikZqgaYSAG9kw@mail.gmail.com>
In-Reply-To: <CABPqkBRe_+AAFTtuQuA-WKoFx1x3CkSbFBx+yikZqgaYSAG9kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 06:12 PM, Stephane Eranian wrote:
> There is something wrong with this patch, I instrumented the code
> and I can see:
> [ 1377.324575] 1. idx=1 reg_idx=1 ref=-1 config=0xff01 era->config=0xff01
>                                                    ^^^^^^
> The test case on WSM (RSP0, RSP1):
> 
> $ perf stat  -a -C13 -e
> offcore_response_1:dmnd_data_rd,offcore_response_1:dmnd_data_rd sleep
> 100 &
> $ perf stat -a -C1 -e offcore_response_1:dmnd_rfo sleep 1
> 
> I think this happens during scheduling of the events, i.e., during the
> run and not on initial
> programming. That could happen with cgroups, for instance.
> 
The bug is in intel_fixup_er(), it should be:

static void intel_fixup_er(struct perf_event *event, int idx)
{
        if (idx == EXTRA_REG_RSP_0) {
                event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
                event->hw.config |= 0x01b7;
                event->hw.extra_reg.idx = EXTRA_REG_RSP_0;
                event->hw.extra_reg.reg = MSR_OFFCORE_RSP_0;
        } else if (idx == EXTRA_REG_RSP_1) {
                event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
                event->hw.config |= 0x01bb;
                event->hw.extra_reg.idx = EXTRA_REG_RSP_1;
                event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
        }
}

Regards
Yan, Zheng
