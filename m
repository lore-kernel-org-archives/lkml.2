Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab2FHIrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:47:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:40498 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760567Ab2FHIrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:47:35 -0400
Message-ID: <1339145227.23343.42.camel@twins>
Subject: Re: [PATCH 3/3] uprobes: write_opcode()->__replace_page() can race
 with try_to_unmap()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 10:47:07 +0200
In-Reply-To: <20120607170041.GC31974@redhat.com>
References: <20120607165942.GA31966@redhat.com>
	 <20120607170041.GC31974@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 19:00 +0200, Oleg Nesterov wrote:
> write_opcode() gets old_page via get_user_pages() and then calls
> __replace_page() which assumes that this old_page is still mapped
> after pte_offset_map_lock().
> 
> This is not true if this old_page was already try_to_unmap()'ed,
> and in this case everything __replace_page() does with old_page
> is wrong. Just for example, put_page() is not balanced.
> 
> I think it is possible to teach __replace_page() to handle this
> unlikely case correctly, but this patch simply changes it to use
> page_check_address() and return -EAGAIN if it fails. The caller
> should notice this error code and retry. 

Note that replace_page() was nicked from ksm, does that suffer a similar
problem?
