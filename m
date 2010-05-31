Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab0EaQ5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:57:21 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47666 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab0EaQ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Bj2s00sTylD/tRENAFOvJzAm5xQuGIwr4c7GQqZXrubG3FZD4fkX9msL9JU242FY5u
         EsboTEu7JnbxPek3RWZYBEMpTUZYDeLlN509R1BRAKXqQt95uRnto6e8bR+g4f7diQb9
         YkUqWtzmdRj7oXqQraimFTwWcm3/e0Sk2WcAA=
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: herbert@gondor.hengli.com.au, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
In-Reply-To: <20100531160425.GA20344@basil.fritz.box>
References: <20100531160425.GA20344@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 18:34:55 +0200
Message-ID: <1275323695.3291.122.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 31 mai 2010 à 18:04 +0200, Andi Kleen a écrit :
> DM-CRYPT: Scale to multiple CPUs
> 
> Currently dm-crypt does all encryption work per dmcrypt mapping in a
> single workqueue. This does not scale well when multiple CPUs
> are submitting IO at a high rate. The single CPU running the single
> thread cannot keep up with the encryption and encrypted IO performance
> tanks.
> 
> This patch changes the crypto workqueue to be per CPU. This means
> that as long as the IO submitter (or the interrupt target CPUs
> for reads) runs on different CPUs the encryption work will be also
> parallel.
> 
> To avoid a bottleneck on the IO worker I also changed those to be
> per CPU threads.
> 
> There is still some shared data, so I suspect some bouncing
> cache lines. But I haven't done a detailed study on that yet.
> 
> All the threads are global, not per CPU. That is to avoid a thread
> explosion on systems with a large number of CPUs and a larger
> number of dm-crypt mappings. The code takes care to avoid problems
> with nested mappings.
>     
> Signed-off-by: Andi Kleen <ak@linux.intel.com>


>  	/*
> +	 * Duplicated per cpu state. Access through
> +	 * per_cpu_ptr() only.
> +	 */
> +	struct crypt_cpu *cpu;
> +
> +	/*
>  	 * Layout of each crypto request:
>  	 *

Since commit e0fdb0e050eae331, we have a __percpu annotation so that
sparse can be augmented. This would also make the comment unnecessary...


We also have this_cpu_ accessors

> +       return per_cpu_ptr(cc->cpu, smp_processor_id());

	this_cpu_ptr(cc->cpu)

and __thic_cpu_ptr() for the 'raw' version


> +       __get_cpu_var(io_wq_cpu) = current;

	this_cpu_write(io_wq_cpu, current)


