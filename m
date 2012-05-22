Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab2EVV6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:58:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57394 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2EVV6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:58:46 -0400
Message-ID: <4FBC0C10.8010801@gmail.com>
Date: Tue, 22 May 2012 15:58:40 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>, ak@linux.intel.com,
        Stephane Eranian <eranian@google.com>
Subject: Re: Does perf inject preserve call chain data?
References: <1337712585.3796.186.camel@schen9-DESK>
In-Reply-To: <1337712585.3796.186.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/12 12:49 PM, Tim Chen wrote:
> Arnaldo,
>
> Wonder if perf inject munged the call chain data from perf record?
>
> When I do
> perf record -a -g -o - sleep 5 |perf inject -v -b  | perf report  -g -i -
> I get a complain from perf report
>
> Warning:
> Selected -g but no callchain data. Did you call 'perf record' without -g?
>

I believe the root cause is that the event list is not written to the 
pipe. Using Arnaldo's git repo as of today (has fixes from Stephane) 
this hack shows the info is there and can be processed.


diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d58e414..60f3f17 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -256,7 +257,7 @@ static int perf_report__setup_sample_type(struct 
perf_report *rep)
                     "'perf record' without -g?\n");
             return -EINVAL;
         }
-       if (symbol_conf.use_callchain) {
+       if (!self->fd_pipe && symbol_conf.use_callchain) {
             ui__warning("Selected -g but no callchain data. Did "
                     "you call 'perf record' without -g?\n");
             return -1;

A proper solution is needed.

David
