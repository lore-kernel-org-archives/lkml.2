Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab2HBOGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 10:06:46 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:46064 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753500Ab2HBOGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 10:06:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0xb4QDoVM1mkf_LHT9v7Ou8fWc5kh.g2M_W3bFfLza3Iqi9
 5Ffi_tkoQTdlGbIss0JLyg9b8Iv3nuh.uImxT6qows0uRpDk.YqmrXW7nIRL
 SgwsgDSdStp3LysL2iddWCI.I3swDDllUv0DtpFSshyABTRVzbPZoj29HIWv
 ejmpkqbRV6wUSO3xufvftUX2.xSakEIv99J69gMFxAQE5PUVtb2BPe5igWcT
 z2_sgcr4EzJI6KjkYNzzTqDYMmg_lgD7WYcXI.o4ftgtgzRws4T_4XqwiExD
 lewNbp9U2pHVU_W2jg3Rk.tDAI_AA57LJnSPswCZc7a647VX7ZbQwFbeurFA
 DvhS7DgVmuYfXmQwtsaSKjNsvxEjXrb.9cvWgrqMrSDnB6lNwa8tgQxo8wtj
 2xkx9nEOQV446HBxtZZrCOA2V4xVPJ7JXdHXdYI9XS9Hmr33_aao-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 2 Aug 2012 09:06:41 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] slub: use free_page instead of put_page for freeing
 kmalloc allocation
In-Reply-To: <1343913065-14631-1-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1208020902390.23049@router.home>
References: <1343913065-14631-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2012, Glauber Costa wrote:

> diff --git a/mm/slub.c b/mm/slub.c
> index e517d43..9ca4e20 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3453,7 +3453,7 @@ void kfree(const void *x)
>  	if (unlikely(!PageSlab(page))) {
>  		BUG_ON(!PageCompound(page));
>  		kmemleak_free(x);
> -		put_page(page);
> +		__free_pages(page, compound_order(page));

Hmmm... put_page would have called put_compound_page(). which would have
called the dtor function. dtor is set to __free_pages() ok which does
mlock checks and verifies that the page is in a proper condition for
freeing. Then it calls free_one_page().

__free_pages() decrements the refcount and then calls __free_pages_ok().

So we loose the checking and the dtor stuff with this patch. Guess that is
ok?

Acked-by: Christoph Lameter <cl@linux.com>

