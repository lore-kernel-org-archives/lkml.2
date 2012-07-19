Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2GTAta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 20:49:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab2GTAsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:48:33 -0400
Date: Thu, 19 Jul 2012 20:58:28 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/9] KVM: x86: simplify read_emulated
Message-ID: <20120719235828.GA7121@amt.cnet>
References: <50056DB8.7080702@linux.vnet.ibm.com>
 <50056DE6.6020801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50056DE6.6020801@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 09:51:34PM +0800, Xiao Guangrong wrote:
> No need split mmio read region into 8-bits pieces since we do it in
> emulator_read_write_onepage
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/emulate.c |   29 ++++++++++++-----------------
>  1 files changed, 12 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 97d9a99..2d1916b 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1166,24 +1166,19 @@ static int read_emulated(struct x86_emulate_ctxt *ctxt,
>  	int rc;
>  	struct read_cache *mc = &ctxt->mem_read;
> 
> -	while (size) {
> -		int n = min(size, 8u);
> -		size -= n;
> -		if (mc->pos < mc->end)
> -			goto read_cached;
> -
> -		rc = ctxt->ops->read_emulated(ctxt, addr, mc->data + mc->end, n,
> -					      &ctxt->exception);
> -		if (rc != X86EMUL_CONTINUE)
> -			return rc;
> -		mc->end += n;
> +	if (mc->pos < mc->end)
> +		goto read_cached;
> 
> -	read_cached:
> -		memcpy(dest, mc->data + mc->pos, n);
> -		mc->pos += n;
> -		dest += n;
> -		addr += n;
> -	}
> +	rc = ctxt->ops->read_emulated(ctxt, addr, mc->data + mc->end, size,
> +				      &ctxt->exception);
> +	if (rc != X86EMUL_CONTINUE)
> +		return rc;
> +
> +	mc->end += size;
> +
> +read_cached:
> +	memcpy(dest, mc->data + mc->pos, size);

What prevents read_emulated(size > 8) call, with
mc->pos == (mc->end - 8) now?

> +	mc->pos += size;
>  	return X86EMUL_CONTINUE;
>  }

