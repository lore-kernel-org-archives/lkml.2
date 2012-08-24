Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab2HXWOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:14:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58532 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932414Ab2HXWO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:14:27 -0400
Message-ID: <5037FC9F.3090603@fb.com>
Date: Fri, 24 Aug 2012 15:13:51 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Ulrich Drepper <drepper@gmail.com>
Subject: perf backtraces off-by-1
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.254]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-24_08:2012-08-24,2012-08-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of our language runtimes like to map IP addresses in perf backtrace 
to specific byte codes. The way things stand now, the addresses on the 
backtrace are return addresses, rather than the caller. I think this 
issue may be present for other unusual call/return sequences where the 
user may be more interested in the calling instruction rather than the 
instruction control flow would return to.

A simple hack such as the one below makes our JIT guys happy. But the
code is not right if there was an asynchronous transfer of control (eg:
signal handler or interrupt).

libunwind contains similar code, but has the additional info in the 
unwind information to recognize async control transfer.

Wondering if this has been discussed before. One option is to support 
this for user mode only, with code to detect signal frames. Any other ideas?

        -Arun

--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -296,6 +296,7 @@ int machine__resolve_callchain(struct machine *self, 
struct perf_evsel *evsel,
	u8 cpumode = PERF_RECORD_MISC_USER;
	unsigned int i;
	int err;
+	int async;

	callchain_cursor_reset(&evsel->hists.callchain_cursor);

@@ -322,6 +323,11 @@ int machine__resolve_callchain(struct machine 
*self, struct perf_evsel *evsel,
			continue;
		}

+		/* XXX: check if this was an async control transfer */
+		async = 0;
+                if (!async) {
+			ip--;
+		}
		al.filtered = false;
		thread__find_addr_location(thread, self, cpumode,
					   MAP__FUNCTION, ip, &al, NULL);


