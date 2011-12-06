Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1LFQeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:34:23 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:22699 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1LFQeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:34:22 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVSJCY-01-203-02
X-M-MSG: 
Date: Tue, 6 Dec 2011 17:33:58 +0100
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] perf tool: Unify handling of features when writing
 feature section
Message-ID: <20111206163358.GL15738@erda.amd.com>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
 <1323167560-2282-9-git-send-email-robert.richter@amd.com>
 <20111206133630.GI7059@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111206133630.GI7059@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.12.11 11:36:30, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 06, 2011 at 11:32:38AM +0100, Robert Richter escreveu:
> > Also moving special code for HEADER_BUILD_ID out to write_build_id().
> 
> For this one I just would add a big fat warning that if there are
> build-ids on the system but the table can't be written, then extreme
> care has to be taken when doing a perf report.
> 
> I.e. one has to be completely sure that the binaries hasn't changed if
> not validating the build-ids.
> 
> If you fix that please add this warning as well when no build-ids are
> found, which hopefully is the odd case these days as all distros I'm
> aware of have build-ids in all DSOs.

What about the following change in addition? perf record then still
stops with an error, but --no-buildid could be used to proceed anyway:

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 766fa0a..80e08ca 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -493,6 +493,13 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
                        return err;
        }
 
+       if (!no_buildid
+           && !perf_header__has_feat(&session->header, HEADER_BUILD_ID)) {
+               pr_err("Couldn't generate buildids. "
+                      "Use --no-buildid option to profile anyway.\n");
+               return -1;
+       }
+
        rec->post_processing_offset = lseek(output, 0, SEEK_CUR);
 
        machine = perf_session__find_host_machine(session);


-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

