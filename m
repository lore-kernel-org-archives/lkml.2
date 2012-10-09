Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab2JIGMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:12:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:62912 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab2JIGMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:12:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,558,1344236400"; 
   d="scan'208";a="231565465"
Message-ID: <5073C05E.5020402@zytor.com>
Date: Tue, 09 Oct 2012 14:12:46 +0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 08/10] x86, xen, mm: fix mapping_pagetable_reserve logic
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org> <1349757558-10856-9-git-send-email-yinghai@kernel.org>
In-Reply-To: <1349757558-10856-9-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 12:39 PM, Yinghai Lu wrote:
>   */
>  struct x86_init_mapping {
> -	void (*pagetable_reserve)(u64 start, u64 end);
> +	void (*make_range_readwrite)(u64 start, u64 end);
>  };
>  

Here you go from one misleading name to another.  Another classic case
of "why hooks suck."

make_range_readwrite is particularly toxic, though, because it makes it
sound like it something along the lines of set_memory_rw(), which it
most distinctly is not.

Furthermore, the naming makes me really puzzled why it is there at all.
 It makes me suspect, but because the patchset is so messy, it is hard
for me to immediately prove, that you're still missing something important.

However, for example:

> unsigned long __initdata pgt_buf_start;
>  unsigned long __meminitdata pgt_buf_end;
>  unsigned long __meminitdata pgt_buf_top;
> +unsigned long __initdata early_pgt_buf_start;
> +unsigned long __meminitdata early_pgt_buf_end;
> +unsigned long __meminitdata early_pgt_buf_top;
>  
>  bool __init is_pfn_in_early_pgt_buf(unsigned long pfn)
>  {
> -	return pfn >= pgt_buf_start && pfn < pgt_buf_top;
> +	return (pfn >= early_pgt_buf_start && pfn < early_pgt_buf_top) ||
> +	       (pfn >= pgt_buf_start && pfn < pgt_buf_top);
>  }

Magic variables augmented with more magic variables.  Why?  This also
seems to assume that we still do all the kernel page tables in one
chunk, which is exactly what we don't want to do.

	-hpa

