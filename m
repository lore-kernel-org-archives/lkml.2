Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2CNFNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 01:13:13 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:53342 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab2CNFNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 01:13:09 -0400
Message-ID: <3e4fc1efb5d7dbe0dd966e3192e84645.squirrel@webmail.greenhost.nl>
In-Reply-To: <1331658828.4449.16.camel@edumazet-glaptop>
References: <1331587715-26069-1-git-send-email-wad@chromium.org>
    <0c55cb258e0b5bbd615923ee2a9f06b9.squirrel@webmail.greenhost.nl>
    <1331658828.4449.16.camel@edumazet-glaptop>
Date: Wed, 14 Mar 2012 06:12:52 +0100
Subject: Re: [PATCH v14 01/13] sk_run_filter: add BPF_S_ANC_SECCOMP_LD_W
From: "Indan Zupancic" <indan@nul.nu>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: f4db13d1ab50da585241c80c5e12767b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, March 13, 2012 18:13, Eric Dumazet wrote:
> On Tue, 2012-03-13 at 11:04 +0100, Indan Zupancic wrote:
>> -	bpf_jit_compile(fp);
>> +	jit = bpf_jit_compile(fp->insns, fp->len, 1);
>> +	if (jit) {
>> +		fp->bpf_func = jit;
>> +		/* Free unused insns memory */
>> +		newfp = krealloc(fp, sizeof(*fp), GFP_KERNEL);
>> +		if (newfp)
>> +			fp = newfp;
>> +	}
>>
>>  	old_fp = rcu_dereference_protected(sk->sk_filter,
>>  					   sock_owned_by_user(sk));
>
> Dont mix unrelated changes in a single patch.

I know, but it was just a quick proof-of-concept. It just showed
a possible advantage of the API change for the current networking
code. The real patch would be split into an API change, the memory
freeing change, and the seccomp support.

>
> Current krealloc() doesnt alloc a new area if the current one is bigger
> than 'new_size', but this might change in next kernel versions.
>
> So this part of your patch does nothing.

Problem is that 'old_size' can be up to 32kB in size and it would be nice
if that memory could be released. If it isn't, then using JIT increases
memory usage, while also not accounting it to the socket.

>
> If it did, this kind of 'optimization' can actually be not good, because
> sizeof(*fp) is small enough (less than half cache line size) to trigger
> a possible false sharing issue. (other part of the cache line could be
> used to hold a often dirtied object)

It could avoid this by allocating at least a cache size. But this is a
problem for all small kmalloc's, isn't it?

What about something like the below:

@@ -625,7 +639,18 @@ int sk_attach_filter(struct sock_fprog *fprog, struct sock *sk)
 		return err;
 	}

-	bpf_jit_compile(fp);
+	jit = bpf_jit_compile(fp->insns, fp->len, 1);
+	if (jit) {
+		int size = max(cache_line_size(), sizeof(*fp));
+		fp->bpf_func = jit;
+		/* Free unused insns memory */
+		newfp = kmalloc(size, GFP_KERNEL);
+		if (newfp) {
+			memcpy(newfp, fp, size);
+			kfree(fp);
+			fp = newfp;
+		}
+	}

 	old_fp = rcu_dereference_protected(sk->sk_filter,
 					   sock_owned_by_user(sk));

Not sure whether to use cache_line_size() or just L1_CACHE_BYTES or
something else.

Greeings,

Indan


