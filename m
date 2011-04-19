Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1DSTW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 15:22:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab1DSTW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 15:22:57 -0400
Subject: Re: [BUG] perf_event: sampling buffer format cannot handle
 multi-event sampling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        Paul Mackerras <paulus@samba.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <BANLkTi=g6iPgdctAmuZ=bb8J6FqNJA-vZQ@mail.gmail.com>
References: <BANLkTi=g6iPgdctAmuZ=bb8J6FqNJA-vZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Apr 2011 21:22:15 +0200
Message-ID: <1303240935.8345.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 19:10 +0000, Stephane Eranian wrote:
> Hi,
> 
> I was looking at the sampling buffer format and I think there is an
> issue in case
> one samples on more than one event at a time and each event as a different
> sample_type value (i.e., what it wants to record in each sample).
> 
> The sample_type is exported per-event by the API. In order to decode a sample
> (PERF_RECORD_SAMPLE) one has to know which event caused it. To identify
> the event, one has to include PERF_SAMPLE_ID in the sample_type. Each such
> id uniquely identifies an event. Assuming the tool keeps a mapping of event to
> ID, we can then reconstruct. This is what perf does.
> 
> The problem is that to extract the event ID, one has to already parse the sample
> itself. That means, you need sample_type to extract the event ID.
> 
> Thus, we have a catch 22 situation.
> 
> Looking at the perf tool, it sort of works today simply because the
> same sample_type
> is applied to all events.
> 
> To solve this, we could either:
>    - add the event ID to the header for PERF_RECORD_SAMPLE
>    - enforce event ID is systematically saved at the beginning on
> PERF_RECORD_SAMPLE
> 
> None of those options is transparent, I am afraid, unless we introduce
> new record types.

Or simply don't mix different sample_types in the same buffer?
