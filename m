Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab1JUILB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 04:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab1JUIK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 04:10:59 -0400
Date: Fri, 21 Oct 2011 10:10:24 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "Xu, Anhua" <anhua.xu@intel.com>
Cc: "acme@redhat.com" <acme@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>, "paulus@samba.org" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
 sample type
Message-ID: <20111021081024.GA2033@jolsa.brq.redhat.com>
References: <1317312068-10411-1-git-send-email-jolsa@redhat.com>
 <1A42CE6F5F474C41B63392A5F80372B212DCA02CB2@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1A42CE6F5F474C41B63392A5F80372B212DCA02CB2@shsmsx501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 03:18:31PM +0800, Xu, Anhua wrote:
> I installed the latest kernel and found without such patch( not sure if other patches were added besides this one). That following command works fine.
> perf record -o perf.data -e ext3:ext3_request_inode -e LLC-loads -- date '+%F'
hi,
was there any ext3 event stored? The issue should be hit when
processing stored events.. either in the atexit code or during
report.

Following command freezes for me on 3.1.0-rc10-tip+:
./perf record -o perf.data -e ext4:ext4_request_inode -e LLC-loads -- date '+%F'


wbr,
jirka

> 
> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Jiri Olsa
> Sent: Friday, September 30, 2011 12:01 AM
> To: acme@redhat.com; a.p.zijlstra@chello.nl; mingo@elte.hu; paulus@samba.org
> Cc: linux-kernel@vger.kernel.org; Jiri Olsa
> Subject: [PATCH] perf tools: Exit recording if events have non matching sample type
> 
> The event processing relies on all events having the same sample_type.
> 
> This is being checked when the session is being opened read only.
> It also needs to be checked when we do record, since events could be
> read during processing build IDs at the end of the record command.
> 
> If we process events with different sample_type the processing might
> skip some events or hang.
> 
> Following command hangs on my setup:
>   ./perf record -o perf.data -e ext4:ext4_mb_new_group_pa \
>    -e LLC-loads -- date '+%F'
> 
> because hardware and tracepoint events have different sample type.
> 
> With the patch applied the record command displays
> "Non matching sample_type" message and exits.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/builtin-record.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index f4c3fbe..71e2c4e 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -832,6 +832,12 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
>  		goto out_symbol_exit;
>  	}
>  
> +	if (!perf_evlist__valid_sample_type(evsel_list)) {
> +		pr_err("Non matching sample_type\n");
> +		err = -EINVAL;
> +		goto out_symbol_exit;
> +	}
> +
>  	if (target_pid != -1)
>  		target_tid = target_pid;
>  
> -- 
> 1.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
