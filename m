Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab2I1IKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:10:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab2I1IKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:10:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87ipay3cof.fsf@rustcorp.com.au>
References: <87ipay3cof.fsf@rustcorp.com.au> <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Fri, 28 Sep 2012 09:09:53 +0100
Message-ID: <27378.1348819793@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rusty Russell <rusty@rustcorp.com.au> wrote:

> And after those three fixes, I still get all fail:
> 
> [    3.361036] Request for unknown module key 'Magrathea: Glacier signing key: 6
> e03943da0f3b015ba6ed7f5e0cac4fe48680994' err -11

Can you look back further in your kernel output, see if you can spot the bit
where it's trying to load the keys.  Look for things from modsign_pubkey.c:

	pr_notice("Loading module verification certificates\n");
	...
			pr_err("MODSIGN: Problem loading in-kernel X.509 certificate (%ld)\n",
			       PTR_ERR(key));
		else
			pr_notice("MODSIGN: Loaded cert '%s'\n",
				  key_ref_to_ptr(key)->description);

> CONFIG_CRYPTO_SHA1=m

Hmmm...  I suspect it's that.  We need a hash to verify the key's own
signature too - and if you're using the key my autogen patch created for you,
I think that would be SHA1, so that must be built in too.

If you can see your kernel log (assuming a panic doesn't prevent you), I
suspect you'll see something like:

	MODSIGN: Problem loading in-kernel X.509 certificate (-65)

which is -ENOPKG.

The answer would be to either select SHA1 in Kconfig or, if possible, to tell
openssl to use the same hash algorithm to sign the key as we're going to use
in signing the modules.

David
