Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab2EYMSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 08:18:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab2EYMSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 08:18:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
References: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
Date: Fri, 25 May 2012 13:18:23 +0100
Message-ID: <10579.1337948303@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've posted a new version with Tetsuo's comments fixed and
module_verify_signature() reduced to:

static int module_verify_signature(const void *data, size_t size)
{
	struct crypto_key_verify_context *mod_sig;
	const char *cp, *sig;
	char *end;
	size_t magic_size, sig_size, mod_size;
	int ret;

	magic_size = sizeof(modsign_magic) - 1;
	if (size <= 5 + magic_size)
		return 1;

	if (memcmp(data + size - magic_size, modsign_magic, magic_size) != 0)
		return 1;
	size -= 5 + magic_size;

	cp = data + size;
	sig_size = simple_strtoul(cp, &end, 10);
	if (sig_size >= size || (*end != ' ' && *end != 'T'))
		return -ELIBBAD;

	mod_size = size - sig_size;
	sig = data + mod_size;

	/* Find the crypto key for the module signature
	 * - !!! if this tries to load the required hash algorithm module,
	 *       we will deadlock!!!
	 */
	mod_sig = verify_sig_begin(modsign_keyring, sig, sig_size);
	if (IS_ERR(mod_sig)) {
		pr_err("Couldn't initiate module signature verification: %ld\n",
		       PTR_ERR(mod_sig));
		return PTR_ERR(mod_sig);
	}

	/* Load the module contents into the digest */
	ret = verify_sig_add_data(mod_sig, data, mod_size);
	if (ret < 0) {
		verify_sig_cancel(mod_sig);
		return ret;
	}

	/* Do the actual signature verification */
	ret = verify_sig_end(mod_sig, sig, sig_size);
	pr_devel("verify-sig : %d\n", ret);
	return ret;
}

See:

http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/modsign-rusty

David
