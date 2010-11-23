Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0KWLIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 06:08:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:38719 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0KWLIW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 06:08:22 -0500
Subject: Re: [PATCH 3/6] perf: Add timestamp to COMM and MMAP events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <1290490544-14349-4-git-send-email-imunsie@au1.ibm.com>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
	 <1290490544-14349-4-git-send-email-imunsie@au1.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 12:08:32 +0100
Message-ID: <1290510512.2072.387.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 16:35 +1100, Ian Munsie wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> This patch adds extra ABI to the perf interface to allow the
> PERF_RECORD_COMM and PERF_RECORD_MMAP events to optionally include a
> timestamp, which they were previously missing.
> 
> This has become necessary since the move to per-task-per-cpu events in
> perf as those events would not necessarily be recorded prior to any
> samples associated with them and would cause perf to miss-attribute
> those events and produce bogus reports. This behaviour can be observed
> almost every run on 64 CPU PowerPC systems, but has also been observed
> on a simple quad core Intel i7.
> 
> The timestamp is requested by setting the all_timed flag in the
> event attributes when opening the event and will be placed just after
> the header of the events in question.
> 
> This patch also ensures that the PERF_RECORD_COMM event is dispatched
> before enabling the counters for enable_on_exec.
> 

> @@ -332,6 +333,7 @@ enum perf_event_type {
>  	 *
>  	 * struct {
>  	 *	struct perf_event_header	header;
> +	 *	{ u64			time;     } && all_timed
>  	 *
>  	 *	u32				pid, tid;
>  	 *	u64				addr;
> @@ -354,6 +356,7 @@ enum perf_event_type {
>  	/*
>  	 * struct {
>  	 *	struct perf_event_header	header;
> +	 *	{ u64			time;     } && all_timed
>  	 *
>  	 *	u32				pid, tid;
>  	 *	char				comm[];


Right, so acme had a patch adding

PERF_SAMPLE_TID
PERF_SAMPLE_TIME
PERF_SAMPLE_ID
PERF_SAMPLE_CPU
PERF_SAMPLE_STREAM_ID

(IIRC) to every record.. so solve this same problem. Except he got
interrupted by KS and things and didn't get around to posting it.

Arnaldo?
