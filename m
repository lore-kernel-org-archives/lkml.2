Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643Ab2FEKMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:12:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab2FEKMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:12:45 -0400
Date: Tue, 5 Jun 2012 12:10:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] uprobes: change build_map_info() to try
	kmalloc(GFP_NOWAIT) first
Message-ID: <20120605101047.GA8822@redhat.com>
References: <20120604145238.GA6408@redhat.com> <20120604145315.GB6416@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604145315.GB6416@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04, Oleg Nesterov wrote:
>
> @@ -772,8 +772,13 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
>  			continue;
>
>  		if (!prev) {
> -			more++;
> -			continue;
> +			prev = kmalloc(sizeof(struct map_info),
> +					GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			if (!prev) {
> +				more++;
> +				continue;
> +			}
> +			prev->next = NULL;
>  		}

OK, this is not exactly right, it is pointless and wrong to
do kmalloc(GFP_NOWAIT) if it failed before (iow, more != 0).

Easy to fix, I'll send v2 tomorrow.

Oleg.

