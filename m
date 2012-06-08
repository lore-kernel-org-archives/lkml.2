Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228Ab2FHKGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 06:06:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab2FHKGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 06:06:03 -0400
Date: Fri, 8 Jun 2012 12:03:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] uprobes: write_opcode()->__replace_page() can race
	with try_to_unmap()
Message-ID: <20120608100358.GA19131@redhat.com>
References: <20120607165942.GA31966@redhat.com> <20120607170041.GC31974@redhat.com> <1339145227.23343.42.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339145227.23343.42.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08, Peter Zijlstra wrote:
>
> On Thu, 2012-06-07 at 19:00 +0200, Oleg Nesterov wrote:
> > write_opcode() gets old_page via get_user_pages() and then calls
> > __replace_page() which assumes that this old_page is still mapped
> > after pte_offset_map_lock().
> >
> > This is not true if this old_page was already try_to_unmap()'ed,
> > and in this case everything __replace_page() does with old_page
> > is wrong. Just for example, put_page() is not balanced.
> >
> > I think it is possible to teach __replace_page() to handle this
> > unlikely case correctly, but this patch simply changes it to use
> > page_check_address() and return -EAGAIN if it fails. The caller
> > should notice this error code and retry.
>
> Note that replace_page() was nicked from ksm, does that suffer a similar
> problem?

Yes, I looked at replace_page() too. Afaics it looks fine, it does the
additional pte_same(pte, orig_pte) check.

Oleg.

