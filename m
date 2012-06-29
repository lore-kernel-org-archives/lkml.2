Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2F2Bo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 21:44:28 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:46467 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab2F2Bo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 21:44:26 -0400
Date: Fri, 29 Jun 2012 10:44:06 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, mtosatti@redhat.com,
        agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH 5/6] KVM: Separate rmap_pde from
 kvm_lpage_info->write_count
Message-Id: <20120629104406.5aacc584.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4FEC96EB.1050307@redhat.com>
References: <20120628105733.ccd9abb3.yoshikawa.takuya@oss.ntt.co.jp>
	<20120628110141.7b908c91.yoshikawa.takuya@oss.ntt.co.jp>
	<4FEBCBB3.3060707@linux.vnet.ibm.com>
	<20120628124546.83a829f3.yoshikawa.takuya@oss.ntt.co.jp>
	<4FEC96EB.1050307@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 20:39:55 +0300
Avi Kivity <avi@redhat.com> wrote:

> > Note: write_count: 4 bytes, rmap_pde: 8 bytes.  So we are wasting
> > extra paddings by packing them into lpage_info.
> 
> The wastage is quite low since it's just 4 bytes per 2MB.

Yes.

> >> Why not just introduce a function to get the next rmap? Something like this:
> > 
> > I want to eliminate this kind of overheads.
> 
> I don't think the overhead is significant.  rmap walk speed is largely a
> function of cache misses IMO, and we may even be adding cache misses by
> splitting lpage_info.

Maybe.  But as far as I can see, write_count does not gain much from
being close to rmap_pde.

> But I still think it's the right thing since it simplifies the code.

After the rmap integration, we can remove
	if (likely(level == PT_PAGE_TABLE_LEVEL))
heuristics from __gfn_to_rmap().

As a bonus, the helper will become enough simple to be always inlined
which reduces some function calls.

> Maybe we should add a prefetch() on write_count do mitigate the
> overhead, if it starts showing up in profiles.

OK, I will post rmap integration work as soon as possible, but it
still needs to be synced with unrelated ppc works at some point in
the future: so please take that separately from this series.

Thanks,
	Takuya
