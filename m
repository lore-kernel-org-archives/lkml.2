Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1K0MeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 07:34:12 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:53830 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab1K0MeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 07:34:11 -0500
Message-ID: <4ED22E3E.8080507@cesarb.net>
Date: Sun, 27 Nov 2011 10:34:06 -0200
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Nick Bowler <nbowler@elliptictech.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/62] highmem: mark k[un]map_atomic() with two arguments
 as deprecated
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-2-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-2-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-11-2011 03:26, Cong Wang escreveu:
>   /*
>    * Prevent people trying to call kunmap_atomic() as if it were kunmap()
>    * kunmap_atomic() should get the return value of kmap_atomic, not the page.
>    */
> -#define kunmap_atomic(addr, args...)				\
> -do {								\
> -	BUILD_BUG_ON(__same_type((addr), struct page *));	\
> -	__kunmap_atomic(addr);					\
> -} while (0)
> +static inline void kunmap_atomic(void *addr)
> +{
> +	BUILD_BUG_ON(__same_type((addr), struct page *));
> +	__kunmap_atomic(addr);
> +}
> +
> +static inline void __deprecated kunmap_atomic_deprecated(void *addr,
> +							enum km_type km)
> +{
> +	BUILD_BUG_ON(__same_type((addr), struct page *));
> +	__kunmap_atomic(addr);
> +}

This will break the misuse detection of kunmap_atomic (see commit 
597781f3e51f48ef8e67be772196d9e9673752c4).

kunmap_atomic() _must_ be a macro, so the __same_type can see the type 
the caller used. If you use an inline function, all it will see is a 
void *, even if the caller confused it with kunmap() and passed a struct 
page *.

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
