Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab2IDX3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:29:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992Ab2IDX3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:29:05 -0400
Date: Tue, 4 Sep 2012 16:28:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuah.khan@hp.com
Cc: fujita.tomonori@lab.ntt.co.jp, paul.gortmaker@windriver.com,
        bhelgaas@google.com, amwang@redhat.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH] swiotlb: add kernel error message to track iobtlb
 overflow buffer usage
Message-Id: <20120904162804.baad7cc0.akpm@linux-foundation.org>
In-Reply-To: <1346460959.3393.3.camel@lorien2>
References: <1346460959.3393.3.camel@lorien2>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2012 18:55:59 -0600
Shuah Khan <shuah.khan@hp.com> wrote:

> Add kernel error message to track iotlb overflow buffer triggers to understand
> how often the overflow buffer gets used.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  lib/swiotlb.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index 45bc1f8..597d7b9 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -682,6 +682,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
>  	if (!map) {
>  		swiotlb_full(dev, size, dir, 1);
>  		map = io_tlb_overflow_buffer;
> +		dev_err(dev, "SWIOTLB is full. Mapping overflow buffer.\n");
>  	}
>  
>  	dev_addr = swiotlb_virt_to_bus(dev, map);

hm.  I would view this as a developer-only debugging thing which
shouldn't be present in production code.  Plus there's a potential that
some poor person will have his logs flooded with this message.

A more typical way of handling this would be to increment a stats
counter, accessible in procfs or debugfs.

