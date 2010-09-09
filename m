Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab0IINwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 09:52:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53987 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab0IINwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 09:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DaMgthKQCAB6/69wmfVEE/bNO5DlIloiKzwfyLSBJMZt6csewwRggf3iRtPTI3CGrl
         4PGXPbkCBa6a+WV8cK96C76ZyZ8aDgSfmXctsfZOjxYIMCAo87K6fc71c4Xze+JUtpPy
         dXxBIXdtBeXYQP5h+HC3PFaMOqCvWX/OtD1pA=
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu
 per-cgroup monitoring (v3)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com
In-Reply-To: <4c88dca1.44e7d80a.577e.3592@mx.google.com>
References: <4c88dca1.44e7d80a.577e.3592@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 15:52:02 +0200
Message-ID: <1284040322.2589.174.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 09 septembre 2010 à 06:09 -0700, Stephane Eranian a écrit :
> This kernel patch adds the ability to filter monitoring based on
> container groups (cgroups). This is for use in per-cpu mode only.
>     
> The patch adds perf_event_attr.cgroup, a boolean, to activate
> this new mode. The cgroup is designated by passing in
> perf_event_attr.cgroup_fd, an opened file descriptor to
> the <mnt>/<cgroup>/perf_event.perf file.
>     
> This is the second version of this patch. It corrects the way
> time_enabled is accounted for. In cgroup mode, time_enabled reflects
> the time the cgroup was active, i.e., threads from the cgroup executed
> on the monitored CPU.  This is a more useful metric than just
> wall-clock. The meaning of time_enabled without cgroup is unaffected.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>


> +#ifdef CONFIG_CGROUPS
> +struct perf_cgroup_time {
> +	u64 time;
> +	u64 timestamp;
> +};
> +
> +struct perf_cgroup {
> +	struct cgroup_subsys_state css;
> +	struct perf_cgroup_time *time;

	struct perf_cgroup_time __percpu *time;

Please run sparse  after this "__percpu" change.



> +};
> +#endif
> +
>  /*
> +
> +	jc->time = alloc_percpu(struct perf_cgroup_time);
> +	if (!jc->time) {
> +		vfree(jc);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	for_each_possible_cpu(c) {
> +		t = per_cpu_ptr(jc->time, c);
> +		t->time = 0;
> +		t->timestamp = 0;
> +	}

alloc_percpu() is zalloc_percpu() in fact, memory is already cleared.


