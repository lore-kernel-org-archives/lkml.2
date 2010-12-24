Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab0LXKEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 05:04:36 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37747 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab0LXKEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 05:04:34 -0500
X-AuditID: b753bd60-a44fbba000000f8d-3e-4d14702ffbd7
Message-ID: <4D147027.7000802@hitachi.com>
Date: Fri, 24 Dec 2010 19:04:23 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v2 2/6] perf bts: Introduce new sub command 'perf
 bts trace'
References: <20101221090527.8552.41486.stgit@localhost6.localdomain6> <20101221090549.8552.26257.stgit@localhost6.localdomain6> <20101221183131.GO1750@nowhere>
In-Reply-To: <20101221183131.GO1750@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/22 3:31), Frederic Weisbecker wrote:
[...]
>> +static int process_sample_event(event_t *event __unused,
>> +	struct sample_data *sample, struct perf_session *session __unused)
>> +{
>> +	/* sample->ip is 'from address', sample->addr is 'to address' */
>> +	printf(FMT_ADDR " =>  " FMT_ADDR "\n", sample->ip, sample->addr);
>
> It seems this unconditionally prints out the event, but a sample
> event can be about anything. If you recorded only branches it's fine,
> but if there were other events this will mess up.
Exactly.
I'll add a check code of PERF_SAMPLE_ID there.


And, I found the problem that perf cannot handle the data including
multiple event types. I executed following command to make perf.data
includes two event types: hardware and software event.

  # perf record -e branches:u -c 1 -d -e raw_syscalls:sys_enter ls
  (... ls outputs)
[ perf record: Woken up 18 times to write data ]
[ perf record: Captured and wrote 4.468 MB perf.data (~195216 samples) ]

  # perf bts trace
   Fatal: non matching sample_type

It results in error. Other perf subcommands also failed on this recorded data.
For example, perf annotate, perf script, perf report.

In the future, I would like to analyze BTS log and other type events
at the same time.

>
> Well, when you launch the tool you can iterate into the session->header.attr
> and check if there is something else than a branch perf event. And then emit
> a warning if so.
>
> That doesn't solve the problem but the user will know there is one.
>
> Actually the best would be to select PERF_SAMPLE_ID in the sample_type
> on record and also PERF_FORMAT_ID in the read_format.
>
> Then you can find the PERF_SAMPLE_ID that matches your event. If we
> record that in the perf headers we can retrieve which events id are the
> branch ones.
Agreed.

>
> But well, that's a secondary problem for now.
Thank you for your advise!

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
------------------------------------
Akihiro Nagai
Email: akihiro.nagai.hw@hitachi.com
