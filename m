Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0DVOqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:46:19 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:1910 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755212Ab0DVOqR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:46:17 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L1A90O-02-F9E-02
X-M-MSG: 
Date: Thu, 22 Apr 2010 16:45:58 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/12] perf, x86: implement the ibs interrupt handler
Message-ID: <20100422144558.GG6450@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-13-git-send-email-robert.richter@amd.com>
 <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 22 Apr 2010 14:45:59.0130 (UTC) FILETIME=[8597C3A0:01CAE22A]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.04.10 14:19:57, Stephane Eranian wrote:
> > +       perf_sample_data_init(&data, 0);
> > +       if (event->attr.sample_type & PERF_SAMPLE_RAW) {
> > +               for (i = 1; i < size; i++)
> > +                       rdmsrl(msr++, *buf++);
> > +               raw.size = sizeof(u64) * size;
> > +               raw.data = buffer;
> > +               data.raw = &raw;
> > +       }
> > +
> 
> Need to add the padding: raw.size = sizeof(u64) * size + sizeof(u32);

The u32 size header in the raw sampling data layout leads to unaligned
memory access for 64 bit values. No matter if the padding is inserted
at the beginning or end of the raw sample, it introduces either on the
sending or receiving side an 32 bit offset.

Wouldn't it be better to simply make size an u64 or to add another
reserved u32 value to the header. This could introduce some overhead
on smaller architectures, but currently this is only used on x86. The
event size encoding of the ring_buffer implementation could be another
alternative.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

