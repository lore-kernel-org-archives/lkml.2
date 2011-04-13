Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab1DMQGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:06:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478Ab1DMQGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:06:43 -0400
Message-ID: <4DA5CA0E.8050102@redhat.com>
Date: Wed, 13 Apr 2011 19:06:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Nelson Elhage <nelhage@ksplice.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: emulator: Handle wraparound in (cs_base + offset)
 when fetching.
References: <1302709453-19031-1-git-send-email-nelhage@ksplice.com>
In-Reply-To: <1302709453-19031-1-git-send-email-nelhage@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 06:44 PM, Nelson Elhage wrote:
> Currently, setting a large (i.e. negative) base address for %cs does not work on
> a 64-bit host. The "JOS" teaching operating system, used by MIT and other
> universities, relies on such segments while bootstrapping its way to full
> virtual memory management.
>
> Signed-off-by: Nelson Elhage<nelhage@ksplice.com>
> ---
>   arch/x86/kvm/emulate.c |    5 ++++-
>   1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 0ad47b8..54e84b2 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -505,9 +505,12 @@ static int do_fetch_insn_byte(struct x86_emulate_ctxt *ctxt,
>   	int size, cur_size;
>
>   	if (eip == fc->end) {
> +		unsigned long linear = eip + ctxt->cs_base;
> +		if (ctxt->mode != X86EMUL_MODE_PROT64)
> +			linear&= (u32)-1;
>   		cur_size = fc->end - fc->start;
>   		size = min(15UL - cur_size, PAGE_SIZE - offset_in_page(eip));
> -		rc = ops->fetch(ctxt->cs_base + eip, fc->data + cur_size,
> +		rc = ops->fetch(linear, fc->data + cur_size,
>   				size, ctxt->vcpu,&ctxt->exception);
>   		if (rc != X86EMUL_CONTINUE)
>   			return rc;

A better fix would be to call linearize() here, which does the necessary 
truncation as well as segment checks.

However, this patch is a lot more backportable, so I think it should be 
applied, and a conversion to linearize() performed afterwards.

-- 
error compiling committee.c: too many arguments to function

