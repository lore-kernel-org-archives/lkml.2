Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761058Ab2BNUun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:50:43 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:4206 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760766Ab2BNUul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:50:41 -0500
Date: Tue, 14 Feb 2012 15:50:32 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Christoph Lameter <cl@linux.com>
Cc: Xi Wang <xi.wang@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Re: Uninline kcalloc
Message-ID: <20120214205032.GA631@elliptictech.com>
References: <alpine.DEB.2.00.1202130958470.23562@router.home>
 <20120213194446.GD26353@mwanda>
 <alpine.DEB.2.00.1202131424020.25908@router.home>
 <20120214072017.GF26353@mwanda>
 <alpine.DEB.2.00.1202140858080.20013@router.home>
 <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com>
 <alpine.DEB.2.00.1202141032410.22250@router.home>
 <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com>
 <alpine.DEB.2.00.1202141329360.24883@router.home>
 <alpine.DEB.2.00.1202141336060.24883@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202141336060.24883@router.home>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-14 13:37 -0600, Christoph Lameter wrote:
> This patch still preserves kcalloc. But note that if kcalloc returns NULL
> then multiple conditions may have caused it. One is that the array is
> simply too large. The other may be that such an allocation is not possible
> due to fragmentation.
[...]
> +static inline long calculate_array_size(size_t n, size_t size)
> +{
> +	if (size != 0 && n > ULONG_MAX / size)
> +
> +		return 0;

This isn't right.  The above tests whether or not the result of the
multiplication will not be representable in an 'unsigned long'...

> +
> +	return n * size;

but then the result is assigned to a (signed) long, which may overflow 
if it's greater than LONG_MAX.

> +}
[...]
>  void *kcalloc(size_t n, size_t size, gfp_t flags)
>  {
> -	if (size != 0 && n > ULONG_MAX / size)
> -		return NULL;
> -	return __kmalloc(n * size, flags | __GFP_ZERO);
> +	size_t s = calculate_array_size(n, size);
> +
> +	if (s)
> +		return kzalloc(s, flags);
> +
> +	return NULL;
>  }

This hunk changes the behaviour of kcalloc if either of the two size parameters
is 0.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

