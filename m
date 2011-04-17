Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab1DQM0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 08:26:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab1DQM0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 08:26:35 -0400
Message-ID: <4DAADC72.5040503@redhat.com>
Date: Sun, 17 Apr 2011 15:26:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Nelson Elhage <nelhage@ksplice.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: emulator: Use linearize() when fetching instructions.
References: <4DA5CA0E.8050102@redhat.com> <1302838072-16717-1-git-send-email-nelhage@ksplice.com>
In-Reply-To: <1302838072-16717-1-git-send-email-nelhage@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2011 06:27 AM, Nelson Elhage wrote:
> This means that the truncation behavior in linearize needs to grow an additional
> slight piece of complexity: when fetching, truncation is dependent on the
> execution mode, instead of the current address size.
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index a5f63d4..d3d43a7 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -542,7 +542,7 @@ static int emulate_nm(struct x86_emulate_ctxt *ctxt)
>
>   static int linearize(struct x86_emulate_ctxt *ctxt,
>   		     struct segmented_address addr,
> -		     unsigned size, bool write,
> +		     unsigned size, bool write, bool fetch,

Calls to functions with strings of bool arguments are confusing.  Please 
make this __linearize, and introduce a new linearize() which doesn't 
have a fetch argument.

>   		ulong *linear)
>   {
>   	struct decode_cache *c =&ctxt->decode;
> @@ -602,7 +602,7 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
>   		}
>   		break;
>   	}

linearize() will currently fault on an unreadable code segment.  Need to 
avoid that on instruction fetches.

> -	if (c->ad_bytes != 8)
> +	if (fetch ? ctxt->mode != X86EMUL_MODE_PROT64 : c->ad_bytes != 8)
>   		la&= (u32)-1;
>   	*linear = la;
>   	return X86EMUL_CONTINUE;

-- 
error compiling committee.c: too many arguments to function

