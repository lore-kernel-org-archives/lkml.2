Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab1LOTTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:19:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52030 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab1LOTTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:19:11 -0500
Message-ID: <4EEA4827.2000302@gmail.com>
Date: Thu, 15 Dec 2011 12:19:03 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com> <1323969824-9711-5-git-send-email-robert.richter@amd.com>
In-Reply-To: <1323969824-9711-5-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/15/2011 10:23 AM, Robert Richter wrote:
> This patch adds a script to collect and display IBS samples.
> There are the following options:
> 
>  perf script ibs [ibs_op|ibs_fetch] [-c period] <command>
> 
> Examples for usage:
> 
>  perf script ibs ibs_op <command>
>  perf script ibs ibs_fetch <command>
>  perf script record ibs ibs_op -c 500000 <command>
>  perf script report ibs
>  perf script record ibs ibs_op -c 500000 <command> | perf script report ibs
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  tools/perf/scripts/perl/bin/ibs-record |   23 +++++++++++++++
>  tools/perf/scripts/perl/bin/ibs-report |    6 ++++
>  tools/perf/scripts/perl/ibs.pl         |   47 ++++++++++++++++++++++++++++++++
>  3 files changed, 76 insertions(+), 0 deletions(-)
>  create mode 100644 tools/perf/scripts/perl/bin/ibs-record
>  create mode 100644 tools/perf/scripts/perl/bin/ibs-report
>  create mode 100644 tools/perf/scripts/perl/ibs.pl
> 
> diff --git a/tools/perf/scripts/perl/bin/ibs-record b/tools/perf/scripts/perl/bin/ibs-record
> new file mode 100644
> index 0000000..dc5f4d2
> --- /dev/null
> +++ b/tools/perf/scripts/perl/bin/ibs-record
> @@ -0,0 +1,23 @@
> +#! /bin/bash
> +
> +while [ "${1+defined}" ]; do
> +    case $1 in
> +	ibs_op|ibs_fetch)
> +	    EVENT=$1
> +	    shift
> +	    break
> +	    ;;
> +	-*)
> +	    REC_OPT+=($1)
> +	    shift
> +	    ;;
> +	*)
> +	    echo $0 "$@" >&2
> +	    echo "Invalid option: $1" >&2
> +	    echo "perf script ibs [ibs_op|ibs_fetch] [-c <period>]" >&2
> +	    exit 1
> +	    ;;
> +    esac
> +done
> +
> +perf record -e ${EVENT:-ibs_op}:r0 -c 100000 -R -a "${REC_OPT[@]}" "$@"
> diff --git a/tools/perf/scripts/perl/bin/ibs-report b/tools/perf/scripts/perl/bin/ibs-report
> new file mode 100644
> index 0000000..f44e69d
> --- /dev/null
> +++ b/tools/perf/scripts/perl/bin/ibs-report
> @@ -0,0 +1,6 @@
> +#! /bin/bash
> +
> +# description: collect and display AMD IBS samples
> +# args: [ibs_op|ibs_fetch] [-c period]
> +
> +perf script -s "$PERF_EXEC_PATH"/scripts/perl/ibs.pl "$@"
> diff --git a/tools/perf/scripts/perl/ibs.pl b/tools/perf/scripts/perl/ibs.pl
> new file mode 100644
> index 0000000..caee32f
> --- /dev/null
> +++ b/tools/perf/scripts/perl/ibs.pl
> @@ -0,0 +1,47 @@
> +#
> +# ibs.pl - perf script for AMD Instruction Based Sampling
> +#
> +# Copyright (C) 2011 Advanced Micro Devices, Inc., Robert Richter
> +#
> +# For licencing details see kernel-base/COPYING
> +#
> +# description: collect and display AMD IBS samples
> +# args: [ibs_op|ibs_fetch] [-c period]
> +#
> +# examples:
> +#
> +#  perf script ibs ibs_op <command>
> +#  perf script ibs ibs_fetch <command>
> +#  perf script record ibs ibs_op -c 500000 <command>
> +#  perf script report ibs
> +#  perf script record ibs ibs_op -c 500000 <command> | perf script report ibs
> +#
> +
> +# Packed byte string args of process_event():
> +#
> +# $event:	union perf_event	util/event.h
> +# $attr:	struct perf_event_attr	linux/perf_event.h
> +# $sample:	struct perf_sample	util/event.h
> +# $raw_data:	perf_sample->raw_data	util/event.h
> +
> +sub process_event
> +{
> +	my ($event, $attr, $sample, $raw_data) = @_;
> +
> +	my ($type)		= (unpack("LSS", $event))[0];
> +	my ($sample_type)	= (unpack("LLQQQQQLLQQ", $attr))[4];
> +	my ($cpu, $raw_size)	= (unpack("QLLQQQQQLL", $sample))[8, 9];
> +	my ($caps, @ibs_data)	= unpack("LQ*", $raw_data);
> +
> +	return if (!$raw_size);		# no raw data
> +
> +	if (scalar(@ibs_data) ==  3) {
> +	        printf("IBS_FETCH sample on cpu%d\tIBS0: 0x%016x IBS1: 0x%016x IBS2:0x%016x\n",
> +		       $cpu, @ibs_data);
> +	} else {
> +	        printf("IBS_OP sample on cpu%d\t" .
> +		       "\t IBS0: 0x%016x IBS1: 0x%016x IBS2: 0x%016x\n" .
> +		       "\tIBS3: 0x%016x IBS4: 0x%016x IBS5: 0x%016x IBS6: 0x%016x\n",
> +		       cpu, @ibs_data);
> +	}
> +}

Doesn't seem like you are verifying that the tracepoints fed to this
script are actually ibs related. For example, if a user points to the
wrong perf.data which has raw data in it this script would happily parse
and display numbers.

Also, why a perl script versus the builtin dumping capability of
perf-script? e.g., add ibs to the fields and while processing the event
verify that the tracepoint is ibs related.

David
