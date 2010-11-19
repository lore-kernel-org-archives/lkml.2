Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab0KSSAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:00:47 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:56952 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab0KSSAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:00:45 -0500
Subject: Re: [PATCH v1.4 4/5] keys: add new trusted key-type
From: David Safford <safford@watson.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <10330.1290183801@redhat.com>
References: <1290120166-3132-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <10330.1290183801@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 13:00:16 -0500
Message-ID: <1290189616.2597.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 16:23 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

thanks for the review! - getting closer...

> > +keyctl print returns an ascii hex copy of the sealed key, which is in standard
> 
> I'd quote 'keyctl print' just so it's obvious where the command ends and the
> descriptive text starts.

ok

> > +Usage:
> > +  keyctl add encrypted name "new key-type:master-key-name keylen" ring
> > +  keyctl add encrypted name "load key-type:master-key-name keylen hex_blob" ring
> > +  keyctl update keyid "update key-type:master-key-name"
> > +
> > +where 'key-type' is either 'trusted' or 'user'.
> 
> I recommend adding some example commands with all the arguments substituted.
> Nothing helps get to grip with an API like knowing what a command is supposed
> to look like when it's actually used.

now that this is moved to documentation, you are right, more examples 
would be nice... willdo.

> > +static int trusted_tpm_send(u32 chip_num, unsigned char *cmd, int buflen)
> 
> There are still a lot of places in here where you should probably be using
> const and size_t.

will clean up.

> > +static int my_get_random(unsigned char *buf, int len)
> > +{
> > +	struct tpm_buf *tb;
> > +	int ret;
> > +
> > +	tb = kzalloc(sizeof *tb, GFP_KERNEL);
> > +	if (!tb)
> > +		return -ENOMEM;
> > +	ret = tpm_get_random(tb, buf, len);
> 
> Using kzalloc() rather than kmalloc() is a waste of time, I'd've thought.
> It's a temporary buffer.  Does it really need to be precleared?

In this case, none need to be precleared. Will fix.

> > +	ret = tpm_pcr_extend(TPM_ANY_NUM, pcrnum, hash);
> > +	return ret;
> 
> Merge.

agreed

> > +static int trusted_update(struct key *key, const void *data, size_t datalen)
> > +{
> > ...
> > +	*(datablob + datalen) = '\0';
> 
> That's what [] is for.

agreed.

> > +	if (new_o)
> > +		kfree(new_o);
> 
> kfree() can handle a NULL pointer.

agreed.

> > +	if (new_o->pcrlock)
> > +		ret = pcrlock(new_o->pcrlock);
> > +	rcu_assign_pointer(key->payload.data, new_p);
> > +	call_rcu(&p->rcu, trusted_rcu_free);
> 
> Should there be a check for pcrlock() failure?

yes, because if the pcrlock failed, even though the key
was successfully created, it is not safe to use. 
Will correct.

> > +/* not already defined in tpm.h - specific to this use */
> > +#define TPM_TAG_RQU_COMMAND		193
> > +#define TPM_TAG_RQU_AUTH1_COMMAND	194
> > ...
> 
> Values defined for TPM hardware access really ought to be in a separate file
> in include/linux/.  They aren't strictly specific to the trusted key
> implementation here; that may be the only user currently in the kernel, but
> that doesn't mean there can't be another user.

Currently tpm request packet defines are private to the tpm driver.
With the opening of a tpm_send() interface, perhaps it does make 
sense for an include/linux/tpm_packet.h for everyone (including tpm.c)
to use, even though there is little overlap currently.

We could create that with these current defines to start,
and then do a cleanup patch for tpm.c to take advantage.

dave





