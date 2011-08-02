Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1HBLoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:44:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:33098 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1HBLoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:44:04 -0400
Subject: Re: [PATCH 4/7] perf, x86: Implement IBS interrupt handler
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1311860812-28748-5-git-send-email-robert.richter@amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
	 <1311860812-28748-5-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 02 Aug 2011 13:43:28 +0200
Message-ID: <1312285408.1147.115.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> +       msr = hwc->config_base;
> +       buf = buffer;
> +       rdmsrl(msr++, *buf);
> +       if (!(*buf++ & perf_ibs->valid_mask))
> +               return 0;
> +
> +       perf_sample_data_init(&data, 0);
> +       if (event->attr.sample_type & PERF_SAMPLE_RAW) {
> +               for (i = 1; i < perf_ibs->reg_count; i++)
> +                       rdmsrl(msr++, *buf++);
> +               raw.size = sizeof(u32) + sizeof(u64) * perf_ibs->reg_count;
> +               raw.data = buffer;
> +               data.raw = &raw;
> +       } 

OK, so this dumps a linear range of MSRs into the raw data buffer. The
only 'problem' I have with that is that Fam12 will then also dump 103A
IBS Control Register, which seems pointless.
