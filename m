Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2APKEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 05:04:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab2APKEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 05:04:37 -0500
Message-ID: <4F13F631.9010804@redhat.com>
Date: Mon, 16 Jan 2012 12:04:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F13EEC5.8050807@linux.vnet.ibm.com>
In-Reply-To: <4F13EEC5.8050807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 11:32 AM, Xiao Guangrong wrote:
> Add 'perf kvm-events' support to analyze kvm vmexit/mmio/ioport smartly
>
> Usage:
> 	perf kvm-events record

Why not 'perf record -e kvm'?

> 	perf kvm-events report



> +static const char *get_exit_reason(long isa, u64 exit_code)
> +{
> +	int table_size = ARRAY_SIZE(svm_exit_reasons);
> +	struct exit_reasons_table *table = svm_exit_reasons;
> +
> +
> +	if (isa == 1) {
> +		table = vmx_exit_reasons;
> +		table_size = ARRAY_SIZE(vmx_exit_reasons);
> +	}
> +
> +	while (table_size--) {
> +		if (table->exit_code == exit_code)
> +			return table->reason;

... table[exit_code] ...

> +		table++;
> +	}
> +
> +	die("unkonw kvm exit code:%ld on %s\n", exit_code, isa == 1 ?
> +						"VMX" : "SVM");

"unknown"

> +
> +struct kvm_events_ops {
> +	bool (*is_begain_event)(struct event *event, void *data);

begin

> +	bool (*is_end_event)(struct event *event);
> +	struct event_key (*get_key)(struct event *event, void *data);
> +	void (*decode_key)(struct event_key *key, char decode[20]);
> +	const char *name;
> +};
> +
> +
> +static struct event_key exit_event_get_key(struct event *event, void *data)
> +{
> +	struct event_key key;
> +
> +	key.key = raw_field_value(event, "exit_reason", data);
> +	key.info = raw_field_value(event, "isa", data);

"isa" is not available on all kernel versions; need to fall back to
/proc/cpuid detection.

> +	return key;
> +}
>

-- 
error compiling committee.c: too many arguments to function

