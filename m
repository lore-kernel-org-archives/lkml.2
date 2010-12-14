Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab0LNQAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:00:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241Ab0LNQAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:00:24 -0500
Date: Tue, 14 Dec 2010 16:53:10 +0100
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
Subject: Re: [Patch 3/21] Make vma_dump_size() generic
Message-ID: <20101214155310.GA11400@redhat.com>
References: <20101214152259.67896960@suzukikp> <20101214153013.07878e76@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214153013.07878e76@suzukikp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suzuki, I didn't read this series. Still I have some concerns after
the very brief look...

On 12/14, Suzuki K. Poulose wrote:
>
> @@ -114,10 +113,18 @@ unsigned long vma_dump_size(struct vm_ar
>  		 * Switch to the user "segment" for get_user(),
>  		 * then put back what elf_core_dump() had in place.
>  		 */
> -		set_fs(USER_DS);
> -		if (unlikely(get_user(word, header)))
> -			word = 0;
> -		set_fs(fs);
> +		if (p->group_leader == current->group_leader) {

same_thread_group() ?

> +			mm_segment_t fs = get_fs();
> +			set_fs(USER_DS);
> +			if (unlikely(get_user(word, header)))
> +				word = 0;
> +			set_fs(fs);
> +		} else {
> +			int bytes = access_process_vm(p, (unsigned long)header,
> +						&word, sizeof (word), 0);

Well. This adds a little pessimization. It is possible that the
"normal" coredump dumps the CLONE_VM process which doesn't below
to current's thread group.

May be you can compare ->mm's, but I am not sure.

Oleg.

