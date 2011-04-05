Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab1DEB1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 21:27:24 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:50457 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab1DEB1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 21:27:11 -0400
X-AuditID: b753bd60-a5abcba000004916-63-4d9a6fec00df
X-AuditID: b753bd60-a5abcba000004916-63-4d9a6fec00df
Message-ID: <4D9A6FE8.2010301@hitachi.com>
Date: Tue, 05 Apr 2011 10:27:04 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2.6.39-rc1-tip 26/26] 26: uprobes: filter chain
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6> <20110401143737.15455.30181.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110401143737.15455.30181.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/04/01 23:37), Srikar Dronamraju wrote:
> Loops through the filters callbacks of currently registered
> consumers to see if any consumer is interested in tracing this task.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
>  kernel/uprobes.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/uprobes.c b/kernel/uprobes.c
> index c950f13..62ccb56 100644
> --- a/kernel/uprobes.c
> +++ b/kernel/uprobes.c
> @@ -450,6 +450,23 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
>  	up_read(&uprobe->consumer_rwsem);
>  }
>  
> +static bool filter_chain(struct uprobe *uprobe, struct task_struct *t)
> +{
> +	struct uprobe_consumer *consumer;
> +	bool ret = false;
> +
> +	down_read(&uprobe->consumer_rwsem);
> +	for (consumer = uprobe->consumers; consumer;
> +					consumer = consumer->next) {
> +		if (!consumer->filter || consumer->filter(consumer, t)) {
> +			ret = true;
> +			break;
> +		}
> +	}
> +	up_read(&uprobe->consumer_rwsem);
> +	return ret;
> +}
> +

Where this function is called from ? This patch seems the last one of this series...

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
