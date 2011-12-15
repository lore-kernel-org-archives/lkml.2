Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852Ab1LOXrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:47:37 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:3220
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759690Ab1LOXrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:47:35 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LW9RF3-02-9RA-02
X-M-MSG: 
Date: Fri, 16 Dec 2011 00:47:28 +0100
From: Robert Richter <robert.richter@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
Message-ID: <20111215234727.GJ15738@erda.amd.com>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
 <1323969824-9711-5-git-send-email-robert.richter@amd.com>
 <4EEA4827.2000302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EEA4827.2000302@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.12.11 12:19:03, David Ahern wrote:

> > +sub process_event
> > +{
> > +	my ($event, $attr, $sample, $raw_data) = @_;
> > +
> > +	my ($type)		= (unpack("LSS", $event))[0];
> > +	my ($sample_type)	= (unpack("LLQQQQQLLQQ", $attr))[4];
> > +	my ($cpu, $raw_size)	= (unpack("QLLQQQQQLL", $sample))[8, 9];
> > +	my ($caps, @ibs_data)	= unpack("LQ*", $raw_data);
> > +
> > +	return if (!$raw_size);		# no raw data
> > +
> > +	if (scalar(@ibs_data) ==  3) {
> > +	        printf("IBS_FETCH sample on cpu%d\tIBS0: 0x%016x IBS1: 0x%016x IBS2:0x%016x\n",
> > +		       $cpu, @ibs_data);
> > +	} else {
> > +	        printf("IBS_OP sample on cpu%d\t" .
> > +		       "\t IBS0: 0x%016x IBS1: 0x%016x IBS2: 0x%016x\n" .
> > +		       "\tIBS3: 0x%016x IBS4: 0x%016x IBS5: 0x%016x IBS6: 0x%016x\n",
> > +		       cpu, @ibs_data);
> > +	}
> > +}
> 
> Doesn't seem like you are verifying that the tracepoints fed to this
> script are actually ibs related. For example, if a user points to the
> wrong perf.data which has raw data in it this script would happily parse
> and display numbers.

For 'perf script ibs' and 'perf script record ibs' this does not
matter as the builtin perf record wrapper is used that always creates
ibs data. For 'perf script report ibs' the perf.data file is not
checked for valid ibs samples. In case you point to a wrong file your
report will be wrong too. I don't think this is an issue for this
initial version. The pmu mapping is already in the header so
implementing a check is generally possible.

> Also, why a perl script versus the builtin dumping capability of
> perf-script? e.g., add ibs to the fields and while processing the event
> verify that the tracepoint is ibs related.

IBS samples are not tracepoints but some special kind of hardware
event. It would be hard to reuse the tracing framework for this. Also,
the parser above is intended to be a reference implementation of how
to generate and decode ibs samples. It should be the basis for
customized scripts to extract information from ibs data.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

