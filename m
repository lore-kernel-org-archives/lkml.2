Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839Ab2FBSX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 14:23:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964779Ab2FBSX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 14:23:58 -0400
Date: Sat, 2 Jun 2012 20:21:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] uprobes: install_breakpoint() should fail if
	is_swbp_insn() == T
Message-ID: <20120602182158.GA21971@redhat.com>
References: <20120530165816.GA8085@redhat.com> <1338398931.28384.7.camel@twins> <20120530173717.GM15587@linux.vnet.ibm.com> <1338400142.28384.12.camel@twins> <1338400450.28384.16.camel@twins> <20120531185339.GA28057@redhat.com> <20120601155312.GA20265@redhat.com> <20120601163315.GJ24279@linux.vnet.ibm.com> <20120601172055.GA24798@redhat.com> <20120601183113.GA31771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601183113.GA31771@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Oleg Nesterov wrote:
>
> 	while (more--) {
> 		info = kmalloc(sizeof(struct map_info), GFP_KERNEL);
> 		if (!info) {
> 			curr = ERR_PTR(-ENOMEM);
> 			goto out;
> 		}
> 		info->next = prev;
> 		prev = info;
> 	}

This should be "do ... while (--more)", otherwise it seems to work
and really helps.

I did the simple test under qemu. Currently uprobe_register() hangs
"forever" if the probed addr has 10000 mappings, I'have stopped qemu
after several minutes.

With the new code uprobe_register() needs 0.403s to complete.

We can also change build_map_info() to try GFP_NOWAIT | GFP_NOMEMALLOC
under i_mmap_mutex first, not sure this is really needed.

I'll write the changelog and send the patch...

Do you see any problems with this approach?

Oleg.

