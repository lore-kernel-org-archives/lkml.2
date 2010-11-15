Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab0KOTgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:36:07 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33490 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360Ab0KOTgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:36:04 -0500
Subject: Re: [PATCH v1.3 4/4] keys: add new key-type encrypted
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <8268.1289837934@redhat.com>
References: <1289694826.3257.82.camel@localhost.localdomain>
	 <1289595738.2731.80.camel@localhost.localdomain>
	 <1289404309-15955-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <26689.1289591135@redhat.com> <27900.1289597013@redhat.com>
	 <8268.1289837934@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 14:35:51 -0500
Message-ID: <1289849751.3027.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 16:18 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > > But if you're going to use a user-defined key, you really need to prefix
> > > the description with something suitable.
> > 
> > Agreed. So instead of: 
> > 	keyctl add encrypted name "new master-key-name keylen" ring
> > 
> > the description would be prefixed with the key type like:	
> > 	keyctl add encrypted name "new trusted|user master-key-name keylen" ring
> 
> I don't think you understood what I meant.  If you look at the following
> function:

> +static struct key *request_master_key(struct encrypted_key_payload *epayload,
> +	       	   			void **master_key,
> +					unsigned int *master_keylen)
> +{
> +	struct key *mkey;
> +
> +	mkey = request_trusted_key(epayload->master_desc,
> +				   master_key, master_keylen);
> +	if (IS_ERR(mkey)) {
> +		mkey = request_user_key(epayload->master_desc,
> +					master_key, master_keylen);
> +		if (IS_ERR(mkey)) {
> +			pr_info("encrypted_key: trusted/user key %s not found",
> +				epayload->master_desc);
> +			return mkey;
> +		}
> +	}
> +	dump_master_key(*master_key, *master_keylen);
> +	return mkey;
> +}
> 
> In the bit where you go for a user key (having failed to get a trusted key),
> you should prefix the description here (or in request_user_key()) with
> something like "trusted:".  Then you don't need to change the user interface.
> 
> David

Am assuming you mean something like this:

keyctl add encrypted name "new trusted:master-key-name keylen" ring
keyctl add encrypted name "new user:master-key-name keylen" ring

and, as you said, works without changing the API.

thanks,

Mimi

