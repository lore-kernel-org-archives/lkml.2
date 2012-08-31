Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2HaOdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:33:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab2HaOdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:33:11 -0400
Message-ID: <5040CB1C.1010909@suse.cz>
Date: Fri, 31 Aug 2012 16:33:00 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/25] MODSIGN: Provide module signing public keys to
 the kernel
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk> <20120816013751.872.688.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120816013751.872.688.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.8.2012 03:37, David Howells wrote:
> +asm(".section .init.data,\"aw\"\n"
> +    "modsign_public_keys:\n"
> +    ".incbin \"modsign.pub\"\n"
> +    "modsign_public_keys_end:"
> +    );
> +
> +/*
> + * We need to make sure ccache doesn't cache the .o file as it doesn't notice
> + * if modsign.pub changes.
> + */
> +static __initdata const char annoy_ccache[] = __TIME__ "foo";

This results in a different object file after each build, even if
modsign.pub is the same :(. How about generating a modsign-hash.c with
the following content

static __initdata const char annoy_ccache[] = "<some checksum of
modsign.pub, or the key fingerprint>";

and including it in modsign-pubkey.c with the preprocessor? When
changing the public key, modsign.hash.c would change as well and ccache
would notice it. But when doing a rebuild from the same source with the
same public key, the resulting object file would not change.

Thanks,
Michal
