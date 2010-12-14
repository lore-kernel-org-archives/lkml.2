Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606Ab0LNQo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:44:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759594Ab0LNQo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:44:28 -0500
Date: Tue, 14 Dec 2010 17:37:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 15/21] Collect ELF Core notes data
Message-ID: <20101214163719.GH11400@redhat.com>
References: <20101214152259.67896960@suzukikp> <20101214154733.495bd2e7@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214154733.495bd2e7@suzukikp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14, Suzuki K. Poulose wrote:
>
> @@ -164,10 +197,28 @@ static int open_gencore(struct inode *in
>  	list_add(&cp->list, &core_list);
>  	mutex_unlock(&core_mutex);
>
> +	max_regset = get_max_regsets(task);
> +
> +	for (i = 0; i < get_nr_threads(task); i++) {
> +		tinfo = kzalloc(offsetof(struct elf_thread_core_info,
> +					notes[max_regset]), GFP_KERNEL);
> +		if (unlikely(!tinfo)) {
> +			cleanup_cp(cp);
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		tinfo->next = cp->tinfo;
> +		cp->tinfo = tinfo;
> +	}

This looks strange... Obviously we can't trust get_nr_threads()
before this process is stopped/frozen.

Just noticed... release_gencore() does thaw_process() for each
thread. But, again, if it was stopped we can race with SIGCONT
and exit. IOW, -EIO is possible. Who will thaw other threads?
Also, we can probably race with exec, but I am not sure.

Oleg.

